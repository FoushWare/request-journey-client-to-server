# 📊 Observability Stack — Metrics, Logs, Traces

> Visibility into what the system is doing in production.  
> Three pillars: **Metrics** (Prometheus/Grafana), **Logs** (ELK), **Traces** (Jaeger).

---

## Three Pillars of Observability

```mermaid
graph TB
    subgraph Services["Running Services"]
        Auth["Auth Service"]
        Notes["Notes Service"]
        Email["Email Service"]
        NGINX["NGINX"]
        Kafka["Kafka"]
    end

    subgraph Metrics["📈 Metrics — Prometheus + Grafana"]
        Prom["Prometheus<br/>(scrapes /metrics every 15s)"]
        Grafana["Grafana<br/>(dashboards, alerts)"]
        AlertMgr["AlertManager<br/>(PagerDuty, Slack)"]

        Prom --> Grafana
        Prom --> AlertMgr
    end

    subgraph Logs["📜 Logs — ELK Stack"]
        Filebeat["Filebeat<br/>(log shipper, runs as DaemonSet)"]
        Logstash["Logstash<br/>(parse, transform)"]
        Elasticsearch["Elasticsearch<br/>(store + index)"]
        Kibana["Kibana<br/>(search, visualize)"]

        Filebeat --> Logstash
        Logstash --> Elasticsearch
        Elasticsearch --> Kibana
    end

    subgraph Traces["🔍 Traces — Jaeger"]
        Collector["Jaeger Collector"]
        JaegerUI["Jaeger UI<br/>(trace explorer)"]
        Collector --> JaegerUI
    end

    %% Services → Observability
    Auth -->|"expose :8080/metrics"| Prom
    Notes -->|"expose :8080/metrics"| Prom
    Email -->|"expose :8080/metrics"| Prom
    NGINX -->|"nginx-prometheus-exporter"| Prom
    Kafka -->|"kafka-exporter"| Prom

    Auth -->|"stdout JSON logs"| Filebeat
    Notes -->|"stdout JSON logs"| Filebeat
    Email -->|"stdout JSON logs"| Filebeat
    NGINX -->|"access logs"| Filebeat

    Auth -->|"OpenTelemetry spans"| Collector
    Notes -->|"OpenTelemetry spans"| Collector

    style Services fill:#e8f5e9
    style Metrics fill:#fff3e0
    style Logs fill:#e3f2fd
    style Traces fill:#f3e5f5
```

---

## Prometheus Metrics — What to Measure

```mermaid
mindmap
    root((Prometheus Metrics))
        HTTP
            http_requests_total
            http_request_duration_seconds
            http_errors_total
        Notes Service
            notes_created_total
            notes_fetched_total
            notes_cache_hit_ratio
        Auth Service
            auth_logins_total
            auth_failures_total
            active_sessions_gauge
        Email Service
            emails_sent_total
            email_delivery_duration_s
            email_errors_total
        Kafka
            kafka_consumer_lag
            kafka_messages_in_rate
            kafka_messages_out_rate
        System
            cpu_usage_percent
            memory_usage_bytes
            disk_io_ops
        SLA
            p95_latency_ms
            p99_latency_ms
            availability_percent
```

---

## Alerting Rules

```mermaid
flowchart TD
    subgraph "Alert Conditions (Prometheus Rules)"
        A1["Error Rate > 5% for 5min"]
        A2["P95 Latency > 500ms for 5min"]
        A3["Pod CrashLoopBackOff"]
        A4["Kafka Consumer Lag > 10,000"]
        A5["Disk usage > 85%"]
        A6["Certificate expiry < 30 days"]
    end

    subgraph "Alert Routing (AlertManager)"
        AM["AlertManager"]
        Slack["Slack #alerts"]
        PagerDuty["PagerDuty (critical)"]
        Email2["Email (warning)"]
    end

    A1 -->|critical| AM
    A2 -->|warning| AM
    A3 -->|critical| AM
    A4 -->|warning| AM
    A5 -->|warning| AM
    A6 -->|warning| AM

    AM -->|severity=critical| PagerDuty
    AM -->|severity=warning| Slack
    AM -->|all| Email2
```

---

## Distributed Trace — Notes API Call

```mermaid
graph LR
    subgraph "Trace: GET /api/notes (TraceID: abc123)"
        T1["NGINX<br/>Span 1: 2ms<br/>(proxy overhead)"]
        T2["API Gateway<br/>Span 2: 3ms<br/>(routing)"]
        T3["Auth Validate<br/>Span 3: 5ms<br/>(JWT verify)"]
        T4["Notes Service<br/>Span 4: 45ms total"]
        T5["Redis Lookup<br/>Span 5: 1ms<br/>(cache miss)"]
        T6["PostgreSQL<br/>Span 6: 40ms<br/>(query)"]
        T7["Redis Write<br/>Span 7: 1ms<br/>(cache store)"]

        T1 --> T2
        T2 --> T3
        T3 --> T4
        T4 --> T5
        T5 -->|miss| T6
        T6 --> T7
    end

    subgraph "Flame Graph View"
        direction TB
        Root["Total: 55ms"]
        Root --> NGINX2["NGINX: 2ms"]
        Root --> Auth2["Auth: 5ms"]
        Root --> Notes2["Notes: 42ms"]
        Notes2 --> Redis2["Redis: 2ms"]
        Notes2 --> DB2["PostgreSQL: 40ms 🔴 bottleneck"]
    end
```

> The trace shows PostgreSQL is the bottleneck.  
> Action: Add index on `user_id` or add Redis caching with longer TTL.

---

## Grafana Dashboards — What to Build

```mermaid
graph TB
    subgraph Dashboards["Grafana Dashboards"]
        D1["📊 Service Overview
        - Request rate (req/s)
        - Error rate (%)
        - P95 latency (ms)
        - Active pods"]

        D2["🗄️ Database Dashboard
        - Query latency P95
        - Connection pool usage
        - Cache hit ratio
        - Slow query count"]

        D3["📨 Kafka Dashboard
        - Messages in/out per second
        - Consumer lag per group
        - DLQ message count
        - Partition distribution"]

        D4["🏗️ Infrastructure
        - Node CPU/memory
        - Pod restart count
        - Storage usage
        - Network I/O"]

        D5["🔒 Security
        - Failed login attempts
        - Auth token errors
        - Rate limit hits
        - Certificate expiry"]
    end
```
