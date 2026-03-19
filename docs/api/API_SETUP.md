# TaskForge: Multi-Tenant Project Management SaaS Application SETTING UP API

## API Setup in FastAPI

### Tasks Involved in setting up API

1. setting up routes for each action in the website
2. setting up models in sqlalchemy to work with PostgreSQL in Supabase
3. ensuring all code adheres to CLEAN architecture

## Actions to be coded for within API

- [ ] Authentication: login/ and signup/
- [ ] Get all organizations the user is a part of
- [ ] ADMIN access allows for elevated actions within organization -> CRUD operations with members
- [ ] Get all projects within an organization
- [ ] View all project history, tasks, buckets, members, and comment mentions within a project
- [ ] U,D operations with project members if user is a project manager
- [ ] CRUD with tasks, subtasks
- [ ] CRUD with buckets
- [ ] CRD with comments within tasks

### NOTE: we must remember to trace each action listed above to any one of the user entities described within the system: org_member, org_admin, proj_member, proj_managers

### some actions are not bound to user entities

1. creating organizations

### actions for org admin

1. create projects within an organization
2. get all projects within an organization
3. delete projects from organization
4. update status, title, description of projects within an organization
5. add organization members to different projects
6. view all members within an organization
7. update the access level of a member within an organization
8. delete a member from an organization

### actions for org member

1. be able to navigate to different projects -> get projects within an organization, which they are a part of
2. view all members within an organization
3. view all projects within an organization - but not navigate to it

### actions for project manager

1. update status, title, and description of a project
2. view, create, update, delete all buckets within a project
3. view, create, update, delete, assign all tasks within a bucket
4. view, create, update, delete all subtasks + metadata + comments within a task
5. view all comment mentions for the current user
6. view projects activities for a project

### actions for a project member

1. view all buckets within a project
2. view, create, update, delete, assign all tasks within a bucket
3. view, create all subtasks + metadata + comments within a task
4. update, delete all subtasks + metadata + comments within a task if they created it themselves
5. view all comment mentions for the current user
6. view project activities for a project
