# Task: CI/CD - Add Automated Testing and Code Quality Checks in Pipelines

**Related Issue:** #57  
**Prerequisites:** task-001 (Jenkins setup), task-002 (Jenkins backend pipeline), task-003 (Jenkins frontend pipeline), task-005 (GitHub Actions backend), task-006 (GitHub Actions frontend)  
**Estimated Time:** 4-6 hours  
**Notes App Context:** Add automated testing and code quality checks (ESLint, Prettier, security scanning) to CI/CD pipelines to ensure Notes App code quality before deployment

---

## Learning Objectives

By the end of this task, you will be able to:

- Understand code quality tools and their importance in CI/CD
- Configure ESLint for frontend (Next.js/React) and backend (Node.js)
- Set up Prettier for consistent code formatting
- Integrate security vulnerability scanning (npm audit)
- Add automated testing to CI/CD pipelines
- Configure code coverage reporting
- Understand quality gates and their role in preventing bad code from merging

---

## Theory Section

### What are Code Quality Checks?

**Code quality checks** are automated tools that analyze your code for:
- **Syntax errors**: Code that won't run
- **Style violations**: Inconsistent formatting, naming conventions
- **Best practices**: Code patterns that could cause bugs
- **Security vulnerabilities**: Dependencies with known security issues
- **Code complexity**: Functions that are too complex to maintain
- **Test coverage**: How much of your code is tested

**Why This Matters for Notes App:**

The Notes App has:
- **Frontend**: Next.js/React with TypeScript - needs linting and formatting
- **Backend**: Node.js/Express - needs linting and security scanning
- **Dependencies**: npm packages that may have vulnerabilities
- **Tests**: Unit tests, integration tests that should run automatically

Running quality checks in CI/CD ensures:
- Bad code doesn't get merged to main branch
- Security vulnerabilities are caught early
- Code style is consistent across the team
- Tests run automatically on every change

**Real-World Context:**

In production environments:
- **Quality gates** prevent merging code that fails checks
- **Security scanning** prevents deploying vulnerable dependencies
- **Code coverage** ensures critical paths are tested
- **Automated testing** catches bugs before they reach production

**Key Concepts:**

- **ESLint**: JavaScript/TypeScript linter that finds code problems
- **Prettier**: Code formatter that enforces consistent style
- **npm audit**: Security vulnerability scanner for npm dependencies
- **Jest**: Testing framework for JavaScript
- **Code Coverage**: Percentage of code covered by tests
- **Quality Gates**: Automated checks that must pass before merging

---

## Prerequisites Check

Before starting, ensure you have:

- [ ] Completed task-001 (Jenkins server setup)
- [ ] Completed task-002 (Jenkins backend pipeline)
- [ ] Completed task-003 (Jenkins frontend pipeline)
- [ ] Completed task-005 (GitHub Actions backend workflow)
- [ ] Completed task-006 (GitHub Actions frontend workflow)
- [ ] Notes App codebase available (frontend and backend)
- [ ] Node.js and npm installed
- [ ] Access to Jenkins server
- [ ] GitHub repository with Actions enabled

**Verify Prerequisites:**
```bash
# Check Node.js and npm
node --version
npm --version

# Check if Notes App exists
ls frontend/
ls backend/

# Check Jenkins is accessible
curl http://localhost:8080  # or your Jenkins URL
```

---

## Step-by-Step Instructions

### Step 1: Configure ESLint for Frontend (Next.js)

**Objective:** Set up ESLint to check Next.js/React code quality

**Why ESLint:**
- Finds bugs before runtime
- Enforces coding standards
- Catches common mistakes
- Improves code maintainability

**Instructions:**

1. **Navigate to frontend directory:**
```bash
cd frontend/
```

2. **Install ESLint dependencies (if not already installed):**
```bash
npm install --save-dev eslint eslint-config-next
```

3. **Create or update `.eslintrc.json`:**
```json
{
  "extends": ["next/core-web-vitals", "next/typescript"],
  "rules": {
    "no-console": "warn",
    "no-unused-vars": "warn",
    "@typescript-eslint/no-explicit-any": "warn"
  }
}
```

