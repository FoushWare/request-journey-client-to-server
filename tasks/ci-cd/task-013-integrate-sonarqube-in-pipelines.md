# Task: CI/CD - Integrate SonarQube into CI/CD Pipelines

**Related Issue:** N/A (New task for code quality)  
**Prerequisites:** task-011 (SonarQube setup), task-012 (SonarQube project configuration), task-002 (Jenkins backend pipeline), task-005 (GitHub Actions backend)  
**Estimated Time:** 3-4 hours  
**Notes App Context:** Integrate SonarQube analysis into Jenkins and GitHub Actions pipelines so that code quality is automatically analyzed on every code change, with quality gates preventing bad code from merging

---

## Learning Objectives

By the end of this task, you will be able to:

- Integrate SonarQube into Jenkins pipelines
- Integrate SonarQube into GitHub Actions workflows
- Configure SonarQube Scanner in CI/CD
- Set up quality gate checks
- Configure branch analysis and PR decoration
- Understand how quality gates prevent bad code from merging
- Interpret SonarQube analysis results in CI/CD

---

## Theory Section

### SonarQube CI/CD Integration

**Why Integrate SonarQube in CI/CD:**

- **Automated Analysis**: Code is analyzed on every change automatically
- **Quality Gates**: Prevents merging code that doesn't meet quality standards
- **Early Detection**: Catches bugs and vulnerabilities before production
- **Consistent Standards**: Enforces code quality across all contributions
- **Historical Tracking**: Tracks code quality trends over time

**Key Concepts:**

- **SonarQube Scanner**: Tool that performs code analysis
- **Quality Gate**: Set of conditions that must pass (e.g., no critical bugs)
- **Branch Analysis**: Analyzing code in feature branches
- **PR Decoration**: Adding SonarQube results to pull requests
- **Token Authentication**: Using tokens to authenticate with SonarQube

**Integration Methods:**

1. **Jenkins Integration:**
   - SonarQube Scanner plugin
   - SonarQube server configuration
   - Quality gate checks in pipeline

2. **GitHub Actions Integration:**
   - SonarCloud GitHub Action (for SonarCloud)
   - SonarQube Scanner CLI (for self-hosted)
   - Quality gate status checks

**Why This Matters for Notes App:**

The Notes App benefits from:
- Automatic code quality analysis on every push/PR
- Quality gates preventing bad code from merging
- Security vulnerability detection in CI/CD
- Test coverage tracking
- Technical debt monitoring

**Real-World Context:**

In production:
- Every PR is analyzed before merging
- Quality gates block merges if standards aren't met
- Teams review SonarQube reports in PRs
- Code quality trends tracked over time

---

## Prerequisites Check

Before starting, ensure you have:

- [ ] Completed task-011 (SonarQube setup - project created)
- [ ] Completed task-012 (SonarQube project configured)
- [ ] Completed task-002 (Jenkins backend pipeline)
- [ ] Completed task-005 (GitHub Actions backend workflow)
- [ ] SonarQube project key and token available
- [ ] Jenkins server accessible
- [ ] GitHub repository with Actions enabled

**Verify Prerequisites:**
```bash
# Check Jenkins is accessible
curl http://localhost:8080 2>/dev/null || echo "Jenkins not accessible"

# Check GitHub repository
git remote -v

# Verify SonarQube project exists
# Go to SonarQube dashboard and verify project
```

---

## Step-by-Step Instructions

### Part A: Jenkins Integration

#### Step A1: Install SonarQube Scanner Plugin in Jenkins

**Objective:** Install plugin to enable SonarQube integration

**Instructions:**

1. **Open Jenkins:**
   - Navigate to http://localhost:8080 (or your Jenkins URL)
   - Log in as admin

2. **Install SonarQube Scanner plugin:**
   - Click "Manage Jenkins"
   - Click "Manage Plugins"
   - Go to "Available" tab
   - Search for "SonarQube Scanner"
   - Check the box
   - Click "Install without restart" or "Download now and install after restart"

3. **Install SonarQube plugin (for server configuration):**
   - Search for "SonarQube"
   - Check the box
   - Click "Install without restart"

4. **Restart Jenkins (if needed):**
   - Wait for installation to complete
   - Restart Jenkins if prompted

**Expected Output:**
- Plugins installed successfully
- SonarQube Scanner available in pipeline steps

---

#### Step A2: Configure SonarQube Server in Jenkins

