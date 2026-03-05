# TaskForge: Multi-Tenant Project Management SaaS Application INDICES & CONSTRAINTS DOCUMENT

## FEATURE-WISE DB QUERY REQUIREMENTS

### Login

1. Fetch user using email_id or user_name
2. Select organization during login

### Registration

1. Check if email_id or user_name are taken
2. Password must be 8-24 characters long, with at least 1 lowercase character, 1 uppercase character, 1 digit and 1 symbol out of ["-", "_", "@", ".", "$"]

### Main Dashboard

1. Show all projects pertaining to specific organization
2. If user is "ADMIN", they can view all org_users
3. Project names must be unique under a specific organization
4. View all tasks assigned to user irrespective of projects

### Project Dashboard

Given below are all filter-based views:

1. Show all tasks assigned to user specific to project
2. Show all tasks based on status specific to project
3. Show all tasks specific to project
4. Show all tasks based on buckets specific to project
5. If user is PROJ_MANAGER, they can view the project history specific to project - load recent 20, and load more on request
6. If user is PROJ_MANAGER, they can view all proj_users
7. Open comment mentions specific to user_id
8. Each project can have only 1 project manager
9. View all comment mentions

### Open Task Modal

1. View all data about task using task_id: subtask, comments, description, status, assigned_to, title, due_date, created_by

## How would these reflect on adding Indices & Constraints?

### Login

To fetch users using their email_id or user_name and must be unique

1. UNIQUE(email_id) on USERS schema
2. UNIQUE(user_name) on USERS schema

Setting a unique constraint automatically creates the index, so there's no ned to explicitly set these indices

### Registration

To check if email_id or user_name are taken, the constraints from Login will suffice.

To hash password, constraints must NOT be applied at a DB level, and hence will not be handled here.

### Main Dashboard

To view all projects specific to organization at once:

1. INDEX(org_id, status, created_at DESC) on PROJECTS schema (can index based on schema as well)

To view all project users specific to organization at once:

1. INDEX(org_id) on ORG_USERS -- automatically created using the PK(org_id, user_id) on ORG_USERS

To ensure project names are unique specific to organization:

1. UNIQUE(org_id, proj_name) on PROJECTS

To view all tasks assigned to user irrespective of projects:

1. INDEX(assigned_to) on TASKS

### Project Dashboard

To be able to view all filter-based versions of data on the project dashboard:

1. INDEX (proj_id) on TASKS -- specific to project (derived from 2)
2. INDEX(proj_id, status) on TASKS -- specific to status (you cannot filter only based on status within TASKS because TASKS is a schema that contains tasks spanning across all projects)
3. INDEX(proj_id, bucket_id) on TASKS -- filter based on buckets
4. INDEX(proj_id) on PROJ_USERS
5. INDEX(project_id, assigned_to) on TASKS (derived from 2)

Since each project can have only 1 PROJ_MANAGER

1. UNIQUE(proj_id, role = "PROJ_MANAGER") on PROJ_USERS

To load only the most recen 20 project activities in the project history,

1. INDEX(proj_id, created_at DESC) on PROJECT_ACTIVITY

To view all comment mentions

1. INDEX(user_id) on COMMENT_MENTIONS

### Open Task Modal

To view all metadata specific to task

1. INDEX(task_id) on TASKS -- automatically created since task_id is a primary key

To view all comments in the task modal

1. INDEX(task_id, created_at ASC) on COMMENTS
