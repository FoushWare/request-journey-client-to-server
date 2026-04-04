# Task: ZooKeeper Fundamentals

**Related Issue:** #158  
**Category:** Distributed Systems  
**Prerequisites:** Basic distributed systems concepts, Docker  
**Estimated Time:** 3–4 hours  
**Notes App Context:** Use ZooKeeper for distributed coordination of multi-instance Notes API

---

## Learning Objectives

- Understand ZooKeeper's role in distributed systems
- Explore the znode data model
- Work with ephemeral and sequential znodes
- Understand watchers
- Compare ZooKeeper to etcd

---

## Theory Section

### What is ZooKeeper?

ZooKeeper is a centralized service for:
- **Configuration management** — store config that all nodes share
- **Service discovery** — register/discover running services
- **Leader election** — coordinate which node is the primary
- **Distributed locking** — prevent race conditions across nodes

### ZNode Types

| Type | Persistence | Use Case |
|------|-------------|----------|
| Persistent | Survives client disconnect | Config, permanent data |
| Ephemeral | Deleted when client disconnects | Service registration, leader election |
| Persistent Sequential | Persistent with auto-increment | Queuing |
| Ephemeral Sequential | Ephemeral with auto-increment | Leader election |

### Watches

- Clients can **watch** a znode for changes
- When the znode changes (created, deleted, data changed), the client is notified
- Watches are **one-time** — must be re-registered after firing

---

## Step-by-Step Instructions

### Step 1: Set Up ZooKeeper with Docker

```bash
docker run -d --name zookeeper \
  -p 2181:2181 \
  -e ZOOKEEPER_CLIENT_PORT=2181 \
  confluentinc/cp-zookeeper:latest
```

### Step 2: Explore ZNodes with CLI

```bash
# Connect to ZooKeeper CLI
docker exec -it zookeeper zookeeper-shell localhost:2181

# Basic operations
ls /
create /notes-app "config"
get /notes-app
set /notes-app "new-config"
delete /notes-app

# Create ephemeral node (disappears when session ends)
create -e /notes-app/instance1 "192.168.1.1:3000"

# Create sequential node
create -s /notes-app/lock- "request1"
# Creates: /notes-app/lock-0000000001
```

### Step 3: Implement Service Registration

**Instructions:**
1. Write a Go program that registers a Notes API instance in ZooKeeper on startup
2. Use an ephemeral node so the registration disappears if the service crashes
3. List all registered instances by reading `/notes-app/instances/`

### Step 4: Compare ZooKeeper to etcd

| Feature | ZooKeeper | etcd |
|---------|-----------|------|
| Protocol | ZAB | Raft |
| Data Model | Hierarchical (znodes) | Flat key-value |
| Watches | One-time | Streaming watch |
| Performance | Lower | Higher |
| Used In | Old Kafka, Hadoop | Kubernetes, new Kafka (KRaft) |

### Step 5: Why Kafka Replaced ZooKeeper

Research and summarize:
- What ZooKeeper managed in old Kafka
- What problems ZooKeeper caused at scale
- What KRaft (Kafka Raft) brings

---

## Verification

1. ZooKeeper running with Docker
2. Created persistent and ephemeral znodes via CLI
3. Service registration implemented in Go
4. Completed ZooKeeper vs etcd comparison

---

## Task Checklist

- [ ] ZooKeeper running locally
- [ ] Explored znodes via CLI
- [ ] Implemented service registration with ephemeral nodes
- [ ] Understood the watch mechanism
- [ ] Compared ZooKeeper to etcd
- [ ] Understood why Kafka dropped ZooKeeper

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

---

## Diagram

```mermaid
graph TD
    subgraph ZooKeeper Ensemble
        ZK1[ZooKeeper Node 1\nLeader]
        ZK2[ZooKeeper Node 2\nFollower]
        ZK3[ZooKeeper Node 3\nFollower]
        ZK1 <-->|sync| ZK2
        ZK1 <-->|sync| ZK3
    end

    subgraph Znode Tree
        Root([/])
        Root --> Services[/services]
        Root --> Config[/config]
        Services --> API[/services/api-1\nephemeral]
        Services --> Worker[/services/worker-1\nephemeral]
        Config --> DB[/config/db-host\npersistent]
    end

    ClientA([Client A]) -->|create ephemeral znode| API
    ClientB([Client B]) -->|watch /services| ZK1
    ZK1 -->|watch event: NodeCreated| ClientB

    style ZK1 fill:#e67e22,color:#fff
    style ZK2 fill:#3498db,color:#fff
    style ZK3 fill:#3498db,color:#fff
```

## Automation Reference

> The steps above are **manual/raw** — they teach you ZooKeeper by doing it yourself.  
> The `automation/` directory contains the production-grade IaC equivalent:

| What | Where | Description |
|------|-------|-------------|
| Kubernetes cluster (ZooKeeper StatefulSet) | [`automation/terraform/modules/eks/`](../../automation/terraform/modules/eks/) | Provisions AWS EKS; ZooKeeper can be deployed as a StatefulSet with persistent volumes for each ensemble node |
| Docker for local ZooKeeper | [`automation/ansible/roles/docker/`](../../automation/ansible/roles/docker/) | Ansible role to install Docker, enabling a local 3-node ZooKeeper ensemble via docker-compose for experimentation |
