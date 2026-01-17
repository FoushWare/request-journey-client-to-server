# Deployment Specifications

Contains deployment manifests for Kubernetes, Helm charts, GitOps configurations, and Infrastructure as Code.

## Organization

- **helm/** - Helm charts for application deployments
- **gitops/** - Flux CD and Argo CD configurations
- **kubernetes/** - Raw Kubernetes manifests
- **terraform/** - AWS infrastructure as code
- **ansible/** - Configuration management playbooks

## Deployment Strategies

### Kubernetes
- Deployments for stateless services
- StatefulSets for stateful services
- ConfigMaps and Secrets for configuration
- Persistent Volumes for data storage

### Helm
- Templated manifests for environment configuration
- Multi-environment values files (dev, staging, prod)
- Chart versioning and releases

### GitOps
- Flux CD for declarative GitOps
- Argo CD for multi-cluster deployments
- Git-as-source-of-truth principle

### Infrastructure
- AWS VPC and networking
- EC2 instances and auto-scaling groups
- RDS for managed databases
- S3 for object storage

## Deployment Workflow

1. Code changes → Git commit
2. CI pipeline → Docker image build & push
3. GitOps tool → Kubernetes deployment
4. Observability → Monitoring and logging

---

See parent [README.md](../README.md) for project overview.
