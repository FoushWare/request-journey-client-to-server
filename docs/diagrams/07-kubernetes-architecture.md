# ☸️ Kubernetes Architecture — Cluster Layout

> How the Notes App is deployed on Kubernetes (EKS).  
> Including namespaces, network policies, ingress, HPA, and GitOps.

---

## Cluster Architecture

```mermaid
graph TB
    subgraph EKS_Cluster["EKS Cluster (us-east-1)"]
        subgraph ControlPlane["Control Plane (AWS Managed)"]
            APIServer["kube-apiserver"]
            ETCD["etcd (cluster state)"]
            Scheduler["kube-scheduler"]
            ControllerMgr["controller-manager"]
        end

        subgraph SystemNS["Namespace: kube-system"]
            CoreDNS["CoreDNS (service discovery)"]
            CNI["AWS VPC CNI (pod networking)"]
            NodeLocal["node-local-dns"]
        end

        subgraph InfrastructureNS["Namespace: infrastructure"]
            IngressCtrl["NGINX Ingress Controller"]
            ArgoCD2["Argo CD"]
            CertManager["cert-manager (TLS)"]
            ExternalDNS["external-dns (Route 53)"]
        end

        subgraph MonitoringNS["Namespace: monitoring"]
            Prometheus2["Prometheus (StatefulSet)"]
            Grafana2["Grafana (Deployment)"]
            AlertManager2["AlertManager"]
            Jaeger2["Jaeger (Deployment)"]
        end

        subgraph LoggingNS["Namespace: logging"]
            Filebeat2["Filebeat (DaemonSet)"]
            Logstash2["Logstash (Deployment)"]
            Kibana2["Kibana (Deployment)"]
        end

        subgraph AppNS["Namespace: notes-app"]
            subgraph AuthDeploy["Auth Service"]
                AuthPod1["Pod: auth-service-1"]
                AuthPod2["Pod: auth-service-2"]
                AuthSvc_K8s["Service: auth-service<br/>(ClusterIP)"]
                AuthHPA["HPA: 2–10 replicas<br/>(CPU > 70%)"]
            end

            subgraph NotesDeploy["Notes Service"]
                NotesPod1["Pod: notes-service-1"]
                NotesPod2["Pod: notes-service-2"]
                NotesPod3["Pod: notes-service-3"]
                NotesSvc_K8s["Service: notes-service<br/>(ClusterIP)"]
                NotesHPA["HPA: 3–20 replicas<br/>(CPU > 70%)"]
            end

            subgraph EmailDeploy["Email Service"]
                EmailPod1["Pod: email-service-1"]
                EmailSvc_K8s["Service: email-service<br/>(ClusterIP)"]
            end

            Ingress["Ingress Resource<br/>(notes-app.com)"]
        end

        subgraph DataNS["Namespace: data"]
            PG_StatefulSet["PostgreSQL StatefulSet<br/>(1 primary + 2 replicas)"]
            Mongo_StatefulSet["MongoDB StatefulSet<br/>(3-node replica set)"]
            Redis_StatefulSet["Redis StatefulSet<br/>(Sentinel mode)"]
        end

        subgraph MsgNS["Namespace: messaging"]
            Kafka_StatefulSet["Kafka StatefulSet<br/>(3 brokers)"]
            ZK_StatefulSet["ZooKeeper StatefulSet<br/>(3 nodes)"]
        end
    end

    %% Control Plane connections
    APIServer --- ETCD
    APIServer --- Scheduler
    APIServer --- ControllerMgr

    %% Ingress to services
    Ingress --> AuthSvc_K8s
    Ingress --> NotesSvc_K8s

    %% Services to Pods
    AuthSvc_K8s --> AuthPod1
    AuthSvc_K8s --> AuthPod2
    NotesSvc_K8s --> NotesPod1
    NotesSvc_K8s --> NotesPod2
    NotesSvc_K8s --> NotesPod3

    style EKS_Cluster fill:#e3f2fd
    style AppNS fill:#e8f5e9
    style DataNS fill:#e8eaf6
    style MsgNS fill:#f3e5f5
    style MonitoringNS fill:#fff3e0
```

---

## Network Policies

```mermaid
graph TB
    subgraph NetPolicies["Kubernetes Network Policies"]
        subgraph Allowed["✅ Allowed Traffic"]
            A1["Ingress → Auth Service (port 8080)"]
            A2["Ingress → Notes Service (port 8080)"]
            A3["Notes Service → MongoDB (port 27017)"]
            A4["Notes Service → Redis (port 6379)"]
            A5["Auth Service → PostgreSQL (port 5432)"]
            A6["All Services → Prometheus (port 8080 scrape)"]
            A7["All Services → Kafka (port 9092)"]
        end

        subgraph Blocked["❌ Blocked Traffic"]
            B1["Internet → Database pods (direct)"]
            B2["Email Service → PostgreSQL"]
            B3["Database pods → Internet"]
            B4["Auth → MongoDB (wrong DB)"]
        end
    end

    Note["Network policies implement the
    principle of least privilege at the network level.
    Each service can only talk to what it needs."]
```

---

## Horizontal Pod Autoscaler (HPA)

```mermaid
graph TB
    subgraph HPA_Flow["HPA — Auto Scaling Flow"]
        Metrics["Metrics Server<br/>(CPU, Memory, Custom)"]
        HPA_Controller["HPA Controller<br/>(checks every 15s)"]

        subgraph Decision["Scale Decision"]
            Check["Current CPU > target?"]
            ScaleUp["Scale Up<br/>(add pods)"]
            ScaleDown["Scale Down<br/>(remove pods, 5min cooldown)"]
        end

        Deploy["Deployment<br/>(desired replicas updated)"]

        Metrics --> HPA_Controller
        HPA_Controller --> Check
        Check -->|">70%"| ScaleUp
        Check -->|"<50%"| ScaleDown
        ScaleUp --> Deploy
        ScaleDown --> Deploy
    end

    subgraph HPA_Config["Notes Service HPA Config"]
        YAML["apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: notes-service-hpa
spec:
  scaleTargetRef:
    kind: Deployment
    name: notes-service
  minReplicas: 3
  maxReplicas: 20
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80"]
    end
```

---

## GitOps Flow with Argo CD

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant AppRepo as App Repository
    participant CI as GitHub Actions (CI)
    participant ECR as Container Registry (ECR)
    participant GitOpsRepo as GitOps Repository
    participant ArgoCD as Argo CD
    participant K8s as Kubernetes

    Dev->>AppRepo: git push feature/new-notes-api
    AppRepo->>CI: Trigger CI pipeline
    CI->>CI: test → lint → security scan → build
    CI->>ECR: docker push notes-service:v1.2.3
    CI->>GitOpsRepo: Update image tag in values.yaml
    GitOpsRepo->>ArgoCD: Webhook: manifest changed
    ArgoCD->>K8s: kubectl apply (rolling update)
    K8s-->>ArgoCD: Deployment health check
    ArgoCD-->>Dev: ✅ Sync complete (Slack notification)
```
