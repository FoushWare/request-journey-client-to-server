# Final Solution: Saga Pattern

This directory contains Saga pattern implementation for distributed transactions.

## Files

### `saga-example.js`
- Saga orchestrator implementation
- Choreography-based saga
- Compensating actions

## Saga Pattern

### Why Saga?
- No distributed transactions (2PC)
- Eventual consistency
- Handle failures gracefully

### Saga Types

**Choreography-based:**
- Services coordinate via events
- No central coordinator
- More decentralized

**Orchestration-based:**
- Central coordinator manages saga
- More control
- Easier to understand

## Example: Create Note Saga

1. **Step 1**: Create note in Notes Service
2. **Step 2**: Update user stats in User Service
3. **If Step 2 fails**: Compensate by deleting note

## Compensation Actions

Each step has a compensating action:
- Create Note → Delete Note
- Update Stats → Revert Stats
- Send Email → Send Cancellation Email

## Best Practices

- Design compensating actions carefully
- Make steps idempotent
- Log saga execution
- Monitor saga state
- Handle compensation failures

