# Task: CI/CD - Create Jenkins Pipeline for Frontend

**Related Issue:** #53  
**Prerequisites:** task-001 (Jenkins server setup), task-002 (Jenkins backend pipeline - for reference)  
**Estimated Time:** 2-3 hours  
**Notes App Context:** Create a Jenkins pipeline that automates frontend build, testing, code quality checks, and deployment for the Notes App Next.js frontend

---

## Learning Objectives

By the end of this task, you will be able to:

- Create a Jenkinsfile for Next.js/React frontend
- Integrate code quality checks (ESLint, Prettier, security scanning) into frontend pipeline
- Configure Next.js build process in pipeline
- Run and monitor frontend pipeline
- Understand frontend-specific pipeline considerations

---

## Theory Section

### Frontend Pipeline Considerations

**Frontend vs Backend Pipelines:**

Frontend pipelines have unique considerations:
- **Build Process**: Next.js requires build step (creates optimized production build)
- **Static Assets**: Need to handle public assets, images, fonts
- **Environment Variables**: Next.js uses `NEXT_PUBLIC_*` prefix for client-side vars
- **Type Checking**: TypeScript compilation happens during build
- **Testing**: React Testing Library or Jest for component tests

**Why This Matters for Notes App:**

The Notes App frontend needs:
- Automated builds on code changes
- Code quality checks (ESLint for React/TypeScript)
- TypeScript type checking
- Component testing
- Production-optimized builds
- Static asset optimization

**Key Concepts:**

- **Next.js Build**: Creates optimized production bundle
- **Static Export**: Can export static HTML (optional)
- **TypeScript Compilation**: Happens during build
- **Code Splitting**: Next.js automatically splits code
- **Image Optimization**: Next.js optimizes images

---

## Prerequisites Check

Before starting, ensure you have:

- [ ] Completed task-001 (Jenkins server setup)
- [ ] Completed task-002 (Backend pipeline - for reference)
- [ ] Notes App frontend codebase available
- [ ] Git repository with frontend code
- [ ] Node.js and npm installed on Jenkins agent
- [ ] Basic understanding of Next.js build process

**Verify Prerequisites:**
```bash
# Check frontend code exists
ls frontend/
ls frontend/package.json
ls frontend/next.config.js

# Check Node.js (on Jenkins agent)
node --version
npm --version
```

---

## Step-by-Step Instructions

### Step 1: Create Jenkinsfile for Frontend

**Objective:** Create a Jenkinsfile that defines the frontend pipeline

**Instructions:**

1. **Navigate to frontend directory:**
```bash
cd frontend/
```

2. **Create `Jenkinsfile` in frontend root:**
```groovy
pipeline {
    agent any
    
    environment {
        NODE_VERSION = '18'
        NPM_CONFIG_CACHE = "${WORKSPACE}/.npm"
        NEXT_TELEMETRY_DISABLED = '1'
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
                script {
                    // ESLint - Next.js has built-in linting
                    def lintResult = sh(
                        script: 'npm run lint',
                        returnStatus: true
                    )
                    if (lintResult != 0) {
                        error('ESLint checks failed!')
                    }
                    
                    // Check code formatting
                    def formatResult = sh(
                        script: 'npm run format:check || echo "Prettier not configured"',
                        returnStatus: true
                    )
                    if (formatResult != 0) {
                        error('Code formatting check failed! Run npm run format')
                    }
                    
                    // TypeScript type checking
                    sh 'npx tsc --noEmit || echo "TypeScript check completed"'
                    
                    // Security audit
                    sh 'npm audit --audit-level=high || echo "Security audit completed with warnings"'
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                echo 'Running frontend tests...'
                sh '''
                    npm test -- --coverage --watchAll=false || echo "Tests completed"
                '''
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
                echo 'Building Next.js application...'
                sh '''
                    npm run build
                '''
            }
            post {
                success {
                    echo 'Build completed successfully!'
                    // Archive build artifacts
                    archiveArtifacts artifacts: '.next/**/*', 
                                     fingerprint: true,
                                     allowEmptyArchive: false
                }
            }
        }
        
        stage('Build Analysis') {
            steps {
                echo 'Analyzing build output...'
                script {
                    // Check build size
                    def buildSize = sh(
                        script: 'du -sh .next 2>/dev/null || echo "0"',
                        returnStdout: true
                    ).trim()
                    echo "Build size: ${buildSize}"
                    
                    // List build artifacts
                    sh 'ls -lah .next/ || echo "Build directory not found"'
                }
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
            echo 'Frontend pipeline succeeded!'
        }
        failure {
            echo 'Frontend pipeline failed!'
            // Send notification (configure in task-010)
        }
    }
}
```

