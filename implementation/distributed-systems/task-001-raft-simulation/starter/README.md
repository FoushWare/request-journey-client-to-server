# Starter: task-001-raft-consensus-leader-election

This is the starter code for this task. The goal is to implement the solution from scratch.

## Instructions

1. Read the task guide in `tasks/distributed-systems/task-001-raft-consensus-leader-election.md`
2. Implement the solution in this directory
3. Compare your solution with `../final-solution/`

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

## Getting Started

```bash
# Start required services
docker-compose up -d

# Install dependencies (if applicable)
# Go: go mod tidy
# Python: pip install -r requirements.txt
# Node: npm install
```
