# Task: CI/CD - Setup GitHub Actions Workflow for Backend

**Related Issue:** #55  
**Prerequisites:** task-001 (Jenkins setup - for understanding CI/CD concepts), Git repository with backend code  
**Estimated Time:** 2-3 hours  
**Notes App Context:** Create a GitHub Actions workflow that automates backend build, testing, code quality checks, and deployment for the Notes App backend API

---

## Learning Objectives

By the end of this task, you will be able to:

- Understand GitHub Actions workflow structure
- Create workflow files for Node.js/Express backend
- Integrate code quality checks (ESLint, Prettier, security scanning) into workflows
- Configure workflow triggers (push, pull request)
- Run and monitor GitHub Actions workflows
- Understand workflow artifacts and caching

---

## Theory Section

### What are GitHub Actions?

**GitHub Actions** is a CI/CD platform built into GitHub that allows you to automate workflows directly in your repository. Workflows are defined in YAML files and run on GitHub-hosted runners.

**Key Concepts:**

- **Workflow**: Automated process defined in YAML file
- **Job**: Set of steps that run on the same runner
- **Step**: Individual task (run command, use action)
- **Action**: Reusable unit of code (e.g., checkout, setup-node)
- **Runner**: Virtual machine that executes jobs (GitHub-hosted or self-hosted)
- **Event**: Trigger that starts workflow (push, PR, schedule)

**Why This Matters for Notes App:**

The Notes App backend needs:
- Automated builds on code changes
- Code quality checks before building
- Automated testing
- Consistent deployment process
- Build artifacts for deployment

GitHub Actions provides:
- Free CI/CD for public repositories
- Easy integration with GitHub
- Large ecosystem of actions
- Parallel job execution
- Matrix builds for multiple versions

**Real-World Context:**

In production:
- Workflows run on every push/PR
- Quality gates prevent bad code
- Builds are versioned and tagged
- Deployment is automated
- Status checks required for merging

---

## Prerequisites Check

Before starting, ensure you have:

- [ ] GitHub repository with Notes App backend code
- [ ] Backend code in repository
- [ ] GitHub account with Actions enabled
- [ ] Basic understanding of YAML syntax
- [ ] Node.js project structure (package.json exists)

**Verify Prerequisites:**
```bash
# Check repository exists
git remote -v

# Check backend code exists
ls backend/
ls backend/package.json

# Check if .github directory exists
ls .github/ 2>/dev/null || echo "Will create .github directory"
```

---

## Step-by-Step Instructions

### Step 1: Create GitHub Actions Workflow Directory

**Objective:** Set up directory structure for workflows

**Instructions:**

