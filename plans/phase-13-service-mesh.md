# Phase 13 — Service Mesh (Istio)

## Overview

As the number of microservices grows, managing service-to-service security, retries, timeouts, canary deployments, and observability inside application code becomes unmanageable. **Istio** solves this by injecting an **Envoy sidecar proxy** into every pod. The sidecar handles mTLS encryption, load balancing, retries, circuit breaking, traffic splitting, and telemetry — transparently, without any application code changes.

## Prerequisites

- **Phase 03 complete** — Notes App running in Kubernetes with multiple microservice pods
- **Phase 12 complete** — GitOps deployments via Argo CD (Istio config will be managed as Git-committed CRDs)
- **Phase 14 complete** is recommended but not required — having separate microservices makes the mesh more meaningful

## Learning Objectives

- Understand the service mesh architecture: control plane (Istiod) and data plane (Envoy sidecars)
- Install Istio in the EKS cluster using `istioctl`
- Enable automatic sidecar injection per namespace
- Enforce mTLS between all Notes App microservices (zero-trust networking)
- Control traffic with `VirtualService` and `DestinationRule` CRDs
- Implement canary deployments (90/10 traffic split between two backend versions)
- Implement circuit breaking (fail fast after N consecutive errors)
- Inject faults for chaos testing (add latency, return errors for a percentage of requests)
- Visualise the service mesh topology in Kiali
- View distributed traces enriched with Envoy span data in Jaeger

## Task Sequence

Complete the following tasks **in order**:

1. `tasks/service-mesh/task-001-setup-istio.md`
   > Install Istio with `istioctl install --set profile=demo`. Enable sidecar injection on the `notes-app` namespace (`kubectl label namespace notes-app istio-injection=enabled`). Restart pods and verify two containers per pod (`app` + `istio-proxy`).

2. `tasks/service-mesh/task-002-istio-traffic-management.md`
   > Create a `VirtualService` and `DestinationRule` for the Notes backend. Implement a 90/10 canary split between `v1` (stable) and `v2` (new). Use `weight` fields to shift traffic gradually.

3. `tasks/service-mesh/task-003-istio-security-mtls.md`
   > Apply a `PeerAuthentication` policy set to `STRICT` mode. Verify that plain HTTP requests between services are rejected. Confirm that the Envoy proxies automatically negotiate mTLS without application changes.

4. `tasks/service-mesh/task-004-istio-observability.md`
   > Enable Kiali, Jaeger, and Grafana integrations. Open Kiali and view the live service dependency graph. Trigger a request and watch the trace in Jaeger showing all Envoy hops. Set up Grafana panels for Istio service-level metrics (success rate, P99 latency).

## Istio Traffic Management Patterns

| Pattern | CRD | Notes App Use Case |
|---------|-----|-------------------|
| Canary deploy | `VirtualService` weight split | Roll out new Notes backend version to 10 % of traffic |
| Blue-green switch | `VirtualService` host redirect | Instant cut-over with instant rollback |
| Circuit breaker | `DestinationRule` outlier detection | Stop sending traffic to a failing Search Service pod |
| Retry policy | `VirtualService` retries | Retry transient database connection errors |
| Fault injection | `VirtualService` fault | Simulate 500 ms latency to test frontend timeout handling |
| Request timeout | `VirtualService` timeout | 3-second hard timeout on all backend calls |

## Success Criteria

Before moving to Phase 14, verify:

- [ ] All `notes-app` namespace pods show 2/2 containers (app + `istio-proxy`)
- [ ] `kubectl exec` + `curl` from one service to another succeeds; plain HTTP without the sidecar is rejected
- [ ] 90/10 traffic split confirmed by watching Kiali graph — v2 receives ~10 % of requests
- [ ] Kiali shows green health for all Notes App services
- [ ] Jaeger shows end-to-end traces with Envoy sidecar spans visible
- [ ] Circuit breaker activates — when Search Service returns 5 errors in a row, traffic stops routing to it

---

## ➡️ Next Phase

**[Phase 14 — Microservices Architecture](./phase-14-microservices.md)**

Phase 14 completes the microservices decomposition of the Notes App. The monolithic backend is broken into separate Auth, Notes, Email, and Search services in an Nx monorepo. Patterns like CQRS, Event Sourcing, and the Saga pattern are implemented.
