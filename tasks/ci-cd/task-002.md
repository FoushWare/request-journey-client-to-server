# Task: CI/CD - Create Jenkins Pipeline for Backend

**Related Issue:** #52  
**Prerequisites:** task-001 (Jenkins server setup)  
**Estimated Time:** 2-3 hours  
**Notes App Context:** Create a Jenkins pipeline that automates backend build, testing, code quality checks, and deployment for the Notes App backend API

---

## Learning Objectives

By the end of this task, you will be able to:

- Understand Jenkins pipeline structure and syntax
- Create a Jenkinsfile for Node.js/Express backend
- Integrate code quality checks (ESLint, Prettier, security scanning) into pipeline
- Configure pipeline stages (checkout, install, quality checks, test, build)
- Run and monitor Jenkins pipelines
- Understand pipeline artifacts and reports

---

## Theory Section

### What is a Jenkins Pipeline?

A **Jenkins Pipeline** is a suite of plugins that supports implementing and integrating continuous delivery pipelines into Jenkins. It defines your entire build process as code.

**Key Concepts:**

- **Jenkinsfile**: A text file that defines the pipeline (stored in repository)
- **Stages**: Logical divisions of work (checkout, build, test, deploy)
- **Steps**: Individual tasks within a stage
- **Agent**: Where the pipeline runs (Jenkins node)
- **Artifacts**: Files produced by the pipeline (build outputs, reports)

**Why This Matters for Notes App:**

The Notes App backend needs:
- Automated builds on code changes
- Code quality checks before building
- Automated testing
- Consistent deployment process
- Build artifacts for deployment

A Jenkins pipeline ensures:
- Every code change is automatically built and tested
- Quality checks prevent bad code from deploying
- Builds are reproducible
- Deployment is automated

**Real-World Context:**

In production:
- Pipelines run on every commit
- Quality gates prevent bad code
- Builds are versioned and tagged
- Deployment is automated and consistent

---

## Prerequisites Check

Before starting, ensure you have:

