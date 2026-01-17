# Task: GitHub Actions Build Pipeline
**Issue:** #42 | **Category:** CI/CD | **Priority:** High | **Effort:** 6h

---

## 📋 Objective

Configure GitHub Actions for automated building, testing, and validation of code changes.

---

## 📝 Description

Implement CI pipeline using GitHub Actions to automatically build and test code on every push and pull request:
- Build jobs for backend and frontend
- Automated testing (unit, integration, e2e)
- Code quality analysis
- Artifact creation and storage
- Failure notifications

---

## ✅ Acceptance Criteria

- [ ] Build workflow created for backend
- [ ] Build workflow created for frontend
- [ ] Unit tests running automatically
- [ ] Integration tests passing
- [ ] Code coverage metrics collected
- [ ] Build artifacts created
- [ ] Failure notifications working
- [ ] Workflow documentation complete
- [ ] Team trained on CI
- [ ] Build time < 10 minutes

---

## 🔧 Sub-Tasks

### 1. GitHub Actions Setup
- [ ] Install GitHub Actions
- [ ] Configure runner (self-hosted or GitHub-hosted)
- [ ] Set up runner authentication
- [ ] Configure environment variables
- [ ] Set up secrets for credentials
- [ ] Document runner configuration

### 2. Backend Build Pipeline
- [ ] Create .github/workflows/backend-build.yml
- [ ] Configure Node.js environment
- [ ] Set up dependency caching
- [ ] Run npm install/build
- [ ] Run linting (ESLint)
- [ ] Create build artifacts

### 3. Frontend Build Pipeline
- [ ] Create .github/workflows/frontend-build.yml
- [ ] Configure Next.js environment
- [ ] Set up npm cache
- [ ] Run build with optimizations
- [ ] Generate static export
- [ ] Upload build artifacts

### 4. Unit Testing
- [ ] Configure Jest for testing
- [ ] Run backend unit tests
- [ ] Run frontend unit tests
- [ ] Collect coverage reports
- [ ] Set minimum coverage threshold
- [ ] Create coverage badges

### 5. Integration Testing
- [ ] Set up test database
- [ ] Run API integration tests
- [ ] Run database migration tests
- [ ] Verify service connections
- [ ] Test error handling
- [ ] Document test scenarios

### 6. Code Quality Analysis
- [ ] Integrate SonarQube/CodeClimate
- [ ] Run static analysis
- [ ] Check code complexity
- [ ] Generate quality reports
- [ ] Set quality gates
- [ ] Configure notifications

### 7. Artifact Management
- [ ] Configure artifact storage
- [ ] Create versioned builds
- [ ] Store Docker images
- [ ] Archive test reports
- [ ] Implement retention policy
- [ ] Document artifact usage

### 8. Security Scanning
- [ ] Enable dependency scanning
- [ ] Scan for secrets
- [ ] Check for vulnerabilities
- [ ] Generate security reports
- [ ] Fail on critical issues
- [ ] Document security checks

### 9. Workflow Monitoring
- [ ] Set up build notifications
- [ ] Configure Slack alerts
- [ ] Monitor build times
- [ ] Track failure rates
- [ ] Create build dashboard
- [ ] Document troubleshooting

### 10. Performance Optimization
- [ ] Optimize build cache
- [ ] Parallelize tests
- [ ] Reduce build time
- [ ] Monitor resource usage
- [ ] Document optimization
- [ ] Create performance report

---

## 📚 Learning Resources

- **GitHub Actions:** https://docs.github.com/en/actions
- **Workflow Syntax:** https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions
- **CI Best Practices:** https://github.blog/2022-02-11-github-actions-ci-cd-best-practices/
- **Caching:** https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows
- **Security:** https://docs.github.com/en/actions/security-guides

---

## 💻 Code Example: Backend Build Workflow