4. **Create `.eslintignore`:**
```
node_modules
.next
out
build
dist
```

5. **Add ESLint script to `package.json`:**
```json
{
  "scripts": {
    "lint": "next lint",
    "lint:fix": "next lint --fix"
  }
}
```

6. **Test ESLint locally:**
```bash
npm run lint
```

**Expected Output:**
- ESLint runs and reports any issues
- No errors for clean code
- Warnings for code style issues

**Troubleshooting:**
- **Issue**: ESLint not found
  - **Solution**: Run `npm install` to install dependencies
- **Issue**: Too many errors
  - **Solution**: Run `npm run lint:fix` to auto-fix some issues

---

### Step 2: Configure ESLint for Backend (Node.js/Express)

**Objective:** Set up ESLint to check Node.js/Express code quality

**Instructions:**

1. **Navigate to backend directory:**
```bash
cd backend/
```

2. **Install ESLint dependencies:**
```bash
npm install --save-dev eslint eslint-config-standard eslint-plugin-import eslint-plugin-node eslint-plugin-promise
```

3. **Create `.eslintrc.json`:**
```json
{
  "extends": ["standard"],
  "env": {
    "node": true,
    "es2021": true
  },
  "rules": {
    "no-console": "off",
    "no-unused-vars": "warn",
    "indent": ["error", 2],
    "quotes": ["error", "single"]
  }
}
```

4. **Create `.eslintignore`:**
```
node_modules
*.log
.env
```

5. **Add ESLint script to `package.json`:**
```json
{
  "scripts": {
    "lint": "eslint .",
    "lint:fix": "eslint . --fix"
  }
}
```

6. **Test ESLint locally:**
```bash
npm run lint
```

**Expected Output:**
- ESLint analyzes backend code
- Reports any code quality issues
- Suggests fixes

---

### Step 3: Configure Prettier for Code Formatting

**Objective:** Set up Prettier to enforce consistent code formatting

**Why Prettier:**
- Automatically formats code
- Eliminates style debates
- Works with ESLint
- Ensures consistent formatting

**Instructions:**

1. **Install Prettier in both frontend and backend:**
```bash
# Frontend
cd frontend/
npm install --save-dev prettier

# Backend
cd backend/
npm install --save-dev prettier
```

2. **Create `.prettierrc` in both directories:**
```json
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false
}
```

3. **Create `.prettierignore` in both directories:**
```
node_modules
.next
out
build
dist
*.log
.env
```

4. **Add Prettier scripts to `package.json` (both frontend and backend):**
```json
{
  "scripts": {
    "format": "prettier --write .",
    "format:check": "prettier --check ."
  }
}
```

5. **Test Prettier:**
```bash
npm run format:check
```

**Expected Output:**
- Prettier checks code formatting
- Reports files that need formatting
- Can auto-format with `npm run format`

---

### Step 4: Set Up Security Vulnerability Scanning

**Objective:** Configure npm audit to scan for security vulnerabilities

**Why Security Scanning:**
- Finds vulnerable dependencies
- Prevents security breaches
- Keeps dependencies up to date
- Required for production deployments

**Instructions:**

1. **Run npm audit in both frontend and backend:**
```bash
# Frontend
cd frontend/
npm audit

# Backend
cd backend/
npm audit
```

2. **Fix vulnerabilities (if any):**
```bash
# Update packages
npm update

# Or install specific versions
npm install package-name@latest
```

3. **Add audit script to `package.json` (both):**
```json
{
  "scripts": {
    "audit": "npm audit",
    "audit:fix": "npm audit fix"
  }
}
```

4. **Test audit:**
```bash
npm run audit
```

**Expected Output:**
- Lists any security vulnerabilities
- Shows severity levels (low, moderate, high, critical)
- Provides recommendations

**Troubleshooting:**
- **Issue**: Many vulnerabilities
  - **Solution**: Run `npm audit fix` to automatically fix some issues