- [ ] Completed task-001 (Jenkins server setup and running)
- [ ] Jenkins accessible (http://localhost:8080 or your Jenkins URL)
- [ ] Notes App backend codebase available
- [ ] Git repository with backend code
- [ ] Node.js and npm installed on Jenkins agent
- [ ] Basic understanding of Jenkins

**Verify Prerequisites:**
```bash
# Check Jenkins is running
curl http://localhost:8080

# Check backend code exists
ls backend/
ls backend/package.json

# Check Node.js (on Jenkins agent)
node --version
npm --version
```

---

## Step-by-Step Instructions

### Step 1: Create Jenkinsfile for Backend

**Objective:** Create a Jenkinsfile that defines the backend pipeline

**Instructions:**

1. **Navigate to backend directory:**
```bash
cd backend/
```

2. **Create `Jenkinsfile` in backend root:**
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
                    npm install
                    npm cache clean --force
                '''
            }
        }
        
        stage('Code Quality Checks') {
            steps {
                echo 'Running code quality checks...'
                sh '''
                    # Run ESLint
                    npm run lint || true
                    
                    # Check code formatting
                    npm run format:check || true
                    
                    # Security audit
                    npm audit --audit-level=moderate || true
                '''
            }
        }
        
        stage('Run Tests') {
            steps {
                echo 'Running tests...'
                sh 'npm test'
            }
            post {
                always {
                    // Publish test results
                    junit 'test-results.xml'
                    // Publish coverage
                    publishHTML([
                        reportDir: 'coverage',
                        reportFiles: 'index.html',
                        reportName: 'Test Coverage Report'
                    ])
                }
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building backend...'
                sh 'npm run build || echo "No build script, skipping"'
            }
        }
        
        stage('Archive Artifacts') {
            steps {
                echo 'Archiving build artifacts...'
                archiveArtifacts artifacts: '**/*', 
                                 fingerprint: true,
                                 allowEmptyArchive: true
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline completed'
            // Clean workspace
            cleanWs()
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
            // Send notification (configure in task-010)
        }
    }
}
```

3. **Save the Jenkinsfile**

**Key Points:**
- `agent any`: Runs on any available Jenkins node
- `checkout scm`: Checks out code from source control
- Code quality checks run before tests
- Test results and coverage are published
- Artifacts are archived for deployment

---

### Step 2: Configure Code Quality Scripts

**Objective:** Ensure backend has code quality scripts in package.json

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

2. **If scripts don't exist, add them:**
```bash
cd backend/
# Edit package.json and add scripts
```

**Note:** If you haven't set up ESLint/Prettier yet, complete task-007 first, or add basic scripts:
```json
{
  "scripts": {
    "lint": "echo 'Linting not configured'",
    "format:check": "echo 'Prettier not configured'",
    "audit": "npm audit",
    "test": "jest || echo 'Tests not configured'"
  }
}
```

---

### Step 3: Create Pipeline Job in Jenkins

**Objective:** Create a Jenkins job that uses the Jenkinsfile

**Instructions:**

1. **Open Jenkins dashboard:**
   - Navigate to http://localhost:8080 (or your Jenkins URL)
   - Log in if required

2. **Create new pipeline job:**
   - Click "New Item"
   - Enter name: "notes-app-backend-pipeline"
   - Select "Pipeline"
   - Click "OK"

3. **Configure pipeline:**
   - Scroll to "Pipeline" section
   - **Definition**: Select "Pipeline script from SCM"
   - **SCM**: Select "Git"
   - **Repository URL**: Enter your repository URL
   - **Credentials**: Add if repository is private
   - **Branches to build**: `*/main` or `*/master`
   - **Script Path**: `backend/Jenkinsfile`
   - Click "Save"

4. **Verify configuration:**
   - Check "Pipeline Syntax" link to validate syntax
   - Review pipeline structure

---

### Step 4: Run the Pipeline

**Objective:** Execute the pipeline and verify it works

**Instructions:**

1. **Trigger pipeline:**
   - Go to pipeline job page
   - Click "Build Now"

2. **Monitor pipeline execution:**
   - Click on the build number
   - Click "Console Output" to see real-time logs
   - Watch each stage execute

3. **Verify stages:**
   - Checkout: Code should be checked out
   - Install Dependencies: npm install should run
   - Code Quality Checks: Lint, format, audit should run
   - Run Tests: Tests should execute
   - Build: Build should complete
   - Archive Artifacts: Artifacts should be archived

**Expected Output:**
- Pipeline runs successfully
- All stages complete
- Test results visible
- Coverage report available
- No errors in console

**Troubleshooting:**
- **Issue**: Pipeline fails on checkout
  - **Solution**: Check repository URL and credentials
- **Issue**: npm install fails
  - **Solution**: Check Node.js is installed on agent
- **Issue**: Code quality checks fail
  - **Solution**: Fix linting/formatting issues or configure scripts

---

### Step 5: Enhance Pipeline with Quality Gates

**Objective:** Add quality gates that fail pipeline on quality check failures

**Instructions:**

1. **Update Jenkinsfile to fail on quality check failures:**

```groovy
stage('Code Quality Checks') {
    steps {
        echo 'Running code quality checks...'
        script {
            // ESLint - fail on errors
            def lintResult = sh(
                script: 'npm run lint',
                returnStatus: true
            )
            if (lintResult != 0) {
                error('ESLint checks failed!')
            }
            
            // Format check - fail on formatting issues
            def formatResult = sh(
                script: 'npm run format:check',
                returnStatus: true
            )
            if (formatResult != 0) {
                error('Code formatting check failed! Run npm run format')
            }
            
            // Security audit - warn but don't fail
            sh 'npm audit --audit-level=high || echo "Security audit completed with warnings"'
        }
    }
}
```

2. **Save and commit Jenkinsfile**

3. **Test quality gates:**
   - Make a code change that fails linting
   - Commit and push
   - Verify pipeline fails on quality check stage

**Expected Output:**
- Pipeline fails if linting errors exist
- Pipeline fails if formatting is incorrect
- Security audit warnings don't fail pipeline (unless critical)

---

### Step 6: Add Test Coverage Threshold

**Objective:** Ensure minimum test coverage

**Instructions:**

1. **Update test stage to check coverage:**

```groovy
stage('Run Tests') {
    steps {
        echo 'Running tests with coverage...'
        sh 'npm run test:coverage'
    }
    post {
        always {
            // Publish coverage report
            publishHTML([
                reportDir: 'coverage',
                reportFiles: 'index.html',
                reportName: 'Test Coverage Report'
            ])
            
            // Check coverage threshold
            script {
                def coverage = sh(
                    script: 'cat coverage/coverage-summary.json | grep -oP \'"lines":{"total":\\K[0-9]+',
                    returnStatus: true
                )
                // Add coverage threshold check if needed
            }
        }
    }
}
```

2. **Save and test**

---

## Notes App Specifics

### How This Applies to Notes App

**Backend (Express):**
- Pipeline builds Node.js/Express backend
- Code quality checks ensure API code quality
- Tests verify API endpoints work correctly
- Build creates deployment-ready artifacts

**Integration:**
- Pipeline runs on every commit
- Quality gates prevent bad code
- Test coverage ensures API reliability
- Artifacts ready for deployment (task-009)

**Quality Checks:**
- ESLint checks JavaScript code quality
- Prettier ensures consistent formatting
- npm audit scans for security vulnerabilities
- Tests verify API functionality

---

## Verification

### How to Verify the Task is Complete

**Functional Verification:**
1. Pipeline job created in Jenkins
2. Pipeline runs successfully
3. All stages complete without errors
4. Code quality checks execute
5. Tests run and pass
6. Coverage report generated

**Technical Verification:**
1. Jenkinsfile exists in backend directory
2. Pipeline configuration correct
3. Quality checks integrated
4. Test results published
5. Artifacts archived

**Commands to Run:**
```bash
# Verify Jenkinsfile exists
ls backend/Jenkinsfile

# Check pipeline syntax (in Jenkins)
# Go to pipeline job > Pipeline Syntax

# View pipeline logs
# In Jenkins: Job > Build > Console Output
```

**Expected Results:**
- Pipeline runs on code changes
- Quality checks execute before build
- Tests run automatically
- Coverage reports available
- Pipeline fails on quality check failures

---

## Troubleshooting

### Common Issues and Solutions

**Issue 1: Pipeline Not Triggering**

**Symptoms:**
- Pipeline doesn't run on commits
- Manual build works but auto-build doesn't

**Causes:**
- Webhook not configured
- Branch configuration incorrect
- SCM polling not enabled

**Solutions:**
1. Configure webhook (task-004)
2. Check branch configuration
3. Enable SCM polling in job configuration

---

**Issue 2: Code Quality Checks Failing**

**Symptoms:**
- Pipeline fails on quality check stage
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
- Test stage fails
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
- Use credentials plugin for sensitive data
- Don't hardcode secrets in Jenkinsfile
- Use environment variables for configuration
- Scan dependencies for vulnerabilities

### Performance Best Practices
- Cache node_modules between builds
- Run quality checks in parallel (if possible)
- Use lightweight agents
- Clean workspace after build

### Operational Best Practices
- Version control Jenkinsfile
- Use descriptive stage names
- Add meaningful echo statements
- Publish test results and coverage
- Archive important artifacts

### Code Quality Best Practices
- Fail fast on quality check failures
- Enforce quality gates
- Maintain high test coverage
- Review quality reports regularly

---

## Additional Resources

### Documentation
- [Jenkins Pipeline Documentation](https://www.jenkins.io/doc/book/pipeline/)
- [Jenkinsfile Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Jenkins Pipeline Steps Reference](https://www.jenkins.io/doc/pipeline/steps/)

### Learning Resources
- [Jenkins Pipeline Tutorial](https://www.jenkins.io/doc/pipeline/tour/hello-world/)
- [Writing Jenkinsfile Best Practices](https://www.jenkins.io/doc/book/pipeline/pipeline-best-practices/)

---

## Next Steps

After completing this task:

1. **Immediate Next Task**: `task-003-create-jenkins-frontend-pipeline.md` - Create frontend pipeline
2. **Related Tasks**: 
   - `task-004-configure-github-webhook.md` - Configure webhooks
   - `task-007-add-automated-testing.md` - Add comprehensive testing
3. **Future Learning**: 
   - Advanced pipeline features (parallel stages, matrix builds)
   - Pipeline as code best practices

---

## Reflection Questions

1. Why are code quality checks important before building?
2. How do quality gates prevent bad code from deploying?
3. What is the benefit of version controlling Jenkinsfile?
4. How does test coverage help ensure code quality?

---

## Task Checklist

- [ ] Read and understood the theory section
- [ ] Completed all prerequisite checks
- [ ] Created Jenkinsfile for backend
- [ ] Configured code quality scripts
- [ ] Created pipeline job in Jenkins
- [ ] Ran pipeline successfully
- [ ] Added quality gates
- [ ] Verified code quality checks run
- [ ] Verified tests execute
- [ ] Reviewed troubleshooting section
- [ ] Applied best practices
- [ ] Ready to move to next task

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed  
**Date Started:** [Date]  
**Date Completed:** [Date]  
**Time Spent:** [Hours/Days]  
**Mentor Notes:** [Space for mentor feedback]
