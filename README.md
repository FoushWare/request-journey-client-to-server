# 🚀 Full-Stack DevOps Learning Project

> **🌱 Now with [GitHub Spec-Kit](https://github.com/github/spec-kit) Integration!**  
> Use Spec-Driven Development for structured, AI-assisted implementation. See [SPEC_KIT_INTEGRATION.md](SPEC_KIT_INTEGRATION.md) for details.

## Overview 🌟

This project is a comprehensive, step-by-step learning initiative designed to take you through the **entire lifecycle of a modern web application** — from handling a simple client request to building a fully automated, monitored, secure, cloud-ready deployment.

### 📝 Application Functionality

The core project is a simple **Notes App** with:

- ✅ User account creation  
- ✅ User login  
- ✅ Create notes  
- ✅ View notes  
- ✅ Logout functionality  

This simple foundation allows you to progressively integrate concepts across:

- Full-stack development  
- Networking  
- DevOps engineering  
- CI/CD automation  
- Containerization  
- Cloud architecture  
- Logging & observability  
- Security best practices  

---

## 🗺️ Roadmap / Phases

The learning journey is divided into **8 progressive phases**, each building on the previous:

### **1. Frontend & Backend**
- Build the Notes App frontend (React/Next.js)
- Implement REST API backend (Node.js/Express)
- Add authentication using JWT

### **2. Databases**
- Add persistence using PostgreSQL or MongoDB
- Migrate to AWS RDS for cloud database practice

### **3. Networking & Servers**
- Configure NGINX as a reverse proxy
- Add load balancing (round-robin)
- Configure HTTPS with Let's Encrypt SSL/TLS

### **4. DevOps & CI/CD**
- Containerize frontend & backend using Docker
- Build pipelines using Jenkins / GitHub Actions
- Automate server provisioning using Ansible

### **5. Logging & Monitoring**
- Integrate ELK Stack (Elasticsearch, Logstash, Kibana)
- Use Filebeat or Fluent Bit for log shipping
- Add Prometheus for metrics collection
- Add Grafana dashboards for visualization & alerting

### **6. Security**
- Improve JWT with refresh tokens
- Add 2FA authentication
- Configure a Web Application Firewall (WAF)
- Apply secure headers & rate limiting

### **7. Cloud & AWS**
- Deploy backend/frontend to EC2
- Serve static assets via S3 + CloudFront CDN
- Host database in RDS
- Create serverless functions using Lambda

### **8. Full Integration & QA**
- Connect all components into a single architecture
- Perform end-to-end testing
- Implement load testing & performance analysis
- Finalize documentation and project diagrams

---

## 🛠️ Tech Stack

| Layer | Tech / Tool | Description |
|------|-------------|-------------|
| **Frontend** | React, Next.js, Tailwind CSS | Modern reactive UI for app functionality |
| **Backend** | Node.js, Express, JWT | REST API server with authentication |
| **Database** | PostgreSQL / MongoDB, AWS RDS | Persistent local & cloud storage |
| **Reverse Proxy** | NGINX | Load balancing & HTTPS offloading |
| **Containerization** | Docker | Packaged services for portability |
| **Orchestration** | Kubernetes | Automated scaling & deployment |
| **Automation** | Ansible | Server provisioning & configuration |
| **CI/CD** | Jenkins, GitHub Actions | Automated build/test/deploy pipelines |
| **Logging** | ELK Stack, Filebeat, Fluent Bit | Centralized log aggregation |
| **Monitoring** | Prometheus, Grafana | Metrics dashboards & alerting |
| **Cloud** | AWS (EC2, S3, RDS, Lambda) | Cloud hosting & serverless compute |

---

## 📁 Folder Structure

Below is the project structure:

```
request-journey-client-to-server/
│
├── frontend/ # React / Next.js Notes App
│ ├── pages/
│ ├── components/
│ ├── public/
│ └── ...
│
├── backend/ # Node.js + Express API
│ ├── src/
│ ├── routes/
│ ├── controllers/
│ ├── services/
│ └── ...
│
├── issues/ # GitHub Issues (149 issues)
│ ├── issue-1.md through issue-149.md
│ └── ...
│
├── spec-kit/ # ⭐ Specifications Repository (NEW)
│ ├── api-specs/ # API contracts and specifications
│ ├── architecture/ # Architecture diagrams and ADRs
│ ├── database-schemas/ # Database schema definitions
│ ├── security-specs/ # Security configurations
│ ├── deployment-specs/ # Kubernetes, Helm, Terraform
│ ├── observability-specs/ # Monitoring, logging, tracing
│ └── README.md
│
├── implementation/ # Code implementations for tasks
│ ├── docker/
│ ├── kubernetes/
│ ├── ci-cd/
│ ├── aws/
│ └── ...
│
├── tasks/ # Learning tasks organized by category
│ ├── docker/
│ ├── kubernetes/
│ ├── ci-cd/
│ ├── security/
│ ├── logging/
│ ├── nginx/
│ ├── ansible/
│ ├── aws/
│ └── ...
│
├── capsule-projects/ # Example projects
│ ├── api-gateway/
│ ├── blog-platform/
│ ├── e-commerce-app/
│ ├── realtime-chat/
│ └── todo-project-management/
│
├── docs/ # Documentation
│ ├── LEARNING_PATH.md
│ ├── IMPLEMENTATION_STATUS.md
│ └── ...
│
├── plans/ # Planning documents
│ ├── 01-devops-learning-path-plan.md
│ ├── 02-enhanced-plan-terraform-vault-implementation.md
│ └── ...
│
├── scripts/ # Automation scripts
│ └── process-new-issues.sh
│
└── README.md # This file

```

---

## 🔄 Development Workflow

This project uses a professional **Git Flow** branching strategy with automated GitHub issue synchronization.

### Quick Start

```bash
# 1. Sync GitHub issues to local files
./sync-github-issues.sh

# 2. Generate tasks, plans, and documentation from issues
./create-from-issues.sh all

# 3. Create a feature branch from develop
git checkout develop
git pull origin develop
git checkout -b feature/issue-123-description

# 4. Implement the feature and commit
git add .
git commit -m "feat: implement feature as per issue #123"
git push origin feature/issue-123-description

# 5. Create PR and merge after review
```

### Key Documents

- **[GITFLOW_STRATEGY.md](GITFLOW_STRATEGY.md)** - Branching strategy & conventions
- **[WORKFLOW_GUIDE.md](WORKFLOW_GUIDE.md)** - Step-by-step workflow guide
- **[SETUP_COMPLETE.md](SETUP_COMPLETE.md)** - Setup summary & quick reference
- **[SCRIPT_USAGE_EXAMPLES.md](SCRIPT_USAGE_EXAMPLES.md)** - Script examples & automation
- **[VERIFICATION_CHECKLIST.md](VERIFICATION_CHECKLIST.md)** - Setup verification

### Branch Structure

```
master (production) ← release branches ← develop ← feature branches
```

- **`master`** - Production-ready code only
- **`develop`** - Integration branch for features
- **`feature/*`** - Feature development (from develop)
- **`release/*`** - Release preparation (from develop to master)
- **`hotfix/*`** - Emergency fixes (from master)

### Automation Scripts

1. **`sync-github-issues.sh`**
   - Syncs all GitHub issues to `issues/` folder
   - Creates markdown files for each issue
   - Generates sync summary

2. **`create-from-issues.sh`**
   - Generates tasks from issues → `tasks/`
   - Generates implementation plans → `plans/`
   - Generates technical documentation → `docs/`

### Workflow: Issue → Implementation

1. **Sync** - `./sync-github-issues.sh`
2. **Generate** - `./create-from-issues.sh all`
3. **Branch** - `git checkout -b feature/issue-XXX`
4. **Implement** - Follow generated task checklist
5. **Commit** - Use semantic messages: `feat:`, `fix:`, `docs:`
6. **Review** - Create PR, get approval
7. **Merge** - Merge to develop, tag release when ready

### GitHub Token Setup (Recommended)

For higher API rate limits:

```bash
export GITHUB_TOKEN=ghp_your_token_here
./sync-github-issues.sh
```

Get token: GitHub Settings → Developer settings → Personal access tokens  
Scopes needed: `repo`, `read:user`

---


