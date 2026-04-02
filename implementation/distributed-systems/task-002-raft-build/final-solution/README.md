# Final Solution: task-002-build-raft-simulation

This directory will contain the reference solution for this task.

## Note

Try to complete the task yourself first before looking at this solution.

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

## Walkthrough

See the task guide in `tasks/distributed-systems/task-002-build-raft-simulation.md` for a step-by-step explanation.
