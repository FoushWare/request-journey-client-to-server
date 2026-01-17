# Issue #136: Service Discovery in Kubernetes  Circuit Breakers & Retries Distributed Tracing (Jaeger / OpenTelemetry)  Saga Pattern for Distributed Transactions

**Status**: open  
**Created**: 2025-12-17T18:03:17Z  
**Updated**: 2025-12-17T18:03:17Z  
**Author**: @FoushWare  
**URL**: [https://github.com/FoushWare/request-journey-client-to-server/issues/136](https://github.com/FoushWare/request-journey-client-to-server/issues/136)

## Details

**Labels**:   
**Assignees**:   
**Milestone**: None  

## Description

Perfect. Below is the **next clean batch of GitHub issues**, fully aligned with your project rules:

✔ Numbered titles
✔ Detailed objectives
✔ Clear sub-issues
✔ Labels using `+` (no commas)
✔ Copy-paste ready for GitHub Web UI

I continued numbering after **95**.

---

## ✅ Issue 100 – Service Discovery in Kubernetes

```md
## Objective
Understand and implement **service discovery** in Kubernetes so microservices can locate and communicate with each other reliably without hardcoded IPs.

---

## Tasks / Sub-Issues

### 1. Service Discovery Fundamentals
- [ ] What is service discovery?
- [ ] Why static IPs do not work in Kubernetes
- [ ] DNS-based service discovery

### 2. Kubernetes Services
- [ ] Create ClusterIP Service
- [ ] Understand Service selectors
- [ ] Access service via DNS name

### 3. Internal Communication
- [ ] Configure service-to-service calls
- [ ] Use environment-based discovery
- [ ] Test pod-to-pod resolution

### 4. Headless Services
- [ ] Create headless Service
- [ ] Use for stateful workloads
- [ ] Observe DNS records

### 5. Documentation
- [ ] Create `docs/kubernetes/service-discovery.md`
- [ ] Add mermaid diagram
- [ ] Document common issues

---

## Labels
`kubernetes+discovery`
`microservices+networking`
`dns+services`
`learning+kubernetes`
`phase5+infrastructure`
```

---

## ✅ Issue 105 – Circuit Breakers & Retries

```md
## Objective
Improve system resilience by implementing **circuit breakers, retries, and timeouts** to handle service failures gracefully in a microservices environment.

---

## Tasks / Sub-Issues

### 1. Failure Handling Concepts
- [ ] Understand cascading failures
- [ ] Learn retry vs timeout vs circuit breaker

### 2. Retry Strategies
- [ ] Implement retry with exponential backoff
- [ ] Set max retry limits
- [ ] Avoid retry storms

### 3. Circuit Breaker States
- [ ] Closed state
- [ ] Open state
- [ ] Half-open state

### 4. Implementation
- [ ] Implement at gRPC client level
- [ ] Add fallback responses
- [ ] Log breaker state changes

### 5. Observability
- [ ] Track failure metrics
- [ ] Visualize breaker states in Grafana

### 6. Documentation
- [ ] Create `docs/resilience/circuit-breakers.md`
- [ ] Add flow diagram

---

## Labels
`microservices+resilience`
`circuitbreaker+retry`
`fault+tolerance`
`grpc+communication`
`learning+reliability`
`phase5+architecture`
```

---

## ✅ Issue 110 – Distributed Tracing (Jaeger / OpenTelemetry)

```md
## Objective
Implement **distributed tracing** to follow a single request as it flows across multiple microservices, enabling deep visibility into latency and failures.

---

## Tasks / Sub-Issues

### 1. Tracing Fundamentals
- [ ] What is distributed tracing?
- [ ] Understand traceId and spanId

### 2. OpenTelemetry Setup
- [ ] Add OpenTelemetry SDK
- [ ] Instrument gRPC & HTTP calls
- [ ] Propagate context headers

### 3. Jaeger Deployment
- [ ] Deploy Jaeger in Kubernetes
- [ ] Configure collector & agent
- [ ] Expose Jaeger UI

### 4. Tracing Validation
- [ ] Trace request across services
- [ ] Analyze latency per service
- [ ] Identify bottlenecks

### 5. Documentation
- [ ] Create `docs/observability/tracing.md`
- [ ] Add trace flow diagram

---

## Labels
`observability+tracing`
`opentelemetry+jaeger`
`microservices+debugging`
`performance+visibility`
`learning+observability`
`phase6+monitoring`
```

---

## ✅ Issue 115 – Saga Pattern for Distributed Transactions

```md
## Objective
Handle **data consistency** across microservices using the **Saga Pattern**, avoiding distributed transactions while ensuring system reliability.

---

## Tasks / Sub-Issues

### 1. Understand Distributed Transactions
- [ ] Why 2PC is not recommended
- [ ] Eventual consistency principles

### 2. Saga Models
- [ ] Choreography-based saga
- [ ] Orchestration-based saga

### 3. Implementation
- [ ] Define saga steps
- [ ] Define compensating actions
- [ ] Handle failure scenarios

### 4. Observability
- [ ] Log saga execution
- [ ] Track saga state transitions

### 5. Documentation
- [ ] Create `docs/architecture/saga-pattern.md`
- [ ] Add saga flow diagram

---

## Labels
`saga+pattern`
`distributed+transactions`
`microservices+data`
`eventual+consistency`
`architecture+design`
`learning+microservices`
`phase6+architecture`
```

---

## ✅ Issue 120 – API Versioning Strategy

```md
## Objective
Design a robust **API versioning strategy** to evolve services without breaking existing consumers.

---

## Tasks / Sub-Issues

### 1. Versioning Approaches
- [ ] URI versioning (`/v1`)
- [ ] Header-based versioning
- [ ] Media type versioning

### 2. Versioning Rules
- [ ] Backward compatibility guidelines
- [ ] Deprecation policy
- [ ] Sunset strategy

### 3. Implementation
- [ ] Implement versioned routes
- [ ] Maintain multiple versions
- [ ] Add version-aware middleware

### 4. Documentation
- [ ] Create `docs/api/versioning.md`
- [ ] Add API lifecycle diagram

---

## Labels
`api+versioning`
`backend+contracts`
`microservices+api`
`breaking+changes`
`learning+api`
`phase5+backend`
```

---

## ✅ Issue 125 – Monorepo vs Polyrepo Decision

```md
## Objective
Evaluate and decide between **Monorepo** and **Polyrepo** strategies for managing microservices codebases.

---

## Tasks / Sub-Issues

### 1. Understand Repo Strategies
- [ ] What is monorepo?
- [ ] What is polyrepo?
- [ ] Tooling comparison

### 2. Evaluation Criteria
- [ ] Team size
- [ ] Deployment frequency
- [ ] CI/CD complexity
- [ ] Code sharing needs

### 3. Decision Making
- [ ] Choose repo strategy
- [ ] Document rationale
- [ ] Identify risks

### 4. Implementation
- [ ] Apply chosen structure
- [ ] Update pipelines
- [ ] Update documentation

---

## Labels
`repo+strategy`
`monorepo+polyrepo`
`architecture+decision`
`devops+workflow`
`learning+architecture`
`phase5+foundation`
```

---

## 🎯 You are now covering:

* Kubernetes internals
* Microservices reliability
* Observability
* Data consistency
* API governance
* Repo strategy

When you’re ready, next logical batches could be:

* **Event-driven architecture (Kafka)**
* **Caching strategies (Redis)**
* **Service Mesh (Istio/Linkerd)**
* **Zero-trust security**
* **Cost optimization in AWS**

Just say **“next batch”** and I’ll continue cleanly.

