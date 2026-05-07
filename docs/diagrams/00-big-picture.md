# 🗺️ Big Picture — Full Project Overview

> This diagram shows how ALL the major systems in this project connect together.  
> Every box represents a topic/phase you will learn hands-on through the tasks.

## Learner-First Reading Order

Read and execute this system map using the canonical sequence:
1) mock server, 2) fixed backend responses, 3) real database, 4) containerization, 5) microfrontend, 6) microservices, 7) microservice challenges, 8) kubernetes, 9) ansible, 10) production extras.

---

## Full System Map

```mermaid
graph TB
    subgraph Client["🌐 Client Layer"]
        Browser["Browser / Mobile App"]
    end

    subgraph Network["🔗 Network & Edge Layer"]
        DNS["DNS<br/>(Route 53 / CoreDNS)"]
        CDN["CDN<br/>(CloudFront / Nginx Cache)"]
        LB["Load Balancer<br/>(ELB / NGINX)"]
    end

    subgraph Gateway["🚪 API Gateway & Proxy"]
        NGINX["NGINX Reverse Proxy<br/>(SSL Termination, Rate Limiting)"]
        AG["API Gateway"]
    end

    subgraph Services["⚙️ Microservices (Nx Monorepo — Node.js/TypeScript + Go)"]
        Auth["Auth Service<br/>(Go / Node.js)"]
        Notes["Notes Service<br/>(Go / Node.js)"]
        Email["Email Service<br/>(Python / Node.js)"]
        Search["Search Service<br/>(TypeScript — Nx)"]
        NxNote["📦 Nx Workspace<br/>(Node.js services share<br/>libs/shared/types+auth+kafka)"]
    end

    subgraph Messaging["📨 Event Streaming"]
        Kafka["Apache Kafka<br/>(Topics, Partitions, DLQ)"]
    end

    subgraph Databases["🗄️ Databases"]
        PG["PostgreSQL<br/>(Users, Auth)"]
        Mongo["MongoDB<br/>(Notes)"]
        Redis["Redis<br/>(Cache, Sessions)"]
        ES["Elasticsearch<br/>(Search Index)"]
        Neo4j["Neo4j<br/>(Graph: follows, tags)"]
    end

    subgraph Orchestration["☸️ Kubernetes + GitOps"]
        K8s["Kubernetes Cluster<br/>(EKS)"]
        Helm["Helm Charts"]
        ArgoCD["Argo CD<br/>(GitOps)"]
        Istio["Istio Service Mesh<br/>(mTLS, Traffic)"]
    end

    subgraph Infra["🏗️ Infrastructure as Code"]
        Terraform["Terraform<br/>(VPC, EKS, RDS, S3)"]
        Ansible["Ansible<br/>(Config, Deploy, Harden)"]
    end

    subgraph Observability["📊 Observability"]
        Prometheus["Prometheus<br/>(Metrics)"]
        Grafana["Grafana<br/>(Dashboards)"]
        Jaeger["Jaeger<br/>(Distributed Tracing)"]
        ELK["ELK Stack<br/>(Logs: ES + Kibana)"]
    end

    subgraph Security["🔒 Security"]
        Vault["HashiCorp Vault<br/>(Secrets)"]
        CICD["CI/CD Pipeline<br/>(GitHub Actions + Jenkins)"]
    end

    subgraph Distributed["🌐 Distributed Systems"]
        Raft["Raft / etcd<br/>(Leader Election)"]
        ZK["ZooKeeper<br/>(Coordination)"]
        Restate["Restate.dev<br/>(Durable Execution)"]
    end

    subgraph Cloud["☁️ Cloud — AWS"]
        EC2["EC2"]
        S3["S3"]
        RDS["RDS"]
        EKS_Cloud["EKS"]
        LocalStack["LocalStack<br/>(Local Dev)"]
    end

    %% Client → Network
    Browser -->|HTTPS| DNS
    DNS --> CDN
    CDN -->|cache miss| LB
    LB --> NGINX
    NGINX --> AG

    %% Gateway → Services
    AG --> Auth
    AG --> Notes
    AG --> Search

    %% Services → Messaging
    Notes -->|events| Kafka
    Auth -->|events| Kafka
    Kafka -->|email-events| Email
    Kafka -->|note-events| Search

    %% Services → Databases
    Auth --> PG
    Notes --> Mongo
    Notes --> Redis
    Search --> ES
    Notes -.->|graph features| Neo4j

    %% Services → Vault
    Auth --> Vault
    Notes --> Vault

    %% Kubernetes
    Services --> K8s
    K8s --> Helm
    ArgoCD --> K8s
    Istio --> Services

    %% IaC
    Terraform --> Cloud
    Ansible --> K8s

    %% Observability
    Services -->|metrics| Prometheus
    Prometheus --> Grafana
    Services -->|traces| Jaeger
    Services -->|logs| ELK

    %% Distributed Systems
    K8s -->|uses| Raft
    Kafka -->|coordination| ZK
    Notes -->|durable workflows| Restate

    %% CI/CD
    CICD -->|deploy| ArgoCD

    %% Cloud mapping
    K8s --- EKS_Cloud
    PG --- RDS
    Mongo --- EC2
    Notes -->|uploads| S3
    LocalStack -.->|emulates| Cloud

    style Client fill:#e1f5fe
    style Network fill:#fff3e0
    style Gateway fill:#fce4ec
    style Services fill:#e8f5e9
    style Messaging fill:#f3e5f5
    style Databases fill:#e8eaf6
    style Orchestration fill:#e0f2f1
    style Infra fill:#fbe9e7
    style Observability fill:#f1f8e9
    style Security fill:#fff8e1
    style Distributed fill:#e8eaf6
    style Cloud fill:#e3f2fd
```

