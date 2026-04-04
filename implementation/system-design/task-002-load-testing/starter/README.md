# Starter: task-002-load-testing-k6

This is the starter code for this task. The goal is to implement the solution from scratch.

## Instructions

1. Read the task guide in `tasks/system-design/task-002-load-testing-k6.md`
2. Implement the solution in this directory
3. Compare your solution with `../final-solution/`

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

## Getting Started

```bash
# Start required services
docker-compose up -d

# Install dependencies (if applicable)
# Go: go mod tidy
# Python: pip install -r requirements.txt
# Node: npm install
```
