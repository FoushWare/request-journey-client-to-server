# Starter: task-003-durable-execution-restate

This is the starter code for this task. The goal is to implement the solution from scratch.

## Instructions

1. Read the task guide in `tasks/distributed-systems/task-003-durable-execution-restate.md`
2. Implement the solution in this directory
3. Compare your solution with `../final-solution/`

## Architecture Diagram

```mermaid
graph TB
    Client["📱 Client"]
    Restate["⚙️ Restate Server\n(durable journal)"]
    Handler["🔧 Service Handler\n(idempotent steps)"]
    DB["🗄️ MongoDB"]
    Email["📧 Email Service"]

    Client -->|invoke| Restate
    Restate -->|execute with retries| Handler
    Handler --> DB
    Handler --> Email

    style Restate fill:#f3e5f5,stroke:#9c27b0
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
