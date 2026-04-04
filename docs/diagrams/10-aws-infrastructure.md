# ☁️ AWS Infrastructure — Production Architecture

> Full AWS topology for the Notes App — VPC, EKS, RDS, S3, CloudFront, and more.

---

## AWS Architecture Overview

```mermaid
graph TB
    subgraph Internet["🌐 Internet"]
        Users["Users Worldwide"]
    end

    subgraph AWS_Global["AWS Global Services"]
        Route53["Route 53<br/>(DNS: notes-app.com)"]
        CloudFront["CloudFront CDN<br/>(Static assets + API cache)"]
        WAF["AWS WAF<br/>(Web Application Firewall)"]
        Shield["AWS Shield Standard<br/>(DDoS protection)"]
    end

    subgraph Region["AWS Region: us-east-1"]
        subgraph VPC["VPC: 10.0.0.0/16"]
            subgraph PublicSubnets["Public Subnets (AZ-a, AZ-b, AZ-c)"]
                IGW["Internet Gateway"]
                NATGw["NAT Gateway (HA)"]
                ALB["Application Load Balancer<br/>(HTTPS :443)"]
            end

            subgraph PrivateSubnets_App["Private Subnets — App Tier"]
                EKS_Nodes["EKS Worker Nodes<br/>(m5.xlarge × 6)
                Namespace: notes-app"]
            end

            subgraph PrivateSubnets_Data["Private Subnets — Data Tier"]
                RDS_Primary["RDS PostgreSQL<br/>(Multi-AZ, db.r6g.large)"]
                RDS_Replica["RDS Read Replica<br/>(db.r6g.large)"]
                ElastiCache["ElastiCache Redis<br/>(Cluster Mode, 3 shards)"]
                DocDB["DocumentDB<br/>(MongoDB compatible, 3 nodes)"]
            end
        end

        subgraph EKS_Control["EKS Control Plane"]
            EKS_API["EKS API Server<br/>(AWS Managed)"]
        end

        subgraph Storage["Storage"]
            S3_Uploads["S3: notes-uploads<br/>(user files, versioned)"]
            S3_Assets["S3: notes-assets<br/>(static: JS, CSS, images)"]
            S3_Backups["S3: notes-backups<br/>(DB backups, 90d retention)"]
            ECR["ECR<br/>(Container Registry)"]
        end

        subgraph Security_Services["Security & Identity"]
            IAM["IAM<br/>(Roles, OIDC for EKS)"]
            SecretsManager["Secrets Manager<br/>(DB passwords, API keys)"]
            KMS["KMS<br/>(Encryption keys)"]
            ACM["ACM<br/>(TLS Certificates)"]
        end

        subgraph Observability_AWS["Observability"]
            CloudWatch["CloudWatch<br/>(Logs + Metrics)"]
            CloudTrail["CloudTrail<br/>(API audit log)"]
            XRay["X-Ray<br/>(Distributed tracing)"]
        end
    end

    Users --> Route53
    Route53 --> CloudFront
    CloudFront --> WAF
    WAF --> ALB
    ALB --> EKS_Nodes

    EKS_Nodes --> RDS_Primary
    EKS_Nodes --> ElastiCache
    EKS_Nodes --> DocDB
    EKS_Nodes --> S3_Uploads

    RDS_Primary --> RDS_Replica

    S3_Assets --> CloudFront

    EKS_Nodes --> SecretsManager
    EKS_Nodes --> CloudWatch

    style Internet fill:#e3f2fd
    style AWS_Global fill:#fff3e0
    style Region fill:#f5f5f5
    style PublicSubnets fill:#e8f5e9
    style PrivateSubnets_App fill:#e8eaf6
    style PrivateSubnets_Data fill:#fce4ec
    style Storage fill:#f3e5f5
```

---

## VPC Network Topology (CIDR Design)

```mermaid
graph TB
    subgraph VPC["VPC: 10.0.0.0/16"]
        subgraph AZ_A["Availability Zone: us-east-1a"]
            PubA["Public: 10.0.1.0/24<br/>(ALB, NAT GW)"]
            AppA["Private App: 10.0.11.0/24<br/>(EKS nodes)"]
            DataA["Private Data: 10.0.21.0/24<br/>(RDS, ElastiCache)"]
        end

        subgraph AZ_B["Availability Zone: us-east-1b"]
            PubB["Public: 10.0.2.0/24"]
            AppB["Private App: 10.0.12.0/24"]
            DataB["Private Data: 10.0.22.0/24"]
        end

        subgraph AZ_C["Availability Zone: us-east-1c"]
            PubC["Public: 10.0.3.0/24"]
            AppC["Private App: 10.0.13.0/24"]
            DataC["Private Data: 10.0.23.0/24"]
        end
    end

    Note["3 AZs = High Availability
    EKS nodes spread across all 3 AZs
    RDS Multi-AZ = 2 AZs
    ElastiCache cluster = 3 AZs"]
```

---

## IAM — Least Privilege per Service

```mermaid
graph TB
    subgraph IRSA["IRSA (IAM Roles for Service Accounts)"]
        NotesSA["K8s SA: notes-service"] -->|"assume role"| NotesRole["IAM Role: notes-service-role"]
        AuthSA["K8s SA: auth-service"] -->|"assume role"| AuthRole["IAM Role: auth-service-role"]
        BackupSA["K8s SA: backup-job"] -->|"assume role"| BackupRole["IAM Role: backup-role"]
    end

    subgraph Permissions["IAM Role Permissions"]
        NotesRole --> NotesPerms["s3:GetObject s3:PutObject
        (notes-uploads bucket only)
        secretsmanager:GetSecretValue
        (notes/* secrets only)"]

        AuthRole --> AuthPerms["secretsmanager:GetSecretValue
        (auth/* secrets only)
        kms:Decrypt
        (auth encryption key only)"]

        BackupRole --> BackupPerms["s3:PutObject
        (notes-backups bucket only)
        rds:CreateSnapshot
        (notes-app-db only)"]
    end

    Note["Each service has its own IAM role.
    Principle of Least Privilege.
    No service can access another service's secrets."]
```

---

## Terraform Infrastructure — Module Structure

```mermaid
graph TB
    subgraph Root["Root Module (main.tf)"]
        Root_Call["Calls all modules"]
    end

    subgraph Modules["Terraform Modules"]
        VPC_Mod["module: vpc
        - VPC, subnets (6)
        - Internet Gateway
        - NAT Gateway (HA)
        - Route tables"]

        EKS_Mod["module: eks
        - EKS cluster
        - Node groups (3 AZs)
        - OIDC provider
        - Add-ons: CoreDNS, VPC CNI"]

        RDS_Mod["module: rds
        - RDS PostgreSQL Multi-AZ
        - Parameter group
        - Subnet group
        - Security group"]

        Cache_Mod["module: elasticache
        - Redis cluster mode
        - 3 shards × 1 replica
        - Subnet group"]

        S3_Mod["module: s3
        - 3 buckets (uploads, assets, backups)
        - Versioning
        - Lifecycle rules
        - Encryption (KMS)"]

        Security_Mod["module: security
        - IAM roles (per service)
        - Security groups
        - KMS keys
        - ACM certificates"]
    end

    Root_Call --> VPC_Mod
    Root_Call --> EKS_Mod
    Root_Call --> RDS_Mod
    Root_Call --> Cache_Mod
    Root_Call --> S3_Mod
    Root_Call --> Security_Mod

    EKS_Mod -->|"depends on"| VPC_Mod
    RDS_Mod -->|"depends on"| VPC_Mod
    Cache_Mod -->|"depends on"| VPC_Mod
```
