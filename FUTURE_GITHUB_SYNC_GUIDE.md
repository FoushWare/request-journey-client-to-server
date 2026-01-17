# Future GitHub Sync Guide

This guide documents how to keep the project synchronized with GitHub issues in the future.

## Quick Sync Process

### Step 1: Fetch All GitHub Issues

```bash
# Fetch all issues from GitHub repository
gh issue list --repo FoushWare/request-journey-client-to-server --limit 500 \
  --json number,title,state,labels,createdAt,updatedAt,body > /tmp/github_issues.json

# View the JSON to identify new issues
cat /tmp/github_issues.json | jq '.[].number' | sort -n
```

### Step 2: Identify New Issues

Compare GitHub issue numbers with local files:

```bash
# Get GitHub issue numbers
gh issue list --repo FoushWare/request-journey-client-to-server --limit 500 \
  --json number | jq '.[].number' | sort -n > /tmp/github_issues_numbers.txt

# Get local issue numbers
ls issues/issue-*.md | sed 's/.*issue-//;s/.md$//' | sort -n > /tmp/local_issues_numbers.txt

# Find missing issues (issues in GitHub but not locally)
comm -23 /tmp/github_issues_numbers.txt /tmp/local_issues_numbers.txt
```

### Step 3: Create New Issue Files

For each new issue number (e.g., #150), create a file:

```bash
# Create from GitHub data
gh issue view <ISSUE_NUMBER> --repo FoushWare/request-journey-client-to-server \
  --json number,title,state,labels,createdAt,updatedAt,body --template \
  '```markdown
# Issue #{{.number}}: {{.title}}

**State:** {{.state}}  
**Created:** {{.createdAt}}  
**Updated:** {{.updatedAt}}  
**URL:** https://github.com/FoushWare/request-journey-client-to-server/issues/{{.number}}

**Labels:** {{.labels | join(", ")}}

---

{{.body}}

```' > issues/issue-<ISSUE_NUMBER>.md
```

### Step 4: Categorize and Organize

1. **Identify Category:** Review issue labels and content
2. **Update Tasks:** Add references to relevant task directories in `/tasks/`
3. **Extract Specs:** Add specifications to `/spec-kit/` categories
4. **Update Docs:** Update task counts in `docs/IMPLEMENTATION_STATUS.md`

### Step 5: Document Changes

Update this file and sync summary with:
- New issue count
- New categories (if any)
- Changes to existing structure

---

## Categorization Guide

### How to Categorize Issues

Review issue content and assign to one or more categories:

- **🔵 Networking** (#1-10, #121-131): OSI model, DNS, load balancing, gRPC, HTTP
- **🟢 Backend** (#11-20): Node.js, Express, routing, databases, authentication
- **🟡 Frontend** (#21-30): React, Next.js, state management, UI components
- **🔴 Docker** (#31-40): Containerization, Docker Compose, logging
- **🟣 Kubernetes** (#41-50, #133, #138): Orchestration, deployments, services
- **🟠 CI/CD** (#51-60): Jenkins, GitHub Actions, automation
- **⚫ Security** (#61-70): JWT, TLS, RBAC, rate limiting, validation
- **🟤 Logging** (#71-80): ELK Stack, Filebeat, Kibana, dashboards
- **⚪ NGINX** (#81-90): Reverse proxy, load balancing, caching
- **🔵 Ansible** (#91-100): Automation, playbooks, configuration
- **🟢 AWS** (#101-110, #145-147): EC2, S3, RDS, Lambda, CloudWatch
- **🟡 Integration** (#111-120): Full-stack connectivity, end-to-end testing
- **🟣 Advanced Networking** (#121-131): Service discovery, gRPC, CORS
- **🟠 Advanced Topics** (#134-149): Microservices, GitOps, Istio, Helm

---

## Spec-Kit Population Guide

When extracting specifications to `spec-kit/`:

### API Specs (`spec-kit/api-specs/`)
- OpenAPI/Swagger definitions from API issues
- gRPC `.proto` files from messaging issues
- REST contracts and request/response schemas

### Architecture (`spec-kit/architecture/`)
- Mermaid diagrams showing system flow
- ADRs (Architectural Decision Records) for major decisions
- Design pattern documentation (Saga, Circuit Breaker, etc.)

### Database Schemas (`spec-kit/database-schemas/`)
- SQL table definitions
- MongoDB collection structures
- Schema migration scripts

### Security (`spec-kit/security-specs/`)
- JWT/OAuth configurations
- RBAC policy definitions
- mTLS certificates and configs

### Deployment (`spec-kit/deployment-specs/`)
- Kubernetes manifests (Deployments, Services, ConfigMaps)
- Helm chart templates
- Terraform AWS configurations
- Ansible playbooks

### Observability (`spec-kit/observability-specs/`)
- Prometheus metric definitions
- Grafana dashboard configurations
- Jaeger tracing setup
- ELK Stack configurations

---

## Automation Script

Consider creating a script to automate sync:

```bash
#!/bin/bash
# sync-github-issues.sh

REPO="FoushWare/request-journey-client-to-server"
ISSUES_DIR="issues"

echo "🔄 Syncing GitHub issues..."

# Fetch all issues
gh issue list --repo $REPO --limit 500 \
  --json number,title,state,labels,createdAt,updatedAt,body > /tmp/github_issues.json

# For each issue, create local file if missing
jq '.[] | .number' /tmp/github_issues.json | while read -r issue_num; do
  issue_file="$ISSUES_DIR/issue-$issue_num.md"
  
  if [ ! -f "$issue_file" ]; then
    echo "✅ Creating issue-$issue_num.md"
    # Generate file content from GitHub data
    # (Implementation details omitted for brevity)
  fi
done

echo "✅ Sync complete!"
```

---

## Troubleshooting

### Issue: GitHub CLI Not Authenticated
```bash
gh auth login
# Follow prompts to authenticate
```

### Issue: Too Many Issues to Fetch
Use pagination:
```bash
for page in 1 2 3; do
  gh issue list --repo FoushWare/request-journey-client-to-server \
    --page $page --limit 100 ...
done
```

### Issue: Issue File Already Exists
Check if content is outdated and update:
```bash
# Compare with GitHub version
gh issue view <NUMBER> --repo FoushWare/request-journey-client-to-server --body
```

---

## Timeline

| Date | Action | Status |
|------|--------|--------|
| Jan 17, 2026 | Initial sync (149 issues) | ✅ Complete |
| Jan 17, 2026 | Created spec-kit structure | ✅ Complete |
| Future | Sync new issues as they're created | ⏳ Pending |
| Future | Populate spec-kit with actual specs | ⏳ Pending |

---

## References

- [GitHub CLI Documentation](https://cli.github.com/)
- [jq Manual (JSON processor)](https://stedolan.github.io/jq/)
- [OpenAPI Specification](https://spec.openapis.org/)
- [Kubernetes API Reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

---

Last updated: January 17, 2026
