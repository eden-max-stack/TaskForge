-- query simulation for all features in the system - for performance tracking

-- get all users within an organization: org_0003
SELECT ou.*, u.full_name, u.email_id FROM org_users ou JOIN users u ON ou.user_id = u.user_id WHERE ou.org_id = 'org_0003';

-- get all projects within an organization
SELECT * FROM projects WHERE org_id = 'org_0003' ORDER BY created_at DESC;

-- get all users within a project
SELECT pu.*, u.full_name, u.email_id FROM proj_users pu JOIN users u ON pu.user_id = u.user_id WHERE pu.proj_id = 'proj_0003';

-- get all buckets within a project
SELECT * FROM buckets WHERE proj_id = 'proj_0003';

-- get all tasks within a project - grouped by buckets
SELECT * FROM tasks WHERE proj_id = 'proj_0003' ORDER BY bucket_id, created_at DESC;

-- get all task meta, subtasks, and comments for a task when you open the task modal
SELECT t.*, s.* FROM tasks t JOIN subtasks s ON t.task_id = s.task_id WHERE t.task_id = 'task_0003';
SELECT * FROM comments WHERE task_id = 'task_0003' ORDER BY created_at ASC;

-- get all comment mentions of a user on the main dashboard asc order in time
SELECT * FROM comment_mentions cm JOIN comments c ON cm.comment_id = c.comment_id WHERE cm.mentioned_user_id = 'user_0003' ORDER BY c.created_at ASC;

-- get all comments written by user
SELECT * FROM comments WHERE created_by = 'user_0003' ORDER BY created_at ASC;

-- get all tasks assigned to user
SELECT * FROM tasks WHERE assigned_to = 'user_0003' ORDER BY due_date ASC;

-- get all project activities desc order in time
SELECT *
FROM project_activities
WHERE proj_id = 'proj_0003'
AND done_at < '2026-03-01T10:00:00'
ORDER BY done_at DESC
LIMIT 10;