**Objective:** Configure Jenkins to connect to SonarQube

**Instructions:**

1. **Configure SonarQube server:**
   - Click "Manage Jenkins"
   - Click "Configure System"
   - Scroll to "SonarQube servers" section
   - Click "Add SonarQube"
   - **Name**: "SonarQube" (or your preferred name)
   - **Server URL**: 
     - For SonarCloud: `https://sonarcloud.io`
     - For self-hosted: `http://localhost:9000` (or your SonarQube URL)
   - **Server authentication token**: 
     - Click "Add" next to "Server authentication token"
     - **Kind**: "Secret text"
     - **Secret**: Paste your SonarQube token (from task-011)
     - **ID**: "sonar-token" (or your preferred ID)
     - Click "Add"
     - Select the token from dropdown
   - Click "Save"

2. **Configure SonarQube Scanner:**
   - Click "Manage Jenkins"
   - Click "Global Tool Configuration"
   - Scroll to "SonarQube Scanner" section
   - Click "Add SonarQube Scanner"
   - **Name**: "SonarQube Scanner"
   - **Install automatically**: Check this box
   - **Version**: Select latest version (e.g., "4.8.0.2856")
   - Click "Save"

**Expected Output:**
- SonarQube server configured in Jenkins
- SonarQube Scanner tool configured
- Ready to use in pipelines

---

#### Step A3: Add SonarQube Stage to Backend Jenkinsfile

**Objective:** Integrate SonarQube analysis into backend pipeline

**Instructions:**

1. **Update `backend/Jenkinsfile` to add SonarQube stage:**

```groovy
pipeline {
    agent any
    
    environment {
        NODE_VERSION = '18'
        NPM_CONFIG_CACHE = "${WORKSPACE}/.npm"
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }
        
        stage('Install Dependencies') {
            steps {
                echo 'Installing npm dependencies...'
                sh '''
                    cd backend
                    npm install
                '''
            }
        }
        
        stage('Code Quality Checks') {
            steps {
                echo 'Running code quality checks...'
                dir('backend') {
                    sh 'npm run lint || true'
                    sh 'npm run format:check || true'
                    sh 'npm audit --audit-level=moderate || true'
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                echo 'Running tests...'
                dir('backend') {
                    sh 'npm test'
                }
            }
            post {
                always {
                    junit 'backend/test-results.xml'
                    publishHTML([
                        reportDir: 'backend/coverage',
                        reportFiles: 'index.html',
                        reportName: 'Test Coverage Report'
                    ])
                }
            }
        }
        
        // NEW: SonarQube Analysis Stage
        stage('SonarQube Analysis') {
            steps {
                echo 'Running SonarQube analysis...'
                script {
                    def scannerHome = tool 'SonarQube Scanner'
                    withSonarQubeEnv('SonarQube') {
                        sh """
                            ${scannerHome}/bin/sonar-scanner \
                                -Dsonar.projectKey=notes-app-backend \
                                -Dsonar.sources=backend/src,backend \
                                -Dsonar.exclusions=**/node_modules/**,**/dist/**,**/build/** \
                                -Dsonar.javascript.lcov.reportPaths=backend/coverage/lcov.info \
                                -Dsonar.host.url=${env.SONAR_HOST_URL} \
                                -Dsonar.login=${env.SONAR_TOKEN}
                        """
                    }
                }
            }
        }
        
        // NEW: Quality Gate Check
        stage('Quality Gate') {
            steps {
                echo 'Checking quality gate...'
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building backend...'
                dir('backend') {
                    sh 'npm run build || echo "No build script, skipping"'
                }
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline completed'
            cleanWs()
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
```

2. **Update environment variables:**
   - Replace `notes-app-backend` with your actual project key
   - Replace `SONAR_HOST_URL` and `SONAR_TOKEN` with your values
   - Or use Jenkins credentials for tokens

3. **Alternative: Use sonar-project.properties:**
   - If you created `backend/sonar-project.properties` in task-012, you can simplify:
```groovy
stage('SonarQube Analysis') {
    steps {
        script {
            def scannerHome = tool 'SonarQube Scanner'
            withSonarQubeEnv('SonarQube') {
                dir('backend') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
    }
}
```

4. **Save and commit Jenkinsfile**

**Key Points:**
- `withSonarQubeEnv`: Provides SonarQube server connection
- `waitForQualityGate`: Waits for analysis and checks quality gate
- `abortPipeline: true`: Fails pipeline if quality gate fails

