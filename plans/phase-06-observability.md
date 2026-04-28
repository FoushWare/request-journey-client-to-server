# Phase 06 — Observability (Logs, Metrics, Traces)

## Overview

You cannot fix what you cannot see. This phase implements the **Three Pillars of Observability** for the Notes App:

- **Logs** — what happened (ELK Stack: Elasticsearch + Logstash + Kibana)
- **Metrics** — how much / how fast (Prometheus + Grafana)
- **Traces** — where time was spent across services (OpenTelemetry + Jaeger)

By the end of this phase you will have Grafana dashboards tracking request rates and error rates, Kibana showing every Notes App log event, and Jaeger showing the full distributed trace of a `/api/notes` request through all microservices.

## Prerequisites

- **Phase 02 complete** — Docker stack running
- **Phase 03 complete** — Notes App running in Kubernetes (logs come from pods)
- **Phase 05 complete** — Security events should feed into the log pipeline

## Learning Objectives

- Understand structured (JSON) logging and why it matters for log aggregation
- Set up Elasticsearch as a centralised log store
- Parse and transform logs with Logstash (or Fluent Bit for Kubernetes)
- Build Kibana dashboards and saved searches for Notes App events
- Instrument the Notes App backend with Prometheus `/metrics` endpoint
- Set up Prometheus to scrape all services and store time-series data
- Build Grafana dashboards for request rate, error rate, and latency (RED method)
- Configure AlertManager to send Slack / email alerts on SLO breaches
- Instrument the backend with OpenTelemetry SDK for distributed tracing
- Visualise end-to-end request traces in Jaeger

## Task Sequence

Complete the following tasks **in order**:

### ELK Stack — Logging (tasks 1–5)

1. `tasks/logging/task-001-install-elasticsearch.md`
   > Run Elasticsearch in Docker / Kubernetes. Verify it responds on port 9200. Understand index mappings and sharding.

2. `tasks/logging/task-002-install-logstash.md`
   > Configure Logstash pipeline: input (Filebeat/HTTP) → filter (JSON parse, add fields) → output (Elasticsearch). Ship a test log event.

3. `tasks/logging/task-003-install-kibana.md`
   > Connect Kibana to Elasticsearch. Create an index pattern `notes-app-*`. Discover view shows all ingested logs.

4. `tasks/logging/task-004-configure-filebeat.md`
   > Run Filebeat as a DaemonSet in Kubernetes. Configure it to tail `/var/log/containers/*.log` and forward to Logstash.

5. `tasks/logging/task-005-configure-fluent-bit.md`
   > Run Fluent Bit as an alternative log shipper. Compare performance and configuration with Filebeat. Choose the right tool for your environment.

### Log Standards and Retention (tasks 6–8)

6. `tasks/logging/task-006-configure-promtail-for-loki.md`
   > Optionally set up Loki + Promtail as a lightweight alternative to the ELK stack. Explore logs in Grafana's Explore view.

7. `tasks/logging/task-007-standardize-log-format.md`
   > Enforce a structured log format across all Notes App services: `{ timestamp, level, service, traceId, message, ...fields }`. Validate the format in CI.

8. `tasks/logging/task-008-add-log-rotation.md`
   > Configure Elasticsearch ILM (Index Lifecycle Management) to roll over indices daily and delete logs older than 30 days.

### Kibana Dashboards and Alerting (tasks 9–10)

9. `tasks/logging/task-009-create-kibana-dashboards.md`
   > Build dashboards: total requests per minute, error rate (4xx/5xx), top endpoints, login failure count.

10. `tasks/logging/task-010-alerting-on-critical-logs.md`
    > Configure Kibana Watcher (or Grafana Alerting) to send a Slack notification when the error rate exceeds 1 % in a 5-minute window.

### Prometheus, Grafana, and Tracing (task 11)

11. `tasks/logging/task-011-observability-three-pillars.md`
    > End-to-end exercise: instrument the backend with `prom-client` (Prometheus), `opentelemetry-sdk` (traces), and structured JSON logging. Verify all three pillars produce data simultaneously for a single `/api/notes POST` call.

## Key Dashboards to Build

| Dashboard | Tool | Key Panels |
|-----------|------|------------|
| Notes App Overview | Grafana | Request rate, error rate, P95 latency |
| Infrastructure | Grafana | Pod CPU/memory, node disk, HPA replica count |
| Logs Explorer | Kibana | Full-text search, level filter, service filter |
| Trace Waterfall | Jaeger | End-to-end latency, slowest spans |

## Success Criteria

Before moving to Phase 07, verify:

- [ ] `curl http://notes-app.local/api/notes` produces a log entry visible in Kibana within 30 seconds
- [ ] Grafana dashboard shows live request rate and error rate graphs
- [ ] AlertManager fires a test alert to Slack
- [ ] Jaeger shows a trace for a `/api/notes` request, spanning the backend → PostgreSQL query
- [ ] Log retention policy deletes indices older than 30 days
- [ ] All services emit logs in the standardised JSON format

---

## ➡️ Next Phase

**[Phase 07 — NGINX & Reverse Proxy](./phase-07-nginx-reverse-proxy.md)**

Phase 07 takes a deeper look at NGINX: load balancing strategies, advanced rate limiting, caching, SSL offloading, and using NGINX as the Kubernetes Ingress Controller.
