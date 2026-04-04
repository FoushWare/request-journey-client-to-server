# Final Solution: task-002-dead-letter-queue

This directory will contain the reference solution for this task.

## Note

Try to complete the task yourself first before looking at this solution.

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

## Walkthrough

See the task guide in `tasks/messaging/task-002-dead-letter-queue.md` for a step-by-step explanation.