---

#### Step A4: Add SonarQube Stage to Frontend Jenkinsfile

**Objective:** Integrate SonarQube analysis into frontend pipeline

**Instructions:**

1. **Update `frontend/Jenkinsfile` similarly:**

```groovy
stage('SonarQube Analysis') {
    steps {
        echo 'Running SonarQube analysis...'
        script {
            def scannerHome = tool 'SonarQube Scanner'
            withSonarQubeEnv('SonarQube') {
                sh """
                    ${scannerHome}/bin/sonar-scanner \
                        -Dsonar.projectKey=notes-app-frontend \
                        -Dsonar.sources=frontend/src,frontend/pages,frontend/components \
                        -Dsonar.exclusions=**/node_modules/**,**/.next/**,**/out/** \
                        -Dsonar.javascript.lcov.reportPaths=frontend/coverage/lcov.info \
                        -Dsonar.host.url=${env.SONAR_HOST_URL} \
                        -Dsonar.login=${env.SONAR_TOKEN}
                """
            }
        }
    }
}

stage('Quality Gate') {
    steps {
        timeout(time: 5, unit: 'MINUTES') {
            waitForQualityGate abortPipeline: true
        }
    }
}
```

2. **Or use sonar-project.properties:**
```groovy
stage('SonarQube Analysis') {
    steps {
        script {
            def scannerHome = tool 'SonarQube Scanner'
            withSonarQubeEnv('SonarQube') {
                dir('frontend') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
    }
}
```

3. **Save and commit**

---

#### Step A5: Test Jenkins Pipeline with SonarQube

**Objective:** Verify SonarQube integration works in Jenkins

**Instructions:**

1. **Trigger pipeline:**
   - Go to Jenkins dashboard
   - Click on your pipeline job
   - Click "Build Now"

2. **Monitor pipeline:**
   - Watch SonarQube Analysis stage
   - Check console output for analysis progress
   - Wait for Quality Gate stage

3. **Verify results:**
   - Check SonarQube dashboard for analysis results
   - Verify quality gate status
   - Check pipeline passed/failed based on quality gate

**Expected Output:**
- SonarQube analysis runs successfully
- Results appear in SonarQube dashboard
- Quality gate check completes
- Pipeline passes if quality gate passes

**Troubleshooting:**
- **Issue**: Scanner not found
  - **Solution**: Verify SonarQube Scanner is configured in Global Tool Configuration
- **Issue**: Authentication failed
  - **Solution**: Check token is correct in Jenkins credentials
- **Issue**: Quality gate timeout
  - **Solution**: Increase timeout or check SonarQube server is accessible

---

### Part B: GitHub Actions Integration

#### Step B1: Add SonarQube Secrets to GitHub

**Objective:** Store SonarQube credentials as GitHub secrets

**Instructions:**

1. **Go to GitHub repository:**
   - Navigate to your repository
   - Click "Settings"
   - Click "Secrets and variables" > "Actions"

2. **Add SonarQube token:**
   - Click "New repository secret"
   - **Name**: `SONAR_TOKEN`
   - **Value**: Paste your SonarQube token (from task-011)
   - Click "Add secret"

3. **Add organization key (for SonarCloud):**
   - Click "New repository secret"
   - **Name**: `SONAR_ORGANIZATION`
   - **Value**: Your SonarCloud organization key
   - Click "Add secret"

4. **Verify secrets:**
   - Secrets should appear in the list
   - They will be available in workflows as `${{ secrets.SONAR_TOKEN }}`

**Expected Output:**
- Secrets added to GitHub repository
- Available for use in workflows

---

#### Step B2: Add SonarQube to Backend GitHub Actions Workflow

**Objective:** Integrate SonarQube analysis into backend workflow

**Instructions:**