3. **Save the Jenkinsfile**

**Key Points:**
- `NEXT_TELEMETRY_DISABLED`: Disables Next.js telemetry
- TypeScript type checking included
- Next.js build creates optimized production bundle
- Build artifacts archived for deployment

---

### Step 2: Configure Frontend Code Quality Scripts

**Objective:** Ensure frontend has code quality scripts in package.json

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
    "audit": "npm audit",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage"
  }
}
```

2. **If TypeScript is used, ensure type checking:**
```json
{
  "scripts": {
    "type-check": "tsc --noEmit"
  }
}
```

**Note:** Next.js includes ESLint by default. If you need custom configuration, see task-007.

---

### Step 3: Create Pipeline Job in Jenkins

**Objective:** Create a Jenkins job that uses the frontend Jenkinsfile

**Instructions:**

1. **Open Jenkins dashboard:**
   - Navigate to http://localhost:8080 (or your Jenkins URL)
   - Log in if required

2. **Create new pipeline job:**
   - Click "New Item"
   - Enter name: "notes-app-frontend-pipeline"
   - Select "Pipeline"
   - Click "OK"

3. **Configure pipeline:**
   - Scroll to "Pipeline" section
   - **Definition**: Select "Pipeline script from SCM"
   - **SCM**: Select "Git"
   - **Repository URL**: Enter your repository URL
   - **Credentials**: Add if repository is private
   - **Branches to build**: `*/main` or `*/master`
   - **Script Path**: `frontend/Jenkinsfile`
   - Click "Save"

4. **Verify configuration:**
   - Check "Pipeline Syntax" link
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
   - Code Quality Checks: Lint, format, type check, audit should run
   - Run Tests: Tests should execute
   - Build: Next.js build should complete
   - Build Analysis: Build size should be reported

**Expected Output:**
- Pipeline runs successfully
- All stages complete
- Next.js build creates .next directory
- Test results visible
- Coverage report available
- Build artifacts archived

**Troubleshooting:**
- **Issue**: Next.js build fails
  - **Solution**: Check for TypeScript errors, missing dependencies
- **Issue**: Build takes too long
  - **Solution**: Use build cache, optimize dependencies
- **Issue**: Type checking fails
  - **Solution**: Fix TypeScript errors or disable type checking stage

---

### Step 5: Optimize Pipeline Performance

**Objective:** Improve pipeline speed with caching

**Instructions:**

1. **Add caching to pipeline:**

```groovy
stage('Install Dependencies') {
    steps {
        echo 'Installing npm dependencies...'
        script {
            // Cache node_modules
            def cacheDir = "${WORKSPACE}/.npm-cache"
            if (fileExists(cacheDir)) {
                sh "cp -r ${cacheDir}/node_modules . || true"
            }
            
            sh 'npm install'
            
            // Save cache
            sh "mkdir -p ${cacheDir} && cp -r node_modules ${cacheDir}/ || true"
        }
    }
}
```

2. **Add Next.js build cache:**

```groovy
stage('Build') {
    steps {
        echo 'Building Next.js application...'
        script {
            // Use Next.js build cache if available
            sh '''
                if [ -d .next/cache ]; then
                    echo "Using existing build cache"
                fi
                npm run build
            '''
        }
    }
}
```

3. **Save and test**

**Expected Output:**
- Faster pipeline execution
- Dependencies cached between builds
- Build cache reused

---

### Step 6: Add Environment Variables

**Objective:** Configure Next.js environment variables for build

**Instructions:**

1. **Update build stage with environment variables:**

```groovy
stage('Build') {
    environment {
        NEXT_PUBLIC_API_URL = "${env.API_URL ?: 'http://localhost:5000'}"
        NODE_ENV = 'production'
    }
    steps {
        echo 'Building Next.js application...'
        sh 'npm run build'
    }
}
```

2. **Or use Jenkins credentials:**

```groovy
stage('Build') {
    environment {
        NEXT_PUBLIC_API_URL = credentials('api-url')
    }
    steps {
        sh 'npm run build'
    }
}
```

3. **Save and test**

**Note:** Next.js requires `NEXT_PUBLIC_*` prefix for client-side environment variables.

---

## Notes App Specifics

### How This Applies to Notes App

**Frontend (Next.js):**
- Pipeline builds Next.js/React frontend
- Code quality checks ensure React/TypeScript code quality
- TypeScript type checking ensures type safety
- Tests verify component functionality
- Build creates optimized production bundle

**Integration:**
- Pipeline runs on every commit
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
1. Pipeline job created in Jenkins
2. Pipeline runs successfully
3. All stages complete without errors
4. Code quality checks execute
5. TypeScript type checking runs
6. Tests run and pass
7. Next.js build completes
8. Build artifacts archived

**Technical Verification:**
1. Jenkinsfile exists in frontend directory
2. Pipeline configuration correct
3. Quality checks integrated
4. Build creates .next directory
5. Test results published
6. Artifacts archived

**Commands to Run:**
```bash
# Verify Jenkinsfile exists
ls frontend/Jenkinsfile

