# Task: CI/CD - Configure SonarQube Project for Notes App

**Related Issue:** N/A (New task for code quality)  
**Prerequisites:** task-011 (SonarQube setup)  
**Estimated Time:** 2-3 hours  
**Notes App Context:** Configure SonarQube project settings, quality profiles, quality gates, and analysis parameters specifically for the Notes App frontend and backend codebases

---

## Learning Objectives

By the end of this task, you will be able to:

- Configure sonar-project.properties files
- Set up code analysis parameters
- Configure quality profiles and rules
- Set up quality gates
- Configure file exclusions
- Test local SonarQube analysis
- Understand SonarQube metrics and reports

---

## Theory Section

### SonarQube Project Configuration

**sonar-project.properties** is a configuration file that tells SonarQube:
- Which files to analyze
- Which files to exclude
- Source code encoding
- Test file locations
- Coverage report locations
- Language-specific settings

**Key Concepts:**

- **Project Key**: Unique identifier for your project
- **Sources**: Directories containing source code
- **Tests**: Directories containing test files
- **Exclusions**: Files/directories to exclude from analysis
- **Quality Profile**: Set of rules for code analysis
- **Quality Gate**: Conditions that must be met (e.g., no critical bugs)
- **Coverage**: Test coverage metrics

**Why This Matters for Notes App:**

The Notes App has:
- **Frontend**: Next.js/React with TypeScript - needs JavaScript/TypeScript analysis
- **Backend**: Node.js/Express - needs JavaScript analysis
- **Dependencies**: node_modules should be excluded
- **Build outputs**: .next, dist should be excluded
- **Test files**: Should be analyzed separately

Proper configuration ensures:
- Only relevant code is analyzed
- Test coverage is measured correctly
- Build artifacts are excluded
- Dependencies are ignored

**Real-World Context:**

In production:
- Each project has its own configuration
- Quality gates enforce standards
- Coverage thresholds ensure test quality
- Exclusions keep analysis focused on source code

---

## Prerequisites Check

Before starting, ensure you have:

- [ ] Completed task-011 (SonarQube setup)
- [ ] SonarQube project created (Cloud or self-hosted)
- [ ] Project key and authentication token available
- [ ] Notes App codebase available
- [ ] SonarQube Scanner installed (for local testing)

**Verify Prerequisites:**
```bash
# Check if SonarQube Scanner is installed (optional, for local testing)
sonar-scanner --version 2>/dev/null || echo "Scanner not installed (will install if needed)"

# Check Notes App structure
ls frontend/
ls backend/
```

---

## Step-by-Step Instructions

### Step 1: Install SonarQube Scanner (Optional - for Local Testing)

**Objective:** Install SonarQube Scanner to test analysis locally

**Instructions:**

1. **Download SonarQube Scanner:**
   - Go to https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/
   - Download SonarQube Scanner for your OS
   - Or use Docker: `docker pull sonarsource/sonar-scanner-cli`

2. **Install (Linux/Mac):**
```bash
# Extract and add to PATH
unzip sonar-scanner-*.zip
export PATH=$PATH:$(pwd)/sonar-scanner/bin
```

3. **Verify installation:**
```bash
sonar-scanner --version
```

**Note:** This is optional. CI/CD pipelines will use scanner automatically.

---

### Step 2: Configure Backend SonarQube Project

**Objective:** Create sonar-project.properties for backend

**Instructions:**

1. **Navigate to backend directory:**
```bash
cd backend/
```

2. **Create `sonar-project.properties`:**

