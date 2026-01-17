# 📚 GitHub Issues ↔ Tasks Synchronization Guide

**Purpose:** Ensure all 149 GitHub issues have corresponding learning tasks  
**Status:** Implementation Guide  
**Last Updated:** January 17, 2026

---

## Overview

This guide shows how to:
1. View all newly added GitHub issues
2. Map issues to task categories
3. Create/update task files
4. Keep issues and tasks in sync

---

## Quick Reference: Issue Numbers by Category

### Frontend (Issues #21-30)
**Category:** microservices  
**Topics:** Next.js, React, components, state management

### Backend (Issues #11-20)
**Category:** microservices  
**Topics:** Express.js, APIs, authentication, database

### Networking (Issues #1-10)
**Category:** networking  
**Topics:** OSI, TCP/IP, DNS, routing, firewalls

### Docker (Issues #31-40)
**Category:** docker  
**Topics:** Images, containers, Dockerfile, Docker Compose

### Kubernetes (Issues #41-50, #121-131, #138-139)
**Category:** kubernetes, helm  
**Topics:** Pods, deployments, services, scaling, networking

### CI/CD (Issues #51-60)
**Category:** ci-cd  
**Topics:** GitHub Actions, pipelines, testing, deployment

### Security (Issues #61-70)
**Category:** security  
**Topics:** TLS, RBAC, secrets, authentication, compliance

### Logging & Monitoring (Issues #71-80)
**Category:** logging  
**Topics:** ELK, Prometheus, Grafana, Jaeger

### NGINX (Issues #81-90)
**Category:** nginx  
**Topics:** Reverse proxy, load balancing, SSL, security

### Ansible (Issues #91-100)
**Category:** ansible  
**Topics:** Playbooks, roles, automation, provisioning

### AWS (Issues #101-110, #145-147)
**Category:** aws  
**Topics:** EC2, RDS, S3, ECS, Lambda, CloudWatch

### Integration & Testing (Issues #111-120)
**Category:** integration  
**Topics:** E2E testing, integration, QA, performance

### Advanced Topics (Issues #133-149)
**Categories:** kubernetes, helm, hashicorp, gitops, service-mesh, terraform  
**Topics:** Service mesh, GitOps, Vault, HashiCorp, advanced patterns

---

## Step-by-Step: Create Task from GitHub Issue

### Step 1: Review the GitHub Issue

```bash
# Read issue content
cat /Users/a.fouad/SideProjects/Request-journey/request-journey-client-to-server/issues/issue-XX.md
```

Example Issue #31 (Docker):
```markdown
# Issue #31: Create Notes App frontend Dockerfile

**State:** Open  
**Created:** 2025-12-02T...  
**URL:** https://github.com/FoushWare/request-journey-client-to-server/issues/31

**Labels:** docker

---

## Objective
Create a Dockerfile for the frontend application.

## Tasks / Sub-Issues
- [ ] Create frontend/Dockerfile
- [ ] Install Node.js dependencies
- [ ] Build Next.js application
- [ ] Set up multi-stage build
- [ ] Test Dockerfile locally

## References
- https://docs.docker.com/language/nodejs/
```

### Step 2: Determine Task Category

Map issue number to category:
- Issue #31 → Docker category (`tasks/docker/`)
- Issue #1 → Networking category (`tasks/networking/`)
- Issue #51 → CI/CD category (`tasks/ci-cd/`)

### Step 3: Create Task File

**File naming:**
```
tasks/[category]/task-[sequence].md
```

Example for Docker:
```
tasks/docker/task-001-create-notes-app-frontend-dockerfile.md
```

### Step 4: Use Task Template