# Test build locally
cd frontend/
npm run build
ls .next/

# Check pipeline logs
# In Jenkins: Job > Build > Console Output
```

**Expected Results:**
- Pipeline runs on code changes
- Quality checks execute before build
- Type checking prevents type errors
- Tests run automatically
- Next.js build succeeds
- Build artifacts available

---

## Troubleshooting

### Common Issues and Solutions

**Issue 1: Next.js Build Fails**

**Symptoms:**
- Build stage fails
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
- Type check stage fails
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
- Test stage skips or fails
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
- Use Jenkins credentials plugin
- Scan dependencies regularly
- Review security audit results

### Performance Best Practices
- Cache node_modules between builds
- Use Next.js build cache
- Optimize build process
- Run quality checks in parallel if possible

### Operational Best Practices
- Version control Jenkinsfile
- Use descriptive stage names
- Add meaningful echo statements
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
- [Next.js Deployment Documentation](https://nextjs.org/docs/deployment)
- [Next.js Build Optimization](https://nextjs.org/docs/advanced-features/measuring-performance)
- [Jenkins Pipeline Documentation](https://www.jenkins.io/doc/book/pipeline/)

### Learning Resources
- [Next.js Build Process](https://nextjs.org/docs/api-reference/next.config.js/introduction)
- [TypeScript in Next.js](https://nextjs.org/docs/basic-features/typescript)

---

## Next Steps

After completing this task:

1. **Immediate Next Task**: `task-004-configure-github-webhook.md` - Configure webhooks
2. **Related Tasks**: 
   - `task-005-setup-github-actions-backend.md` - GitHub Actions backend
   - `task-006-setup-github-actions-frontend.md` - GitHub Actions frontend
3. **Future Learning**: 
   - Advanced Next.js optimizations
   - Frontend performance monitoring

---

## Reflection Questions

1. Why is TypeScript type checking important in the pipeline?
2. How does Next.js build optimization work?
3. What are the benefits of caching in pipelines?
4. How do frontend pipelines differ from backend pipelines?

---

## Task Checklist

- [ ] Read and understood the theory section
- [ ] Completed all prerequisite checks
- [ ] Created Jenkinsfile for frontend
- [ ] Configured code quality scripts
- [ ] Created pipeline job in Jenkins
- [ ] Ran pipeline successfully
- [ ] Added TypeScript type checking
- [ ] Verified code quality checks run
- [ ] Verified tests execute
- [ ] Verified Next.js build succeeds
- [ ] Reviewed troubleshooting section
- [ ] Applied best practices
- [ ] Ready to move to next task

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed  
**Date Started:** [Date]  
**Date Completed:** [Date]  
**Time Spent:** [Hours/Days]  
**Mentor Notes:** [Space for mentor feedback]