```properties
# SonarQube Project Key (from task-011)
sonar.projectKey=notes-app-backend
sonar.projectName=Notes App Backend

# Source code location
sonar.sources=src,.
sonar.sourceEncoding=UTF-8

# Exclude node_modules, build outputs, etc.
sonar.exclusions=**/node_modules/**,**/dist/**,**/build/**,**/*.test.js,**/*.spec.js,**/coverage/**,**/.env**

# Test files (if you want to analyze them separately)
sonar.tests=__tests__,tests
sonar.test.inclusions=**/*.test.js,**/*.spec.js

# Coverage reports (if available)
sonar.javascript.lcov.reportPaths=coverage/lcov.info

# Language
sonar.language=js

# For SonarCloud
sonar.organization=your-organization-key
sonar.host.url=https://sonarcloud.io

# For self-hosted
# sonar.host.url=http://localhost:9000
```

3. **Update values:**
   - Replace `your-organization-key` with your SonarCloud organization key (if using SonarCloud)
   - Replace `notes-app-backend` with your actual project key
   - Adjust source paths if your structure differs

4. **Save the file**

**Key Points:**
- `sonar.sources`: Where your source code is
- `sonar.exclusions`: What to exclude from analysis
- `sonar.tests`: Where test files are
- `sonar.javascript.lcov.reportPaths`: Coverage report location

---

### Step 3: Configure Frontend SonarQube Project

**Objective:** Create sonar-project.properties for frontend

**Instructions:**

1. **Navigate to frontend directory:**
```bash
cd frontend/
```

2. **Create `sonar-project.properties`:**

```properties
# SonarQube Project Key (from task-011)
sonar.projectKey=notes-app-frontend
sonar.projectName=Notes App Frontend

# Source code location
sonar.sources=src,pages,components
sonar.sourceEncoding=UTF-8

# Exclude node_modules, build outputs, etc.
sonar.exclusions=**/node_modules/**,**/.next/**,**/out/**,**/dist/**,**/build/**,**/*.test.tsx,**/*.test.ts,**/*.spec.tsx,**/*.spec.ts,**/coverage/**,**/.env**

# Test files
sonar.tests=__tests__,tests
sonar.test.inclusions=**/*.test.tsx,**/*.test.ts,**/*.spec.tsx,**/*.spec.ts

# Coverage reports (if available)
sonar.javascript.lcov.reportPaths=coverage/lcov.info
sonar.typescript.lcov.reportPaths=coverage/lcov.info

# Language (TypeScript and JavaScript)
sonar.language=ts,js

# For SonarCloud
sonar.organization=your-organization-key
sonar.host.url=https://sonarcloud.io

# For self-hosted
# sonar.host.url=http://localhost:9000
```

3. **Update values:**
   - Replace `your-organization-key` with your SonarCloud organization key
   - Replace `notes-app-frontend` with your actual project key
   - Adjust source paths for your Next.js structure

4. **Save the file**

**Key Points:**
- Frontend uses TypeScript, so both `ts` and `js` languages
- Next.js specific exclusions (.next, out directories)
- React/TypeScript test file patterns

---

### Step 4: Configure Quality Profile (Optional)

**Objective:** Customize code analysis rules

**Instructions:**

**For SonarCloud:**
1. Go to SonarCloud dashboard
2. Click on your project
3. Go to "Quality Profiles"
4. Select profile (e.g., "Sonar way" for JavaScript/TypeScript)
5. Review rules (can customize later)

**For Self-hosted:**
1. Go to SonarQube: http://localhost:9000
2. Click "Quality Profiles"
3. Select language (JavaScript or TypeScript)
4. Copy "Sonar way" profile or use default
5. Customize rules if needed

**Note:** Default profiles are usually sufficient for learning. You can customize later.

---

### Step 5: Configure Quality Gate

**Objective:** Set up quality gate conditions

**Instructions:**

**For SonarCloud:**
1. Go to SonarCloud dashboard
2. Click on your project
3. Go to "Quality Gates"
4. Select "Sonar way" quality gate (default)
5. Review conditions:
   - Coverage on new code > 80%
   - Duplicated lines on new code < 3%
   - Maintainability rating = A
   - Reliability rating = A
   - Security rating = A