- **Issue**: Breaking changes
  - **Solution**: Review changelogs before updating major versions

---

### Step 5: Add Testing Framework (Jest)

**Objective:** Set up Jest for automated testing

**Why Testing:**
- Catches bugs early
- Ensures code works as expected
- Prevents regressions
- Documents expected behavior

**Instructions:**

1. **Install Jest in backend:**
```bash
cd backend/
npm install --save-dev jest supertest
```

2. **Create `jest.config.js` in backend:**
```javascript
module.exports = {
  testEnvironment: 'node',
  coveragePathIgnorePatterns: ['/node_modules/'],
  testMatch: ['**/__tests__/**/*.test.js'],
  collectCoverageFrom: ['src/**/*.js', '!src/**/*.test.js'],
};
```

3. **Create sample test file `__tests__/server.test.js`:**
```javascript
const request = require('supertest');
const app = require('../src/server');

describe('Notes App API', () => {
  test('GET /health returns 200', async () => {
    const response = await request(app).get('/health');
    expect(response.statusCode).toBe(200);
  });
});
```

4. **Add test script to `package.json`:**
```json
{
  "scripts": {
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage"
  }
}
```

5. **Run tests:**
```bash
npm test
```

**Expected Output:**
- Tests run and pass
- Coverage report generated
- Test results displayed

---

### Step 6: Add Code Quality Checks to Jenkins Pipeline

**Objective:** Integrate code quality checks into Jenkins backend pipeline

**Instructions:**

1. **Update Jenkinsfile (backend) to add quality check stages:**

```groovy
pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Install Dependencies') {
            steps {
                sh 'cd backend && npm install'
            }
        }
        
        // NEW: Code Quality Checks
        stage('Code Quality') {
            steps {
                dir('backend') {
                    sh 'npm run lint'
                    sh 'npm run format:check'
                    sh 'npm run audit'
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                dir('backend') {
                    sh 'npm test'
                }
            }
        }
        
        stage('Build') {
            steps {
                dir('backend') {
                    sh 'npm run build'
                }
            }
        }
    }
    
    post {
        always {
            // Publish test results
            junit 'backend/test-results.xml'
            // Publish coverage reports
            publishHTML([
                reportDir: 'backend/coverage',
                reportFiles: 'index.html',
                reportName: 'Coverage Report'
            ])
        }
    }
}
```

2. **Save and commit the Jenkinsfile**

3. **Run the pipeline in Jenkins:**
   - Go to Jenkins dashboard
   - Click on your backend pipeline job
   - Click "Build Now"

4. **Verify quality checks run:**
   - Check pipeline console output
   - Verify lint, format, and audit stages complete
   - Check test results

**Expected Output:**
- Pipeline includes code quality stage
- Lint, format, and audit checks run
- Tests execute
- Coverage report generated

---

### Step 7: Add Code Quality Checks to Jenkins Frontend Pipeline

**Objective:** Integrate code quality checks into Jenkins frontend pipeline

**Instructions:**

1. **Update Jenkinsfile (frontend) similar to backend:**

```groovy
pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Install Dependencies') {
            steps {
                sh 'cd frontend && npm install'
            }
        }
        
        // NEW: Code Quality Checks
        stage('Code Quality') {
            steps {
                dir('frontend') {
                    sh 'npm run lint'
                    sh 'npm run format:check'
                    sh 'npm run audit'
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                dir('frontend') {
                    sh 'npm test'
                }
            }
        }
        
        stage('Build') {
            steps {
                dir('frontend') {
                    sh 'npm run build'
                }
            }
        }
    }
}
```

2. **Save and test the pipeline**

---

### Step 8: Add Code Quality Checks to GitHub Actions

**Objective:** Integrate code quality checks into GitHub Actions workflows

**Instructions:**

1. **Update `.github/workflows/backend.yml`:**

