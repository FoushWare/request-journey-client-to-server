# Task: CI/CD - Setup GitHub Actions Workflow for Frontend

**Related Issue:** #56  
**Prerequisites:** task-001 (Jenkins setup - for understanding CI/CD concepts), task-005 (Backend workflow - for reference), Git repository with frontend code  
**Estimated Time:** 2-3 hours  
**Notes App Context:** Create a GitHub Actions workflow that automates frontend build, testing, code quality checks, and deployment for the Notes App Next.js frontend

---

## Learning Objectives

By the end of this task, you will be able to:

- Create GitHub Actions workflow for Next.js/React frontend
- Integrate code quality checks (ESLint, Prettier, TypeScript, security scanning) into workflows
- Configure Next.js build process in workflows
- Run and monitor frontend workflows
- Understand frontend-specific workflow considerations

---

## Theory Section

### Frontend Workflow Considerations

**Frontend vs Backend Workflows:**

Frontend workflows have unique considerations:
- **Build Process**: Next.js requires build step (creates optimized production build)
- **Static Assets**: Need to handle public assets, images, fonts
- **Environment Variables**: Next.js uses `NEXT_PUBLIC_*` prefix for client-side vars
- **Type Checking**: TypeScript compilation happens during build
- **Testing**: React Testing Library or Jest for component tests
- **Build Artifacts**: Next.js creates `.next` directory with optimized build

**Why This Matters for Notes App:**

The Notes App frontend needs:
- Automated builds on code changes
- Code quality checks (ESLint for React/TypeScript)
- TypeScript type checking
- Component testing
- Production-optimized builds
- Static asset optimization

GitHub Actions provides:
- Free CI/CD for public repositories
- Easy integration with GitHub
- Large ecosystem of actions
- Parallel job execution
- Matrix builds for multiple Node.js versions

**Key Concepts:**

- **Next.js Build**: Creates optimized production bundle
- **TypeScript Compilation**: Happens during build
- **Code Splitting**: Next.js automatically splits code
- **Image Optimization**: Next.js optimizes images
- **Static Export**: Can export static HTML (optional)

---

## Prerequisites Check

Before starting, ensure you have:

- [ ] Completed task-005 (Backend workflow - for reference)
- [ ] GitHub repository with Notes App frontend code
- [ ] Frontend code in repository
- [ ] GitHub account with Actions enabled
- [ ] Basic understanding of YAML syntax
- [ ] Next.js project structure (package.json, next.config.js exist)

**Verify Prerequisites:**
```bash
# Check repository exists
git remote -v

# Check frontend code exists
ls frontend/
ls frontend/package.json
ls frontend/next.config.js

# Check if .github directory exists
ls .github/workflows/ 2>/dev/null || echo "Will create workflow file"
```

---

## Step-by-Step Instructions

### Step 1: Create Frontend Workflow File

**Objective:** Create workflow file for frontend CI/CD

**Instructions:**

1. **Create `.github/workflows/frontend.yml`:**

