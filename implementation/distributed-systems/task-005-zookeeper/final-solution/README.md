# Final Solution: task-005-zookeeper-fundamentals

This directory will contain the reference solution for this task.

## Note

Try to complete the task yourself first before looking at this solution.

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

## Walkthrough

See the task guide in `tasks/distributed-systems/task-005-zookeeper-fundamentals.md` for a step-by-step explanation.
