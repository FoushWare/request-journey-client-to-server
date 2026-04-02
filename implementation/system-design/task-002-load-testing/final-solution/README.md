# Final Solution: task-002-load-testing-k6

This directory will contain the reference solution for this task.

## Note

Try to complete the task yourself first before looking at this solution.

## Architecture Diagram

```mermaid
graph TB
    k6["🔧 k6 Load Generator\n(virtual users, ramp-up scripts)"]
    API["🌐 Notes API\n(Express / NestJS)"]
    DB["🗄️ PostgreSQL"]
    Cache["⚡ Redis Cache"]
    Metrics["📊 k6 Metrics\n(stdout / InfluxDB / Grafana)"]

    k6 -->|HTTP requests| API
    API --> Cache
    API --> DB
    k6 -->|reports| Metrics

    style k6 fill:#ff9,stroke:#f90
    style Metrics fill:#e1f5fe
```

## Walkthrough

See the task guide in `tasks/system-design/task-002-load-testing-k6.md` for a step-by-step explanation.