```yaml
name: Backend CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  quality-checks:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          
      - name: Install Dependencies
        run: |
          cd backend
          npm install
          
      - name: Run ESLint
        run: |
          cd backend
          npm run lint
          
      - name: Check Code Formatting
        run: |
          cd backend
          npm run format:check
          
      - name: Security Audit
        run: |
          cd backend
          npm audit --audit-level=moderate
          
      - name: Run Tests
        run: |
          cd backend
          npm test
          
      - name: Upload Coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./backend/coverage/lcov.info
          flags: backend
```

2. **Update `.github/workflows/frontend.yml` similarly**

3. **Commit and push changes:**
```bash
git add .
git commit -m "Add code quality checks to CI/CD pipelines"
git push
```

4. **Verify GitHub Actions run:**
   - Go to GitHub repository
   - Click "Actions" tab
   - Verify workflows run and pass

**Expected Output:**
- GitHub Actions workflows include quality checks
- All checks pass on push/PR
- Coverage reports uploaded

---

## Notes App Specifics

### How This Applies to Notes App

**Frontend (Next.js):**
- ESLint configured for React/TypeScript
- Prettier formats JSX and TypeScript files
- Next.js built-in linting integrated
- Security scanning for frontend dependencies

**Backend (Express):**
- ESLint configured for Node.js
- Prettier formats JavaScript files
- Security scanning for backend dependencies
- Jest tests for API endpoints

**Integration:**
- Both frontend and backend have quality checks
- Checks run in parallel in CI/CD
- Quality gates prevent merging bad code
- Coverage reports track test coverage

**Quality Gates:**
- Lint must pass (no errors)
- Formatting must be consistent
- Security audit must pass (no critical vulnerabilities)
- Tests must pass
- Coverage threshold (e.g., 80%)

---

## Verification

### How to Verify the Task is Complete

**Functional Verification:**
1. Run `npm run lint` in both frontend and backend - should pass
2. Run `npm run format:check` - should pass
3. Run `npm run audit` - should show no critical vulnerabilities
4. Run `npm test` - all tests should pass

**Technical Verification:**
1. Check Jenkins pipelines include quality check stages
2. Verify GitHub Actions workflows include quality checks
3. Check pipeline logs show quality checks running
4. Verify test coverage reports are generated

**Commands to Run:**
```bash
# Frontend
cd frontend/
npm run lint
npm run format:check
npm run audit
npm test

# Backend
cd backend/
npm run lint
npm run format:check
npm run audit
npm test
```

**Expected Results:**
- All quality checks pass
- No critical security vulnerabilities
- Tests pass with good coverage
- CI/CD pipelines include quality stages
- Quality gates prevent merging bad code

---

## Troubleshooting

### Common Issues and Solutions

**Issue 1: ESLint Errors**

**Symptoms:**
- Many linting errors
- Pipeline fails on lint stage

**Causes:**
- Code doesn't follow ESLint rules
- Missing ESLint configuration

**Solutions:**
1. Run `npm run lint:fix` to auto-fix some issues
2. Manually fix remaining errors
3. Update ESLint rules if needed
4. Check `.eslintrc.json` configuration

**Prevention:**
- Run lint locally before committing
- Use pre-commit hooks (optional)

---

**Issue 2: Prettier Formatting Issues**

**Symptoms:**
- Format check fails
- Inconsistent code formatting

**Causes:**
- Code not formatted with Prettier
- Different Prettier configuration

**Solutions:**
1. Run `npm run format` to auto-format code
2. Commit formatted code
3. Ensure `.prettierrc` is consistent

**Prevention:**
- Format code before committing
- Use editor Prettier extension

---

**Issue 3: Security Vulnerabilities**

**Symptoms:**
- npm audit shows vulnerabilities
- Pipeline fails on audit stage

**Causes:**
- Outdated dependencies
- Vulnerable package versions

**Solutions:**
1. Run `npm audit fix` to auto-fix
2. Update vulnerable packages manually
3. Review breaking changes before updating
4. Use `npm audit --audit-level=moderate` to allow low-severity issues

**Prevention:**
- Regularly update dependencies
- Monitor security advisories
- Use dependency update tools

---

**Issue 4: Tests Failing**

