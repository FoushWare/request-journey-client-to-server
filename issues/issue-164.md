# Issue #164: Saga, CQRS, and Event Sourcing Patterns

**State:** Open  
**Created:** 2026-03-31T07:34:39Z  
**Updated:** 2026-03-31T08:24:02Z  
**URL:** https://github.com/FoushWare/request-journey-client-to-server/issues/164

**Labels:** None

---

## Description

Apply microservices coordination and data patterns that solve three of the hardest distributed systems problems:

- **Saga Pattern** — distributed transactions without 2PC (choreography + orchestration styles)
- **CQRS (Command Query Responsibility Segregation)** — separate read and write models for performance and clarity
- **Event Sourcing** — store state as a sequence of events (immutable audit log, time-travel debugging)

These three patterns form a powerful combination: Event Sourcing stores history, CQRS separates read/write concerns, and Saga coordinates multi-step workflows.

---

## Why These Patterns Matter

Traditional databases use in-place state mutations and distributed transactions (2PC) that don't scale in microservices. These patterns replace that model:

| Problem | Solution |
|---------|----------|
| Distributed transactions across services | Saga (compensating transactions) |
| Read performance bottleneck, JOIN hell | CQRS (dedicated read model) |
| No audit trail, hard debugging | Event Sourcing (event log as source of truth) |
| Multi-step business flows | Saga orchestration |

---

## Key Concepts

### Saga Pattern
- Each step emits an event; next step reacts to it (choreography)
- OR a central orchestrator service drives the workflow (orchestration)
- On failure: compensating transactions undo completed steps
- Already introduced in task-006 (microservices)

### CQRS
- **Command side**: handles writes (CreateNote, UpdateNote, DeleteNote)
- **Query side**: handles reads (GetNote, ListNotes) with denormalized, fast read models
- Both sides can scale independently
- Read model updated via events (eventual consistency)

### Event Sourcing
- Never mutate state directly — append an event to an event log
- Current state = replay of all events
- Benefits: full audit, time-travel debugging, easy CQRS integration
- Challenges: event schema evolution, snapshots for long-lived aggregates

### How They Work Together
1. Command → CQRS write model handles it
2. Event → stored in event store (Event Sourcing)
3. Read model → updated asynchronously from events
4. Saga → reacts to events, coordinates cross-service workflows

---

## Learning Objectives

- [ ] Understand CQRS: separate Command and Query models
- [ ] Implement CQRS for the Notes service (write DB + read DB)
- [ ] Understand Event Sourcing: events as the source of truth
- [ ] Implement an event store for Notes domain events
- [ ] Combine CQRS + Event Sourcing in the Notes service
- [ ] Understand Saga pattern (already covered in task-006)
- [ ] See how all three patterns integrate in a single Notes workflow

---

## Tasks to Create

- `tasks/microservices/task-013-cqrs-event-sourcing.md`

---

## Notes App Integration

The Notes service will be refactored to:
- Accept `CreateNote` / `UpdateNote` / `DeleteNote` commands on the write side
- Store `NoteCreated` / `NoteUpdated` / `NoteDeleted` events in an event store (EventStoreDB or Kafka)
- Project events into a read-optimized MongoDB/Redis read model
- Use Saga to coordinate `Create Note → Send Email Notification → Confirm` workflow
