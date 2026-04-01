# Issue #165: Testing Microservices (Unit, Integration, E2E, Contract, Production Tests)

**State:** Open  
**Created:** 2026-03-31T12:50:37Z  
**Updated:** 2026-03-31T12:50:37Z  
**URL:** https://github.com/FoushWare/request-journey-client-to-server/issues/165

**Labels:** None

---

## Description

Implement a full microservices testing strategy covering all levels of the testing pyramid and advanced production-level testing techniques:

- **Unit tests** — individual functions and classes in isolation
- **Integration tests** — service + dependencies (DB, cache, message broker)
- **E2E tests** — full request flow across all services
- **Contract tests** — API consumer/provider contracts using Pact
- **Production tests** — blue-green deployment + canary testing in production

---

## Why Testing Microservices is Hard

Testing microservices is significantly more complex than testing a monolith:
- Services have **network boundaries** — you can't call a function, you make HTTP or gRPC calls
- **Data isolation** — each service owns its own DB, making integration state management tricky
- **Asynchronous events** — testing Kafka/RabbitMQ flows requires special tooling
- **Contract drift** — consumers and providers evolve independently, breaking APIs silently
- **Production is different** — staging environments never perfectly match prod traffic

---

## Key Concepts

### Testing Pyramid for Microservices

```
         E2E
        /    \
   Integration
  /            \
   Unit Tests (base)
```

Many unit tests (cheap, fast), fewer integration tests, minimal E2E tests (slow, expensive).

### Contract Testing (Pact)
- **Consumer** writes a contract: "I expect this API to return these fields"
- **Provider** verifies it hasn't broken the contract
- Prevents breaking changes from silently propagating
- Tools: Pact, Spring Cloud Contract, PactFlow

### Blue-Green Deployment Testing
- Two identical environments: blue (current) and green (new)
- Route 100% traffic to blue while green is prepared and tested
- Switch traffic to green once green passes all tests
- Instant rollback by switching back to blue

### Canary Testing
- Route a small percentage (e.g., 5%) of real traffic to the new version
- Monitor error rates, latency, and user behavior
- Gradually increase traffic percentage if metrics stay healthy
- Automatic rollback if error rate exceeds threshold

---

## Learning Objectives

- [ ] Write unit tests for a Notes microservice handler
- [ ] Write integration tests with TestContainers (real DB/Redis in Docker)
- [ ] Write E2E tests across all Notes App services
- [ ] Implement contract tests with Pact (consumer + provider)
- [ ] Configure blue-green deployment in Kubernetes
- [ ] Configure canary releases with traffic splitting
- [ ] Monitor production tests with error rate alerts

---

## Tools Referenced

- **Pact** — open-source contract testing
- **PactFlow** — SaaS contract broker for CI/CD integration
- **Spring Cloud Contract** — JVM-based contract testing
- **TestContainers** — real Docker containers for integration tests
- **Jest / Vitest** — unit and integration tests for Node.js
- **Playwright / Cypress** — E2E browser testing
- **K6 / Artillery** — load/performance testing in production

---

## Tasks to Create

- `tasks/microservices/task-014-microservices-testing.md`

---

## Notes App Integration

- Unit test each Notes service handler (create, update, delete, list)
- Integration test Notes API with real PostgreSQL via TestContainers
- E2E test: create note via frontend → backend → DB → return response
- Contract test: Frontend (consumer) defines contract for Notes API (provider)
- Canary: deploy new version of Notes API to 10% traffic, watch error rate