**Symptoms:**
- Tests fail in pipeline
- Coverage below threshold

**Causes:**
- Code changes break tests
- Missing test coverage
- Test configuration issues

**Solutions:**
1. Fix failing tests
2. Add tests for uncovered code
3. Check test configuration
4. Review test coverage reports

**Prevention:**
- Write tests alongside code
- Maintain good test coverage
- Run tests locally before committing

---

## Best Practices

### Security Best Practices
- Run `npm audit` regularly
- Update dependencies promptly
- Use `npm audit fix` carefully (test after)
- Monitor security advisories
- Use Snyk or similar tools for advanced scanning

### Performance Best Practices
- Run quality checks in parallel
- Cache node_modules in CI/CD
- Use incremental linting
- Optimize test execution time

### Operational Best Practices
- Fail fast on quality check failures
- Provide clear error messages
- Generate detailed reports
- Integrate quality checks early in pipeline
- Use quality gates to prevent bad merges

### Code Quality Best Practices
- Fix linting errors, don't disable rules
- Maintain consistent code style
- Write meaningful tests
- Aim for high test coverage (80%+)
- Review quality reports regularly

---

## Additional Resources

### Documentation
- [ESLint Documentation](https://eslint.org/docs/latest/)
- [Prettier Documentation](https://prettier.io/docs/en/)
- [Jest Documentation](https://jestjs.io/docs/getting-started)
- [npm audit Documentation](https://docs.npmjs.com/cli/v8/commands/npm-audit)

### Learning Resources
- [ESLint Rules Guide](https://eslint.org/docs/latest/rules/)
- [Prettier Configuration Options](https://prettier.io/docs/en/configuration.html)
- [Jest Testing Best Practices](https://jestjs.io/docs/getting-started)

### Tools
- [ESLint Playground](https://eslint.org/play/): Try ESLint rules online
- [Prettier Playground](https://prettier.io/playground/): Try Prettier formatting
- [npm Package Security](https://www.npmjs.com/advisories): Check package vulnerabilities

---

## Next Steps

After completing this task:

1. **Immediate Next Task**: `task-008-add-docker-build-and-push.md` - Build and push Docker images
2. **Related Tasks**: 
   - `task-011-setup-sonarqube.md` - Set up SonarQube for advanced code analysis
   - `task-012-configure-sonarqube-project.md` - Configure SonarQube project
3. **Future Learning**: 
   - Advanced code quality tools (SonarQube, CodeClimate)
   - Pre-commit hooks (Husky, lint-staged)
   - Code review best practices

---

## Reflection Questions

Take a moment to reflect on what you learned:

1. Why are code quality checks important in CI/CD pipelines?
2. How do ESLint and Prettier work together?
3. What security risks do vulnerable dependencies pose?
4. How do quality gates prevent bad code from merging?
5. What is the relationship between test coverage and code quality?

**Document Your Learning:**
- Write down key concepts you learned
- Note any challenges you faced
- Document solutions you discovered
- Record questions for your mentor

---

## Task Checklist

Use this checklist to track your progress:

- [ ] Read and understood the theory section
- [ ] Completed all prerequisite checks
- [ ] Configured ESLint for frontend
- [ ] Configured ESLint for backend
- [ ] Set up Prettier for code formatting
- [ ] Configured security vulnerability scanning
- [ ] Set up Jest testing framework
- [ ] Added quality checks to Jenkins backend pipeline
- [ ] Added quality checks to Jenkins frontend pipeline
- [ ] Added quality checks to GitHub Actions workflows
- [ ] Verified all quality checks pass locally
- [ ] Verified pipelines run quality checks
- [ ] Reviewed troubleshooting section
- [ ] Applied best practices
- [ ] Documented learnings
- [ ] Ready to move to next task

---

## Notes

[Space for mentee to add their own notes, observations, or questions]

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed  
**Date Started:** [Date]  
**Date Completed:** [Date]  
**Time Spent:** [Hours/Days]  
**Mentor Notes:** [Space for mentor feedback]

