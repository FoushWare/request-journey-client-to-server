# Starter: task-005-zookeeper-fundamentals

This is the starter code for this task. The goal is to implement the solution from scratch.

## Instructions

1. Read the task guide in `tasks/distributed-systems/task-005-zookeeper-fundamentals.md`
2. Implement the solution in this directory
3. Compare your solution with `../final-solution/`

## Architecture Diagram

```mermaid
graph TB
    Client["🖥️ ZooKeeper Client"]
    ZK["🦁 ZooKeeper Ensemble\n(3 or 5 nodes)"]
    Leader["👑 Leader Node"]
    Follower1["📋 Follower 1"]
    Follower2["📋 Follower 2"]
    Znodes["🌲 Znode Tree\n/election, /config, /locks"]

    Client -->|connect| ZK
    ZK --> Leader
    Leader --- Follower1
    Leader --- Follower2
    ZK -->|read/write| Znodes

    style Leader fill:#ff9,stroke:#f90
    style ZK fill:#e8f5e9
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
