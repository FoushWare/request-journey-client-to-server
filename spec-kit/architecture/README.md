# Architecture Specifications

Contains architecture diagrams, ADRs (Architectural Decision Records), and design patterns.

## Organization

- **diagrams/** - Visual architecture representations
- **decisions/** - ADR documents for major decisions
- **patterns/** - Implementation patterns (Saga, Circuit Breaker, etc.)

## Key Diagrams

- **microservices-architecture.mmd** - Overall microservices topology
- **service-mesh-topology.mmd** - Istio service mesh layout
- **gitops-workflow.mmd** - GitOps continuous deployment flow
- **aws-infrastructure.mmd** - AWS cloud infrastructure layout

## Architecture Decisions

Each ADR documents:
- Context (Why this decision was needed)
- Decision (What was chosen and why)
- Consequences (Trade-offs and implications)
- Alternatives (Other options considered)

## Design Patterns

- Saga Pattern (Distributed transactions)
- Circuit Breaker (Fault tolerance)
- Event-Driven Architecture (Async communication)
- Service Discovery (Dynamic service location)
- CQRS (Separate read/write models)

---

See parent [README.md](../README.md) for project overview.
