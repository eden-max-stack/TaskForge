# TaskForge: Multi-Tenant Project Management SaaS Application PERFORMANCE NOTES - REVERSE INDEX CHECKING

Earlier, I wrote a document called 'indices_and_constraints.md' where I created indices based on what I assumed would be required.

Then I wrote another focument 'query_simulation.md' today which helped me reverse engine any indices that seemed redundant / were not included.

I used EXPLAIN ANALYZE to understand whether indices were used or not.

1. in the task: get all task meta, subtasks, and comments for a task when you open the task modal - an IDX was used on tasks t, but not subtasks s, so I had to create an index on subtasks based on task_id

Earlier runtime: 3.11 ms
After applying index in subtasks: 0.010ms

2. in the task: get all comment mentions of a user on the main dashboard asc order in time - there was no index created on comments based on created_at so I created it - sql still uses seq scan bcz the table only has 600 rows and index lookup is more expensive

3. in the task: get all buckets within a project - there was no index created on buckets based on proj_id so i created it. it still uses a seq scan?

Earlier runtime: 1.06 ms
After applying index in buckets: 0.02 ms
