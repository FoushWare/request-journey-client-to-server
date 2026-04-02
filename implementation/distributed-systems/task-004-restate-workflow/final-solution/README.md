# Final Solution: task-004-restate-notes-app-workflow

This directory will contain the reference solution for this task.

## Note

Try to complete the task yourself first before looking at this solution.

## Architecture Diagram

```mermaid
graph TB
    Client["📱 Client\nPOST /api/notes"]
    Restate["⚙️ Restate Server\n(durable workflow engine)"]
    Auth["🔐 Auth Step\n(validate token)"]
    Notes["📝 Notes Step\n(save to MongoDB)"]
    Email["📧 Email Step\n(send via SES)"]
    Search["🔍 Search Step\n(index in Elasticsearch)"]

    Client -->|invoke workflow| Restate
    Restate --> Auth
    Auth -->|pass| Notes
    Notes -->|pass| Email
    Email -->|pass| Search

    style Restate fill:#f3e5f5,stroke:#9c27b0
    style Client fill:#e1f5fe
```

## Walkthrough

See the task guide in `tasks/distributed-systems/task-004-restate-notes-app-workflow.md` for a step-by-step explanation.
