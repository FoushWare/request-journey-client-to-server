# Starter: task-002-build-raft-simulation

This is the starter code for this task. The goal is to implement the solution from scratch.

## Instructions

1. Read the task guide in `tasks/distributed-systems/task-002-build-raft-simulation.md`
2. Implement the solution in this directory
3. Compare your solution with `../final-solution/`

## Architecture Diagram

```mermaid
graph TB
    subgraph Cluster["Raft Cluster (5 nodes)"]
        Leader["👑 Leader\n(sends heartbeats)"]
        F1["📋 Follower 1"]
        F2["📋 Follower 2"]
        F3["📋 Follower 3"]
        F4["📋 Follower 4"]
    end
    Client["🌐 Client"]

    Client -->|write request| Leader
    Leader -->|AppendEntries RPC| F1
    Leader -->|AppendEntries RPC| F2
    Leader -->|AppendEntries RPC| F3
    Leader -->|AppendEntries RPC| F4

    style Leader fill:#ff9,stroke:#f90
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
