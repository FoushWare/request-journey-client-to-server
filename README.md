# 🚀 Full-Stack DevOps Learning Project — The Complete Guide

> **Everything in one place.** This is a comprehensive, production-grade learning project that takes a simple Notes App from a browser click all the way to a globally distributed, auto-scaling, fully observable, security-hardened cloud deployment.
>
> Every layer is taught hands-on through 141+ structured tasks across 21 technology categories.

---

## 📋 Table of Contents

1. [What is This Project?](#what-is-this-project)
2. [The Notes App](#the-notes-app)
3. [Big Picture — Everything Connected](#big-picture--everything-connected)
4. [Layer 0 — Micro-Frontend Architecture](#layer-0--micro-frontend-architecture)
5. [Layer 1 — Client & Network Edge](#layer-1--client--network-edge)
6. [Layer 2 — Load Balancer & Reverse Proxy (NGINX)](#layer-2--load-balancer--reverse-proxy-nginx)
7. [Layer 3 — API Gateway & Microservices](#layer-3--api-gateway--microservices)
8. [Layer 4 — Event Streaming (Kafka)](#layer-4--event-streaming-kafka)
9. [Layer 5 — Databases & Storage](#layer-5--databases--storage)
10. [Layer 6 — Container Orchestration (Kubernetes)](#layer-6--container-orchestration-kubernetes)
11. [Layer 7 — GitOps & Helm](#layer-7--gitops--helm)
12. [Layer 8 — Service Mesh (Istio)](#layer-8--service-mesh-istio)
13. [Layer 9 — CI/CD Pipelines](#layer-9--cicd-pipelines)
14. [Layer 10 — Security](#layer-10--security)
15. [Layer 11 — Observability (Logs, Metrics, Traces)](#layer-11--observability-logs-metrics-traces)
16. [Layer 12 — Infrastructure as Code (Terraform + Ansible)](#layer-12--infrastructure-as-code-terraform--ansible)
17. [Layer 13 — Cloud Deployment (AWS / GCP / Azure)](#layer-13--cloud-deployment-aws--gcp--azure)
18. [Layer 14 — Serverless (Lambda / Cloud Functions)](#layer-14--serverless-lambda--cloud-functions)
19. [Layer 15 — Distributed Systems](#layer-15--distributed-systems)
20. [The Full Learning Roadmap](#the-full-learning-roadmap)
21. [Task Categories & File Index](#task-categories--file-index)

---

## What is This Project?

This repository is a **complete, end-to-end DevOps learning curriculum** built around one real application: a Notes App. Every concept is not just explained — it's implemented hands-on, connected to the same codebase, and built toward a production-ready architecture.

**The philosophy:** _Learn by building. Everything is connected._

- The app starts as a plain Node.js + React app
- Each phase adds a real production capability
- By the end, the same app runs on Kubernetes, with Istio mTLS, Kafka event streaming, HashiCorp Vault secrets, Prometheus/Grafana observability, GitOps via Argo CD, and Terraform-provisioned infrastructure — all on EKS

### Current Learner-First Execution Order

1. App with mock server (no backend)
2. App with backend fixed responses (no database)
3. Backend with real database
4. Containerization
5. Microfrontend
6. Microservice
7. Microservice challenges
8. Kubernetes
9. Ansible
10. Production-readiness extras

---

## The Notes App

The foundation application is deliberately simple so that all learning energy goes to the infrastructure:

| Feature | Implementation |
|---------|---------------|
| User registration | REST API → PostgreSQL |
| User login | JWT (access + refresh tokens) |
| Create a note | REST API → MongoDB |
| List notes | REST API with Redis caching |
| Upload attachment | S3 pre-signed URL |
| Email on note created | Kafka event → Lambda → SES |
| Search notes | Kafka event → Elasticsearch |

**Tech stack:**

| Layer | Technology |
|-------|-----------|
| Frontend | React / Next.js / Tailwind CSS |
| **Micro-Frontends** | **Webpack 5 Module Federation, Nx MFE, single-spa** |
| Backend (main) | Node.js / Express |
| Microservices | Node.js (Nx monorepo), Go, Python |
| Auth | JWT (HS256, access + refresh) |
| Databases | PostgreSQL, MongoDB, Redis, Elasticsearch |
| Messaging | Apache Kafka |
| Containerization | Docker |
| Orchestration | Kubernetes (EKS) |
| Service Mesh | Istio |
| IaC | Terraform + Ansible |
| Secrets | HashiCorp Vault |
| CI/CD | GitHub Actions + Jenkins |
| GitOps | Argo CD + Flux |
| Observability | Prometheus + Grafana + Jaeger + ELK |
| Cloud | AWS (primary), GCP + Azure (alternatives) |
| Serverless | AWS Lambda, GCP Cloud Functions, Azure Functions |

---

## Big Picture — Everything Connected

```mermaid
graph TB
    subgraph Client["🌐 Client Layer"]
        Browser["Browser / Mobile App"]
        subgraph MFE_Layer["🧩 Micro-Frontends (Module Federation)"]
            Shell["Shell App\n(host, routing)"]
            AuthMFE["Auth MFE\n(/login /register)"]
            NotesMFE["Notes MFE\n(/notes)"]
            SearchMFE["Search MFE\n(/search)"]
        end
    end

    subgraph Edge["🔗 Network Edge"]
        DNS["DNS\n(Route 53 / CoreDNS)"]
        CDN["CDN\n(CloudFront / Nginx Cache)"]
        WAF["WAF\n(Rate Limiting, DDoS)"]
        LB["Load Balancer\n(ELB / NGINX)"]
    end

    subgraph Proxy["🚪 Reverse Proxy & Gateway"]
        NGINX["NGINX\n(SSL Termination\nLoad Balancing\nRate Limiting)"]
        AG["API Gateway\n(Routing, Auth)"]
    end

    subgraph Services["⚙️ Microservices — Nx Monorepo"]
        Auth["Auth Service\n(Go / Node.js)"]
        Notes["Notes Service\n(Go / Node.js)"]
        Email["Email Service\n(Node.js)"]
        Search["Search Service\n(TypeScript)"]
    end

    subgraph Messaging["📨 Event Streaming"]
        Kafka["Apache Kafka\n(Topics, Partitions\nConsumer Groups, DLQ)"]
    end

    subgraph Databases["🗄️ Databases & Storage"]
        PG["PostgreSQL\n(Users, Auth)"]
        Mongo["MongoDB\n(Notes content)"]
        Redis["Redis\n(Cache, Sessions)"]
        ES["Elasticsearch\n(Search index)"]
        S3["S3\n(Attachments)"]
    end

    subgraph Serverless["⚡ Serverless"]
        Lambda["AWS Lambda\n(Email Notify\nImage Resize\nCleanup)"]
    end

    subgraph K8s["☸️ Kubernetes — EKS"]
        Pods["Pods & Deployments"]
        HPA["HPA — Auto Scaling"]
        Ingress["Ingress + TLS"]
        NP["Network Policies"]
    end

    subgraph GitOps["🔄 GitOps"]
        ArgoCD["Argo CD\n(GitOps sync)"]
        Flux["Flux CD\n(alternative)"]
        Helm["Helm Charts"]
    end

    subgraph Mesh["🕸️ Service Mesh"]
        Istio["Istio\n(mTLS, Traffic Mgmt\nCircuit Breaker)"]
    end

    subgraph CICD["🏗️ CI/CD"]
        GHA["GitHub Actions"]
        Jenkins["Jenkins"]
        SonarQube["SonarQube\n(Code Quality)"]
    end

    subgraph Observability["📊 Observability"]
        Prometheus["Prometheus\n(Metrics)"]
        Grafana["Grafana\n(Dashboards)"]
        Jaeger["Jaeger\n(Distributed Traces)"]
        ELK["ELK Stack\n(Logs)"]
    end

    subgraph Security["🔒 Security"]
        Vault["HashiCorp Vault\n(Secrets)"]
        Consul["Consul\n(Service Discovery)"]
        JWT_Sec["JWT + 2FA\nHTTPOnly Cookies\nCSRF Protection"]
    end

    subgraph IaC["🏗️ Infrastructure as Code"]
        Terraform["Terraform\n(VPC, EKS, RDS\nS3, ECR, IAM, KMS)"]
        Ansible["Ansible\n(Docker, K8s\nMonitoring, Security)"]
    end

    subgraph Cloud["☁️ AWS Cloud"]
        EC2["EC2\n(VMs)"]
        EKS_C["EKS\n(K8s managed)"]
        RDS["RDS\n(Postgres)"]
        ECR["ECR\n(Images)"]
        CF["CloudFront\n(CDN)"]
        LocalStack["LocalStack\n(Local dev)"]
    end

    %% MFE layer
    Browser --- Shell
    Shell --> AuthMFE
    Shell --> NotesMFE
    Shell --> SearchMFE

    %% Request flow
    Browser -->|HTTPS| DNS
    DNS --> CDN
    CDN --> WAF
    WAF --> LB
    LB --> NGINX
    NGINX --> AG
    AG --> Auth
    AG --> Notes
    AG --> Search

    %% Events
    Notes -->|note.created| Kafka
    Auth -->|user.registered| Kafka
    Kafka -->|email topic| Email
    Kafka -->|search topic| Search
    Kafka -->|email queue| Lambda

    %% Databases
    Auth --> PG
    Notes --> Mongo
    Notes --> Redis
    Search --> ES
    Notes --> S3

    %% Secrets
    Auth --> Vault
    Notes --> Vault

    %% K8s
    K8s --> Pods
    Pods --> HPA
    Services --- K8s
    Istio --- Services
    Ingress --- AG

    %% GitOps
    CICD --> ArgoCD
    ArgoCD --> K8s
    Helm --> ArgoCD

    %% Observability
    Services -->|metrics| Prometheus
    Prometheus --> Grafana
    Services -->|traces| Jaeger
    Services -->|logs| ELK

    %% IaC
    Terraform --> Cloud
    Ansible --> K8s

    %% Cloud mapping
    EKS_C --- K8s
    RDS --- PG
    ECR --- Pods
    CF --- CDN

    style Client fill:#e1f5fe,stroke:#01579b
    style MFE_Layer fill:#fce4ec,stroke:#c62828
    style Edge fill:#fff3e0,stroke:#e65100
    style Proxy fill:#fce4ec,stroke:#880e4f
    style Services fill:#e8f5e9,stroke:#1b5e20
    style Messaging fill:#f3e5f5,stroke:#4a148c
    style Databases fill:#e8eaf6,stroke:#1a237e
    style Serverless fill:#fff9c4,stroke:#f57f17
    style K8s fill:#e0f2f1,stroke:#004d40
    style GitOps fill:#e8f5e9,stroke:#1b5e20
    style Mesh fill:#fbe9e7,stroke:#bf360c
    style CICD fill:#f3e5f5,stroke:#4a148c
    style Observability fill:#f1f8e9,stroke:#33691e
    style Security fill:#fff8e1,stroke:#ff6f00
    style IaC fill:#fbe9e7,stroke:#bf360c
    style Cloud fill:#e3f2fd,stroke:#0d47a1
```

---

## Layer 0 — Micro-Frontend Architecture

> **The frontend is also decomposed.** Just as the backend is split into microservices, the Notes App UI is split into independently deployable **Micro-Frontends** — one per feature domain — orchestrated by a Shell App using Webpack 5 Module Federation.

```mermaid
graph TB
    subgraph Shell["🏠 Shell App — Host (Next.js, port 3000)"]
        Router["Client-side Router\n/ → layout\n/auth → AuthMFE\n/notes → NotesMFE\n/search → SearchMFE\n/me → ProfileMFE"]
        SharedCtx["Shared Context\n(AuthContext, Theme)"]
        SharedUI["@notes-app/shared-ui\n(Button, Modal, Navbar)"]
    end

    subgraph Remotes["🧩 Remote MFEs (independently deployed)"]
        AuthMFE["🔐 Auth MFE\n(React, Vite — port 3001)\nLogin / Register / 2FA\nOwner: Auth Team"]
        NotesMFE["📝 Notes MFE\n(Next.js — port 3002)\nNote list + editor\nOwner: Notes Team"]
        SearchMFE["🔍 Search MFE\n(React, Vite — port 3003)\nSearch + results\nOwner: Search Team"]
        ProfileMFE["👤 Profile MFE\n(Next.js SSR — port 3004)\nUser settings\nOwner: Platform Team"]
    end

    subgraph Hosting["📦 Deployment"]
        CDN_MFE["CloudFront + S3\n(CSR MFEs: Auth, Notes, Search)\nremoteEntry.js — no cache\nchunks — 1yr cache"]
        K8S_MFE["Kubernetes EKS\n(SSR MFE: Profile)\nDeployment + Service + Ingress"]
        NxBuild["Nx Workspace\nnx affected:build\n(only changed MFEs rebuild)"]
    end

    Shell -->|Module Federation| AuthMFE
    Shell -->|Module Federation| NotesMFE
    Shell -->|Module Federation| SearchMFE
    Shell -->|Module Federation| ProfileMFE

    AuthMFE --> CDN_MFE
    NotesMFE --> CDN_MFE
    SearchMFE --> CDN_MFE
    ProfileMFE --> K8S_MFE

    NxBuild --> CDN_MFE
    NxBuild --> K8S_MFE

    style Shell fill:#e1f5fe,stroke:#01579b
    style Remotes fill:#fce4ec,stroke:#c62828
    style Hosting fill:#e8f5e9,stroke:#1b5e20
```

### MFE ↔ Microservice Mapping

| Micro-Frontend | Calls | Backend Microservice |
|---------------|-------|---------------------|
| Auth MFE | REST `/api/auth/*` | Auth Service (Go/Node.js) |
| Notes MFE | REST `/api/notes/*` | Notes Service (Go/Node.js) |
| Search MFE | REST `/api/search/*` | Search Service (TypeScript) |
| Profile MFE | REST `/api/auth/*` + `/api/notes/*` | Auth + Notes Services |

### Module Federation Architecture

```mermaid
sequenceDiagram
    participant Browser as 👤 Browser
    participant Shell as 🏠 Shell App (host)
    participant CDN as 📡 CDN / S3
    participant AuthSvc as 🔐 Auth Service

    Browser->>Shell: Load notes-app.com
    Shell->>CDN: GET /importmap.json
    CDN-->>Shell: { auth-mfe: "cdn.../auth-mfe/remoteEntry.js" }
    Browser->>CDN: GET /auth-mfe/remoteEntry.js
    CDN-->>Browser: remoteEntry manifest
    Note over Browser: User navigates to /login
    Browser->>CDN: GET /auth-mfe/chunk-abc123.js (lazy)
    CDN-->>Browser: Auth MFE bundle (cached 1yr)
    Browser->>AuthSvc: POST /api/auth/login
    AuthSvc-->>Browser: JWT token
    Note over Browser: Token stored in Shell's AuthContext\nAvailable to ALL MFEs
```

**Tasks:** `tasks/micro-frontend/`
- `task-001-introduction-to-micro-frontends.md` — Architecture, decomposition, when to use
- `task-002-module-federation-webpack5.md` — Webpack 5 Module Federation, shared singletons
- `task-003-single-spa-orchestration.md` — single-spa alternative, framework-agnostic
- `task-004-nx-monorepo-micro-frontends.md` — Nx generators, shared libs, `nx affected`
- `task-005-deploy-mfe-kubernetes-cdn.md` — S3+CloudFront (CSR) + K8s (SSR), cache strategy

---

## Layer 1 — Client & Network Edge

> **Request journey start:** Browser makes an HTTPS request. Before it reaches any server, it passes through DNS, CDN, WAF, and Load Balancer.

```mermaid
sequenceDiagram
    participant User as 👤 User Browser
    participant DNS as 🌐 DNS (Route 53)
    participant CDN as 📡 CDN (CloudFront)
    participant WAF as 🛡️ WAF
    participant LB as ⚖️ Load Balancer (ELB/NGINX)
    participant NGINX as 🔀 NGINX Reverse Proxy

    User->>DNS: GET notes-app.com (HTTPS)
    DNS-->>User: A record → CloudFront IP
    User->>CDN: HTTPS request
    CDN-->>User: Cache HIT (static assets)
    CDN->>WAF: Cache MISS → forward to origin
    WAF->>WAF: Check rules (rate limit, IP block, SQLi/XSS)
    WAF->>LB: Allowed request
    LB->>NGINX: Round-robin to healthy pod
    NGINX->>NGINX: SSL termination, header injection
    Note over NGINX: Strips client TLS, adds X-Request-ID
```

**Tasks covering this layer:**
- `tasks/networking/` — DNS, TCP/IP, HTTP/2, TLS handshake (11 tasks)
- `tasks/nginx/` — Reverse proxy, load balancing, rate limiting, SSL/TLS (10 tasks)

---

## Layer 2 — Load Balancer & Reverse Proxy (NGINX)

```mermaid
graph LR
    subgraph LBLayer["⚖️ Load Balancing Strategies"]
        RR["Round Robin\n(equal distribution)"]
        LC["Least Connections\n(route to least busy)"]
        IPH["IP Hash\n(sticky sessions)"]
        WRR["Weighted Round Robin\n(canary deploys)"]
    end

    subgraph NGINX_Config["🔀 NGINX Capabilities"]
        SSL["SSL/TLS Termination\n(Let's Encrypt)"]
        Rate["Rate Limiting\n(10 req/s per IP)"]
        Cache["Proxy Cache\n(static assets)"]
        Headers["Security Headers\n(HSTS, CSP, X-Frame)"]
        Upstream["Upstream Pool\n(backend pods)"]
        Health["Health Checks\n(/health endpoint)"]
    end

    Clients -->|HTTPS| SSL
    SSL --> Rate
    Rate --> Cache
    Cache -->|cache miss| Upstream
    Upstream --> RR
    Upstream --> LC
    Upstream --> IPH
    Headers --> Clients
```

**Key config patterns:**
- NGINX as Kubernetes Ingress Controller
- Rate limiting: `limit_req_zone` per IP
- SSL offloading with Let's Encrypt cert-manager
- Health checks: `upstream` + `proxy_next_upstream`

**Tasks:** `tasks/nginx/task-001` through `task-010`

---

## Layer 3 — API Gateway & Microservices

```mermaid
graph TB
    subgraph APIGateway["🚪 API Gateway"]
        Route["Request Routing\n/api/auth/* → Auth\n/api/notes/* → Notes\n/api/search/* → Search"]
        AuthMW["Auth Middleware\nJWT Validation"]
        Throttle["Rate Throttling\nPer-user quotas"]
        Transform["Request Transform\nAdd correlation IDs"]
    end

    subgraph Microservices["⚙️ Microservices (Nx Monorepo)"]
        AuthSvc["🔐 Auth Service\n• Register / Login\n• JWT issue + refresh\n• 2FA TOTP\n• Session mgmt"]
        NotesSvc["📝 Notes Service\n• CRUD notes\n• S3 attachments\n• CQRS write side\n• Saga coordinator"]
        EmailSvc["📧 Email Service\n• Kafka consumer\n• SES sending\n• Template engine"]
        SearchSvc["🔍 Search Service\n• Kafka consumer\n• ES indexing\n• Full-text search"]
    end

    subgraph Patterns["🏛️ Patterns Used"]
        Circuit["Circuit Breaker\n(Hystrix / Istio)"]
        Saga["Saga Pattern\n(Choreography)"]
        CQRS["CQRS +\nEvent Sourcing"]
        Sidecar["Sidecar Pattern\n(Istio envoy proxy)"]
        Disc["Service Discovery\n(CoreDNS / Consul)"]
    end

    APIGateway --> AuthSvc
    APIGateway --> NotesSvc
    APIGateway --> SearchSvc

    NotesSvc --> Circuit
    NotesSvc --> Saga
    NotesSvc --> CQRS
    AuthSvc --> Sidecar
    AuthSvc --> Disc
```

**Tasks:** `tasks/microservices/task-001` through `task-014`  
**Implementation:** `implementation/microservices/`  
**Nx Workspace:** `implementation/microservices/task-009-nx-monorepo/`

---

## Layer 4 — Event Streaming (Kafka)

```mermaid
graph LR
    subgraph Producers["📤 Producers"]
        NP["Notes Service\nnote.created\nnote.updated\nnote.deleted"]
        AP["Auth Service\nuser.registered\nuser.login"]
    end

    subgraph Kafka["📨 Apache Kafka"]
        subgraph Topics["Topics"]
            T1["notes-events\n(3 partitions)"]
            T2["user-events\n(2 partitions)"]
            T3["email-queue\n(1 partition)"]
            DLQ["dead-letter-queue\n(failed messages)"]
        end
        ZK["ZooKeeper\n(Broker coordination)"]
    end

    subgraph Consumers["📥 Consumer Groups"]
        CG1["email-consumer-group\n→ Email Service\n→ Lambda"]
        CG2["search-consumer-group\n→ Search Service\n→ Elasticsearch"]
        CG3["audit-consumer-group\n→ Audit Log"]
    end

    NP -->|produce| T1
    NP -->|produce| T3
    AP -->|produce| T2

    T1 --> CG2
    T1 --> CG3
    T2 --> CG1
    T3 --> CG1
    DLQ -->|retry| T3

    ZK --> Kafka
```

**Tasks:** `tasks/messaging/`
- `task-001-kafka-setup.md`
- `task-002-dead-letter-queue.md`
- `task-003-retry-patterns.md`
- `task-004-kafka-partitions.md`
- `task-005-consumer-groups.md`

---

## Layer 5 — Databases & Storage

```mermaid
graph TB
    subgraph WriteModels["✏️ Write Models (Command Side)"]
        AuthWrite["Auth Service\n↓\nPostgreSQL\n(users, sessions, tokens)"]
        NotesWrite["Notes Service\n↓\nMongoDB\n(notes content, versions)"]
    end

    subgraph ReadModels["📖 Read Models (Query Side — CQRS)"]
        SearchRead["Search Service\n↓\nElasticsearch\n(full-text index)"]
        CacheRead["All Services\n↓\nRedis\n(API response cache\nsession store\nrate limit counters)"]
    end

    subgraph Storage["💾 Object Storage"]
        S3Store["Notes Service\n↓\nS3\n(attachments, images\npre-signed URLs)"]
    end

    subgraph GraphDB["🕸️ Graph (Optional)"]
        Neo["Notes Service\n↓\nNeo4j\n(tags, follows\nrecommendations)"]
    end

    subgraph CloudDBs["☁️ Cloud Databases"]
        RDS["AWS RDS\n(managed Postgres)"]
        ElastiCache["AWS ElastiCache\n(managed Redis)"]
        S3Cloud["AWS S3\n(managed object store)"]
    end

    AuthWrite --> RDS
    NotesWrite -.->|local dev| NotesWrite
    CacheRead --> ElastiCache
    S3Store --> S3Cloud
```

**Tasks:**
- `tasks/aws/task-005-provision-rds-database.md`
- `tasks/terraform/task-005-provision-rds-database.md`
- `tasks/system-design/task-004-caching-strategy.md`

---

## Layer 6 — Container Orchestration (Kubernetes)

```mermaid
graph TB
    subgraph EKS["☸️ EKS Cluster"]
        subgraph ControlPlane["Control Plane (AWS managed)"]
            APIServer["kube-apiserver"]
            ETCD["etcd\n(cluster state)"]
            Scheduler["kube-scheduler"]
            CM["controller-manager"]
        end

        subgraph NodeGroup["Worker Node Group (t3.medium × 3)"]
            subgraph NsNotesApp["Namespace: notes-app"]
                AuthPod["Auth Pod\n(2 replicas)"]
                NotesPod["Notes Pod\n(3 replicas)"]
                EmailPod["Email Pod\n(1 replica)"]
                SearchPod["Search Pod\n(2 replicas)"]
            end

            subgraph NsInfra["Namespace: infra"]
                PGPod["PostgreSQL Pod\n+ PVC"]
                MongoPod["MongoDB Pod\n+ PVC"]
                RedisPod["Redis Pod\n+ PVC"]
                KafkaPod["Kafka + ZK\n+ PVC"]
            end

            subgraph NsMonitoring["Namespace: monitoring"]
                PromPod["Prometheus"]
                GrafPod["Grafana"]
                JaegerPod["Jaeger"]
            end
        end

        subgraph K8sObjects["Key Kubernetes Objects"]
            Deploy["Deployments\n(rolling updates)"]
            SVC["Services\n(ClusterIP / LoadBalancer)"]
            CM2["ConfigMaps\n(app config)"]
            Secrets["Secrets\n(from Vault)"]
            HPA2["HPA\n(CPU/mem autoscaling)"]
            NP2["NetworkPolicy\n(micro-segmentation)"]
            Ingress2["Ingress\n(NGINX controller + TLS)"]
            SA["ServiceAccounts\n(IRSA for AWS)"]
        end
    end

    APIServer --> NodeGroup
    Scheduler --> NodeGroup
    K8sObjects --- NsNotesApp
```

**Tasks:** `tasks/kubernetes/task-001` through `task-013`
- Deployments, Services, Ingress, ConfigMaps, Secrets
- HPA (Horizontal Pod Autoscaler)
- Rolling updates + pod probes (liveness/readiness/startup)
- Network Policies (micro-segmentation)
- Deploying to cloud (EKS/GKE/AKS)

---

## Layer 7 — GitOps & Helm

```mermaid
sequenceDiagram
    participant Dev as 👨‍💻 Developer
    participant Git as 📁 Git Repo (GitOps Repo)
    participant CI as 🏗️ GitHub Actions CI
    participant Helm as ⛵ Helm Chart
    participant ArgoCD as 🔄 Argo CD
    participant K8s as ☸️ Kubernetes

    Dev->>Git: Push code change
    Git->>CI: Trigger CI pipeline
    CI->>CI: Test → Build → Push image to ECR
    CI->>Git: Update image tag in values.yaml
    Git->>ArgoCD: Webhook: GitOps repo changed
    ArgoCD->>ArgoCD: Detect drift from desired state
    ArgoCD->>Helm: Render chart with new values
    Helm->>K8s: kubectl apply manifests
    K8s-->>ArgoCD: Sync status: Healthy ✅
    ArgoCD-->>Dev: Deployment complete notification
```

**Tasks:**
- `tasks/helm/` — Install Helm, create charts, multi-env values, CI/CD integration
- `tasks/gitops/` — Flux CD, Argo CD, multi-cluster, best practices

---

## Layer 8 — Service Mesh (Istio)

```mermaid
graph TB
    subgraph ServiceMesh["🕸️ Istio Service Mesh"]
        subgraph ControlPlane2["Istiod (Control Plane)"]
            Pilot["Pilot\n(service discovery\ntraffic rules)"]
            Citadel["Citadel\n(cert authority\nmTLS certs)"]
            Galley["Galley\n(config validation)"]
        end

        subgraph DataPlane["Data Plane — Envoy Sidecars"]
            Auth_E["Auth Pod\n[app + envoy proxy]"]
            Notes_E["Notes Pod\n[app + envoy proxy]"]
            Email_E["Email Pod\n[app + envoy proxy]"]
        end

        subgraph IstioFeatures["Capabilities"]
            MTLS["mTLS\n(auto cert rotation\nzero-trust networking)"]
            Traffic["Traffic Management\n(canary: 90/10 split\nblue-green\nretries + timeouts)"]
            Observe["Observability\n(Kiali dashboard\nJaeger traces\nPrometheus metrics)"]
            FaultInj["Fault Injection\n(chaos testing\nlatency + errors)"]
        end
    end

    Pilot --> DataPlane
    Citadel --> MTLS
    DataPlane --> Traffic
    DataPlane --> Observe
    DataPlane --> FaultInj
```

**Tasks:** `tasks/service-mesh/`
- `task-001-setup-istio.md`
- `task-002-istio-traffic-management.md` (canary, blue-green)
- `task-003-istio-security-mtls.md`
- `task-004-istio-observability.md`

---

## Layer 9 — CI/CD Pipelines

```mermaid
flowchart LR
    subgraph Trigger["⚡ Triggers"]
        PR["Pull Request"]
        Push["Push to main"]
        Tag["Git Tag\n(release)"]
    end

    subgraph CI["🔍 CI Stage — GitHub Actions / Jenkins"]
        Lint["Lint\n(ESLint, Prettier)"]
        Test["Unit + Integration\nTests (Jest, Go test)"]
        Sonar["SonarQube\nCode Quality Gate"]
        Security["Security Scan\n(Trivy, Snyk)"]
        Build["Docker Build\n(multi-stage)"]
        Push["Push to ECR\n(image:sha)"]
    end

    subgraph Gate["🚦 Quality Gate"]
        Gate1{"Coverage > 80%?"}
        Gate2{"No Critical CVEs?"}
        Gate3{"Sonar Quality Gate?"}
    end

    subgraph CD["🚀 CD Stage — Argo CD"]
        UpdateValues["Update Helm\nvalues.yaml\nimage tag"]
        ArgoDeploy["Argo CD detects\nGit change"]
        Deploy["kubectl apply\n(rolling update)"]
        Smoke["Smoke Tests\n(/health endpoint)"]
        Rollback["Auto Rollback\n(on failure)"]
    end

    Trigger --> Lint
    Lint --> Test
    Test --> Sonar
    Sonar --> Security
    Security --> Build
    Build --> Push
    Push --> Gate1
    Gate1 -->|pass| Gate2
    Gate2 -->|pass| Gate3
    Gate3 -->|pass| UpdateValues
    UpdateValues --> ArgoDeploy
    ArgoDeploy --> Deploy
    Deploy --> Smoke
    Smoke -->|fail| Rollback

    style Gate fill:#fff3e0
    style Rollback fill:#ffcdd2
```

**Tasks:** `tasks/ci-cd/task-001` through `task-014`
- GitHub Actions workflows, Jenkins pipelines
- SonarQube integration (setup, configure, pipeline gating)
- Automated testing in CI
- Pipeline gating: CI must pass before CD

---

## Layer 10 — Security

```mermaid
graph TB
    subgraph AuthSecurity["🔐 Authentication & Authorization"]
        JWT["JWT Tokens\n(HS256, 15min expiry)"]
        Refresh["Refresh Tokens\n(7d, HTTPOnly cookie)"]
        TwoFA["2FA TOTP\n(Google Authenticator)"]
        CSRF["CSRF Protection\n(SameSite + token)"]
        Sessions["Session Management\n(Redis-backed)"]
    end

    subgraph NetworkSecurity["🌐 Network Security"]
        HTTPS["HTTPS Everywhere\n(Let's Encrypt\ncert-manager)"]
        HSTS["HSTS Headers\n(preload)"]
        CSP["Content Security\nPolicy"]
        RateLimit["Rate Limiting\n(NGINX + API GW)"]
        NP3["K8s Network Policies\n(deny-all default)"]
        MTLS2["Istio mTLS\n(service-to-service)"]
    end

    subgraph SecretsMgmt["🗄️ Secrets Management"]
        Vault2["HashiCorp Vault\n(dynamic secrets\nauto-rotation)"]
        VaultK8s["Vault Agent\nInjector (K8s)"]
        VaultAWS["Vault AWS Auth\n(IRSA-backed)"]
        K8sSecrets["K8s Secrets\n(from Vault CSI\ndriver)"]
    end

    subgraph InfraSecurity["🏗️ Infrastructure Security"]
        IAM["IAM Roles\n(least privilege\nIRSA for pods)"]
        SG["Security Groups\n(port allowlists)"]
        KMS["AWS KMS\n(encrypt at rest\nRDS, S3, SQS)"]
        ACM["ACM\n(managed TLS certs)"]
    end

    AuthSecurity --> SecretsMgmt
    SecretsMgmt --> K8sSecrets
    NetworkSecurity --> InfraSecurity
```

**Tasks:**
- `tasks/security/` — JWT, sessions, 2FA, OWASP, HTTPOnly cookies, CSRF (13 tasks)
- `tasks/vault/` — Vault install, K8s integration, AWS auth, dynamic secrets (10 tasks)

---

## Layer 11 — Observability (Logs, Metrics, Traces)

> The **Three Pillars of Observability**: Logs tell you *what* happened. Metrics tell you *how much*. Traces tell you *where*.

```mermaid
graph TB
    subgraph Apps["⚙️ Services"]
        S1["Auth Service"]
        S2["Notes Service"]
        S3_["Email Service"]
    end

    subgraph Logs["📋 Logs — ELK Stack"]
        Filebeat["Filebeat\n(log shipper)"]
        Logstash["Logstash\n(parse + transform)"]
        ElasticSearch["Elasticsearch\n(log storage + index)"]
        Kibana["Kibana\n(log dashboards\nerror search)"]
    end

    subgraph Metrics["📈 Metrics — Prometheus Stack"]
        PromScrape["Prometheus\n(scrape /metrics every 15s)"]
        AlertManager["AlertManager\n(PagerDuty / Slack)"]
        GrafanaDash["Grafana\n(dashboards + alerts\nSLO tracking)"]
    end

    subgraph Traces["🔍 Distributed Traces — Jaeger"]
        OtelSDK["OpenTelemetry SDK\n(auto-instrument)"]
        JaegerCollector["Jaeger Collector\n(receive spans)"]
        JaegerUI["Jaeger UI\n(trace waterfall\nlatency analysis)"]
    end

    Apps -->|stdout logs| Filebeat
    Filebeat --> Logstash
    Logstash --> ElasticSearch
    ElasticSearch --> Kibana

    Apps -->|/metrics endpoint| PromScrape
    PromScrape --> AlertManager
    PromScrape --> GrafanaDash

    Apps -->|trace context headers| OtelSDK
    OtelSDK --> JaegerCollector
    JaegerCollector --> JaegerUI
```

**Tasks:** `tasks/logging/task-001` through `task-011`
- ELK setup, Filebeat, Fluent Bit
- Prometheus + Grafana
- OpenTelemetry + Jaeger
- Observability Three Pillars (`task-011-observability-three-pillars.md`)

---

## Layer 12 — Infrastructure as Code (Terraform + Ansible)

```mermaid
graph LR
    subgraph TF["🏗️ Terraform — Cloud Provisioning"]
        VPC_M["vpc module\n(VPC, subnets, IGW, NAT)"]
        EKS_M["eks module\n(EKS cluster + node groups)"]
        RDS_M["rds module\n(Postgres, multi-AZ)"]
        EC_M["elasticache module\n(Redis cluster)"]
        S3_M["s3 module\n(buckets + policies)"]
        ECR_M["ecr module\n(container repos)"]
        IAM_M["iam module\n(roles + IRSA)"]
        SG_M["security_groups module\n(port rules)"]
        KMS_M["kms module\n(encryption keys)"]
        ACM_M["acm module\n(TLS certs)"]
    end

    subgraph Ansible_R["⚙️ Ansible — Configuration Management"]
        Docker_R["docker role\n(install Docker)"]
        K8s_R["kubernetes role\n(apply manifests)"]
        Notes_R["notes-app role\n(deploy services)"]
        Mon_R["monitoring role\n(Prometheus, Grafana)"]
        Sec_R["security role\n(harden OS, firewall)"]
    end

    TF -->|outputs: cluster endpoint\nnode IAM role\nVPC IDs| Ansible_R
    Ansible_R -->|applies to| EKS_M
```

**Tasks:**
- `tasks/terraform/task-001` through `task-010` — Full Terraform curriculum
- `tasks/ansible/task-001` through `task-010` — Full Ansible curriculum
- `automation/terraform/` — 10 production Terraform modules
- `automation/ansible/` — 5 production Ansible roles

---

## Layer 13 — Cloud Deployment (AWS / GCP / Azure)

```mermaid
graph TB
    subgraph Strategies["☁️ Deployment Strategies"]
        subgraph VM["Option A: Raw VMs"]
            EC2_D["EC2 + Docker Compose\n(dev/test only)"]
        end
        subgraph ManagedK8s["Option B: Managed K8s (Recommended)"]
            EKS_D["AWS EKS\n(Terraform + kubectl)"]
            GKE_D["GCP GKE\n(gcloud + kubectl)"]
            AKS_D["Azure AKS\n(az aks + kubectl)"]
        end
        subgraph Dedicated["Option C: Dedicated Hosts"]
            DedEC2["EC2 Dedicated Hosts\n(HIPAA/PCI compliance)"]
            SoleTenant["GCP Sole-Tenant\n(physical isolation)"]
            AzDedicated["Azure Dedicated Hosts\n(BYOL + compliance)"]
        end
    end

    subgraph AWSInfra["🟧 AWS Infrastructure (Primary)"]
        VPC2["VPC\n(public + private subnets)"]
        EKS2["EKS Cluster\n(worker nodes)"]
        RDS2["RDS Postgres\n(multi-AZ)"]
        Redis2["ElastiCache Redis\n(cluster mode)"]
        ECR2["ECR\n(container images)"]
        S3_2["S3\n(attachments + state)"]
        CF2["CloudFront\n(CDN)"]
        R53["Route 53\n(DNS)"]
    end

    EKS_D --> AWSInfra
    VM -.->|not recommended for prod| EC2_D
```

**Tasks:** `tasks/kubernetes/task-013`, `tasks/aws/task-001` through `task-015`

---

## Layer 14 — Serverless (Lambda / Cloud Functions)

```mermaid
flowchart LR
    subgraph Triggers["⚡ Triggers"]
        SQS_T["SQS Queue\n(email events)"]
        S3_T["S3 Event\n(file uploads)"]
        CW_T["CloudWatch Events\n(cron schedule)"]
        CF_T["CloudFront\n(Lambda@Edge)"]
    end

    subgraph Functions["🔧 Lambda Functions"]
        Email_F["email-notification\n(Node.js)\nSES email on note.created"]
        Resize_F["image-resize\n(Python)\nResize S3 uploads"]
        Cleanup_F["cleanup\n(Node.js)\nPurge expired data"]
        Edge_F["auth-edge\n(Node.js)\nJWT at CloudFront edge"]
    end

    subgraph Alternatives["🌐 Multi-Cloud FaaS"]
        GCF["GCP Cloud Functions\n(Pub/Sub trigger)"]
        AZF["Azure Functions\n(Service Bus trigger)"]
    end

    SQS_T --> Email_F
    S3_T --> Resize_F
    CW_T --> Cleanup_F
    CF_T --> Edge_F

    Email_F -.->|GCP equivalent| GCF
    Email_F -.->|Azure equivalent| AZF
```

**Tasks:** `tasks/aws/task-016-serverless-lambda.md`

---

## Layer 15 — Distributed Systems

```mermaid
graph TB
    subgraph Consensus["🗳️ Consensus & Leader Election"]
        Raft["Raft Algorithm\n(leader election\nlog replication)"]
        ETCD2["etcd\n(K8s uses this internally\nfor cluster state)"]
        ZK2["ZooKeeper\n(Kafka broker coordination\nleader election)"]
    end

    subgraph DurableExec["⏱️ Durable Execution"]
        Restate["Restate.dev\n(Workflow-as-Code\nnote creation saga:\ncreate → email → search → audit)"]
    end

    subgraph ConsistencyModels["📐 Consistency Models"]
        Strong["Strong Consistency\n(ACID — Postgres)"]
        Eventual["Eventual Consistency\n(Kafka consumers\nElasticsearch index)"]
        CAP["CAP Theorem\n(trade-off: CP vs AP)"]
    end

    Raft --> ETCD2
    ETCD2 --- Kubernetes
    ZK2 --- Kafka
    Restate --> NotesSvc2["Notes Service\n(saga workflow)"]
```

**Tasks:** `tasks/distributed-systems/`
- Raft consensus + simulation
- Durable execution with Restate
- ZooKeeper fundamentals + leader election

---

## The Full Learning Roadmap

```mermaid
graph LR
    P0["🏁 Start"] --> P1
    P1["Phase 1\nDocker\n9 tasks"] --> P2
    P2["Phase 2\nKubernetes\n13 tasks"] --> P3
    P3["Phase 3\nCI/CD\n14 tasks"] --> P4
    P4["Phase 4\nSecurity\n13+ tasks"] --> P5
    P5["Phase 5\nLogging + Obs\n11 tasks"] --> P6
    P6["Phase 6\nNGINX\n10 tasks"] --> P7
    P7["Phase 7\nAnsible\n10 tasks"] --> P8
    P8["Phase 8\nAWS + Cloud\n16 tasks"] --> P9
    P9["Phase 9\nIntegration\n10 tasks"] --> P10
    P10["Phase 10\nNetworking\n11 tasks"] --> P11
    P11["Phase 11\nGitOps\n4 tasks"] --> P12
    P12["Phase 12\nService Mesh\n4 tasks"] --> P13
    P13["Phase 13\nMicroservices\n14 tasks"] --> P14
    P14["Phase 14\nHelm\n4 tasks"] --> P15
    P15["Phase 15\nHashiCorp\n(Vault+Consul\n+Nomad)"] --> P16
    P16["Phase 16\nDistributed\nSystems\n6 tasks"] --> P17
    P17["Phase 17\nKafka\nMessaging\n5 tasks"] --> P18
    P18["Phase 18\nSystem Design\n4 tasks"] --> P19
    P19["Phase 19\nTerraform\n10 tasks"] --> P20
    P20["Phase 20\nServerless\n1 task"] --> P21
    P21["Phase 21\nMicro-\nFrontends\n5 tasks"] --> DONE
    DONE["🎯\nProduction\nReady"]

    style P0 fill:#4CAF50,color:#fff
    style DONE fill:#2196F3,color:#fff
```

---

## Task Categories & File Index

| Category | Directory | # Tasks | Key Topics |
|----------|-----------|---------|-----------|
| **Docker** | `tasks/docker/` | 9 | Dockerfiles, Compose, healthchecks, volumes, networks, logging |
| **Kubernetes** | `tasks/kubernetes/` | 13 | Deployments, Services, Ingress, HPA, Network Policies, rolling updates, cloud deploy |
| **CI/CD** | `tasks/ci-cd/` | 14 | GitHub Actions, Jenkins, SonarQube, pipeline gating, automated testing |
| **Security** | `tasks/security/` | 13+ | JWT, sessions, 2FA, HTTPOnly cookies, CSRF, WAF, OWASP |
| **Logging** | `tasks/logging/` | 11 | ELK stack, Filebeat, Fluent Bit, Prometheus, Grafana, Jaeger, observability pillars |
| **NGINX** | `tasks/nginx/` | 10 | Reverse proxy, load balancing, rate limiting, SSL, security headers |
| **Ansible** | `tasks/ansible/` | 10 | Playbooks, roles, inventory, idempotency, provisioning |
| **AWS** | `tasks/aws/` | 16 | EC2, S3, RDS, EKS, LocalStack, cloud alternatives, Lambda/serverless |
| **Integration** | `tasks/integration/` | 10+ | Frontend + backend integration, end-to-end flows |
| **Networking** | `tasks/networking/` | 11 | DNS, TCP/IP, HTTP/2, TLS, BGP, VPC, subnets |
| **GitOps** | `tasks/gitops/` | 4 | Flux CD, Argo CD, multi-cluster, best practices |
| **Service Mesh** | `tasks/service-mesh/` | 4 | Istio setup, traffic management, mTLS, observability |
| **Microservices** | `tasks/microservices/` | 14 | Architecture, DB design, service discovery, circuit breakers, Saga, CQRS, event sourcing, Nx monorepo, testing |
| **Helm** | `tasks/helm/` | 4 | Charts, environments, CI/CD integration |
| **HashiCorp** | `tasks/hashicorp/` | 6 | Consul (service discovery, config), Nomad (job scheduling, vs K8s) |
| **Vault** | `tasks/vault/` | 10 | Install, policies, K8s integration, AWS auth, dynamic secrets, HA |
| **Distributed Systems** | `tasks/distributed-systems/` | 6 | Raft, etcd, ZooKeeper, Restate durable execution |
| **Messaging** | `tasks/messaging/` | 5 | Kafka setup, DLQ, retry patterns, partitions, consumer groups |
| **System Design** | `tasks/system-design/` | 4 | Architecture diagrams, load testing (k6), scaling strategies, caching |
| **Terraform** | `tasks/terraform/` | 10 | Install, basics, EC2, RDS, S3, VPC, EKS, state, modules |
| **Micro-Frontend** | `tasks/micro-frontend/` | 5 | Module Federation, single-spa, Nx MFE, CSR/SSR deploy to CDN + K8s |

---

## 📁 Repository Structure

```
request-journey-client-to-server/
│
├── README.md                    ← You are here — complete project guide
├── CONSTITUTION.md              ← Project rules, diagram standards, task format
├── docs/
│   ├── diagrams/                ← 12 standalone Mermaid architecture diagrams
│   │   ├── 00-big-picture.md
│   │   ├── 01-request-journey.md
│   │   ├── 02-microservices-architecture.md
│   │   ├── 03-cicd-pipeline.md
│   │   ├── 04-observability-stack.md
│   │   ├── 05-database-topology.md
│   │   ├── 06-kafka-messaging.md
│   │   ├── 07-kubernetes-architecture.md
│   │   ├── 08-security-model.md
│   │   ├── 09-distributed-systems.md
│   │   ├── 10-aws-infrastructure.md
│   │   └── 11-nx-monorepo.md
│   └── AUTOMATION_REFERENCE.md  ← IaC reference matrix
│
├── tasks/                       ← 141+ learning tasks (21 categories)
│   ├── docker/
│   ├── kubernetes/
│   ├── ci-cd/
│   ├── security/
│   ├── logging/
│   ├── nginx/
│   ├── ansible/
│   ├── aws/
│   ├── integration/
│   ├── networking/
│   ├── gitops/
│   ├── service-mesh/
│   ├── microservices/
│   ├── micro-frontend/          ← NEW: Module Federation, Nx MFE, single-spa, CDN deploy
│   ├── helm/
│   ├── hashicorp/
│   ├── vault/
│   ├── distributed-systems/
│   ├── messaging/
│   ├── system-design/
│   └── terraform/
│
├── implementation/              ← Starter + final-solution code for each task
│   ├── docker/
│   ├── kubernetes/
│   ├── microservices/           ← Nx monorepo workspace
│   └── ...
│
├── automation/                  ← Production-grade IaC
│   ├── terraform/
│   │   ├── main.tf              ← Root module wiring all modules
│   │   └── modules/
│   │       ├── vpc/             ← VPC, subnets, IGW, NAT
│   │       ├── eks/             ← EKS cluster + node groups
│   │       ├── rds/             ← Postgres RDS
│   │       ├── elasticache/     ← Redis
│   │       ├── s3/              ← S3 buckets
│   │       ├── ecr/             ← Container registries
│   │       ├── iam/             ← Roles, IRSA
│   │       ├── security_groups/ ← Firewall rules
│   │       ├── kms/             ← Encryption keys
│   │       └── acm/             ← TLS certificates
│   └── ansible/
│       ├── site.yml             ← Master playbook
│       └── roles/
│           ├── docker/
│           ├── kubernetes/
│           ├── notes-app/
│           ├── monitoring/
│           └── security/
│
├── issues/                      ← Processed GitHub issues archive
│   ├── ISSUE_TRACKER.md         ← Master tracking spreadsheet
│   ├── issue-032.md ... issue-168.md
│
└── plans/                       ← Phase and integration plans
    ├── 01-roadmap-standardization.md
    ├── ...
    └── 19-phase-10-production-extras.md
```

---

## 🔑 Key Principles

1. **Everything is connected** — Every task contributes to the same Notes App production architecture
2. **Learn raw, then automate** — Tasks teach manual steps first; `automation/` provides the IaC equivalent
3. **Diagrams are mandatory** — Every task has an inline Mermaid diagram (enforced by `.cursor/rules/`)
4. **Automation Reference section** — Every task ends with a table linking to `automation/terraform/` or `automation/ansible/`
5. **Nx monorepo for everything** — Node.js/TypeScript microservices AND micro-frontend apps share a single Nx workspace with shared libraries (`shared/ui`, `shared/auth`, `shared/types`)
6. **Micro-frontends = microservices for the browser** — Frontend is also independently deployed per feature domain using Webpack 5 Module Federation
6. **GitOps by default** — All Kubernetes changes go through Git → Argo CD, never `kubectl apply` by hand in production

---

## 🚀 Getting Started

```bash
# 1. Clone the repository
git clone https://github.com/FoushWare/request-journey-client-to-server.git
cd request-journey-client-to-server

# 2. Browse the tasks
ls tasks/

# 3. Start with app foundation phase 1 (recommended first phase)
cat tasks/app-foundation/task-001-run-notes-app-with-mock-server.md

# 4. For local cloud dev (AWS services without real AWS)
docker-compose up localstack

# 5. For the full IaC stack
cd automation/terraform
terraform init && terraform plan
```

---

*This project is a living curriculum — new issues are continuously added as GitHub issues and converted into learning tasks. Track progress in `issues/ISSUE_TRACKER.md`.*
