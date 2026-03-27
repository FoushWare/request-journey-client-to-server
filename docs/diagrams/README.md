# 📐 Architecture Diagrams

> All diagrams use **Mermaid** and render natively on GitHub.  
> Open any file and GitHub will render the diagrams automatically.

---

## Diagram Index

| File | What It Shows | Related Issues |
|------|--------------|---------------|
| [00-big-picture.md](./00-big-picture.md) | Full project — all systems connected, learning journey map | All |
| [01-request-journey.md](./01-request-journey.md) | Full HTTP request lifecycle: client → DB → response | #121–131 |
| [02-microservices-architecture.md](./02-microservices-architecture.md) | Service map, communication patterns, auth flow | #134–136, #152 |
| [03-cicd-pipeline.md](./03-cicd-pipeline.md) | GitHub Actions CI, Argo CD CD, branching strategy | #51–60, #140–142 |
| [04-observability-stack.md](./04-observability-stack.md) | Prometheus + Grafana, ELK, Jaeger tracing | #71–80 |
| [05-database-topology.md](./05-database-topology.md) | Database per service, scaling patterns, CAP theorem | #153 |
| [06-kafka-messaging.md](./06-kafka-messaging.md) | Topics, consumer groups, DLQ, partitioning | #156, #157 |
| [07-kubernetes-architecture.md](./07-kubernetes-architecture.md) | EKS cluster layout, HPA, GitOps, network policies | #41–50, #132–133 |
| [08-security-model.md](./08-security-model.md) | Security layers, JWT flow, Vault, OWASP mitigations | #61–70, #155 |
| [09-distributed-systems.md](./09-distributed-systems.md) | Raft, ZooKeeper, Restate, Saga pattern | #150, #151, #158 |
| [10-aws-infrastructure.md](./10-aws-infrastructure.md) | VPC layout, IAM, Terraform modules, full AWS topology | #101–110, #148 |

---

## How to View Diagrams

### On GitHub
Just open any `.md` file — GitHub renders Mermaid automatically.

### Locally
Use VS Code with the **Mermaid Preview** extension:
```bash
code --install-extension bierner.markdown-mermaid
```

### Export to Image (PNG/SVG)
```bash
# Install mermaid CLI
npm install -g @mermaid-js/mermaid-cli

# Export a diagram
mmdc -i docs/diagrams/00-big-picture.md -o docs/diagrams/00-big-picture.svg
```

---

## How to Contribute a Diagram

1. Create a new `.md` file in this directory
2. Use Mermaid syntax inside a ` ```mermaid ` code block
3. Add an entry to the table above
4. For complex diagrams, use subgraphs to group related components

### Mermaid Diagram Types Used

| Type | Syntax | Use For |
|------|--------|---------|
| Flowchart | `graph TB` or `graph LR` | Architecture, component relationships |
| Sequence | `sequenceDiagram` | Request flows, protocols, step-by-step |
| GitGraph | `gitGraph` | Branching strategies |
| Mindmap | `mindmap` | Concept trees |
| Gantt | `gantt` | Timelines, latency budgets |
