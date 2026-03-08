-- creating organizations table
CREATE TABLE organizations (
    org_id VARCHAR(255) PRIMARY KEY,
    org_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ
)

-- creating users table
CREATE TABLE users (
    user_id VARCHAR(255) PRIMARY KEY, 
    user_name VARCHAR(255) NOT NULL, 
    email_id VARCHAR(255) NOT NULL UNIQUE,
    full_name VARCHAR(255),
    pswd_hash VARCHAR (255),
    created_at TIMESTAMPTZ NOT NULL
)

--  creating projects table
CREATE TABLE projects (
    proj_id VARCHAR(255) PRIMARY KEY,
    proj_name VARCHAR(255) NOT NULL,
    org_id VARCHAR(255) REFERENCES organizations (org_id),
    status VARCHAR(50) CHECK (
        status IN ('ACTIVE', 'PAUSED','ARCHIVED', 'DELETED')
    ),
    created_at TIMESTAMPTZ NOT NULL,
    CONSTRAINT unique_proj_name_org UNIQUE (org_id, proj_name) -- can't make this a primary key
)

--  creating organization_users table
CREATE TABLE org_users (
    org_id VARCHAR(255) REFERENCES organizations (org_id),
    user_id VARCHAR(255) REFERENCES users (user_id),
    role VARCHAR(255) NOT NULL CHECK (
        role IN ('ORG_MEMBER', 'ORG_ADMIN')
    ),
    -- CONSTRAINT unique_org_user UNIQUE (org_id, user_id) 
    PRIMARY KEY (org_id, user_id)
)

-- create proj_users table
CREATE TABLE proj_users (
    proj_id VARCHAR(255) REFERENCES projects (proj_id),
    user_id VARCHAR(255) REFERENCES users (user_id),
    role VARCHAR(255) NOT NULL CHECK (
        role IN ('PROJ_MEMBER', 'PROJ_MANAGER')
    ),
    PRIMARY KEY (proj_id, user_id)
)

-- creating buckets table
CREATE TABLE buckets (
    bucket_id VARCHAR(255) PRIMARY KEY,
    bucket_name VARCHAR(255) NOT NULL,
    proj_id VARCHAR(255) REFERENCES projects (proj_id),
    created_at TIMESTAMPTZ NOT NULL,
    CONSTRAINT unique_bucket_name_per_proj UNIQUE (proj_id, bucket_name)
)

-- creating tasks table
CREATE TABLE tasks (
    task_id VARCHAR(255) PRIMARY KEY,
    task_title VARCHAR(255) NOT NULL,
    task_desc TEXT,
    status VARCHAR(50) CHECK (
        status IN ('NOT_STARTED','IN_PROGRESS','COMPLETED')
    ),
    due_date TIMESTAMPTZ,
    created_by VARCHAR(255) NOT NULL REFERENCES users (user_id),
    created_at TIMESTAMPTZ NOT NULL,
    bucket_id VARCHAR(255) NOT NULL REFERENCES buckets (bucket_id),
    proj_id VARCHAR(255) NOT NULL REFERENCES projects (proj_id), 
    assigned_to VARCHAR(255) REFERENCES users (user_id)
)

-- creatin subtasks table
CREATE TABLE subtasks (
    subtask_id VARCHAR(255) PRIMARY KEY,
    subtask_title VARCHAR(255),
    status VARCHAR(50) CHECK (
        status IN ('INCOMPLETE', 'COMPLETED')
    ),
    task_id VARCHAR(255) NOT NULL REFERENCES tasks (task_id)
)

-- creating comments table
CREATE TABLE comments (
    comment_id VARCHAR(255) PRIMARY KEY,
    comment_content TEXT NOT NULL,
    created_by VARCHAR(255) NOT NULL REFERENCES users (user_id),
         TIMESTAMPTZ NOT NULL,
    task_id VARCHAR(255) NOT NULL REFERENCES tasks (task_id)
)

-- creating comment_mentions table
CREATE TABLE comment_mentions (
    comment_id VARCHAR(255) REFERENCES comments (comment_id),
    mentioned_user_id VARCHAR(255) REFERENCES users (user_id), 
    PRIMARY KEY (comment_id, mentioned_user_id)
)

-- creating project_activities table
CREATE TABLE project_activities (
    activity_id VARCHAR(25) PRIMARY KEY,
    proj_id VARCHAR(255) REFERENCES projects (proj_id), 
    activity_title VARCHAR(255),
    activity_desc TEXT,
    done_by VARCHAR(255) REFERENCES users (user_id),
    done_at TIMESTAMPTZ NOT NULL
)

-- each project must only have 1 project manager - enforce constraint
CREATE UNIQUE INDEX unique_proj_manager ON proj_users (proj_id) WHERE role = 'PROJ_MANAGER';    

-- creating indexes for faster lookups

CREATE INDEX idx_proj_bucket_tasks ON tasks (proj_id, bucket_id);
CREATE INDEX idx_tasks_assigned_to ON tasks (assigned_to);
CREATE INDEX idx_tasks_status ON tasks (proj_id, status);


CREATE INDEX idx_comments_task_id ON comments (task_id);
CREATE INDEX idx_comments_mentioned ON comment_mentions (mentioned_user_id);
CREATE INDEX idx_comments_created_by ON comments (created_by);

CREATE INDEX idx_proj_activities ON project_activities (proj_id, created_at);
CREATE INDEX idx_proj_specific_to_org ON projects (org_id, status, created_at);