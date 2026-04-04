# Final Solution: task-003-durable-execution-restate

This directory will contain the reference solution for this task.

## Note

Try to complete the task yourself first before looking at this solution.

## Architecture Diagram

```mermaid
graph TB
    subgraph Client["📱 Client"]
        API["POST /api/notes"]
    end

    subgraph Restate["⚙️ Restate Server"]
        Journal["Durable Journal\n(persists each step)"]
        Workflow["createNoteWorkflow\n1. validateUser\n2. saveNote\n3. sendEmail (if first note)\n4. updateSearchIndex"]
    end

    subgraph Services["🔧 Services"]
        AuthSvc["Auth Service\n(validateUser)"]
        NotesSvc["Notes Service\n(saveNote → MongoDB)"]
        EmailSvc["Email Service\n(SES → user)"]
        SearchSvc["Search Service\n(Elasticsearch index)"]
    end

    API -->|invoke workflow| Restate
    Journal -->|retry on crash| Workflow
    Workflow --> AuthSvc
    Workflow --> NotesSvc
    Workflow --> EmailSvc
    Workflow --> SearchSvc

    style Client fill:#e1f5fe
    style Restate fill:#f3e5f5
    style Services fill:#e8f5e9
```

## Walkthrough

See the task guide in `tasks/distributed-systems/task-003-durable-execution-restate.md` for a step-by-step explanation.