1. **Update `.github/workflows/backend.yml` to add SonarQube job:**

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
          
  # NEW: SonarQube Analysis
  sonarqube:
    name: SonarQube Analysis
    runs-on: ubuntu-latest
    needs: [quality-checks, test]
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
        with:
          fetch-depth: 0  # Shallow clones should be disabled for better analysis
          
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
          
      - name: Generate coverage report
        run: |
          cd backend
          npm run test:coverage || npm test -- --coverage
          
      # For SonarCloud
      - name: SonarCloud Scan
        uses: SonarSource/sonarcloud-github-action@master
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        with:
          projectBaseDir: backend
          args: >
            -Dsonar.projectKey=notes-app-backend
            -Dsonar.organization=${{ secrets.SONAR_ORGANIZATION }}
            
      # For self-hosted SonarQube (alternative)
      # - name: SonarQube Scan
      #   uses: sonarsource/sonarqube-scan-action@master
      #   env:
      #     SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
      #     SONAR_HOST_URL: ${{ secrets.SONAR_HOST_URL }}
      #   with:
      #     projectBaseDir: backend
          
  build:
    name: Build Backend
    runs-on: ubuntu-latest
    needs: [quality-checks, test, sonarqube]
    
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
```

2. **Update project key:**
   - Replace `notes-app-backend` with your actual project key
   - Ensure `SONAR_ORGANIZATION` secret matches your organization

3. **Save and commit**

**Key Points:**
- `fetch-depth: 0`: Full git history for better analysis
- SonarCloud action handles analysis and quality gate
- Coverage report generated before analysis
- Build depends on SonarQube passing

---

#### Step B3: Add SonarQube to Frontend GitHub Actions Workflow

**Objective:** Integrate SonarQube analysis into frontend workflow

**Instructions:**

1. **Update `.github/workflows/frontend.yml` similarly:**

```yaml
  sonarqube:
    name: SonarQube Analysis
    runs-on: ubuntu-latest
    needs: [quality-checks, test]
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
        with:
          fetch-depth: 0
          
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
          
      - name: Generate coverage report
        run: |
          cd frontend
          npm run test:coverage || npm test -- --coverage --watchAll=false || echo "Coverage not configured"
          
      - name: SonarCloud Scan
        uses: SonarSource/sonarcloud-github-action@master
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        with:
          projectBaseDir: frontend
          args: >
            -Dsonar.projectKey=notes-app-frontend
            -Dsonar.organization=${{ secrets.SONAR_ORGANIZATION }}
```

2. **Update project key for frontend**

3. **Save and commit**

---

#### Step B4: Configure Pull Request Decoration (SonarCloud)

**Objective:** Show SonarQube results in pull requests

**Instructions:**

1. **Enable PR decoration in SonarCloud:**
   - Go to SonarCloud dashboard
   - Click on your project
   - Go to "Project Settings" > "Pull Requests"
   - Enable "Pull Request Decoration"
   - Connect GitHub integration if not already connected

2. **Verify PR decoration:**
   - Create a pull request
   - SonarQube analysis should run automatically
   - Results should appear as PR checks
   - Quality gate status shown in PR

**Expected Output:**
- PR decoration enabled
- SonarQube results appear in PRs
- Quality gate status visible

---

#### Step B5: Test GitHub Actions Workflow with SonarQube

**Objective:** Verify SonarQube integration works in GitHub Actions

**Instructions:**

1. **Commit and push changes:**
```bash
git add .github/workflows/
git commit -m "Add SonarQube analysis to workflows"
git push
```

2. **Monitor workflow:**
   - Go to GitHub repository
   - Click "Actions" tab
   - Watch workflow execute
   - Check SonarQube job runs

3. **Verify results:**
   - Check SonarQube dashboard for analysis
   - Verify quality gate status
   - Check workflow passes/fails based on quality gate

**Expected Output:**
- SonarQube analysis runs in workflow
- Results appear in SonarQube dashboard
- Quality gate check completes
- Workflow passes if quality gate passes

---

## Notes App Specifics

### How This Applies to Notes App

**Jenkins Integration:**
- SonarQube analysis runs in both backend and frontend pipelines
- Quality gates prevent deploying bad code
- Analysis results visible in Jenkins console
- Quality gate status determines pipeline success

**GitHub Actions Integration:**
- SonarQube analysis runs on every push/PR
- Quality gates block merging if standards aren't met
- PR decoration shows results in pull requests
- Analysis results visible in workflow logs

**Quality Gates:**
- Enforce code quality standards
- Prevent merging code with critical issues
- Track technical debt
- Monitor test coverage

---

## Verification

### How to Verify the Task is Complete

**Functional Verification:**
1. SonarQube integrated into Jenkins pipelines
2. SonarQube integrated into GitHub Actions workflows
3. Analysis runs automatically on code changes
4. Quality gate checks execute
5. Pipeline/workflow fails if quality gate fails
6. Results visible in SonarQube dashboard

**Technical Verification:**
1. Jenkins plugins installed and configured
2. SonarQube server configured in Jenkins
3. GitHub secrets configured
4. Workflow files updated with SonarQube steps
5. Quality gate checks working

**Commands to Run:**
```bash
# Verify workflow files updated
ls .github/workflows/backend.yml
ls .github/workflows/frontend.yml

