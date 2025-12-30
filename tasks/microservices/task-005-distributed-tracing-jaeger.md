# Task: Microservices - Distributed Tracing with Jaeger

**Related Issue:** #136 (Distributed Tracing)  
**Prerequisites:** task-001 (Microservices architecture), task-003 (Service discovery)  
**Estimated Time:** 3-4 hours  
**Notes App Context:** Implement distributed tracing for Notes App microservices using Jaeger/OpenTelemetry to track requests across services and identify performance bottlenecks

---

## Learning Objectives

- Understand distributed tracing
- Set up OpenTelemetry
- Deploy Jaeger
- Instrument services
- Analyze traces

---

## Theory Section

### Distributed Tracing

**Concepts:**
- **Trace**: Complete request journey
- **Span**: Individual operation
- **TraceId**: Unique request identifier
- **SpanId**: Operation identifier

**Why This Matters:**
- See request flow across services
- Identify latency bottlenecks
- Debug distributed systems

---

## Step-by-Step Instructions

### Step 1: Understand Tracing

**Objective:** Learn tracing concepts

**Instructions:**
1. Study trace, span, traceId concepts
2. Understand context propagation

### Step 2: Set Up OpenTelemetry

**Objective:** Instrument services

**Instructions:**
1. Install OpenTelemetry SDK
2. Instrument HTTP/gRPC calls
3. Propagate context headers

### Step 3: Deploy Jaeger

**Objective:** Set up tracing backend

**Instructions:**
1. Deploy Jaeger to Kubernetes
2. Configure collector
3. Expose Jaeger UI

### Step 4: Validate Tracing

**Objective:** Verify tracing works

**Instructions:**
1. Make request across services
2. View trace in Jaeger UI
3. Analyze latency

---

## Verification

1. OpenTelemetry configured
2. Jaeger deployed
3. Traces visible in UI
4. Request flow tracked

---

## Task Checklist

- [ ] Understood tracing
- [ ] Set up OpenTelemetry
- [ ] Deployed Jaeger
- [ ] Validated tracing

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

