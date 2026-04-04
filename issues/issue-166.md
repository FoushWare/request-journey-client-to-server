# Issue #166: Add the Three Pillars of Observability (Logs, Metrics, Distributed Tracing)

**State:** Open  
**Created:** 2026-03-31T13:23:23Z  
**Updated:** 2026-03-31T23:46:13Z  
**URL:** https://github.com/FoushWare/request-journey-client-to-server/issues/166

**Labels:** None

---

## Description

Implement the **three pillars of observability** for the Notes App microservices:

1. **Distributed Logs** — structured, correlated logs from all services in one place
2. **Metrics** — numerical signals (latency, error rate, throughput, saturation)
3. **Distributed Tracing** — trace a single request as it flows through all services

Without observability, debugging production issues in microservices is nearly impossible. The three pillars together let you ask: *What happened? How much? Why?*

---

## Why Observability Matters in Microservices

In a monolith, you read one log file. In microservices with 10+ services:
- A request touches 5 services — which one failed?
- Latency increased — which service is slow?
- Error rate spiked — is it the DB, the cache, or the network?

Observability answers these questions without needing to SSH into servers.

---

## Key Concepts

### Pillar 1: Distributed Logs
- Structured JSON logs (not plain text) with correlation IDs
- All service logs aggregated into one searchable system
- Tools: **ELK Stack** (Elasticsearch + Logstash + Kibana), **Loki + Grafana**
- Key: every log line includes `traceId`, `spanId`, `serviceId`, `requestId`

### Pillar 2: Metrics
- Time-series numerical data: requests/sec, error rate, p99 latency, CPU, memory
- RED method: **R**ate, **E**rrors, **D**uration per service
- USE method: **U**tilization, **S**aturation, **E**rrors per resource
- Tools: **Prometheus** (collection) + **Grafana** (visualization)
- Alerting: PagerDuty / Alertmanager for SLO breaches

### Pillar 3: Distributed Tracing
- Follows a single request across all service boundaries
- Each service adds a "span" with timing, metadata, and status
- Spans linked by a shared `traceId`
- Tools: **OpenTelemetry** (instrumentation standard) + **Jaeger** or **Zipkin** (backend)
- Uptrace — commercial OpenTelemetry-based platform

### OpenTelemetry (OTel)
- The industry standard for instrumentation
- One SDK instruments your code → exports to any compatible backend
- Supports: traces, metrics, and logs in all major languages
- Replaces vendor-specific SDKs (Datadog agent, Jaeger client, etc.)

---

## Learning Objectives

- [ ] Understand why observability > monitoring
- [ ] Add structured logging with correlation IDs to all services
- [ ] Aggregate logs with ELK or Loki
- [ ] Instrument services with OpenTelemetry SDK
- [ ] Export traces to Jaeger and visualize request flow
- [ ] Instrument metrics: RED method per service
- [ ] Set up Prometheus scraping + Grafana dashboards
- [ ] Configure alerts on SLO breaches (error rate, latency)
- [ ] Correlate a single request ID across logs, metrics, and traces

---

## Tools Referenced

- **OpenTelemetry** — instrumentation framework (traces + metrics + logs)
- **Jaeger** — open-source distributed tracing backend
- **Zipkin** — alternative tracing backend (Twitter origin)
- **Uptrace** — commercial OpenTelemetry-based observability platform
- **Prometheus** — metrics collection
- **Grafana** — visualization (metrics + logs + traces)
- **Loki** — log aggregation by Grafana
- **ELK Stack** — Elasticsearch + Logstash + Kibana

---

## Tasks to Create

- `tasks/logging/task-011-observability-three-pillars.md`

---

## Notes App Integration

- All Notes services emit structured logs with `traceId` and `requestId`
- Notes API instrumented with OpenTelemetry → spans visible in Jaeger
- Prometheus scrapes `/metrics` from all services
- Grafana dashboard: request rate, error rate, p99 latency per service
- Alert: fire if Notes API error rate > 1% for 5 minutes