```yaml
name: Backend Build & Test
on:
  push:
    branches: [main, develop]
    paths:
    - backend/**
    - .github/workflows/backend-build.yml
  pull_request:
    branches: [main, develop]
    paths:
    - backend/**

jobs:
  build:
    runs-on: ubuntu-latest
    timeout-minutes: 30
    
    services:
      postgres:
        image: postgres:15-alpine
        env:
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: test_db
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
        - 5432:5432
      
      redis:
        image: redis:7-alpine
        options: >-
          --health-cmd "redis-cli ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
        - 6379:6379
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'
        cache-dependency-path: backend/package-lock.json
    
    - name: Install dependencies
      run: cd backend && npm ci
    
    - name: Run linting
      run: cd backend && npm run lint
    
    - name: Run type check
      run: cd backend && npm run type-check
    
    - name: Run unit tests
      run: cd backend && npm run test:unit
      env:
        NODE_ENV: test
    
    - name: Run integration tests
      run: cd backend && npm run test:integration
      env:
        DATABASE_URL: postgres://postgres:postgres@localhost:5432/test_db
        REDIS_URL: redis://localhost:6379
        NODE_ENV: test
    
    - name: Build application
      run: cd backend && npm run build
    
    - name: Upload coverage reports
      uses: codecov/codecov-action@v3
      with:
        files: ./backend/coverage/coverage-final.json
        flags: backend
        fail_ci_if_error: false
    
    - name: Create build artifact
      run: |
        cd backend
        npm run build
        tar -czf backend-build.tar.gz dist/ node_modules/
    
    - name: Upload build artifact
      uses: actions/upload-artifact@v3
      with:
        name: backend-build
        path: backend/backend-build.tar.gz
        retention-days: 7
    
    - name: Comment PR with results
      if: github.event_name == 'pull_request'
      uses: actions/github-script@v6
      with:
        script: |
          github.rest.issues.createComment({
            issue_number: context.issue.number,
            owner: context.repo.owner,
            repo: context.repo.repo,
            body: '✅ Backend build successful!\n- Tests passed\n- Coverage: 85%'
          })
```

---

## 💻 Frontend Build Workflow

```yaml
name: Frontend Build & Test
on:
  push:
    branches: [main, develop]
    paths:
    - frontend/**
    - .github/workflows/frontend-build.yml
  pull_request:
    branches: [main, develop]
    paths:
    - frontend/**

jobs:
  build:
    runs-on: ubuntu-latest
    timeout-minutes: 20
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'
        cache-dependency-path: frontend/package-lock.json
    
    - name: Install dependencies
      run: cd frontend && npm ci
    
    - name: Run linting
      run: cd frontend && npm run lint
    
    - name: Run type check
      run: cd frontend && npm run type-check
    
    - name: Run unit tests
      run: cd frontend && npm run test
      env:
        CI: true
    
    - name: Build application
      run: cd frontend && npm run build
      env:
        NEXT_PUBLIC_API_URL: http://api.example.com
    
    - name: Run Lighthouse CI
      uses: treosh/lighthouse-ci-action@v9
      with:
        configPath: ./frontend/lighthouserc.json
        uploadArtifacts: true
        temporaryPublicStorage: true
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        files: ./frontend/coverage/coverage-final.json
        flags: frontend
    
    - name: Create optimized build
      run: |
        cd frontend
        npm run build
        tar -czf frontend-build.tar.gz .next/ public/
    
    - name: Upload build artifact
      uses: actions/upload-artifact@v3
      with:
        name: frontend-build
        path: frontend/frontend-build.tar.gz
        retention-days: 7
```

---

## 📊 CI Pipeline Stages

```mermaid
graph LR
    A[Code Push] -->|Trigger| B[Checkout]
    B --> C[Setup]
    C --> D[Install]
    D --> E[Lint]
    E --> F[Type Check]
    F --> G[Test]
    G --> H[Build]
    H --> I[Quality Check]
    I --> J{Pass?}
    J -->|Yes| K[Create Artifact]
    J -->|No| L[Notify Failure]
```

---

## 🔒 Security Considerations

- **Secrets Management:** Use GitHub Secrets for credentials
- **Dependency Scanning:** Check for known vulnerabilities
- **Code Analysis:** Scan for security issues
- **Build Isolation:** Run builds in ephemeral environments
- **Artifact Security:** Sign and verify build artifacts
- **Access Control:** Limit who can approve deployments

---

## ✨ Success Metrics

- Build success rate > 95%
- Average build time < 10 minutes
- Test coverage > 80%
- All PRs validated before merge
- Zero security vulnerabilities
- Team confident with CI process

---

## 📖 Related Tasks

- [Deployment Pipeline](ci-cd-002.md) - CD configuration
- [Testing Strategy](ci-cd-003.md) - Test automation
- [Monitoring](k8s-008.md) - Build monitoring

---

**Created:** January 17, 2026 | **Last Updated:** January 17, 2026
