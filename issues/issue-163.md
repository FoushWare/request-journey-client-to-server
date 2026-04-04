# Issue #163: Make CI/CD Workflows Gate Each Other (CI Must Pass Before CD Deploys)

**State:** Open  
**Created:** 2026-03-30T11:24:53Z  
**Updated:** 2026-03-30T11:24:53Z  
**URL:** https://github.com/FoushWare/request-journey-client-to-server/issues/163

**Labels:** None

---

## Description

Currently CI (build, test, security scan) and CD (deploy) workflows may run independently or the deployment may proceed even if quality checks fail. This issue enforces **proper pipeline gating**: the CD workflow (deployment) must only trigger after all CI checks pass — tests must be green, security checks must pass, code quality gates must be satisfied — before any deployment occurs.

This is the real-world pattern used by mature engineering teams: **CI is the gate, CD is the reward**.

---

## Why This Matters

In most production environments, deployments that bypass failing tests or security checks cause:
- Broken production environments
- Security vulnerabilities shipped to users
- Increased rollback overhead and on-call incidents

GitHub Actions supports workflow dependencies via `workflow_run` trigger and job-level `needs:` chains. Using these mechanisms:
- CD workflows can be configured to only trigger on successful CI runs
- Multi-job pipelines can enforce sequential gating at every stage
- Failed security or test jobs block the pipeline completely

This pattern mirrors the "shift-left" DevSecOps philosophy: validate early and often, and never let a broken build move forward.

---

## Key Concepts

### CI/CD Pipeline Gating
- **CI (Continuous Integration)**: Builds, runs tests, lints, security scans — validates code correctness
- **CD (Continuous Delivery/Deployment)**: Packages, pushes images, deploys to staging/prod — only runs after CI passes
- **Gate**: A condition that must be satisfied before the pipeline continues

### GitHub Actions Dependency Mechanisms
- **`needs:`**: A job-level directive that declares which jobs must succeed before this one starts
- **`workflow_run`**: A trigger that starts a workflow only when another named workflow completes (with optional status filter: `completed` + `conclusion: success`)
- **Status Checks**: GitHub branch protection rules can enforce that specific CI workflows pass before merges are allowed

### Quality Gates
- Tests green (unit, integration, e2e)
- Security scan clean (SAST via SonarQube, dependency audit)
- Linting passing
- Docker image builds successfully

### Environment-Based Progression
- Code passes CI → deploy to **staging**
- Staging smoke tests pass → promote to **production**
- Any failure at any stage → pipeline halts, team notified

---

## Learning Objectives

- [ ] Understand the difference between CI and CD and why they must be sequenced
- [ ] Use `needs:` to chain jobs within a single GitHub Actions workflow
- [ ] Use `workflow_run` trigger to chain separate workflows
- [ ] Configure status checks and branch protection to enforce CI gates
- [ ] Implement environment-based deployment progression (staging → production)
- [ ] Add Slack/email notifications on pipeline failure
- [ ] Test the gate by intentionally failing a test and verifying CD does not run

---

## Tasks to Create

- `tasks/ci-cd/task-014-pipeline-gating-ci-before-cd.md`

---

## Notes App Integration

The Notes App currently has separate CI and CD workflows. This issue wires them together:
1. **CI workflow** runs on every push/PR: install → lint → test → security scan → build image
2. **CD workflow** is triggered by `workflow_run` on successful CI: push image to ECR → deploy to K8s staging → run smoke tests → (manual approval gate) → deploy to production
3. A failed unit test or a critical SonarQube finding blocks the image from being pushed and deployed
