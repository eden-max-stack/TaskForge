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
FROM unnest(ARRAY['ACTIVE', 'PAUSED', 'ARCHIVED', 'DELETED'])
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
FROM generate_series(1, 10) AS i;

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
    p.proj_id,
    ou.user_id,
    CASE
        WHEN rn = 1 THEN 'PROJ_MANAGER'
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
WHERE rn <= 2;