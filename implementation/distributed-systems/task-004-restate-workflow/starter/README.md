# Starter: task-004-restate-notes-app-workflow

This is the starter code for this task. The goal is to implement the solution from scratch.

## Instructions

1. Read the task guide in `tasks/distributed-systems/task-004-restate-notes-app-workflow.md`
2. Implement the solution in this directory
3. Compare your solution with `../final-solution/`

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

## Getting Started

```bash
# Start required services
docker-compose up -d

# Install dependencies (if applicable)
# Go: go mod tidy
# Python: pip install -r requirements.txt
# Node: npm install
```
