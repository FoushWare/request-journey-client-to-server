# Task 003: Connect Backend to Real Database

**Priority Phase:** 3 (Data persistence)  
**Prerequisites:** Task 002 complete  
**Estimated Time:** 4-6 hours

---

## Objective

Replace fixed backend responses with persistent storage using a real database.

## Learning Outcomes

- Integrate persistence layer with service logic
- Apply schema/migrations and data access patterns
- Validate end-to-end functional behavior with real data

## Required Implementation

1. Define schema for users and notes.
2. Add migration/bootstrap process.
3. Replace in-memory/fixed handlers with real DB operations.
4. Add environment-based DB configuration.
5. Preserve API contract from tasks 001-002.

## Verification

- Notes persist across backend restarts.
- Authentication and note CRUD work against real database.
- Basic failure scenarios handled (DB unavailable, bad input).

## Next Task

Continue with Priority Phase 4: Docker containerization tasks.