---

## Learning Journey Map

```mermaid
graph LR
    P0["🏁 Start"] --> P1
    P1["Phase 1<br/>Docker"] --> P2
    P2["Phase 2<br/>Kubernetes"] --> P3
    P3["Phase 3<br/>CI/CD"] --> P4
    P4["Phase 4<br/>Security"] --> P5
    P5["Phase 5<br/>Logging ELK"] --> P6
    P6["Phase 6<br/>NGINX"] --> P7
    P7["Phase 7<br/>Ansible"] --> P8
    P8["Phase 8<br/>AWS"] --> P9
    P9["Phase 9<br/>Integration"] --> P10
    P10["Phase 10<br/>Networking"] --> P11
    P11["Phase 11<br/>GitOps"] --> P12
    P12["Phase 12<br/>Service Mesh"] --> P13
    P13["Phase 13<br/>Microservices"] --> P14
    P14["Phase 14<br/>Helm"] --> P15
    P15["Phase 15<br/>HashiCorp"] --> P16
    P16["Phase 16<br/>Distributed Systems"] --> P17
    P17["Phase 17<br/>Kafka Messaging"] --> P18
    P18["Phase 18<br/>System Design at Scale"] --> P19["🎯 Production Ready"]

    style P0 fill:#4CAF50,color:#fff
    style P19 fill:#2196F3,color:#fff
```

---

## Issue → Phase Mapping

| Issue Range | Phase | Category |
|-------------|-------|---------|
| #32–40 | Docker | Containerization |
| #41–50 | Kubernetes | Orchestration |
| #51–60 | CI/CD | Automation |
| #61–70 | Security | Security hardening |
| #71–80 | Logging | Observability |
| #81–90 | NGINX | Reverse proxy |
| #91–100 | Ansible | Config management |
| #101–110 | AWS | Cloud |
| #111–120 | Integration | End-to-end |
| #121–131 | Networking | Protocols |
| #132–146 | K8s Advanced / Microservices / GitOps / Helm | Advanced |
| #147–149 | AWS Advanced / LocalStack | Cloud Advanced |
| #150, #158 | Distributed Systems (Raft, ZooKeeper) | Consensus |
| #151 | Durable Execution (Restate) | Distributed |
| #152 | Email Service | Microservices |
| #153–154 | System Design Diagrams + Scale | Design |
| #155 | Auth Mechanisms | Security |
| #156–157 | Kafka DLQ + Partitions | Messaging |