**For Self-hosted:**
1. Go to SonarQube: http://localhost:9000
2. Click "Quality Gates"
3. Select "Sonar way" quality gate
4. Review conditions (same as above)

**Customize (Optional):**
- Adjust coverage threshold
- Add/remove conditions
- Set severity thresholds

**Expected Output:**
- Quality gate configured
- Conditions visible
- Ready to enforce in CI/CD

---

### Step 6: Test Local Analysis (Optional)

**Objective:** Test SonarQube analysis locally before CI/CD integration

**Instructions:**

1. **Set authentication token as environment variable:**
```bash
# For SonarCloud
export SONAR_TOKEN=your-token-from-task-011

# For self-hosted
export SONAR_TOKEN=your-token-from-task-011
export SONAR_HOST_URL=http://localhost:9000
```

2. **Run analysis for backend:**
```bash
cd backend/
sonar-scanner
```

3. **Run analysis for frontend:**
```bash
cd frontend/
sonar-scanner
```

4. **Check results:**
   - Go to SonarQube dashboard
   - Click on your project
   - Review analysis results
   - Check quality gate status

**Expected Output:**
- Analysis completes successfully
- Results appear in SonarQube dashboard
- Quality gate status shown
- Issues and metrics visible

**Troubleshooting:**
- **Issue**: Scanner not found
  - **Solution**: Install SonarQube Scanner or use Docker
- **Issue**: Authentication failed
  - **Solution**: Check token is correct, verify SONAR_TOKEN environment variable
- **Issue**: Project not found
  - **Solution**: Verify project key matches SonarQube project

---

### Step 7: Configure Multi-Module Project (Alternative Approach)

**Objective:** Configure single SonarQube project for both frontend and backend

**Instructions:**

1. **Create root `sonar-project.properties`:**

```properties
# Root project
sonar.projectKey=notes-app
sonar.projectName=Notes App

# Modules
sonar.modules=backend,frontend

# Backend module
backend.sonar.projectKey=notes-app:backend
backend.sonar.projectName=Notes App Backend
backend.sonar.sources=backend/src,backend
backend.sonar.exclusions=**/node_modules/**,**/dist/**,**/build/**

# Frontend module
frontend.sonar.projectKey=notes-app:frontend
frontend.sonar.projectName=Notes App Frontend
frontend.sonar.sources=frontend/src,frontend/pages,frontend/components
frontend.sonar.exclusions=**/node_modules/**,**/.next/**,**/out/**,**/dist/**

# Common settings
sonar.organization=your-organization-key
sonar.host.url=https://sonarcloud.io
```

2. **Save in project root**

**Note:** Choose either separate projects (Step 2-3) or multi-module (this step). Multi-module is better for unified reporting.

---

## Notes App Specifics

### How This Applies to Notes App

**Backend Configuration:**
- Analyzes Node.js/Express JavaScript code
- Excludes node_modules, build outputs
- Includes test coverage if available
- Focuses on API code quality

**Frontend Configuration:**
- Analyzes Next.js/React TypeScript and JavaScript
- Excludes .next, out, node_modules
- Includes component test coverage
- Focuses on UI code quality

**Quality Gates:**
- Enforces code quality standards
- Prevents merging low-quality code
- Tracks technical debt
- Monitors test coverage

---

## Verification

### How to Verify the Task is Complete

**Functional Verification:**
1. sonar-project.properties files created (backend and frontend)
2. Configuration values correct (project keys, organization)
3. Exclusions properly configured
4. Quality gate configured
5. Local analysis test successful (optional)

**Technical Verification:**
1. Properties files syntax correct
2. Project keys match SonarQube projects
3. Source paths correct
4. Exclusions work (node_modules excluded)
5. Ready for CI/CD integration

**Commands to Run:**
```bash
# Verify properties files exist
ls backend/sonar-project.properties
ls frontend/sonar-project.properties

# Test analysis (if scanner installed)
cd backend/
sonar-scanner

# Check SonarQube dashboard
# Go to project > Check analysis results
```

