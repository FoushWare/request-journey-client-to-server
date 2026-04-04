# Starter: task-002-dead-letter-queue

This is the starter code for this task. The goal is to implement the solution from scratch.

## Instructions

1. Read the task guide in `tasks/messaging/task-002-dead-letter-queue.md`
2. Implement the solution in this directory
3. Compare your solution with `../final-solution/`

## Architecture Diagram

```mermaid
graph TB
    Producer["📤 Producer\n(Notes Service)"]
    Topic["📨 Kafka Topic\nnotes-events"]
    Consumer["📥 Consumer\n(Email Service)"]
    DLQ["☠️ Dead Letter Queue\nnotes-events-dlq"]
    Monitor["🔔 DLQ Monitor\n(alert on poison messages)"]

    Producer -->|publish| Topic
    Topic -->|consume| Consumer
    Consumer -->|fail after retries| DLQ
    DLQ -->|alert| Monitor

    style DLQ fill:#ffcdd2,stroke:#f44336
    style Consumer fill:#fff9c4
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
