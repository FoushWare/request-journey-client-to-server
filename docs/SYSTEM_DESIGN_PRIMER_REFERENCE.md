# 📚 System Design Primer — Reference Guide for This Project

> Curated lessons from [donnemartin/system-design-primer](https://github.com/donnemartin/system-design-primer) mapped directly to tasks and issues in this project.
>
> Use this document as a companion guide — every concept here has a corresponding hands-on task.

---

## How to Use This Document

1. Pick a phase you are working on (e.g., "Caching")
2. Read the primer section summary here
3. Follow the link to the corresponding hands-on task
4. Build it in the Notes App

---

## Table of Contents

1. [Performance vs Scalability](#1-performance-vs-scalability)
2. [Latency vs Throughput](#2-latency-vs-throughput)
3. [Availability vs Consistency — CAP Theorem](#3-availability-vs-consistency--cap-theorem)
4. [DNS — Domain Name System](#4-dns--domain-name-system)
5. [CDN — Content Delivery Network](#5-cdn--content-delivery-network)
6. [Load Balancer](#6-load-balancer)
7. [Reverse Proxy](#7-reverse-proxy)
8. [Databases — SQL Patterns](#8-databases--sql-patterns)
9. [Databases — NoSQL Types](#9-databases--nosql-types)
10. [Cache — Layers and Strategies](#10-cache--layers-and-strategies)
11. [Asynchronism — Message Queues](#11-asynchronism--message-queues)
12. [Microservices and Service Discovery](#12-microservices-and-service-discovery)
13. [Communication Protocols](#13-communication-protocols)
14. [Security](#14-security)
15. [Scaling a System to Millions of Users on AWS](#15-scaling-a-system-to-millions-of-users-on-aws)
16. [Latency Numbers Every Engineer Must Know](#16-latency-numbers-every-engineer-must-know)

---

## 1. Performance vs Scalability

### Summary

- **Performance problem**: your system is slow for a **single user**
- **Scalability problem**: your system is fast for one user but **slow under load**

A system is scalable if adding more resources increases performance proportionally.

### Where This Applies in Our Project

| Concept | Our Task |
|---------|---------|
| Measuring performance baseline | `tasks/system-design/task-002-load-testing-k6.md` |
| Scaling horizontally | `tasks/system-design/task-003-scaling-solutions.md` |
| Kubernetes HPA for auto-scaling | `tasks/kubernetes/` |

### Key Trade-offs

- Vertical scaling: simple but expensive, single point of failure
- Horizontal scaling: more complex, requires stateless design, much cheaper

---

## 2. Latency vs Throughput

### Summary

- **Latency**: time to complete a single request (ms)
- **Throughput**: number of requests handled per unit of time (req/sec)

**Goal**: maximize throughput with acceptable latency.

### Where This Applies

| Concept | Our Task |
|---------|---------|
| P95/P99 latency measurement | `tasks/system-design/task-002-load-testing-k6.md` |
| Throughput with Kafka partitions | `tasks/messaging/task-004-kafka-partitions.md` |
| gRPC for low-latency internal calls | `tasks/networking/` (Issue #131) |

### Key Numbers

- L1 cache: ~1 ns
- Main memory: ~100 ns
- SSD read: ~100 µs
- Network: ~1 ms (same DC), ~150 ms (cross-continent)
- HDD seek: ~10 ms

See full latency table in [Section 16](#16-latency-numbers-every-engineer-must-know).

---

## 3. Availability vs Consistency — CAP Theorem

### Summary

A distributed system can only guarantee **two** of three:

```
C = Consistency    (every node sees the same data at the same time)
A = Availability   (every request gets a response)
P = Partition Tolerance (system works despite network splits)
```

Since partitions **always happen** in real networks, you must choose CP or AP.

| Type | Examples | Trade-off |
|------|---------|----------|
| **CP** | HBase, MongoDB, etcd, ZooKeeper | Unavailable during partition |
| **AP** | CouchDB, DynamoDB (eventually consistent) | May serve stale data during partition |

### Consistency Patterns

| Pattern | Description | Example |
|---------|-------------|---------|
| **Weak** | Data may be stale | Memcached, phone calls |
| **Eventual** | Data converges over time | DNS, email, Cassandra |
| **Strong** | All reads see latest write | RDBMS, etcd |

### Where This Applies

| Concept | Our Task |
|---------|---------|
| Raft consensus (CP system) | `tasks/distributed-systems/task-001-raft-consensus-leader-election.md` |
| ZooKeeper (CP system) | `tasks/distributed-systems/task-005-zookeeper-fundamentals.md` |
| Eventual consistency with Kafka | `tasks/messaging/task-001-kafka-setup.md` |
| PostgreSQL (strong consistency) | `tasks/microservices/task-002-microservices-database-design.md` |

---

## 4. DNS — Domain Name System

### Summary

DNS translates domain names (e.g., `notes-app.com`) to IP addresses. It is a **distributed hierarchical database**.

```
Browser → DNS Resolver → Root Nameserver → TLD Nameserver → Authoritative Nameserver → IP
```

**TTL** (Time To Live): how long a DNS record is cached. Lower TTL = faster changes, more DNS load.

**DNS Record Types:**
- `A`: domain → IPv4
- `AAAA`: domain → IPv6
- `CNAME`: alias to another domain
- `MX`: mail server
- `NS`: nameserver for domain

### DNS Load Balancing (Round Robin DNS)

Multiple A records for the same domain:
```
notes-app.com → 1.2.3.4
notes-app.com → 1.2.3.5
notes-app.com → 1.2.3.6
```

Clients alternate between IPs. Drawback: no health checking, sticky sessions break.

### Where This Applies

| Concept | Our Task |
|---------|---------|
| Route 53 DNS setup | `tasks/aws/` (Issue #110) |
| DNS in Kubernetes (CoreDNS) | `tasks/kubernetes/` |
| Service discovery via DNS | `tasks/microservices/task-003-service-discovery-kubernetes.md` |

---

## 5. CDN — Content Delivery Network

### Summary

A CDN is a **geographically distributed** network of servers that caches content close to users.

```
User (Paris) → CDN Edge (Frankfurt) → Origin Server (US)
                          ↑ cache hit = 5ms
                          ↓ cache miss → 200ms round-trip to origin
```

**Two CDN models:**

| Model | Description | Best For |
|-------|-------------|---------|
| **Push CDN** | You push content to CDN manually | Static, rarely changing content |
| **Pull CDN** | CDN pulls from origin on first request | Dynamic, frequently changing content |

**What to Cache on CDN:**
- Static assets: JS, CSS, images, fonts, videos
- Immutable content (versioned builds): `app.v2.3.js`
- Public API responses with appropriate Cache-Control headers

### Where This Applies

| Concept | Our Task |
|---------|---------|
| CDN for Notes App static assets | `tasks/system-design/task-003-scaling-solutions.md` |
| CloudFront setup | `tasks/aws/` |
| NGINX as local CDN/cache | `tasks/nginx/` (Issues #86) |

---

## 6. Load Balancer

### Summary

A load balancer distributes incoming requests across multiple backend servers.

**Layer 4 (Transport) vs Layer 7 (Application):**

| Type | Sees | Routing Based On | Example |
|------|------|-----------------|---------|
| **L4** | TCP/UDP | IP + port | AWS NLB, HAProxy |
| **L7** | HTTP | URL, headers, cookies | AWS ALB, NGINX |

**Routing Algorithms:**
- **Round-robin**: equal distribution (no state)
- **Least connections**: route to server with fewest active connections
- **IP Hash**: consistent routing per client IP (useful for sticky sessions)
- **Weighted**: some servers get more traffic

**Active-Active vs Active-Passive:**
- **Active-Active**: all load balancers handle traffic simultaneously → higher throughput
- **Active-Passive**: one is standby, takes over on failure → simpler, less throughput

### Where This Applies

| Concept | Our Task |
|---------|---------|
| NGINX as L7 load balancer | `tasks/nginx/task-004-configure-load-balancing.md` |
| Kubernetes Services (L4 LB) | `tasks/kubernetes/` |
| AWS ELB/ALB | `tasks/aws/` |
| Load testing to validate | `tasks/system-design/task-002-load-testing-k6.md` |

---

## 7. Reverse Proxy

### Summary

A reverse proxy sits **in front of servers** and forwards client requests to them.

```
Client → [Reverse Proxy: NGINX] → Web Server
                                 → App Server  
                                 → Microservices
```

**Benefits:**
- SSL termination (decrypts HTTPS, forwards plain HTTP internally)
- Compression (gzip at proxy level)
- Caching
- Security (hides backend server IPs)
- Load balancing

**Reverse Proxy vs Load Balancer:**
- Load balancer: needed when you have **multiple servers**
- Reverse proxy: useful even with **one server** (SSL, compression, caching)

### Where This Applies

| Concept | Our Task |
|---------|---------|
| NGINX as reverse proxy | `tasks/nginx/task-003-setup-reverse-proxy-for-backend-api.md` |
| SSL termination at NGINX | `tasks/nginx/task-005-add-ssltls-to-nginx.md` |
| API Gateway as reverse proxy | `tasks/microservices/` |

---

## 8. Databases — SQL Patterns

### Summary

**Relational Database (RDBMS)** stores data in normalized tables with ACID guarantees.

**Scaling Patterns (in order of complexity):**

### Master-Slave Replication
```
Client writes → Master
Client reads  → Slave1, Slave2, Slave3
```
- Master handles all writes
- Slaves replicate from master (async), handle reads
- **Problem**: slave lag, master is SPOF

### Master-Master Replication
```
Client writes → Master1 or Master2 (both accept writes)
```
- Both nodes accept reads AND writes
- **Problem**: conflicts when both write to same record

### Federation (Functional Partitioning)
```
users DB → handles user table
notes DB → handles notes table
email DB → handles email table
```
- Split by function, not by row
- Each DB is smaller, easier to cache
- **Problem**: cross-DB joins, increased complexity

### Sharding
```
User 0-999K   → Shard A
User 1M-2M    → Shard B
User 2M-3M    → Shard C
```
- Horizontal partitioning by a shard key (usually user_id)
- **Problem**: rebalancing, hotspots, cross-shard queries

### Denormalization
- Add redundant data to avoid expensive JOIN queries
- **Problem**: data duplication, more complex writes

### SQL Tuning
- Index columns used in `WHERE`, `JOIN`, `ORDER BY`
- Avoid `SELECT *`
- Use `EXPLAIN` to find slow queries
- Use connection pooling (PgBouncer)

### Where This Applies

| Concept | Our Task |
|---------|---------|
| PostgreSQL for Notes App | `tasks/microservices/task-002-microservices-database-design.md` |
| Read replicas | `tasks/system-design/task-003-scaling-solutions.md` |
| Database sharding (conceptual) | `tasks/system-design/task-003-scaling-solutions.md` |
| RDS on AWS | `tasks/terraform/task-005-provision-rds-database.md` |

---

## 9. Databases — NoSQL Types

### Summary

NoSQL databases sacrifice some RDBMS features (ACID, joins) for better performance and scalability.

| Type | Data Model | Examples | Use Case |
|------|-----------|---------|---------|
| **Key-Value** | HashMap | Redis, DynamoDB | Sessions, caching, leaderboards |
| **Document** | JSON/BSON trees | MongoDB, CouchDB | User profiles, catalogs, content |
| **Wide Column** | Column families | Cassandra, HBase | Time-series, analytics, logs |
| **Graph** | Nodes + edges | Neo4j, Neptune | Social graphs, recommendations, fraud detection |

### When SQL vs NoSQL

**Use SQL when:**
- You need ACID transactions
- Your data is highly relational
- Your schema is well-defined and stable
- You need complex queries and aggregations

**Use NoSQL when:**
- You need to scale horizontally beyond what SQL allows
- Your data has a flexible/dynamic schema
- You need very fast reads/writes at massive scale
- Your data is naturally document-like (JSON)

### Where This Applies

| Concept | Our Task |
|---------|---------|
| MongoDB for notes (document store) | `tasks/microservices/task-002-microservices-database-design.md` |
| Redis (key-value, cache + sessions) | `tasks/system-design/task-004-caching-strategy.md` |
| Neo4j (graph, user connections) | `tasks/microservices/task-002-microservices-database-design.md` |
| Elasticsearch (search, wide-column-like) | `tasks/logging/` |

---

## 10. Cache — Layers and Strategies

### Summary

Caching is the practice of storing frequently accessed data in fast storage to avoid re-computing or re-fetching it.

**Caching Layers:**

```
Browser Cache (HTTP headers)
    ↓ miss
CDN Cache (Edge cache)
    ↓ miss
Application Cache (Redis)
    ↓ miss
Database Query Cache
    ↓ miss
Database Disk
```

**When to Update the Cache:**

| Strategy | Description | Pros | Cons |
|---------|-------------|------|------|
| **Cache-aside** | Read: check cache, miss → DB → store in cache | Only caches needed data | Initial miss penalty |
| **Write-through** | Write: update cache AND DB simultaneously | Always consistent | Extra write latency |
| **Write-behind** | Write: update cache, DB async later | Very fast writes | Risk of data loss |
| **Refresh-ahead** | Pre-populate cache before expiry | Low latency | May cache unused data |

**What NOT to cache:**
- Data that changes frequently (unless TTL is very short)
- User-specific private data without proper cache key isolation
- Large objects that pollute cache memory

### Where This Applies

| Concept | Our Task |
|---------|---------|
| Redis caching for Notes API | `tasks/system-design/task-004-caching-strategy.md` |
| Cache-aside pattern | `tasks/system-design/task-004-caching-strategy.md` |
| NGINX caching | `tasks/nginx/task-006-enable-caching-in-nginx.md` |
| Cache stampede prevention | `tasks/system-design/task-004-caching-strategy.md` |

---

## 11. Asynchronism — Message Queues

### Summary

Async processing decouples producers from consumers. Work is placed in a queue and processed independently.

```
Client → API → Queue → Worker
                 ↑
           (buffered, durable)
```

**Benefits:**
- Smooths out traffic spikes (queue absorbs bursts)
- Decouples services (producer doesn't know about consumer)
- Resilience: messages persist even if consumer is down
- Independent scaling of producers and consumers

**Message Queues vs Task Queues:**
- **Message Queue** (Kafka, RabbitMQ): delivers events/messages, consumers decide what to do
- **Task Queue** (Celery, Sidekiq): workers pick up specific jobs, designed for background work

**Back Pressure:**
When a consumer can't keep up, the queue grows. Back pressure signals producers to slow down.

### Where This Applies

| Concept | Our Task |
|---------|---------|
| Kafka setup | `tasks/messaging/task-001-kafka-setup.md` |
| DLQ (handling failures) | `tasks/messaging/task-002-dead-letter-queue.md` |
| Back pressure with Kafka | `tasks/messaging/task-004-kafka-partitions.md` |
| Email service async | `tasks/microservices/task-008-async-email-with-kafka.md` |

---

## 12. Microservices and Service Discovery

### Summary

Microservices break a monolith into small, independently deployable services. Each service owns its data.

**Principles:**
- Single responsibility: each service does one thing well
- Database per service: no shared databases
- Communicate over APIs (REST, gRPC) or events (Kafka)
- Deploy independently

**Service Discovery:**

When services need to find each other dynamically (because IPs change with Docker/K8s):

| Method | Description | Examples |
|--------|-------------|---------|
| **Client-side** | Client asks registry for address, then calls directly | Consul + client library |
| **Server-side** | Client calls LB, which asks registry | AWS ALB + ECS |
| **DNS-based** | DNS returns service endpoint | Kubernetes Services |

### Where This Applies

| Concept | Our Task |
|---------|---------|
| Microservices intro | `tasks/microservices/task-001-introduce-microservices-architecture.md` |
| Service discovery in K8s | `tasks/microservices/task-003-service-discovery-kubernetes.md` |
| Consul for service discovery | `tasks/hashicorp/task-012-consul-service-discovery.md` |
| Istio service mesh | `tasks/service-mesh/task-001-setup-istio.md` |

---

## 13. Communication Protocols

### Summary

**REST (HTTP):**
- Stateless, text-based, widely supported
- Uses HTTP verbs: GET, POST, PUT, DELETE
- Good for: public APIs, browser clients, external communications

**RPC (gRPC):**
- Binary protocol, strongly typed, code-generated clients
- HTTP/2 based → multiplexing, streaming
- Good for: internal service-to-service communication, low latency

**Comparison:**

| Feature | REST | gRPC |
|---------|------|------|
| Format | JSON/XML | Protocol Buffers (binary) |
| Performance | Moderate | High |
| Streaming | No | Yes (bidirectional) |
| Browser support | Native | Requires proxy |
| Schema | OpenAPI (optional) | Proto files (required) |
| Use case | External APIs | Internal microservices |

### Where This Applies

| Concept | Our Task |
|---------|---------|
| REST for Notes API | All backend tasks |
| gRPC for internal services | `tasks/networking/` (Issue #131) |
| REST vs gRPC comparison | `tasks/microservices/task-003-service-discovery-kubernetes.md` |

---

## 14. Security

### Summary

Key security principles from the primer:

**Encrypt Everything:**
- In transit: TLS everywhere (HTTPS, mTLS between services)
- At rest: encrypted databases, encrypted S3 buckets

**Principle of Least Privilege:**
- Each service/user gets only the minimum permissions needed
- IAM roles for AWS resources
- RBAC in Kubernetes

**Defense in Depth:**
- Multiple security layers: WAF → Load Balancer → NGINX → App → DB
- No single point of trust

**Common Vulnerabilities:**
- **SQL injection** → parameterized queries
- **XSS** → output encoding, CSP headers, HttpOnly cookies
- **CSRF** → SameSite cookies, CSRF tokens
- **Secrets exposure** → never commit secrets, use Vault/AWS Secrets Manager

### Where This Applies

| Concept | Our Task |
|---------|---------|
| JWT / sessions / cookies | `tasks/security/task-011-sessions-vs-jwt.md` |
| CSRF protection | `tasks/security/task-013-httponly-cookies-csrf.md` |
| mTLS with Istio | `tasks/service-mesh/task-003-istio-security-mtls.md` |
| Vault for secrets | `tasks/vault/` |
| Security headers | `tasks/security/` |

---

## 15. Scaling a System to Millions of Users on AWS

### Summary

This is the most directly applicable section from the primer. It describes the **exact scaling journey** our Notes App needs to go through.

### The Scaling Ladder

| Users | Bottleneck | Solution |
|-------|-----------|---------|
| **1 user** | Nothing | Single EC2 + MySQL |
| **Users+** | DB and app on same box | Separate DB to RDS |
| **Users++** | Single web server | Add ELB + multiple EC2, CDN |
| **Users+++** | DB read load | Add ElastiCache (Redis) + read replicas |
| **Users++++** | Traffic spikes | Auto Scaling Groups |
| **Users+++++** | Write load | Federation, sharding, NoSQL, async queues |

### Key Steps in Order

1. **Start with one box** — EC2 + MySQL (vertical scale)
2. **Assign a static IP** — Elastic IP + Route 53 DNS
3. **Separate the DB** — Move MySQL to RDS Multi-AZ
4. **Add CDN** — CloudFront for static assets
5. **Add Load Balancer** — ELB + 2+ EC2 instances
6. **Add Caching** — ElastiCache (Redis) for sessions and hot data
7. **Add Read Replicas** — RDS read replicas
8. **Auto Scaling** — ASG triggered by CloudWatch alarms
9. **Move to microservices** — ECS/EKS for container orchestration
10. **Add async queues** — SQS/Kafka for background work
11. **Shard the database** — Horizontal partitioning

### Where This Applies

This section covers the **entire Notes App scaling journey**:

| Primer Step | Our Task |
|-------------|---------|
| EC2 setup | `tasks/aws/task-003-launch-ec2-instance.md` |
| RDS setup | `tasks/terraform/task-005-provision-rds-database.md` |
| ELB setup | `tasks/aws/` |
| CloudFront | `tasks/aws/` |
| ElastiCache | `tasks/system-design/task-004-caching-strategy.md` |
| Auto Scaling | `tasks/kubernetes/` (HPA) |
| EKS | `tasks/terraform/task-008-provision-eks-cluster.md` |
| SQS/Kafka | `tasks/messaging/task-001-kafka-setup.md` |
| Read replicas | `tasks/system-design/task-003-scaling-solutions.md` |

---

## 16. Latency Numbers Every Engineer Must Know

### The Table

| Operation | Latency |
|-----------|---------|
| L1 cache read | 0.5 ns |
| Branch mispredict | 5 ns |
| L2 cache read | 7 ns |
| Mutex lock/unlock | 25 ns |
| Main memory read | 100 ns |
| Compress 1KB with Snappy | 10,000 ns = 10 µs |
| Send 1KB over 1Gbps network | 10,000 ns = 10 µs |
| Read 4KB from SSD | 100,000 ns = 100 µs |
| Read 1MB sequentially from memory | 250,000 ns = 250 µs |
| Round trip within same datacenter | 500,000 ns = 0.5 ms |
| Read 1MB sequentially from SSD | 1,000,000 ns = 1 ms |
| Disk seek | 10,000,000 ns = 10 ms |
| Read 1MB sequentially from disk | 20,000,000 ns = 20 ms |
| Send packet: California → Netherlands → California | 150,000,000 ns = 150 ms |

### Key Insights

1. Memory is **200x faster** than SSD, **40x faster** than reading from SSD sequentially
2. Network within a datacenter: ~0.5ms → very fast for synchronous microservice calls
3. Cross-continent network: ~150ms → **too slow** for chatty microservices (use async/batching)
4. Disk seek: 10ms → **never do unbounded disk seeks in a hot path**

### Where This Applies

| Concept | Our Task |
|---------|---------|
| Why Redis cache matters | `tasks/system-design/task-004-caching-strategy.md` |
| Why gRPC is faster than REST | `tasks/networking/` |
| Why message queues help | `tasks/messaging/task-001-kafka-setup.md` |
| Performance benchmarking | `tasks/system-design/task-002-load-testing-k6.md` |

---

## Additional System Design Exercises from the Primer

These are classic interview questions. Use them to practice applying the concepts above to the Notes App:

| Question | Relevance to Notes App |
|---------|----------------------|
| Design Pastebin.com | Notes App is essentially a paste service with auth |
| Design Twitter timeline | Notes App feed feature → fan-out pattern |
| Design a web crawler | Elasticsearch indexing of notes |
| Design Mint.com | Financial analytics → time-series data, aggregations |
| Design a social network | Notes App graph features (follow users, share notes) |
| Design a key-value store | Redis implementation understanding |
| Design a system that scales to millions on AWS | **Directly maps to Notes App AWS scaling** |

---

## Attribution

All concepts in this document are sourced from:
> donnemartin/system-design-primer — https://github.com/donnemartin/system-design-primer  
> Licensed under Creative Commons Attribution 4.0 International License

Original content has been summarized, reorganized, and mapped specifically to the tasks in this project.