**Expected Results:**
- Properties files created and configured
- Analysis runs successfully
- Results appear in SonarQube
- Quality gate conditions visible
- Ready for CI/CD integration (task-013)

---

## Troubleshooting

### Common Issues and Solutions

**Issue 1: Analysis Fails - Project Not Found**

**Symptoms:**
- Scanner reports "Project not found"
- Authentication works but project missing

**Causes:**
- Project key mismatch
- Project not created in SonarQube
- Wrong organization key

**Solutions:**
1. Verify project key in properties matches SonarQube
2. Create project in SonarQube if missing
3. Check organization key is correct
4. Verify project exists in dashboard

---

**Issue 2: Too Many Files Analyzed**

**Symptoms:**
- Analysis includes node_modules
- Build outputs analyzed
- Analysis takes too long

**Causes:**
- Exclusions not configured correctly
- Wildcard patterns incorrect

**Solutions:**
1. Check `sonar.exclusions` in properties file
2. Verify exclusion patterns match files
3. Test exclusions locally
4. Add more specific exclusions

---

**Issue 3: Coverage Not Reported**

**Symptoms:**
- Coverage shows 0%
- Coverage report not found

**Causes:**
- Coverage report path incorrect
- Coverage not generated
- Report format mismatch

**Solutions:**
1. Verify coverage report path in properties
2. Generate coverage: `npm run test:coverage`
3. Check report format (should be lcov.info)
4. Verify report exists at specified path

---

## Best Practices

### Configuration Best Practices
- Use separate projects for frontend and backend (easier to manage)
- Or use multi-module for unified reporting
- Exclude build artifacts and dependencies
- Include test files for separate analysis
- Configure coverage report paths correctly

### Quality Gate Best Practices
- Start with default "Sonar way" gate
- Adjust thresholds based on project needs
- Enforce quality gates in CI/CD
- Review and update gates regularly

### Analysis Best Practices
- Run analysis on every code change
- Fix critical issues first
- Track technical debt
- Monitor coverage trends

---

## Additional Resources

### Documentation
- [SonarQube Project Configuration](https://docs.sonarqube.org/latest/project-administration/narrowing-the-focus/)
- [SonarQube Analysis Parameters](https://docs.sonarqube.org/latest/analysis/analysis-parameters/)
- [Quality Gates](https://docs.sonarqube.org/latest/user-guide/quality-gates/)

### Learning Resources
- [SonarQube Configuration Examples](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/)

---

## Next Steps

After completing this task:

1. **Immediate Next Task**: `task-013-integrate-sonarqube-in-pipelines.md` - Integrate SonarQube into CI/CD pipelines
2. **Related Tasks**: 
   - `task-007-add-automated-testing.md` - Ensure tests generate coverage reports
3. **Future Learning**: 
   - Advanced SonarQube configuration
   - Custom quality profiles
   - Quality gate customization

---

## Reflection Questions

1. Why are exclusions important in SonarQube configuration?
2. How do quality gates enforce code quality?
3. What is the benefit of separate projects vs multi-module?
4. How does test coverage integration work?

---

## Task Checklist

- [ ] Read and understood the theory section
- [ ] Completed all prerequisite checks
- [ ] Created sonar-project.properties for backend
- [ ] Created sonar-project.properties for frontend
- [ ] Configured quality profile
- [ ] Configured quality gate
- [ ] Tested local analysis (optional)
- [ ] Verified exclusions work correctly
- [ ] Verified project keys are correct
- [ ] Reviewed troubleshooting section
- [ ] Applied best practices
- [ ] Ready to move to next task

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed  
**Date Started:** [Date]  
**Date Completed:** [Date]  
**Time Spent:** [Hours/Days]  
**Mentor Notes:** [Space for mentor feedback]

