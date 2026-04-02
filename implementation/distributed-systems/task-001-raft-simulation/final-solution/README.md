# Final Solution: task-001-raft-consensus-leader-election

This directory will contain the reference solution for this task.

## Note

Try to complete the task yourself first before looking at this solution.

## Architecture Diagram

```mermaid
graph TB
    subgraph Election["Leader Election (Raft)"]
        C1["🟡 Candidate 1\n(RequestVote RPC)"]
        C2["🟡 Candidate 2\n(RequestVote RPC)"]
        F1["📋 Follower 1"]
        F2["📋 Follower 2"]
        F3["📋 Follower 3"]
    end
    Leader["👑 Elected Leader"]

    C1 -->|vote request| F1
    C1 -->|vote request| F2
    C1 -->|vote request| F3
    C1 -->|majority votes| Leader

    style Leader fill:#ff9,stroke:#f90
    style C1 fill:#fff9c4
```

## Walkthrough

See the task guide in `tasks/distributed-systems/task-001-raft-consensus-leader-election.md` for a step-by-step explanation.
