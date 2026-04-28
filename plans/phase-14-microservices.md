# Phase 14 — Microservices Architecture

## Overview

The Notes App backend started as a single Express server. This phase decomposes it into independent microservices — **Auth Service**, **Notes Service**, **Email Service**, and **Search Service** — each with its own database, deployed independently, and communicating via REST, gRPC, and Kafka events. All services share an **Nx monorepo** for shared libraries, consistent tooling, and affected-only builds.

## Prerequisites

- **Phase 03 complete** — Kubernetes can deploy multiple services independently
- **Phase 11 complete** — gRPC (introduced in networking) is used for internal calls
- **Phase 13 complete** — Istio service mesh manages service-to-service communication
- Kafka cluster running (preview: Phase 17 will deepen Kafka knowledge)

## Learning Objectives

- Understand microservices principles: single responsibility, database per service, loose coupling
- Design the database strategy: PostgreSQL for Auth, MongoDB for Notes, Redis for cache, Elasticsearch for Search
- Refactor the monolith into independent Node.js / Go services in an Nx monorepo
- Implement service discovery via Kubernetes CoreDNS
- Add resilience patterns: circuit breakers, retries, and timeouts (Istio handles these transparently)
- Instrument distributed tracing with OpenTelemetry and Jaeger across all services
- Implement the Saga pattern for distributed transactions (note creation → email notification → search indexing)
- Implement CQRS (Command Query Responsibility Segregation) for the Notes Service
- Implement Event Sourcing for the Notes Service audit log
- Write comprehensive microservices tests (unit, integration, contract, end-to-end)
- Deploy microservices to EKS (each service gets its own Deployment + Service + HPA)

## Task Sequence

Complete the following tasks **in order**:

1. `tasks/microservices/task-001-introduce-microservices-architecture.md`
   > Learn the principles, benefits, and trade-offs of microservices vs monolith. Draw the Notes App decomposition diagram.

2. `tasks/microservices/task-002-microservices-database-design.md`
   > Design database-per-service: Auth → PostgreSQL, Notes → MongoDB, Search → Elasticsearch, Sessions → Redis. Understand how the Saga pattern handles cross-service data consistency.

3. `tasks/microservices/task-003-service-discovery-kubernetes.md`
   > Understand how CoreDNS resolves `http://auth-service.notes-app.svc.cluster.local`. Configure services to call each other by DNS name.

4. `tasks/microservices/task-004-circuit-breakers-retries.md`
   > Configure Istio `DestinationRule` to add circuit breaking and automatic retries. Verify the Notes Service retries a transient Auth Service failure automatically.

5. `tasks/microservices/task-005-distributed-tracing-jaeger.md`
   > Add OpenTelemetry SDK to every service. Propagate `traceparent` headers across REST and gRPC calls. View end-to-end traces in Jaeger.

6. `tasks/microservices/task-006-saga-pattern.md`
   > Implement the Saga choreography pattern for note creation: Notes Service publishes `note.created` → Email Service consumes and sends email → Search Service consumes and indexes. Handle compensation if indexing fails.

7. `tasks/microservices/task-007-cqrs-pattern.md`
   > Split the Notes Service into a Command side (writes to MongoDB) and a Query side (reads from Elasticsearch). Route `GET /notes` to the read model, `POST /notes` to the write model.

8. `tasks/microservices/task-008-event-sourcing.md`
   > Store every note mutation as an immutable event in an event store. Replay events to reconstruct state. Implement an audit log endpoint.

9. `tasks/microservices/task-009-nx-monorepo.md`
   > Scaffold the Nx workspace with `nx generate @nrwl/node:app` for each service. Create shared libraries (`libs/shared-types`, `libs/shared-auth`). Run `nx affected:build` — only changed services rebuild.

10. `tasks/microservices/task-010-api-gateway-pattern.md`
    > Add an API Gateway that routes `/api/auth/*` → Auth Service, `/api/notes/*` → Notes Service, `/api/search/*` → Search Service. The gateway validates JWTs before forwarding.

11. `tasks/microservices/task-011-microservices-testing.md`
    > Write: (a) unit tests per service, (b) integration tests against real databases, (c) contract tests with Pact between the Notes MFE and Notes Service, (d) end-to-end test that creates a note and verifies the email arrives.

12. `tasks/microservices/task-012-resilience-patterns.md`
    > Implement bulkhead pattern (separate thread pools per downstream service). Add timeout + fallback in the Notes Service for the case where Search Service is unavailable.

13. `tasks/microservices/task-013-deploy-microservices.md`
    > Deploy all four services to EKS. Each service has its own `Deployment`, `Service`, `HPA`, and `ConfigMap`. Verify the Argo CD app tree shows all four services `Healthy`.

14. `tasks/microservices/task-014-microservices-observability.md`
    > Create a Grafana dashboard that shows all four services' RED metrics (Rate, Errors, Duration) on a single screen. Set up alerts per service.

## Success Criteria

Before moving to Phase 15, verify:

- [ ] Four independent services deployed: Auth, Notes, Email, Search
- [ ] Each service has its own database — no shared database tables
- [ ] Creating a note triggers the full Saga: MongoDB write → Kafka event → email sent → ES indexed
- [ ] Jaeger shows a distributed trace spanning Auth → Notes → Kafka → Search
- [ ] Circuit breaker activates when Search Service is killed — Notes Service continues working (graceful degradation)
- [ ] `nx affected:build` only rebuilds the changed service (verify with a one-line change)
- [ ] CQRS: `POST /notes` and `GET /notes` hit different code paths and different databases

---

## ➡️ Next Phase

**[Phase 15 — Helm Package Management](./phase-15-helm.md)**

Phase 15 packages the Kubernetes manifests for all microservices into **Helm charts**, making it easy to deploy different environments (dev/staging/prod) with a single `helm upgrade` command and environment-specific `values.yaml` files.
