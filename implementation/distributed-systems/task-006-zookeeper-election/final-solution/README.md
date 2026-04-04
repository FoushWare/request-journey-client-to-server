# Final Solution: task-006-zookeeper-leader-election

This directory will contain the reference solution for this task.

## Note

Try to complete the task yourself first before looking at this solution.

## Architecture Diagram

```mermaid
graph TB
    subgraph ZK["/election/ znodes"]
        Z1["🔢 /election/n-0000000001\n(Candidate A — lowest)"]
        Z2["🔢 /election/n-0000000002\n(Candidate B)"]
        Z3["🔢 /election/n-0000000003\n(Candidate C)"]
    end
    A["Candidate A → 👑 Leader"]
    B["Candidate B watches n-0001"]
    C["Candidate C watches n-0002"]

    Z1 -->|is leader| A
    Z2 -->|watches preceding| B
    Z3 -->|watches preceding| C

    style A fill:#ff9,stroke:#f90
    style Z1 fill:#c8e6c9
```

## Walkthrough

See the task guide in `tasks/distributed-systems/task-006-zookeeper-leader-election.md` for a step-by-step explanation.
