# TaskForge: Multi-Tenant Project Management SaaS Application SCHEMA DOCUMENT

## All Schemas involved

1. organization
2. users
3. org_users
4. projects
5. proj_users
6. bucket
7. task
8. subtask
9. comment
10. project_activity
11. comment_mentions

## Format of Specification of each Schema

schema_name

1. field_name: Optional[datatype] (PK | FK) # other information

## All Schemas with fields and constraints

### ORGANIZATION

1. org_id: str (PK)
2. org_name: str
3. created_at: DateTime

### USERS

1. user_id: str (PK)
2. user_name: str
3. email_id: str
4. full_name: str
5. pswd_hash: str
6. created_at: DateTime

### PROJECTS

1. proj_id: str (PK)
2. proj_name: str
3. org_id: str (FK)
4. status: "ACTIVE" || "PAUSED" || "ARCHIVED" || "DELETED"
5. created_at: DateTime
6. UNIQUE (org_id, proj_name)

### ORG_USERS

1. org_id: str (FK)
2. user_id: str (FK)
3. role: "ORG_MEMBER" || "ADMIN"
4. UNIQUE (org_id, user_id) (PK)

### PROJ_USERS

1. proj_id: str (FK)
2. user_id: str (FK)
3. role: "PROJ_MEMBER" || "PROJ_MANAGER"
4. UNIQUE (proj_id, user_id) (PK)

### BUCKET

1. bucket_id: str (PK)
2. bucket_name: str
3. proj_id: str (FK)
4. UNIQUE (proj_id, bucket_name)
5. created_at: DateTime

### TASK

1. task_id: str (PK)
2. task_title: str
3. status: "NOT_STARTED" || "IN_PROGRESS" || "COMPLETED"
4. assigned*to: Optional[str] (FK*)
5. due_date: Optional[DateTime]
6. bucket_id: str (FK)
7. proj_id: str (FK)
8. created_by: str (FK)
9. desc: Optional[str]
10. created_at: DateTime

### SUBTASK

1. subtask_id: str (PK)
2. subtask_title: str
3. status: "INCOMPLETE" || "COMPLETE"
4. task_id: str (FK)

### COMMENTS

1. comment_id: str (PK)
2. comment_content: str
3. user_id: str (FK)
4. task_id: str (FK)
5. created_at: DateTime

### COMMENT_MENTIONS

1. comment_id: str (FK)
2. user_id: str (FK)
3. PK (comment_id, user_id)

### PROJECT_ACTIVITY

1. proj_id: str (FK)
2. activity_id: str (PK)
3. activity_title: str
4. activity_desc: str
5. user_id: str (FK)
6. time: DateTime