```markdown
# Task-001: Create Notes App Frontend Dockerfile

**GitHub Issue:** #31
**Issue Link:** https://github.com/FoushWare/request-journey-client-to-server/issues/31
**Category:** Docker
**Prerequisites:** Docker installed and running
**Estimated Time:** 1-2 hours
**Difficulty:** Beginner

## Learning Objectives
- [ ] Understand Docker image construction
- [ ] Learn Dockerfile syntax
- [ ] Implement multi-stage builds
- [ ] Optimize image size
- [ ] Test container locally

## Concepts & Theory

### What is a Dockerfile?
A Dockerfile is a text file containing instructions to build a Docker image...

### Multi-stage Builds
Multi-stage builds allow you to use multiple FROM statements in a single Dockerfile...

## Step-by-Step Instructions

### 1. Create Dockerfile for Frontend
```bash
cd frontend
touch Dockerfile
```

### 2. Write Dockerfile
```dockerfile
# Build stage
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci

# Production stage
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
EXPOSE 3000
CMD ["npm", "run", "dev"]
```

### 3. Build Image
```bash
docker build -t notes-app-frontend:1.0 .
```

### 4. Test Container
```bash
docker run -p 3000:3000 notes-app-frontend:1.0
```

## Verification Steps

Run these commands to verify completion:

```bash
# Check image exists
docker images | grep notes-app-frontend

# Run container
docker run -d -p 3000:3000 notes-app-frontend:1.0

# Check logs
docker logs <container-id>

# Test endpoint
curl http://localhost:3000
```

## Notes App Implementation

For the Notes App:
1. Frontend: Next.js application requiring Node.js
2. Optimize build for production deployment
3. Ensure health check endpoint
4. Use environment variables for config

## Troubleshooting

### Issue: Cannot find module
**Solution:** Run `npm ci` instead of `npm install` in Docker

### Issue: Image too large
**Solution:** Use multi-stage builds and alpine base images

### Issue: Port already in use
**Solution:** Use different port: `docker run -p 8000:3000 ...`

## Best Practices

1. Use specific Node.js version (not `latest`)
2. Implement multi-stage builds
3. Use `.dockerignore` to exclude files
4. Pin dependency versions
5. Use `npm ci` for reproducible builds
6. Order Dockerfile commands for caching

## Related Tasks

**Previous:** None (First Docker task)
**Next:** Task-002 (Backend Dockerfile)

---

## Files & Resources

- [Docker Documentation](https://docs.docker.com/)
- [Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Next.js Docker](https://nextjs.org/docs/deployment/docker)
```

---

## Workflow: Update Existing Tasks

### If Task Already Exists

```bash
# 1. Check current content
cat tasks/docker/task-001-create-notes-app-frontend-dockerfile.md

# 2. Update if needed
# - Add GitHub issue link if missing
# - Update instructions if outdated
# - Add/verify verification steps

# 3. Ensure format matches template
```

### If Task Needs Updating

Update header to include issue:
```markdown
# Task-XXX: [Title]

**GitHub Issue:** #YYY  ← Add this line
**Issue Link:** https://github.com/FoushWare/request-journey-client-to-server/issues/YYY  ← Add this
```

---

## Batch Update: Multiple Issues

### For Issues #31-40 (Docker)

1. Check existing docker tasks:
   ```bash
   ls tasks/docker/task-*.md
   ```

2. For each issue #31-40:
   - [ ] Read `issues/issue-31.md`
   - [ ] Check if task exists
   - [ ] Create if missing
   - [ ] Update to add issue reference

3. Use this mapping:
   | Issue | Task File | Title |
   |-------|-----------|-------|
   | #31 | task-001 | Frontend Dockerfile |
   | #32 | task-002 | Backend Dockerfile |
   | #33 | task-003 | Docker Compose |
   | #34 | task-004 | NGINX Container |
   | #35 | task-005 | Environment Variables |
   | #36 | task-006 | Health Checks |
   | #37 | task-007 | Docker Network |
   | #38 | task-008 | Volumes & Database |
   | #39 | task-009 | Container Logging |
   | #40 | task-010 | Docker Registry |

---

## Verification: Check Coverage

### View All Issues by Category

```bash
# See all issues
ls issues/issue-*.md | wc -l

# Count by prefix (example for Docker #31-40)
ls issues/issue-{31..40}.md | wc -l

# View specific issue
cat issues/issue-31.md | head -20
```

### Check Task Exists

