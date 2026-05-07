# Task 001: Run Notes App with Mock Server (No Backend)

**Priority Phase:** 1 (App-first visibility)  
**Prerequisites:** None  
**Estimated Time:** 2-3 hours

---

## Objective

Make the frontend fully usable before any backend exists by using a mock API server.

## Learning Outcomes

- Understand API contract-first development
- Use mock responses to unblock frontend progress
- Validate core user journeys without backend coupling

## Required Implementation

1. Define API contract for auth and notes endpoints.
2. Add a mock server that returns realistic JSON responses.
3. Connect frontend API client to the mock server.
4. Support core flows: login, create note, list notes, logout.
5. Add error-state mocks (401, 500, timeout).

## Verification

- Frontend runs and all key screens work with no backend process.
- Mocked data appears consistently after refresh behavior expected by UI.
- Error states are visible and handled in UI.

## Next Task

Proceed to `task-002-connect-frontend-to-fixed-backend.md`.