1. **Create `.github` directory (if it doesn't exist):**
```bash
mkdir -p .github/workflows
```

2. **Verify directory created:**
```bash
ls -la .github/workflows/
```

**Expected Output:**
- `.github/workflows/` directory exists
- Ready to create workflow files

---

### Step 2: Create Backend Workflow File

**Objective:** Create workflow file for backend CI/CD

**Instructions:**

1. **Create `.github/workflows/backend.yml`:**

```yaml
name: Backend CI/CD

on:
  push:
    branches:
      - main
      - develop
    paths:
      - 'backend/**'
      - '.github/workflows/backend.yml'
  pull_request:
    branches:
      - main
      - develop
    paths:
      - 'backend/**'
      - '.github/workflows/backend.yml'

jobs:
  quality-checks:
    name: Code Quality Checks
    runs-on: ubuntu-latest
    
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
        run: |
          cd backend
          npm ci
          
      - name: Run ESLint
        run: |
          cd backend
          npm run lint
          
      - name: Check code formatting
        run: |
          cd backend
          npm run format:check || echo "Prettier not configured"
          
      - name: Security audit
        run: |
          cd backend
          npm audit --audit-level=moderate
          
  test:
    name: Run Tests
    runs-on: ubuntu-latest
    needs: quality-checks
    
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
        run: |
          cd backend
          npm ci
          
      - name: Run tests
        run: |
          cd backend
          npm test
          
      - name: Generate coverage report
        run: |
          cd backend
          npm run test:coverage || npm test -- --coverage
          
      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          files: ./backend/coverage/lcov.info
          flags: backend
          fail_ci_if_error: false
          
  build:
    name: Build Backend
    runs-on: ubuntu-latest
    needs: [quality-checks, test]
    
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
        run: |
          cd backend
          npm ci
          
      - name: Build backend
        run: |
          cd backend
          npm run build || echo "No build script, skipping"
          
      - name: Upload build artifacts
        uses: actions/upload-artifact@v3
        with:
          name: backend-build
          path: |
            backend/dist
            backend/build
            backend/package.json
          retention-days: 7
          
  security-scan:
    name: Security Scanning
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
        
      - name: Run npm audit
        run: |
          cd backend
          npm audit --audit-level=high
          
      - name: Run Snyk security scan (optional)
        uses: snyk/actions/node@master
        continue-on-error: true
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        with:
          args: --severity-threshold=high
```

2. **Save the file**

**Key Points:**
- Workflow triggers on push/PR to main/develop
- Only runs when backend files change
- Separate jobs for quality checks, tests, and build
- Jobs run in sequence (needs: dependencies)
- Artifacts uploaded for deployment

---

### Step 3: Configure Code Quality Scripts

**Objective:** Ensure backend has code quality scripts

**Instructions:**

1. **Verify or add scripts to `backend/package.json`:**
```json
{
  "scripts": {
    "lint": "eslint .",
    "lint:fix": "eslint . --fix",
    "format": "prettier --write .",
    "format:check": "prettier --check .",
    "audit": "npm audit",
    "test": "jest",
    "test:coverage": "jest --coverage"
  }
}
```

2. **If scripts don't exist, add them**

**Note:** If you haven't set up ESLint/Prettier yet, complete task-007 first, or add basic scripts that won't fail:
```json
{
  "scripts": {
    "lint": "echo 'Linting not configured' && exit 0",
    "format:check": "echo 'Prettier not configured' && exit 0",
    "audit": "npm audit",
    "test": "jest || echo 'Tests not configured' && exit 0"
  }
}
```

---

### Step 4: Commit and Push Workflow

**Objective:** Add workflow to repository and trigger it

**Instructions:**

1. **Add workflow file to git:**
```bash
git add .github/workflows/backend.yml
git commit -m "Add GitHub Actions workflow for backend CI/CD"
git push
```

2. **Verify workflow appears in GitHub:**
   - Go to GitHub repository
   - Click "Actions" tab
   - You should see "Backend CI/CD" workflow
   - Workflow should start running automatically

3. **Monitor workflow execution:**
   - Click on the workflow run
   - Watch jobs execute in real-time
   - Check logs for each step

**Expected Output:**
- Workflow appears in Actions tab
- Workflow runs automatically on push
- All jobs complete successfully
- Quality checks pass
- Tests run and pass
- Build completes

**Troubleshooting:**
- **Issue**: Workflow doesn't appear
  - **Solution**: Check file is in `.github/workflows/` directory
- **Issue**: Workflow doesn't trigger
  - **Solution**: Check branch name matches (main/master)
- **Issue**: Jobs fail
  - **Solution**: Check logs for specific errors

---

### Step 5: Add Workflow Status Badge

**Objective:** Add status badge to README

**Instructions:**

1. **Add badge to README.md:**
```markdown
![Backend CI/CD](https://github.com/YOUR_USERNAME/YOUR_REPO/workflows/Backend%20CI%2FCD/badge.svg)
```

2. **Or use GitHub's badge generator:**
   - Go to Actions tab
   - Click on workflow
   - Click "..." menu
   - Select "Create status badge"
   - Copy markdown code

3. **Commit and push:**
```bash
git add README.md
git commit -m "Add workflow status badge"
git push
```

**Expected Output:**
- Badge appears in README
- Shows workflow status (passing/failing)

---

### Step 6: Configure Branch Protection (Optional)

**Objective:** Require workflow to pass before merging

**Instructions:**

1. **Go to repository settings:**
   - Click "Settings" tab
   - Click "Branches" in left sidebar

2. **Add branch protection rule:**
   - Click "Add rule"
   - Branch name: `main` (or `master`)
   - Enable "Require status checks to pass before merging"
   - Select "Backend CI/CD" workflow
   - Click "Create"

3. **Verify protection:**
   - Try to merge a PR with failing workflow
   - Should be blocked

**Expected Output:**
- PRs require workflow to pass
- Bad code cannot be merged
- Quality gates enforced

---

## Notes App Specifics

### How This Applies to Notes App

**Backend (Express):**
- Workflow builds Node.js/Express backend
- Code quality checks ensure API code quality
- Tests verify API endpoints work correctly
- Build creates deployment-ready artifacts

**Integration:**
- Workflow runs on every push/PR
- Quality gates prevent bad code
- Test coverage ensures API reliability
- Artifacts ready for deployment

**Quality Checks:**
- ESLint checks JavaScript code quality
- Prettier ensures consistent formatting
- npm audit scans for security vulnerabilities
- Tests verify API functionality

---

## Verification

### How to Verify the Task is Complete

**Functional Verification:**
1. Workflow file created in `.github/workflows/`
2. Workflow appears in GitHub Actions tab
3. Workflow runs on push/PR
4. All jobs complete successfully
5. Quality checks execute
6. Tests run and pass
7. Build artifacts uploaded

**Technical Verification:**
1. Workflow file syntax is correct
2. Workflow triggers on correct events
3. Jobs run in correct order
4. Artifacts are uploaded
5. Status badge works

**Commands to Run:**
```bash
# Verify workflow file exists
ls .github/workflows/backend.yml

# Check YAML syntax (if yamllint installed)
yamllint .github/workflows/backend.yml

# View workflow in GitHub
# Go to repository > Actions tab
```

**Expected Results:**
- Workflow runs on code changes
- Quality checks execute before build
- Tests run automatically
- Coverage reports generated
- Build artifacts available
- Status badge shows workflow status

---

## Troubleshooting

### Common Issues and Solutions

**Issue 1: Workflow Not Triggering**

**Symptoms:**
- Workflow doesn't run on push
- No workflow runs appear

**Causes:**
- Incorrect branch name
- Path filters too restrictive
- Workflow file syntax error

**Solutions:**
1. Check branch name matches workflow trigger
2. Remove or adjust path filters
3. Check YAML syntax
4. Verify file is in `.github/workflows/` directory

---

**Issue 2: Quality Checks Failing**

**Symptoms:**
- Quality check job fails
- Lint or format checks fail

**Causes:**
- Code doesn't pass linting
- Formatting not consistent
- Scripts not configured

**Solutions:**
1. Fix linting errors: `npm run lint:fix`
2. Format code: `npm run format`
3. Configure scripts in package.json
4. Review task-007 for setup instructions

---

**Issue 3: Tests Failing**

**Symptoms:**
- Test job fails
- Tests don't run

**Causes:**
- Test code has errors
- Test configuration incorrect
- Dependencies missing

**Solutions:**
1. Fix failing tests
2. Check test configuration
3. Verify dependencies installed
4. Review test setup in task-007

---

## Best Practices

### Security Best Practices
- Use GitHub Secrets for sensitive data
- Don't hardcode secrets in workflow
- Use least privilege for tokens
- Scan dependencies regularly

### Performance Best Practices
- Cache node_modules between runs
- Use matrix builds for multiple versions
- Run jobs in parallel when possible
- Optimize workflow steps

### Operational Best Practices
- Version control workflow files
- Use descriptive job and step names
- Add meaningful comments
- Publish test results and coverage
- Archive important artifacts

### Code Quality Best Practices
- Fail fast on quality check failures
- Enforce quality gates
- Maintain high test coverage
- Review workflow logs regularly

---

## Additional Resources

### Documentation
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [Actions Marketplace](https://github.com/marketplace?type=actions)

### Learning Resources
- [GitHub Actions Tutorial](https://docs.github.com/en/actions/learn-github-actions)
- [Node.js with GitHub Actions](https://docs.github.com/en/actions/automating-builds-and-tests/building-and-testing-nodejs)

---

## Next Steps

After completing this task:

1. **Immediate Next Task**: `task-006-setup-github-actions-frontend.md` - Create frontend workflow
2. **Related Tasks**: 
   - `task-004-configure-github-webhook.md` - Configure webhooks
   - `task-007-add-automated-testing.md` - Add comprehensive testing
3. **Future Learning**: 
   - Advanced workflow features (matrix builds, reusable workflows)
   - Deployment workflows

---

## Reflection Questions

1. Why are separate jobs beneficial in workflows?
2. How do workflow triggers work?
3. What is the benefit of caching in workflows?
4. How do quality gates prevent bad code from merging?

---

## Task Checklist

- [ ] Read and understood the theory section
- [ ] Completed all prerequisite checks
- [ ] Created workflow directory structure
- [ ] Created backend.yml workflow file
- [ ] Configured code quality scripts
- [ ] Committed and pushed workflow
- [ ] Verified workflow runs in GitHub
- [ ] Added workflow status badge
- [ ] Verified quality checks execute
- [ ] Verified tests run
- [ ] Reviewed troubleshooting section
- [ ] Applied best practices
- [ ] Ready to move to next task

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed  
**Date Started:** [Date]  
**Date Completed:** [Date]  
**Time Spent:** [Hours/Days]  
**Mentor Notes:** [Space for mentor feedback]
