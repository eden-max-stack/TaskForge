# TaskForge: Multi-Tenant Project Management SaaS Application SCOPE DOCUMENT

## Problem Statement

Small to mid-sized enginering teams require project management applications to track their ongoing projects, tasks within each project, and maintain a log of activities performed on a daily basis.

This project aims to solve the problem by providing a multi-tenant solution for organization-only memberships, allowing teams to track their projects, tasks, members, and logs.

This project is not intended for solo devs looking to track their work.

## Target Users

- Small organizations with 5-15 members
- Teams with a project manager + developers
- Not intended for solo devs
- Not intended for teams larger than 30 people (could get crowded)

## Core System Concepts

### ORGANIZATION:

- An **organization** is a team within the system, comprised of both the MEMBERS and the MANAGER
- Any tenant who signs up can use the website only through an organization.
- A single organization can have a maximum of 30 members (including a manager).

### USER

- A user can sign up individually to the system, but cannot avail its services OUTSIDE of the scope of an organization
- A user can be a part of upto 2 organizations at a time
- Identity of the user is global
- Role of the user is organization-specific
- Any user is allowed to create organizations

### ORGANIZATION MEMBER

- An **organization member** is a user who is part of an organization
- An organization member can be part of multiple projects within the organization
- An organization member is assigned one out of two roles: ORG_MEMBER | ADMIN

### PROJECTS

- Each organization is allowed to create upto 3 projects (app constraint - ideally want to setup a freemium model)
- Each project contains metadata: title, description (optional), team information (members + access rights to each member), and status ( ACTIVE | PAUSED | ARCHIVED | DELETED )
- Within each project, there are **buckets** of tasks to be completed.
- The status of the project will filter projects in the UI
  - An "active" project will be stored and easily accessible from UI
  - A "paused" project will be stored in the same DB as "active" project for upto 30 days, and then will be moved to the archive
  - An "archived" project means that a project is not being retrieved often.
  - A "deleted" project will be tracked in the project history, but will no longer exist in the DB

### PROJECT USERS

- A **project user** is an organization member who is part of a specific project
- A project user is assigned one out of 2 roles: PROJ_MEMBER | PROJ_MANAGER (manager has elevated rights)

### PROJECT ACTIVITY

- An **activity** within a project is an event performed by any project user
- Examples include updating task progress, modifying project metadata, CRUD of project user, CRUD of buckets

### PROJECT HISTORY

- **Project history** refers to the version history on a project-level
- This tracks all activity within a project, such as:
  - CRUD of buckets
  - CRUD of tasks (inclusive of sub-tasks)
  - Updation/Deletion of project (inclusive of project metadata)
  - CRUD of project users, and their access rights
- A log within the project history tracks: activity title, member who performed the activity, event time
- Project history is immutable, and append-only.
- It is automatically tracked and written to through backend jobs

### BUCKETS

- A **bucket** in a project refers to a domain of tasks to be completed
- Within a project, the "manager" will be able to create up to 10 buckets (ideally part of the freemium model)
- Each bucket contains several tasks within it
- Each bucket is completely customizable, with the following metadata: title, description, task log/version history
- Buckets are not equal to project status. An example of a project bucket is "frontend tasks", "backend tasks", etc. Since the buckets are customizable, the bucket names can also be TODO, PROGRESS, BACKLOGS if preferred.

### TASKS

- A **task** is a checklist item within a bucket in a project
- A task can have sub-tasks within it going upto 1 level only (a sub-task within a task cannot have sub-tasks of itself; no recursion is handled)
- Each task contains the following metadata: title, description, sub-tasks within the task, assigned_to (optional), due date, comments, status

### SUB-TASKS

- A **sub-task** is a smaller task within a task
- A sub-task contains only the title of the sub-task
- A sub-task cannot have sub-tasks of its own
- It does not contain metadata such as due_date, assgined_to, or comments

### COMMENTS

- **Comments** are written by any project user under a specific project task
- Multiple comments can be written for a specific task
- No threads of comments can be created for any task; each comment is a stand-alone comment (there can be no replies to any comment)
- Members can @ any other project user within a comment

## Core Features (v1)

1. Authentication
   - Register
   - Sign in
2. Organizations
   - CRUD of organizations
   - Inviting/Removing members to organizations
   - Assigning roles in organizations
3. Projects
   - CRUD of projects
   - List projects
   - Invite members to projects
4. Tasks
   - CRUD of tasks
   - Adding sub-tasks to tasks
   - Adding comments to tasks
   - Setting optional due date
   - Setting optional "assigned to member"
5. Project History
   - Log all activities within project history
   - List most recent 100 activities, load more on request
   - Filter based on dates
6. Buckets
   - Upto 10 buckets can be added for each project
   - CRUD for each bucket
7. Project Dashboard
   - Navigation to any organization at time of login
   - Navigation to any project from application dashboard
   - View all buckets within a project in dashboard
   - Multiple views of project buckets: list view, kanban board view
   - View latest 10 activities
8. Member Dashboard
   - View all assigned tasks
   - View any mentions on any tasks (under comments)
9. Daily Summary Report
   - Daily summary report stored in database
10. Caching
    - Cache dashboard metrics with TTL

## Future Ideas (not included in v1)

1. Project Templates
2. File attachments to tasks
3. No search engines
4. No notifications
5. No task dependencies

## Multi-Tenancy Model

There is no separate database per organization. Data isolation is enforced at application- and database-level based on organization_id foreign key in all domain tables.

## Role-Based Access Model

### ORGANIZATION-LEVEL ROLES

1. ORG_MEMBER: Organization members are allowed to
   - Creation of projects
2. ORG_ADMIN: Organization admins are allowed to
   - CRUD of organization members
     atop all access rights of organization members
3. PROJ_MEMBER: Project members are allowed to
   - CRUD of tasks
   - Comments on all tasks within project
   - View project history
4. PROJ_MANAGER: Project managers are allowed to
   - RUD of projects
   - CRUD of buckets
   - CRUD of organization_members (add organization members into project, remove project users from project)

## Data Integrity Rules

- A task must always belong to a valid project.
- A project must always belong to a valid organization.
- A user cannot have duplicate membership in the same organization.
- Activity logs are immutable.
- Tasks cannot exist without a creator.
- Sub-tasks can only exist under a valid task.
- Comments are stand-alone, and cannot have replies.
- A project can only have upto 10 buckets.
- Bucket names must be unique per project
- A user can be PROJ_MANAGER within 1 project and a PROJ_MEMBER within another
- Project users cannot exist outside of an organization

## Scalability Assumptions

- < 100 organizations
- < 1000 users
- < 100k tasks

## Architecture Style

- Monolithic backend (no microservices because let's not get ahead of ourselves now)
- RESTful API
- Relational database (Postgres) (most of the data stored will be short and queried for different views in the UI, which works better with relational DBs)
- Background jobs via cron
- Redis for selective caching
