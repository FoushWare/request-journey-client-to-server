# Phase 04 — CI/CD Pipelines

## Overview

Manual deployments are error-prone and slow. This phase automates the entire build → test → scan → push → deploy lifecycle using **GitHub Actions** and **Jenkins**. Every push to the `main` branch will automatically run lint, unit tests, a SonarQube quality gate, build a Docker image, push it to a registry, and deploy the updated image to the Kubernetes cluster — all without human intervention.

## Prerequisites

- **Phase 02 complete** — Docker images build cleanly
- **Phase 03 complete** — Kubernetes manifests deploy the Notes App successfully
- A GitHub repository for the Notes App (push access)
- Optional: a Jenkins server (can run in Docker locally)

## Learning Objectives

- Understand CI/CD principles: continuous integration, continuous delivery, pipeline stages
- Create GitHub Actions workflows for the frontend and backend
- Create a Jenkins declarative pipeline as an alternative
- Integrate code quality tools: ESLint, Prettier, Jest unit tests, Trivy security scanning
- Set up SonarQube for static code analysis with quality gates
- Build and push Docker images to a container registry (Docker Hub or AWS ECR)
- Update Kubernetes deployments automatically via `kubectl set image` or Helm values
- Configure webhook triggers from GitHub to Jenkins
- Send Slack / email notifications on pipeline success or failure
- Enforce quality gates that block merge if coverage or security checks fail

## Task Sequence

Complete the following tasks **in order**:

### Jenkins Pipelines (tasks 1–4)

1. `tasks/ci-cd/task-001-setup-jenkins-server.md`
   > Run Jenkins in Docker. Install plugins: Git, Docker Pipeline, Kubernetes, SonarQube Scanner, Slack Notification.

2. `tasks/ci-cd/task-002-create-jenkins-backend-pipeline.md`
   > Write a `Jenkinsfile` for the backend: checkout → install → lint → test → build Docker image → push to registry → deploy to K8s.

3. `tasks/ci-cd/task-003-create-jenkins-frontend-pipeline.md`
   > Write a `Jenkinsfile` for the frontend MFEs: lint → test → `nx affected:build` → push images → deploy Shell App.

4. `tasks/ci-cd/task-004-configure-github-webhook.md`
   > Configure a GitHub webhook to trigger Jenkins on every push to `main` or a pull-request open event.

### GitHub Actions (tasks 5–8)

5. `tasks/ci-cd/task-005-setup-github-actions-backend.md`
   > Create `.github/workflows/backend.yml`: lint → test → build → push Docker image to ECR.

6. `tasks/ci-cd/task-006-setup-github-actions-frontend.md`
   > Create `.github/workflows/frontend.yml`: lint → `nx affected:test` → `nx affected:build` → push MFE images.

7. `tasks/ci-cd/task-007-add-automated-testing.md`
   > Add Jest unit tests and integration tests to the pipeline. Enforce a minimum 80 % code coverage threshold. Fail the pipeline if it drops below.

8. `tasks/ci-cd/task-008-add-docker-build-and-push.md`
   > Optimise the Docker build step with layer caching (`actions/cache` for Docker BuildKit). Tag images with the Git commit SHA.

### Kubernetes Deployment Automation (tasks 9–10)

9. `tasks/ci-cd/task-009-add-kubernetes-deployment.md`
   > After the image is pushed, the pipeline updates the Kubernetes Deployment image tag (`kubectl set image` or updates `values.yaml` in the GitOps repo for Argo CD — preview of Phase 12).

10. `tasks/ci-cd/task-010-configure-notifications.md`
    > Send a Slack message or email when any pipeline stage fails or when a deployment succeeds.

### SonarQube Quality Gate (tasks 11–13)

11. `tasks/ci-cd/task-011-setup-sonarqube.md`
    > Run SonarQube in Docker. Configure it with a project token for the Notes App.

12. `tasks/ci-cd/task-012-configure-sonarqube-project.md`
    > Set up `sonar-project.properties`. Connect SonarQube to the GitHub repository for pull-request decoration.

13. `tasks/ci-cd/task-013-integrate-sonarqube-in-pipelines.md`
    > Add the SonarQube scanner step to both GitHub Actions and Jenkins pipelines. Configure a quality gate that blocks the pipeline if any Critical bugs or vulnerabilities are found.

## Pipeline Quality Gates

Every merge to `main` must pass **all** of the following gates before a deployment is triggered:

| Gate | Threshold | Action on failure |
|------|-----------|-------------------|
| Unit test coverage | ≥ 80 % | Pipeline fails |
| No critical CVEs (Trivy) | 0 critical | Pipeline fails |
| SonarQube quality gate | Pass | Pipeline fails |
| Docker image build | Success | Pipeline fails |

## Success Criteria

Before moving to Phase 05, verify:

- [ ] A push to `main` automatically triggers the GitHub Actions workflow
- [ ] Pipeline runs lint → test → build → push → deploy without manual steps
- [ ] SonarQube shows a green quality gate after the pipeline runs
- [ ] A pull request with failing tests blocks the merge (branch protection enabled)
- [ ] Docker images in the registry are tagged with the Git commit SHA
- [ ] Kubernetes deployment is updated to the new image tag automatically
- [ ] A Slack / email notification is received when a deployment succeeds

---

## ➡️ Next Phase

**[Phase 05 — Security Hardening](./phase-05-security-hardening.md)**

CI/CD automates delivery. Phase 05 ensures what gets delivered is secure: HTTPS everywhere, JWT hardened, 2FA added, rate limiting applied, and OWASP Top 10 vulnerabilities closed.