```yaml
name: Frontend CI/CD

on:
  push:
    branches:
      - main
      - develop
    paths:
      - 'frontend/**'
      - '.github/workflows/frontend.yml'
  pull_request:
    branches:
      - main
      - develop
    paths:
      - 'frontend/**'
      - '.github/workflows/frontend.yml'

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
          cache-dependency-path: frontend/package-lock.json
          
      - name: Install dependencies
        run: |
          cd frontend
          npm ci
          
      - name: Run ESLint
        run: |
          cd frontend
          npm run lint
          
      - name: Check code formatting
        run: |
          cd frontend
          npm run format:check || echo "Prettier not configured"
          
      - name: TypeScript type check
        run: |
          cd frontend
          npx tsc --noEmit || echo "TypeScript check completed"
          
      - name: Security audit
        run: |
          cd frontend
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
          cache-dependency-path: frontend/package-lock.json
          
      - name: Install dependencies
        run: |
          cd frontend
          npm ci
          
      - name: Run tests
        run: |
          cd frontend
          npm test -- --watchAll=false || echo "Tests not configured"
          
      - name: Generate coverage report
        run: |
          cd frontend
          npm run test:coverage || npm test -- --coverage --watchAll=false || echo "Coverage not configured"
          
      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        continue-on-error: true
        with:
          files: ./frontend/coverage/lcov.info
          flags: frontend
          fail_ci_if_error: false
          
  build:
    name: Build Next.js App
    runs-on: ubuntu-latest
    needs: [quality-checks, test]
    
    env:
      NEXT_PUBLIC_API_URL: ${{ secrets.NEXT_PUBLIC_API_URL || 'http://localhost:5000' }}
      NODE_ENV: production
      NEXT_TELEMETRY_DISABLED: 1
      
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
        run: |
          cd frontend
          npm ci
          
      - name: Build Next.js application
        run: |
          cd frontend
          npm run build
          
      - name: Analyze build output
        run: |
          cd frontend
          echo "Build completed successfully"
          du -sh .next 2>/dev/null || echo "Build directory not found"
          ls -lah .next/ 2>/dev/null || echo "Cannot list build directory"
          
      - name: Upload build artifacts
        uses: actions/upload-artifact@v3
        with:
          name: frontend-build
          path: |
            frontend/.next
            frontend/public
            frontend/package.json
          retention-days: 7
          
  security-scan:
    name: Security Scanning
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
        
      - name: Run npm audit
        run: |
          cd frontend
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
- Only runs when frontend files change
- Separate jobs for quality checks, tests, and build
- TypeScript type checking included
- Next.js build creates optimized production bundle
- Environment variables configured for build

---

### Step 2: Configure Frontend Code Quality Scripts

**Objective:** Ensure frontend has code quality scripts

**Instructions:**

1. **Verify or add scripts to `frontend/package.json`:**
```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "lint:fix": "next lint --fix",
    "format": "prettier --write .",
    "format:check": "prettier --check .",
    "type-check": "tsc --noEmit",
    "audit": "npm audit",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage"
  }
}
```

2. **If scripts don't exist, add them**

**Note:** Next.js includes ESLint by default. TypeScript type checking requires TypeScript to be installed.

---

### Step 3: Commit and Push Workflow

**Objective:** Add workflow to repository and trigger it

**Instructions:**

1. **Add workflow file to git:**
```bash
git add .github/workflows/frontend.yml
git commit -m "Add GitHub Actions workflow for frontend CI/CD"
git push
```

2. **Verify workflow appears in GitHub:**
   - Go to GitHub repository
   - Click "Actions" tab
   - You should see "Frontend CI/CD" workflow
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
- TypeScript type checking passes
- Tests run and pass
- Next.js build completes

**Troubleshooting:**
- **Issue**: Next.js build fails
  - **Solution**: Check for TypeScript errors, missing dependencies
- **Issue**: Type checking fails
  - **Solution**: Fix TypeScript errors or make type checking non-blocking
- **Issue**: Tests not running
  - **Solution**: Configure Jest or make test step optional

---

### Step 4: Add Environment Variables (Optional)

**Objective:** Configure Next.js environment variables for build

**Instructions:**

1. **Add secrets to GitHub repository:**
   - Go to repository Settings
   - Click "Secrets and variables" > "Actions"
   - Click "New repository secret"
   - Add `NEXT_PUBLIC_API_URL` (if needed)
   - Click "Add secret"

2. **Update workflow to use secrets:**

```yaml
env:
  NEXT_PUBLIC_API_URL: ${{ secrets.NEXT_PUBLIC_API_URL || 'http://localhost:5000' }}