```bash
# Look for task file
ls tasks/docker/task-*.md | head -5

# Search for issue reference
grep -r "Issue.*#31" tasks/

# Check if task maps to issue
grep -A2 "GitHub Issue" tasks/docker/task-001*.md
```

### Generate Coverage Report

```bash
# Count issues
ISSUES=$(find issues -name "issue-*.md" | wc -l)

# Count tasks
TASKS=$(find tasks -name "task-*.md" | wc -l)

echo "Issues: $ISSUES, Tasks: $TASKS"
```

---

## Automatic Task Generation Script

```bash
#!/bin/bash
# generate-tasks-from-issues.sh

ISSUES_DIR="issues"
TASKS_DIR="tasks"

for issue_file in $ISSUES_DIR/issue-{31..40}.md; do
    issue_num=$(basename "$issue_file" | sed 's/issue-//;s/\.md//')
    
    # Read issue
    title=$(grep "^# Issue" "$issue_file" | sed 's/.*: //')
    objective=$(grep -A2 "## Objective" "$issue_file" | tail -1)
    
    # Create task file
    task_num=$(printf "%03d" $((issue_num - 30)))
    task_file="tasks/docker/task-$task_num-$(echo "$title" | tr ' ' '-' | tr -cd '[:alnum:]-').md"
    
    cat > "$task_file" << EOF
# Task-$task_num: $title

**GitHub Issue:** #$issue_num
**Issue Link:** https://github.com/FoushWare/request-journey-client-to-server/issues/$issue_num
**Category:** docker

## Learning Objectives
- [ ] Complete GitHub issue #$issue_num

$objective

See: $issue_file for full details
EOF
    
    echo "Created: $task_file"
done
```

---

## Integration with .speckit/tasks.md

After creating/updating tasks, update the Spec-Kit tasks document:

1. Reference the mapping:
   ```markdown
   # Phase X: Category Name
   
   See: GITHUB_ISSUES_TO_TASKS_MAPPING.md for detailed issue→task mapping
   
   **Issues:** #X1-#X10  
   **Tasks:** `tasks/[category]/task-{001..010}.md`
   
   | Issue | Task | Title |
   |-------|------|-------|
   | #X1 | task-001 | Title from issue |
   ```

2. Link to real task files for detailed content

---

## Maintenance: Keep Issues & Tasks in Sync

### Weekly Checklist

- [ ] Check GitHub for new issues
- [ ] Add new issues to `issues/` directory
- [ ] Update task files if needed
- [ ] Verify issue → task mapping
- [ ] Update .speckit/tasks.md

### Monthly Checklist

- [ ] Generate coverage report
- [ ] Identify any uncovered issues
- [ ] Create missing task files
- [ ] Review task quality
- [ ] Update task timelines

---

## Useful Commands

```bash
# View newly added issues (not yet in issues/)
# (requires recent GitHub sync)

# Count all issues
find issues -name "issue-*.md" | wc -l

# List issues by number
ls issues/issue-*.md | sort -V

# Find issues without task mapping
for i in {1..149}; do
  if [ ! -f "issues/issue-$i.md" ]; then
    echo "Missing: issue-$i"
  fi
done

# Search task files
grep -r "GitHub Issue" tasks/ | grep "#31"

# Show task file structure
head -20 tasks/docker/task-001*.md
```

---

## Summary

**Current State:**
- ✅ 149 GitHub issues synced locally
- ✅ Task structure in place with multiple categories
- ⚠️ Tasks need issue linking
- ⚠️ Some categories may need coverage verification

**Next Actions:**
1. Review existing tasks and add GitHub issue references
2. Create missing task files using template
3. Verify coverage: all 149 issues should map to tasks
4. Keep issues and tasks in sync going forward

**Files:**
- [GITHUB_ISSUES_TO_TASKS_MAPPING.md](GITHUB_ISSUES_TO_TASKS_MAPPING.md) - Complete mapping
- [TASK_STATUS_REPORT.md](TASK_STATUS_REPORT.md) - Status analysis
- [analyze-task-coverage.sh](analyze-task-coverage.sh) - Coverage analyzer
