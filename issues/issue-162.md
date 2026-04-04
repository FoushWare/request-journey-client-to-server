# Issue #162: Sidecar Pattern for Shared Logic Across Microservices

**State:** Open  
**Created:** 2026-03-29T11:43:41Z  
**Updated:** 2026-03-29T11:43:41Z  
**URL:** https://github.com/FoushWare/request-journey-client-to-server/issues/162

**Labels:** None

---

## Description

The **Sidecar Pattern** is a structural microservices pattern where a secondary container (the "sidecar") runs **alongside** the primary application container in the same Kubernetes Pod, sharing the same network namespace and storage volumes. The sidecar handles **cross-cutting concerns** — functionality that every service needs but that should not pollute each service's business logic.

Cross-cutting concerns include: TLS certificate management and mutual TLS (mTLS), log collection and forwarding, distributed tracing (injecting trace IDs into requests), health check endpoints, rate limiting, retries and circuit breaking, and configuration/secret injection. Without the sidecar pattern, every service must include library code for each concern — leading to duplication, version drift, and the need to redeploy all services when a shared library is updated.

**Why a sidecar and not a shared library?**  
A shared library lives inside the service process. If the library has a bug, every service must be redeployed. A sidecar is a separate process: updating it requires redeploying only the sidecar container, not the application. It also enables polyglot teams — the main app can be written in Python while the sidecar is written in Go or Rust.

**Envoy Proxy as the canonical sidecar**  
Envoy is the most widely deployed sidecar proxy. Istio Service Mesh automatically injects an Envoy sidecar into every Pod. Envoy handles: mTLS between services, HTTP/2 and gRPC load balancing, retries and timeouts, circuit breaking, distributed tracing (Zipkin/Jaeger headers), and metrics (Prometheus format).

**Kubernetes implementation**  
In Kubernetes, a Pod can contain multiple containers. The sidecar container is defined alongside the main container in the Pod spec. Both containers share `localhost` networking — the main app calls `localhost:15001` and Envoy intercepts and proxies the traffic. Init containers (a special sidecar variant) run before the main container to inject configuration or wait for dependencies.

**Sidecar vs Ambassador vs Adapter**  
These three are related patterns in the same family: Sidecar (generic helper), Ambassador (proxy to external services), Adapter (normalise the main container's interface). All run as co-located containers in a Pod.

---

## Why This Matters

- Sidecar is the foundational pattern behind every service mesh (Istio, Linkerd, Consul Connect)
- mTLS via Envoy sidecar is the standard way to enforce zero-trust networking in Kubernetes
- Separating operational concerns from business logic keeps services small and testable
- Log and trace sidecars enable observability without changing application code
- Understanding sidecars is a prerequisite for understanding Istio and Envoy in production

---

## Key Concepts

### Sidecar Container
A co-located container in the same Pod as the main application. Shares the same network namespace (`localhost`) and can share volumes.

### Envoy Proxy
A high-performance L7 proxy used as the canonical sidecar in Istio and other service meshes. Handles mTLS, load balancing, retries, and telemetry.

### Mutual TLS (mTLS)
Both the client and server present certificates to authenticate each other. Envoy sidecars handle the full TLS handshake transparently — the application sees plain HTTP.

### Init Container
A special container that runs to completion before the main container starts. Used for: waiting for a database to be ready, downloading configuration, running database migrations.

### Ambassador Pattern
A sidecar that acts as an outbound proxy to external services — handling retries, circuit breaking, and connection pooling to a third-party API.

### Adapter Pattern
A sidecar that normalises the main container's output (e.g., translates a legacy log format to JSON before forwarding to a log aggregator).

---

## Learning Objectives

- [ ] Understand the Sidecar pattern and its role in microservices
- [ ] Define a multi-container Pod spec in Kubernetes with a sidecar container
- [ ] Configure a Fluent Bit sidecar for log forwarding from the Notes API
- [ ] Understand how Envoy sidecar proxies work (mTLS, retries, tracing headers)
- [ ] Deploy a Pod with an Envoy sidecar and verify mTLS between two services
- [ ] Understand the difference between Sidecar, Ambassador, and Adapter patterns
- [ ] Understand how Istio auto-injects Envoy sidecars using a MutatingAdmissionWebhook

---

## Tasks to Create

- `tasks/microservices/task-012-sidecar-pattern.md`

---

## Notes App Integration

Apply the sidecar pattern to the Notes App microservices on Kubernetes:

1. **Logging sidecar**: Add a Fluent Bit container to the Notes API Pod that reads from a shared `/var/log` volume and forwards logs to Elasticsearch or CloudWatch.
2. **mTLS sidecar**: Inject Envoy alongside the Notes API. Notes API → Auth API traffic is encrypted with mTLS without any TLS code in the application.
3. **Config injection init container**: Run an init container that fetches secrets from AWS Secrets Manager before the Notes API starts, writing them to a shared volume.
4. **Tracing sidecar**: Envoy automatically injects `x-b3-traceid` headers enabling distributed traces across all Notes App services in Jaeger.

This makes the Notes App deployable with zero-trust networking and full observability — production-grade capabilities added via sidecar configuration, not application code changes.