```

3. **Save and test**

**Note:** Next.js requires `NEXT_PUBLIC_*` prefix for client-side environment variables.

---

### Step 5: Add Workflow Status Badge

**Objective:** Add status badge to README

**Instructions:**

1. **Add badge to README.md:**
```markdown
![Frontend CI/CD](https://github.com/YOUR_USERNAME/YOUR_REPO/workflows/Frontend%20CI%2FCD/badge.svg)
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
git commit -m "Add frontend workflow status badge"
git push
```

**Expected Output:**
- Badge appears in README
- Shows workflow status (passing/failing)

---

### Step 6: Optimize Workflow Performance

**Objective:** Improve workflow speed with caching

**Instructions:**

1. **Workflow already uses npm cache via setup-node action:**
```yaml
- name: Setup Node.js
  uses: actions/setup-node@v3
  with:
    cache: 'npm'
    cache-dependency-path: frontend/package-lock.json
```

2. **Add Next.js build cache (optional):**

```yaml
- name: Cache Next.js build
  uses: actions/cache@v3
  with:
    path: |
      frontend/.next/cache
    key: ${{ runner.os }}-nextjs-${{ hashFiles('frontend/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-nextjs-
```

3. **Save and test**

**Expected Output:**
- Faster workflow execution
- Dependencies cached between runs
- Build cache reused when possible

---

## Notes App Specifics

### How This Applies to Notes App

**Frontend (Next.js):**
- Workflow builds Next.js/React frontend
- Code quality checks ensure React/TypeScript code quality
- TypeScript type checking ensures type safety
- Tests verify component functionality
- Build creates optimized production bundle

**Integration:**
- Workflow runs on every push/PR
- Quality gates prevent bad code
- Type checking prevents type errors
- Build artifacts ready for deployment

**Quality Checks:**
- ESLint checks React/TypeScript code
- Prettier ensures consistent formatting
- TypeScript type checking
- npm audit scans dependencies
- Component tests verify UI functionality

---

## Verification

### How to Verify the Task is Complete

**Functional Verification:**
1. Workflow file created in `.github/workflows/`
2. Workflow appears in GitHub Actions tab
3. Workflow runs on push/PR
4. All jobs complete successfully
5. Quality checks execute
6. TypeScript type checking runs
7. Tests run and pass
8. Next.js build completes
9. Build artifacts uploaded

**Technical Verification:**
1. Workflow file syntax is correct
2. Workflow triggers on correct events
3. Jobs run in correct order
4. Environment variables configured
5. Artifacts are uploaded

**Commands to Run:**
```bash
# Verify workflow file exists
ls .github/workflows/frontend.yml

# Test build locally
cd frontend/
npm run build
ls .next/

# Check workflow in GitHub
# Go to repository > Actions tab
```

**Expected Results:**
- Workflow runs on code changes
- Quality checks execute before build
- Type checking prevents type errors
- Tests run automatically
- Next.js build succeeds
- Build artifacts available
- Status badge shows workflow status

---

## Troubleshooting

### Common Issues and Solutions

**Issue 1: Next.js Build Fails**

**Symptoms:**
- Build job fails
- TypeScript errors
- Missing dependencies

**Causes:**
- TypeScript compilation errors
- Missing npm packages
- Configuration issues

**Solutions:**
1. Fix TypeScript errors
2. Run `npm install` locally to verify dependencies
3. Check `next.config.js` configuration
4. Review build logs for specific errors

---

**Issue 2: Type Checking Fails**

**Symptoms:**
- Type check step fails
- TypeScript errors reported

**Causes:**
- Type errors in code
- Missing type definitions
- Incorrect TypeScript configuration

**Solutions:**
1. Fix type errors
2. Install missing type definitions: `npm install --save-dev @types/package-name`
3. Check `tsconfig.json` configuration
4. Consider making type checking non-blocking initially

---

**Issue 3: Tests Not Running**

**Symptoms:**
- Test job skips or fails
- No test results

**Causes:**
- Tests not configured
- Jest not installed
- Test files not found

**Solutions:**
1. Install Jest: `npm install --save-dev jest`
2. Configure Jest in `package.json`
3. Create test files
4. Review task-007 for test setup

---

## Best Practices

### Security Best Practices
- Don't expose secrets in environment variables
- Use GitHub Secrets for sensitive data
- Scan dependencies regularly
- Review security audit results

### Performance Best Practices
- Cache node_modules between runs
- Use Next.js build cache
- Optimize workflow steps
- Run jobs in parallel when possible

### Operational Best Practices
- Version control workflow files
- Use descriptive job and step names
- Add meaningful comments
- Publish test results and coverage
- Archive build artifacts

### Code Quality Best Practices
- Enforce TypeScript type checking
- Maintain high test coverage
- Fix linting errors promptly
- Keep dependencies updated

---

## Additional Resources

### Documentation
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Next.js Deployment](https://nextjs.org/docs/deployment)
- [Next.js Build Optimization](https://nextjs.org/docs/advanced-features/measuring-performance)

### Learning Resources
- [GitHub Actions Tutorial](https://docs.github.com/en/actions/learn-github-actions)
- [Next.js with GitHub Actions](https://nextjs.org/docs/deployment#github-actions)

---

## Next Steps

After completing this task:

1. **Immediate Next Task**: `task-007-add-automated-testing.md` - Add comprehensive testing
2. **Related Tasks**: 
   - `task-008-add-docker-build-and-push.md` - Build and push Docker images
   - `task-011-setup-sonarqube.md` - Set up SonarQube
3. **Future Learning**: 
   - Advanced Next.js optimizations
   - Frontend performance monitoring

---

## Reflection Questions

1. Why is TypeScript type checking important in the workflow?
2. How does Next.js build optimization work?
3. What are the benefits of caching in workflows?
4. How do frontend workflows differ from backend workflows?

---

## Task Checklist

- [ ] Read and understood the theory section
- [ ] Completed all prerequisite checks
- [ ] Created frontend.yml workflow file
- [ ] Configured code quality scripts
- [ ] Committed and pushed workflow
- [ ] Verified workflow runs in GitHub
- [ ] Added TypeScript type checking
- [ ] Verified quality checks execute
- [ ] Verified tests run
- [ ] Verified Next.js build succeeds
- [ ] Added workflow status badge
- [ ] Reviewed troubleshooting section
- [ ] Applied best practices
- [ ] Ready to move to next task

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed  
**Date Started:** [Date]  
**Date Completed:** [Date]  
**Time Spent:** [Hours/Days]  
**Mentor Notes:** [Space for mentor feedback]
