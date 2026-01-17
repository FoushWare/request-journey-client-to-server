# Spec-Kit Integration Guide

**Date:** January 17, 2026  
**Integration:** GitHub Spec-Kit (Spec-Driven Development Framework)

## What is Spec-Kit?

[GitHub's spec-kit](https://github.com/github/spec-kit) is an open-source toolkit for **Spec-Driven Development** - a methodology where specifications are executable and directly generate working implementations.

### Key Concepts

- **Spec-Driven Development:** Focus on "what" and "why" before "how"
- **AI-Native:** Integrates with AI coding assistants (Claude, Copilot, Cursor, etc.)
- **Process-Oriented:** Multi-step refinement: Constitution → Specify → Plan → Tasks → Implement
- **Technology Independent:** Works with any tech stack

---

## Installation

### Option 1: Using uv (Recommended)

```bash
# Install uv first (if not already installed)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install specify CLI
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

# Verify installation
specify check
```

### Option 2: Using pip

```bash
pip3 install --upgrade pip
pip install git+https://github.com/github/spec-kit.git

# Verify installation
specify --version
```

### Option 3: Clone Repository

```bash
git clone https://github.com/github/spec-kit.git
cd spec-kit
# Follow CONTRIBUTING.md for development setup
```

---

## Spec-Kit Workflow for Request-Journey Project

### Step 1: Create Project Constitution

Define governing principles for the Notes App project:

```bash
specify init . --ai claude --here --force
```

Then in your AI assistant, use:

```
/speckit.constitution

Create principles focused on:
- Code quality and testing standards
- Full-stack DevOps learning outcomes
- Microservices-ready architecture
- Security best practices
- Observability by default
- Zero-downtime deployments
```

### Step 2: Create Specifications

Define what you want to build:

```
/speckit.specify

Build a secure Notes application that:
- Supports user authentication and RBAC
- Stores notes in a database
- Provides REST and gRPC APIs
- Logs to centralized ELK stack
- Deploys via Kubernetes with GitOps
- Monitors with Prometheus/Grafana
- Implements distributed tracing
```

### Step 3: Create Technical Plan

Define architecture and tech choices:

```
/speckit.plan

Tech Stack:
- Frontend: Next.js + React + Tailwind CSS
- Backend: Node.js + Express + TypeScript
- Databases: PostgreSQL + Redis
- Container: Docker + Docker Compose
- Orchestration: Kubernetes + Helm
- CI/CD: GitHub Actions + Flux CD
- Monitoring: Prometheus + Grafana + Jaeger
- Logging: ELK Stack + Filebeat
- Cloud: AWS (EC2, S3, RDS, Lambda)
- IaC: Terraform + Ansible
```

### Step 4: Break Down into Tasks

Generate actionable tasks:

```
/speckit.tasks
```

This will create task files mapped to your 149 GitHub issues.

### Step 5: Implement Features

Execute implementation:

```
/speckit.implement
```

---

## Integration with Existing Project

### Map Spec-Kit to Your Structure

```
request-journey-client-to-server/
├── spec-kit/                    # Your existing spec-kit
│   ├── api-specs/              # Generated from /speckit.specify
│   ├── architecture/            # Generated from /speckit.plan
│   ├── database-schemas/        # Generated schemas
│   ├── security-specs/          # Security from constitution
│   ├── deployment-specs/        # Deployment templates
│   └── observability-specs/     # Monitoring specs
│
├── .speckit/                    # Spec-Kit project files (NEW)
│   ├── constitution.md          # Project principles
│   ├── spec.md                  # Requirements
│   ├── plan.md                  # Technical plan
│   └── tasks/                   # Generated task list
│
├── issues/                      # GitHub issues (#1-149)
├── tasks/                       # Learning tasks
├── implementation/              # Code implementations
└── ...
```

### Syncing Workflow

1. **Create new feature requirement** → `/speckit.specify`
2. **Technical planning** → `/speckit.plan`
3. **Generate tasks** → `/speckit.tasks`
4. **Create GitHub issues** from tasks
5. **Update local issues** with new GitHub issue numbers
6. **Update spec-kit** with specifications from implementation

---

## Supported AI Agents

Works seamlessly with:

| Agent | Support | Notes |
|-------|---------|-------|
| Claude (Code) | ✅ Full | Recommended for this project |
| GitHub Copilot | ✅ Full | Enterprise option |
| Cursor | ✅ Full | Excellent IDE integration |
| Windsurf | ✅ Full | Good alternative |
| Amazon Q Developer | ⚠️ Partial | Limited slash command support |
| Gemini | ✅ Full | Google's offering |
| Qwen Code | ✅ Full | Alibaba's offering |
| IBM Bob | ✅ Full | IDE-based |
| Amp | ✅ Full | Multi-AI support |

### Recommended Setup

For this project, use **Claude Code** or **Cursor** with Spec-Kit:

```bash
# With Claude
specify init . --ai claude --here --force

# With Cursor
specify init . --ai cursor-agent --here --force
```

---

## Available Slash Commands

After initialization, use these commands in your AI assistant:

### Core Commands

| Command | Purpose |
|---------|---------|
| `/speckit.constitution` | Define project principles |
| `/speckit.specify` | Write requirements/user stories |
| `/speckit.plan` | Technical implementation plan |
| `/speckit.tasks` | Generate task breakdown |
| `/speckit.implement` | Execute all tasks |

### Optional Commands

| Command | Purpose |
|---------|---------|
| `/speckit.clarify` | Clarify underspecified areas |
| `/speckit.analyze` | Check artifact consistency |
| `/speckit.checklist` | Generate quality checklists |

---

## Example: Using Spec-Kit for Microservices Feature

### 1. Constitution

```
/speckit.constitution

Microservices Architecture Principles:
- Each service owns its database
- Services communicate via gRPC/REST
- All services emit structured logs
- Distributed tracing on all requests
- RBAC enforced at service level
- Circuit breakers for resilience
- Health checks mandatory
```

### 2. Specify

```
/speckit.specify

Refactor monolithic Notes App into microservices:
- Auth Service (user credentials, JWT)
- Notes Service (CRUD operations)
- User Service (profiles, settings)
- Notification Service (emails, alerts)

Each service:
- Has independent database
- Exposes REST + gRPC endpoints
- Sends structured JSON logs
- Includes health checks
- Implements distributed tracing
```

### 3. Plan

```
/speckit.plan

Microservices Tech Stack:
- gRPC for service-to-service communication
- Protocol Buffers for contracts
- Kubernetes for orchestration
- Helm for deployments
- Istio for service mesh
- ELK for centralized logging
- Prometheus for metrics
- Jaeger for distributed tracing
```

### 4. Tasks

```
/speckit.tasks
```

Generates tasks like:
- Define service boundaries
- Create Proto files
- Implement Auth Service
- Implement Notes Service
- Deploy with Kubernetes
- Setup service mesh
- Configure observability

### 5. Implement

```
/speckit.implement
```

Executes all tasks with code generation.

---

## Environment Variables

When working outside of Git branches:

```bash
export SPECIFY_FEATURE="001-microservices-refactor"
```

This tells Spec-Kit which feature directory to work on.

---

## Troubleshooting

### Issue: `specify` command not found

```bash
# Option 1: Ensure uv installation completed
uv tool list | grep specify

# Option 2: Upgrade
uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git

# Option 3: Use full path
~/.local/bin/specify init
```

### Issue: Git authentication fails on Linux

```bash
# Install Git Credential Manager
wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.1/gcm-linux_amd64.2.6.1.deb
sudo dpkg -i gcm-linux_amd64.2.6.1.deb
git config --global credential.helper manager
```

### Issue: AI agent slash commands not recognized

Ensure:
1. You've run `specify init` in the project root
2. AI agent supports Spec-Kit (check support table above)
3. `.speckit` directory exists with configuration

---

## Recommended Next Steps

1. **Install Spec-Kit CLI**
   ```bash
   uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
   ```

2. **Initialize Project**
   ```bash
   cd request-journey-client-to-server
   specify init . --ai claude --here --force
   ```

3. **Create Constitution**
   - Use `/speckit.constitution` to define project principles

4. **Specify Requirements**
   - Use `/speckit.specify` to detail what you're building

5. **Plan Implementation**
   - Use `/speckit.plan` to define tech stack and architecture

6. **Generate Tasks**
   - Use `/speckit.tasks` to create action items

7. **Update Spec-Kit** (this repository)
   - Add specifications to `spec-kit/` directories
   - Create GitHub issues from generated tasks
   - Map tasks to existing issues #1-149

---

## Resources

- **Official Docs:** https://github.github.io/spec-kit/
- **GitHub Repository:** https://github.com/github/spec-kit
- **Video Overview:** https://www.youtube.com/watch?v=a9eR1xsfvHg
- **Spec-Driven Methodology:** https://github.com/github/spec-kit/blob/main/spec-driven.md
- **Upgrade Guide:** https://github.com/github/spec-kit/blob/main/docs/upgrade.md

---

## License

Spec-Kit is licensed under MIT (same as Request-Journey project).

---

**Last Updated:** January 17, 2026