# Check Jenkinsfile updated
ls backend/Jenkinsfile
ls frontend/Jenkinsfile

# Test workflow (push changes)
git add .
git commit -m "Test SonarQube integration"
git push
```

**Expected Results:**
- SonarQube analysis runs in CI/CD
- Quality gates enforce standards
- Bad code cannot be merged
- Analysis results tracked over time

---

## Troubleshooting

### Common Issues and Solutions

**Issue 1: Jenkins - SonarQube Scanner Not Found**

**Symptoms:**
- Pipeline fails with "tool not found"
- Scanner command not found

**Causes:**
- SonarQube Scanner not configured in Jenkins
- Tool name mismatch

**Solutions:**
1. Verify SonarQube Scanner in Global Tool Configuration
2. Check tool name matches Jenkinsfile
3. Reinstall scanner if needed

---

**Issue 2: GitHub Actions - Authentication Failed**

**Symptoms:**
- SonarQube job fails with authentication error
- Token invalid

**Causes:**
- Token incorrect or expired
- Secret not configured correctly

**Solutions:**
1. Verify SONAR_TOKEN secret is correct
2. Regenerate token if expired
3. Check secret name matches workflow

---

**Issue 3: Quality Gate Always Fails**

**Symptoms:**
- Quality gate fails even with good code
- Conditions too strict

**Causes:**
- Quality gate conditions too strict
- Coverage threshold too high
- Issues in code

**Solutions:**
1. Review quality gate conditions
2. Adjust thresholds if needed
3. Fix code issues
4. Start with lenient gates and tighten over time

---

## Best Practices

### Security Best Practices
- Store tokens in secrets/credentials, never in code
- Rotate tokens regularly
- Use least privilege for tokens
- Don't commit tokens to repository

### Operational Best Practices
- Run analysis on every code change
- Enforce quality gates in CI/CD
- Review SonarQube reports regularly
- Track quality trends over time

### Code Quality Best Practices
- Fix critical issues immediately
- Address high-severity issues promptly
- Maintain good test coverage
- Reduce technical debt gradually

---

## Additional Resources

### Documentation
- [SonarQube Jenkins Plugin](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner-for-jenkins/)
- [SonarCloud GitHub Action](https://github.com/SonarSource/sonarcloud-github-action)
- [Quality Gates](https://docs.sonarqube.org/latest/user-guide/quality-gates/)

### Learning Resources
- [SonarQube CI/CD Integration](https://docs.sonarqube.org/latest/analysis/overview/)

---

## Next Steps

After completing this task:

1. **Immediate Next Task**: `task-008-add-docker-build-and-push.md` - Build and push Docker images
2. **Related Tasks**: 
   - Review SonarQube reports regularly
   - Fix identified issues
3. **Future Learning**: 
   - Advanced SonarQube configuration
   - Custom quality profiles
   - Quality gate optimization

---

## Reflection Questions

1. How do quality gates prevent bad code from merging?
2. What is the benefit of automated code analysis in CI/CD?
3. How does PR decoration help code review?
4. Why is it important to run analysis on every code change?

---

## Task Checklist

- [ ] Read and understood the theory section
- [ ] Completed all prerequisite checks
- [ ] Installed SonarQube plugins in Jenkins
- [ ] Configured SonarQube server in Jenkins
- [ ] Added SonarQube stage to backend Jenkinsfile
- [ ] Added SonarQube stage to frontend Jenkinsfile
- [ ] Added SonarQube secrets to GitHub
- [ ] Added SonarQube job to backend workflow
- [ ] Added SonarQube job to frontend workflow
- [ ] Configured PR decoration (SonarCloud)
- [ ] Tested Jenkins pipeline with SonarQube
- [ ] Tested GitHub Actions workflow with SonarQube
- [ ] Verified quality gates work
- [ ] Reviewed troubleshooting section
- [ ] Applied best practices
- [ ] Ready to move to next task

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed  
**Date Started:** [Date]  
**Date Completed:** [Date]  
**Time Spent:** [Hours/Days]  
**Mentor Notes:** [Space for mentor feedback]

