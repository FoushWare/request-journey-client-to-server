# Plan: Integrate New GitHub Issues #164–#166

**Date**: 2026-04-01  
**Status**: Completed  
**Related Issues**: #164, #165, #166

---

## Overview

This document details the integration of 3 new GitHub issues (#164–#166) into the DevOps learning path. The issues extend two existing categories: **Microservices** (patterns and testing) and **Logging/Observability** (three pillars). Together they cover advanced distributed systems architecture patterns, a complete microservices testing strategy, and the full OpenTelemetry-based observability stack.

## Learner-First Roadmap Alignment (Restructured)

This integration plan is mapped to the restructured roadmap as follows:

- **Phase 7**: Microservice challenges and advanced data/test patterns (#164, #165)
- **Phase 10**: Production-readiness extras for observability (#166)

---

## Issues Integrated

### Microservices Architecture (2 issues)

- **#164**: CQRS and Event Sourcing — separate read/write models (CQRS), store state as immutable events (Event Sourcing), and show how Saga + CQRS + Event Sourcing form a complete distributed data pattern. Note: Saga was already covered in task-006; this task focuses on CQRS and Event Sourcing and their integration with Saga.
- **#165**: Testing Microservices — full testing strategy: unit tests (Jest/Vitest), integration tests (TestContainers with real DB), E2E tests (Playwright), consumer-driven contract tests (Pact), blue-green deployment testing, and canary releases with Istio traffic splitting and automatic rollback.

### Logging / Observability (1 issue)

- **#166**: Three Pillars of Observability — instrument all Notes App services with OpenTelemetry SDK for distributed traces (Jaeger), Prometheus metrics using the RED method, and structured logs (Pino) with traceId correlation. Includes Grafana dashboard and SLO alerting.

---

## Implementation Summary

### Extended Category: Microservices (`tasks/microservices/`)

Two new tasks added:

- **task-013-cqrs-event-sourcing.md**: CQRS command/query separation, event store implementation, state reconstruction by replaying events, read model projector, and how all three patterns (Saga + CQRS + Event Sourcing) connect in one Notes workflow
- **task-014-microservices-testing.md**: Full testing pyramid — unit with mocks, integration with TestContainers, E2E with Playwright, Pact consumer contract tests, Kubernetes blue-green manifests, Istio canary VirtualService with traffic weighting

### Extended Category: Logging (`tasks/logging/`)

One new task added:

- **task-011-observability-three-pillars.md**: OpenTelemetry NodeSDK setup with auto-instrumentation, structured Pino logging with OTel context injection, custom Prometheus metrics (RED method), Jaeger deployment YAML, Grafana dashboard PromQL queries, Alertmanager SLO alert for error rate > 1%

---

## New Files Created

### Issue Files (3 new files)
- `issues/issue-164.md` — CQRS and Event Sourcing Patterns
- `issues/issue-165.md` — Testing Microservices
- `issues/issue-166.md` — Three Pillars of Observability

### Task Files (3 new task files)
- `tasks/microservices/task-013-cqrs-event-sourcing.md`
- `tasks/microservices/task-014-microservices-testing.md`
- `tasks/logging/task-011-observability-three-pillars.md`

### Implementation Stubs (6 new directories, 6 `.gitkeep` files)
- `implementation/microservices/task-013-cqrs-event-sourcing/starter/.gitkeep`
- `implementation/microservices/task-013-cqrs-event-sourcing/final-solution/.gitkeep`
- `implementation/microservices/task-014-microservices-testing/starter/.gitkeep`
- `implementation/microservices/task-014-microservices-testing/final-solution/.gitkeep`
- `implementation/logging/task-011-observability-three-pillars/starter/.gitkeep`
- `implementation/logging/task-011-observability-three-pillars/final-solution/.gitkeep`

### Tracker Updated
- `issues/ISSUE_TRACKER.md` — Added rows for #164–#166, updated summary to 166 total / 134 processed

---

## Statistics

| Metric | Value |
|--------|-------|
| Issues processed this session | 3 |
| New task files | 3 |
| New issue spec files | 3 |
| New implementation stubs | 6 |
| Files modified | 1 (ISSUE_TRACKER.md) |
| Total issues processed to date | 134 |
| Last issue number on GitHub | #166 |
