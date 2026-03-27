# 📐 Diagram Standard — Notes App Architecture

> **This is a constitutional document.**  
> Every AI agent, every contributor, and every task MUST follow these standards.  
> See also: [`CONSTITUTION.md § 9`](../../CONSTITUTION.md#9-diagram-standard-constitution)

---

## ⚖️ The Rule: Diagrams Are Mandatory

The following MUST each contain at least one Mermaid diagram:

- ✅ Every task file (`tasks/**/*.md`)
- ✅ Every capsule project README (`capsule-projects/*/README.md`)
- ✅ Every issue spec (`issues/issue-*.md`)
- ✅ Every plan document (`plans/*.md`)
- ✅ Every implementation README (`implementation/**/README.md`)
- ✅ This index (`docs/diagrams/README.md`) stays current with all subsystem diagrams

---

## 📋 Standalone Diagram Index

| File | What It Shows | Related Issues / Tasks |
|------|--------------|------------------------|
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
| [11-nx-monorepo.md](./11-nx-monorepo.md) | Nx workspace layout, project graph, service boundaries | task-009 (microservices) |

> **When you add a new subsystem**, add a row to this table AND update `00-big-picture.md`.

---

## 🛠️ How to Create a Diagram

### Step 1 — Choose the right diagram type

| Content Type | Mermaid Syntax | Example Use |
|-------------|----------------|-------------|
| Architecture / components | `graph TB` or `graph LR` | Service maps, network topology |
| Request / protocol flows | `sequenceDiagram` | HTTP lifecycle, auth flow |
| Git branching strategy | `gitGraph` | CI/CD branching |
| Concept trees / learning maps | `mindmap` | Topic overviews |
| Timelines / latency budgets | `gantt` | Performance analysis |

### Step 2 — Inline diagram (inside a task or doc)

Every task MUST include this section:

```markdown
## Architecture Diagram

> Where this component fits in the overall request journey:

\`\`\`mermaid
graph TB
    Client["🌐 Client"]
    YourComponent["⚡ Your Component\n(concept being taught)"]
    Downstream["📦 Downstream System"]

    Client --> YourComponent --> Downstream
\`\`\`

**Full standalone diagram:** [docs/diagrams/NN-name.md](../../docs/diagrams/NN-name.md)
```

### Step 3 — Standalone diagram (for a whole subsystem)

Create a new file `docs/diagrams/NN-kebab-name.md`:

```markdown
# 🏷️ Subsystem Name — Notes App

> One-line description of what this diagram shows.

---

## [Diagram Title]

\`\`\`mermaid
graph TB
    subgraph subsystem["Subsystem Name"]
        ComponentA["Component A"]
        ComponentB["Component B"]
    end

    ComponentA --> ComponentB
\`\`\`

**What this shows:**
- Point 1
- Point 2

**Related tasks:** task-XXX, task-YYY  
**Related issues:** #NNN
```

Then add a row to the table in this README.

### Step 4 — Update the big picture

After adding a new subsystem, open `docs/diagrams/00-big-picture.md` and add the new component.

---

## 👁️ How to View Diagrams

### On GitHub
Open any `.md` file — GitHub renders Mermaid automatically.

### In VS Code
Install the Mermaid Preview extension:
```bash
code --install-extension bierner.markdown-mermaid
```

### Export to PNG/SVG
```bash
# Install mermaid CLI
npm install -g @mermaid-js/mermaid-cli

# Export a diagram
mmdc -i docs/diagrams/00-big-picture.md -o docs/diagrams/00-big-picture.svg
mmdc -i docs/diagrams/00-big-picture.md -o docs/diagrams/00-big-picture.png

# Export all diagrams at once
for f in docs/diagrams/*.md; do
  mmdc -i "$f" -o "${f%.md}.svg"
done
```

---

## ✅ Diagram Checklist (for every task/feature)

Before marking a task as complete, verify:

- [ ] Task file contains an inline `## Architecture Diagram` section
- [ ] Inline diagram shows where the concept sits in the request journey
- [ ] If it's a new subsystem → a standalone diagram file exists in `docs/diagrams/`
- [ ] If it's a new subsystem → `docs/diagrams/README.md` table is updated
- [ ] If it's a new subsystem → `docs/diagrams/00-big-picture.md` is updated

---

## 🤖 AI Agent Instructions

When creating or updating any task, issue, plan, or implementation document:

1. **ALWAYS** add a `## Architecture Diagram` section with a Mermaid diagram
2. **ALWAYS** show where the concept fits inside the request journey (client → ... → db → client)
3. **ALWAYS** highlight the component being taught (use `style ComponentName fill:#f96` or subgraph borders)
4. **If this is a new subsystem** → create a standalone `docs/diagrams/NN-name.md` file
5. **If this is a new subsystem** → update this README's table
6. **If this is a new subsystem** → update `00-big-picture.md`
7. **NEVER** mark a task done without a diagram
