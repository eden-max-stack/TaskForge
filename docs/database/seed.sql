-- generating seed script dynamically

-- seeding organizations (10 orgs)
INSERT INTO organizations (org_id, org_name, created_at)
SELECT 
    'org_' || LPAD(i::text,4,'0'),
    'Organization ' || i,
    NOW() - (i * INTERVAL '1 day')
FROM generate_series(1, 10) AS i;

-- seeding projects (5 projects per status of project)
INSERT INTO projects (proj_id, proj_name, org_id, status, created_at)
SELECT 
    'proj_' || LPAD(row_number() OVER ()::text,4,'0'),
    'Project ' || row_number() OVER (),
    'org_' || LPAD((floor(random()* 10) + 1)::text,4,'0'),
    status,
    NOW() - (random() * INTERVAL '30 days')
FROM unnest(ARRAY['ACTIVE', 'PAUSED', 'ARCHIVED', 'DELETED']) AS status
CROSS JOIN generate_series(1,5);

-- seeding users (10 users)
INSERT INTO users (user_id, user_name, email_id, full_name, pswd_hash, created_at)
SELECT 
    'user_' || LPAD(i::text,4,'0'),
    'user_name_' || LPAD(i::text,4,'0'),
    'user' || i || '@test.com',
    'Test User' || i,
    '$2b$10$KbQiYy9nW1MZ9T6e9N8q4O9d0hE5wQvYkGm2H6lq7QFJYcTj3a1yW',
    NOW() - (random() * INTERVAL '30 days')
FROM generate_series(1, 30) AS i;

-- seeding org_users - 3 users per organization
INSERT INTO org_users (org_id, user_id, role) 
SELECT 
    'org_' || LPAD(org_i::text,4,'0'),
    'user_' || LPAD((org_i*3 + user_i-3)::text,4,'0'),
    CASE
        WHEN user_i = 1 THEN 'ORG_ADMIN'
        ELSE 'ORG_MEMBER'
    END
FROM generate_series(1,10) as org_i
CROSS JOIN generate_series(1,3) as user_i;  

-- seeding proj_users - 2 users per project
INSERT INTO proj_users (proj_id, user_id, role)
SELECT
    t.proj_id,
    t.user_id,
    CASE
        WHEN t.rn = 1 THEN 'PROJ_MANAGER'
        ELSE 'PROJ_MEMBER'
    END
FROM (
    SELECT
        p.proj_id,
        ou.user_id,
        ROW_NUMBER() OVER (PARTITION BY p.proj_id ORDER BY random()) as rn
    FROM projects p
    JOIN org_users ou
        ON ou.org_id = p.org_id
) t
WHERE t.rn <= 2;

-- seeding buckets - 3 buckets per project
INSERT INTO buckets (bucket_id, bucket_name, proj_id, created_at)
SELECT 
    'bucket_' || LPAD((row_number() OVER ())::text,4,'0'),
    'Bucket ' || row_number() OVER (),
    proj_id,
    NOW() - (random() * INTERVAL '30 days')
FROM projects
CROSS JOIN generate_series(1,3);

INSERT INTO tasks (task_id, task_title, task_desc, due_date, created_by, bucket_id, proj_id, assigned_to, created_at)
SELECT
    'task_' || LPAD(row_number() OVER ()::text,4,'0'),
    'Task ' || row_number() OVER (),
    'Description for task ' || row_number() OVER (),
    NOW() + (random() * INTERVAL '30 days'),
    pu.user_id,   -- creator
    b.bucket_id,
    b.proj_id,
    pu.user_id,   -- assigned user
    NOW() - (random() * INTERVAL '30 days')

FROM buckets b
CROSS JOIN generate_series(1,5)

JOIN LATERAL (
    SELECT user_id
    FROM proj_users
    WHERE proj_users.proj_id = b.proj_id
    ORDER BY random()
    LIMIT 1
) pu ON TRUE;

-- seeding subtasks - 3 subtasks per task
INSERT INTO subtasks (subtask_id, subtask_title, task_id, status)
SELECT 
    'subtask_' || LPAD(row_number() OVER ()::text,4,'0'),
    'Subtask ' || row_number() OVER (),
    task_id,
    CASE
        WHEN random() < 0.5 THEN 'INCOMPLETE'
        ELSE 'COMPLETED'
    END
FROM tasks
CROSS JOIN generate_series(1,3);

-- seeding comments - 2 comments per task
INSERT INTO comments (comment_id, comment_content, created_by, task_id, created_at)
SELECT 
    'comment_' || LPAD(row_number() OVER ()::text,4,'0'),
    'Comment content for comment ' || row_number() OVER (),
    'user_' || LPAD((floor(random()* 10) + 1)::text,4,'0'),
    task_id,
    NOW() - (random() * INTERVAL '30 days')
FROM tasks
CROSS JOIN generate_series(1,2);

-- seeding comment_mentions - 1 mention for 5 random users
INSERT INTO comment_mentions (comment_id, mentioned_user_id)
SELECT 
    comment_id,
    'user_' || LPAD((floor(random()* 10) + 1)::text,4,'0')
FROM comments
WHERE random() < 0.5;