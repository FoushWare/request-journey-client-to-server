# Phase 16 — HashiCorp Ecosystem (Vault, Consul, Nomad)

## Overview

HashiCorp Vault was introduced in Phase 03 for Kubernetes secret injection. This phase completes the HashiCorp ecosystem: **Consul** for service discovery and distributed configuration management, and **Nomad** as an alternative workload scheduler to Kubernetes. Understanding these tools makes you a well-rounded infrastructure engineer prepared for environments that do not use Kubernetes.

## Prerequisites

- **Phase 03 complete** — HashiCorp Vault already installed and integrated with Kubernetes
- **Phase 09 complete** — Terraform is used to provision the Consul and Nomad infrastructure
- **Phase 14 complete** — Microservices exist and benefit from Consul's service registry

## Learning Objectives

- Install and configure HashiCorp Consul for service discovery
- Register Notes App microservices with the Consul service registry
- Use Consul KV store as a distributed configuration database (alternative to ConfigMaps)
- Understand Consul Connect for service mesh (lightweight alternative to Istio)
- Install HashiCorp Nomad and understand its job scheduling model
- Deploy a Notes App service as a Nomad job (Docker driver)
- Compare Nomad vs Kubernetes: strengths, weaknesses, and when to use each
- Understand how Vault, Consul, and Nomad work together in the HashiCorp stack

## Task Sequence

Complete the following tasks **in order**:

### Consul (tasks 1–3)

1. `tasks/hashicorp/task-011-install-consul.md`
   > Run a single-node Consul cluster in Docker. Access the Consul UI at `http://localhost:8500`. Understand agents (server vs client), gossip protocol, and the service catalogue.

2. `tasks/hashicorp/task-012-consul-service-discovery.md`
   > Register the Notes App backend as a Consul service with a health check. Query the registry with `consul catalog services` and via the DNS interface (`dig backend.service.consul`). Update the frontend to resolve the backend via Consul DNS.

3. `tasks/hashicorp/task-013-consul-configuration-management.md`
   > Store Notes App configuration (`APP_PORT`, `LOG_LEVEL`, `RATE_LIMIT`) in the Consul KV store. Read these values in the backend at startup using the Consul SDK. Change a value in Consul KV and verify the backend hot-reloads the config.

### Nomad (tasks 4–6)

4. `tasks/hashicorp/task-014-install-nomad.md`
   > Install Nomad in development mode (`nomad agent -dev`). Run a simple `raw_exec` job. Access the Nomad UI. Understand the job → task group → task hierarchy.

5. `tasks/hashicorp/task-015-nomad-job-scheduling.md`
   > Write a Nomad job file (HCL) that runs the Notes App backend as a Docker container. Use the `docker` task driver. Set resource limits, a health check, and a rolling update strategy. Deploy with `nomad job run notes-backend.nomad`.

6. `tasks/hashicorp/task-016-nomad-kubernetes-comparison.md`
   > Build a comparison table: Nomad vs Kubernetes across dimensions of complexity, multi-cloud support, non-container workloads, learning curve, community size, and ecosystem. Understand which environments prefer Nomad (batch jobs, mixed workloads, edge).

## HashiCorp Stack Integration

When used together, the three tools cover complementary responsibilities:

| Tool | Responsibility | Notes App Example |
|------|---------------|------------------|
| Vault | Secrets management | Dynamic DB credentials, JWT signing keys |
| Consul | Service discovery + config | Backend discovers Redis by Consul DNS |
| Nomad | Workload scheduling | Run batch cleanup jobs alongside K8s services |

## Success Criteria

Before moving to Phase 17, verify:

- [ ] Notes App backend service appears in the Consul UI with a green health check
- [ ] `dig @127.0.0.1 -p 8600 backend.service.consul` returns the backend container IP
- [ ] Changing `LOG_LEVEL` in Consul KV causes the backend to log at the new level without restart
- [ ] Notes App backend runs as a Nomad job — `nomad job status notes-backend` shows `running`
- [ ] You can articulate 3 scenarios where you would choose Nomad over Kubernetes
- [ ] Vault, Consul, and Nomad are integrated: Nomad retrieves its secrets from Vault via Consul-backed service auth

---

## ➡️ Next Phase

**[Phase 17 — Kafka & Event Streaming](./phase-17-kafka-messaging.md)**

Phase 17 deepens the event-driven architecture introduced in Phase 14 (Saga pattern). Apache Kafka is configured in depth: topics, partitions, consumer groups, dead-letter queues, and retry patterns — making the Notes App fully event-driven.
