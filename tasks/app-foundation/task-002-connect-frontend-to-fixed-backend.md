# Task 002: Connect Frontend to Backend with Fixed Responses (No Database)

**Priority Phase:** 2 (Real HTTP path)  
**Prerequisites:** Task 001 complete  
**Estimated Time:** 3-4 hours

---

## Objective

Replace mock-server-only mode with a real backend process that returns fixed/in-memory responses.

## Learning Outcomes

- Validate real client-server integration early
- Establish API shape before database complexity
- Isolate backend transport/controller concerns

## Required Implementation

1. Build backend routes matching the API contract from task 001.
2. Return fixed or in-memory responses for auth and notes operations.
3. Add request validation and standard error payload format.
4. Point frontend to backend base URL and remove direct mock dependency for normal mode.
5. Keep optional mock mode for debugging.

## Verification

- Frontend talks to backend over HTTP and user journeys still work.
- Backend can restart without data migration concerns.
- API responses are stable and documented.

## Next Task

Proceed to `task-003-connect-backend-to-real-database.md`.
