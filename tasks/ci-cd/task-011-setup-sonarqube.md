# Task: CI/CD - Setup SonarQube for Code Analysis

**Related Issue:** N/A (New task for code quality)  
**Prerequisites:** task-001 (Jenkins setup - for understanding CI/CD), basic understanding of code quality concepts  
**Estimated Time:** 2-4 hours (Cloud: 1-2 hours, Self-hosted: 3-4 hours)  
**Notes App Context:** Set up SonarQube (Cloud or self-hosted) to perform static code analysis on the Notes App codebase, identifying bugs, vulnerabilities, and code smells

---

## Learning Objectives

By the end of this task, you will be able to:

- Understand what SonarQube is and how it works
- Set up SonarQube Cloud (easier option)
- Set up self-hosted SonarQube using Docker
- Create SonarQube projects
- Generate authentication tokens
- Access SonarQube dashboard
- Understand quality gates and metrics

---

## Theory Section

### What is SonarQube?

**SonarQube** is an open-source platform for continuous inspection of code quality. It performs static code analysis to detect:
- **Bugs**: Code that will likely fail at runtime
- **Vulnerabilities**: Security issues in code
- **Code Smells**: Maintainability issues
- **Coverage**: Test coverage metrics
- **Duplications**: Duplicated code blocks
- **Technical Debt**: Estimated time to fix issues

**Key Concepts:**

- **Static Code Analysis**: Analyzing code without executing it
- **Quality Gate**: Set of conditions that must be met (e.g., no critical bugs, 80% coverage)
- **Quality Profile**: Set of rules for code analysis
- **Project**: Represents your codebase in SonarQube
- **Token**: Authentication credential for CI/CD integration

**Why This Matters for Notes App:**

The Notes App benefits from:
- Early detection of bugs and vulnerabilities
- Consistent code quality standards
- Technical debt tracking
- Test coverage monitoring
- Security vulnerability detection
- Code maintainability metrics

**SonarQube Options:**

1. **SonarQube Cloud (SonarCloud)**: 
   - SaaS solution (easier setup)
   - Free for open-source projects
   - Hosted by SonarSource
   - Recommended for beginners

2. **Self-hosted SonarQube**:
   - Full control over installation
   - Can run on-premises
   - Requires infrastructure management
   - Better for enterprise/private projects

**Real-World Context:**

In production:
- SonarQube runs on every code change
- Quality gates prevent merging bad code
- Reports track code quality over time
- Teams use metrics to improve code quality

---

## Prerequisites Check

Before starting, ensure you have:

- [ ] Basic understanding of code quality concepts
- [ ] GitHub account (for SonarCloud) OR Docker installed (for self-hosted)
- [ ] Notes App codebase available
- [ ] Git repository with code
- [ ] Internet connection

**Verify Prerequisites:**
```bash
# For self-hosted: Check Docker
docker --version

# Check repository exists
git remote -v
```

---

## Step-by-Step Instructions

### Option A: SonarQube Cloud (SonarCloud) - Recommended for Beginners

**Objective:** Set up SonarCloud for code analysis (easier, no infrastructure needed)

#### Step A1: Create SonarCloud Account

**Instructions:**

1. **Go to SonarCloud:**
   - Navigate to https://sonarcloud.io
   - Click "Log in" or "Sign up"

2. **Sign in with GitHub:**
   - Click "Log in with GitHub"
   - Authorize SonarCloud to access your GitHub account
   - Complete account setup

3. **Verify account:**
   - Check email for verification (if required)
   - Account should be ready

**Expected Output:**
- SonarCloud account created
- Logged into SonarCloud dashboard

---

#### Step A2: Create Organization

**Instructions:**

1. **Create organization:**
   - In SonarCloud, click "Create Organization"
   - Enter organization name (e.g., "your-username" or "your-company")
   - Select plan (Free plan is sufficient for learning)
   - Click "Create"

2. **Verify organization:**
   - Organization should appear in dashboard
   - Note the organization key (e.g., "your-username")

**Expected Output:**
- Organization created
- Organization key available

---

#### Step A3: Create Project

**Instructions:**

1. **Create new project:**
   - Click "Create Project" or "+" button
   - Select "From GitHub" (if using GitHub)
   - Authorize SonarCloud to access repositories (if first time)

2. **Select repository:**
   - Choose your Notes App repository
   - Click "Set up"

3. **Configure project:**
   - **Project Key**: Auto-generated (e.g., "your-username_request-journey-client-to-server")
   - **Project Name**: "Notes App" or your preferred name
   - **Main Branch**: "main" or "master"
   - Click "Set up"

4. **Note project details:**
   - **Organization Key**: e.g., "your-username"
   - **Project Key**: e.g., "your-username_request-journey-client-to-server"
   - Save these for later use

**Expected Output:**
- Project created in SonarCloud
- Project key and organization key available
- Project appears in dashboard

---

#### Step A4: Generate Authentication Token

**Instructions:**

1. **Generate token:**
   - Click on your profile (top right)
   - Select "My Account"
   - Go to "Security" tab
   - Under "Generate Tokens", enter token name: "Notes App CI/CD"
   - Select expiration (30 days, 60 days, or no expiration)
   - Click "Generate"

2. **Copy token:**
   - **IMPORTANT**: Copy the token immediately
   - Token will not be shown again
   - Save token securely (you'll use it in task-013)

**Expected Output:**
- Authentication token generated
- Token copied and saved securely

---

#### Step A5: Verify SonarCloud Setup

**Instructions:**

1. **Access project dashboard:**
   - Go to SonarCloud dashboard
   - Click on your project
   - Project should show "No analysis yet"

2. **Verify project settings:**
   - Click "Project Settings"
   - Verify project key and organization key
   - Check "Analysis Method" (will configure in task-012)

**Expected Output:**
- Project accessible in SonarCloud
- Project settings visible
- Ready for analysis configuration

---

### Option B: Self-hosted SonarQube - Advanced Option

**Objective:** Set up self-hosted SonarQube using Docker (full control, on-premises)

#### Step B1: Prepare Docker Environment

**Instructions:**

1. **Verify Docker is running:**
```bash
docker --version
docker ps
```

2. **Create directory for SonarQube data:**
```bash
mkdir -p sonarqube-data
chmod 777 sonarqube-data  # SonarQube needs write access
```

**Expected Output:**
- Docker running
- Directory created for data persistence

---

#### Step B2: Deploy SonarQube with Docker Compose

**Instructions:**

1. **Create `docker-compose.yml` for SonarQube:**

```yaml
version: '3.8'

services:
  sonarqube:
    image: sonarqube:community
    container_name: sonarqube
    hostname: sonarqube
    depends_on:
      - sonarqube-db
    environment:
      SONAR_JDBC_URL: jdbc:postgresql://sonarqube-db:5432/sonar
      SONAR_JDBC_USERNAME: sonar
      SONAR_JDBC_PASSWORD: sonar
      SONAR_ES_BOOTSTRAP_CHECKS_DISABLE: true
    volumes:
      - sonarqube-data:/opt/sonarqube/data
      - sonarqube-extensions:/opt/sonarqube/extensions
      - sonarqube-logs:/opt/sonarqube/logs
    ports:
      - "9000:9000"
    networks:
      - sonarqube-network

  sonarqube-db:
    image: postgres:15-alpine
    container_name: sonarqube-db
    environment:
      POSTGRES_USER: sonar
      POSTGRES_PASSWORD: sonar
      POSTGRES_DB: sonar
    volumes:
      - sonarqube-db-data:/var/lib/postgresql/data
    networks:
      - sonarqube-network

volumes:
  sonarqube-data:
  sonarqube-extensions:
  sonarqube-logs:
  sonarqube-db-data:

networks:
  sonarqube-network:
    driver: bridge
```

2. **Save the file**

---

#### Step B3: Start SonarQube

**Instructions:**

1. **Start SonarQube:**
```bash
docker-compose up -d
```

2. **Check containers are running:**
```bash
docker-compose ps
```

3. **Check logs:**
```bash
docker-compose logs -f sonarqube
```

4. **Wait for SonarQube to start:**
   - Wait 1-2 minutes for SonarQube to initialize
   - Look for "SonarQube is operational" in logs

**Expected Output:**
- Containers running
- SonarQube accessible at http://localhost:9000
- Database initialized

**Troubleshooting:**
- **Issue**: SonarQube won't start
  - **Solution**: Check logs, ensure ports 9000 and 5432 are available
- **Issue**: Out of memory errors
  - **Solution**: Increase Docker memory limit (4GB+ recommended)

---

#### Step B4: Access SonarQube and Set Up Admin

**Instructions:**

1. **Access SonarQube:**
   - Open browser: http://localhost:9000
   - Wait for initial setup (may take a few minutes)

2. **Log in:**
   - Default credentials:
     - Username: `admin`
     - Password: `admin`
   - You'll be prompted to change password

3. **Change admin password:**
   - Enter new password
   - Confirm new password
   - Click "Update"

4. **Skip tutorial (optional):**
   - You can skip the tutorial for now
   - We'll configure projects in task-012

**Expected Output:**
- SonarQube dashboard accessible
- Admin password changed
- Ready to create projects

---

#### Step B5: Create Project in SonarQube

**Instructions:**

1. **Create project:**
   - Click "+" (Create Project) or "Create Project" button
   - Select "Manually" (we'll configure analysis in task-012)

2. **Enter project details:**
   - **Project Key**: `notes-app` (must be unique)
   - **Display Name**: "Notes App"
   - Click "Set up"

3. **Generate token:**
   - Select "Generate a token"
   - Enter token name: "Notes App CI/CD"
   - Click "Generate"
   - **Copy token immediately** (won't be shown again)

4. **Note project details:**
   - **Project Key**: `notes-app`
   - **Server URL**: `http://localhost:9000` (or your SonarQube URL)
   - **Token**: (the token you just generated)
   - Save these for task-012 and task-013

**Expected Output:**
- Project created in SonarQube
- Project key and token available
- Project appears in dashboard

---

## Notes App Specifics

### How This Applies to Notes App

**Both Options:**
- SonarQube will analyze Notes App codebase
- Frontend (Next.js/React) and backend (Node.js/Express) will be analyzed
- Quality gates will ensure code quality standards
- Reports will track code quality over time

**SonarCloud:**
- Easier setup, no infrastructure
- Free for open-source projects
- Automatic updates
- Recommended for learning

**Self-hosted:**
- Full control over installation
- Can run on-premises
- Requires maintenance
- Better for enterprise/private projects

---

## Verification

### How to Verify the Task is Complete

**For SonarCloud:**
1. Account created and logged in
2. Organization created
3. Project created
4. Project key and organization key noted
5. Authentication token generated and saved
6. Project accessible in dashboard

**For Self-hosted:**
1. Docker Compose file created
2. SonarQube containers running
3. SonarQube accessible at http://localhost:9000
4. Admin password changed
5. Project created
6. Project key and token noted
7. Project accessible in dashboard

**Commands to Run:**
```bash
# For self-hosted: Check containers
docker-compose ps

# Check SonarQube logs
docker-compose logs sonarqube

# Access SonarQube
curl http://localhost:9000/api/system/status
```

**Expected Results:**
- SonarQube (Cloud or self-hosted) is accessible
- Project created and visible
- Authentication token generated
- Ready for project configuration (task-012)

---

## Troubleshooting

### Common Issues and Solutions

**Issue 1: SonarCloud - Cannot Access GitHub Repositories**

**Symptoms:**
- Repositories don't appear when creating project
- Authorization fails

**Causes:**
- GitHub integration not authorized
- Repository is private and SonarCloud doesn't have access

**Solutions:**
1. Re-authorize GitHub in SonarCloud settings
2. Check GitHub organization settings
3. Ensure repository is accessible
4. Try manual project creation

---

**Issue 2: Self-hosted - SonarQube Won't Start**

**Symptoms:**
- Container exits immediately
- Logs show errors

**Causes:**
- Insufficient memory
- Port conflicts
- Database connection issues

**Solutions:**
1. Increase Docker memory (4GB+ recommended)
2. Check ports 9000 and 5432 are available
3. Verify database container is running
4. Check Docker logs for specific errors

---

**Issue 3: Self-hosted - Cannot Access SonarQube**

**Symptoms:**
- http://localhost:9000 doesn't load
- Connection refused

**Causes:**
- SonarQube still initializing
- Port not exposed correctly
- Firewall blocking

**Solutions:**
1. Wait 2-3 minutes for initialization
2. Check `docker-compose ps` - containers should be running
3. Verify port mapping in docker-compose.yml
4. Check firewall settings

---

## Best Practices

### Security Best Practices
- Store tokens securely (use secrets management)
- Don't commit tokens to repository
- Rotate tokens regularly
- Use least privilege for tokens

### Operational Best Practices
- Backup SonarQube data regularly (self-hosted)
- Monitor SonarQube performance
- Keep SonarQube updated (self-hosted)
- Document project keys and tokens

### Code Quality Best Practices
- Use quality gates to enforce standards
- Review SonarQube reports regularly
- Fix critical issues first
- Track technical debt

---

## Additional Resources

### Documentation
- [SonarCloud Documentation](https://docs.sonarcloud.io/)
- [SonarQube Documentation](https://docs.sonarqube.org/latest/)
- [SonarQube Docker Installation](https://docs.sonarqube.org/latest/setup/install-server/)

### Learning Resources
- [SonarQube Getting Started](https://docs.sonarqube.org/latest/user-guide/getting-started/)
- [SonarCloud Quick Start](https://docs.sonarcloud.io/getting-started/overview/)

---

## Next Steps

After completing this task:

1. **Immediate Next Task**: `task-012-configure-sonarqube-project.md` - Configure SonarQube project for Notes App
2. **Related Tasks**: 
   - `task-013-integrate-sonarqube-in-pipelines.md` - Integrate SonarQube into CI/CD pipelines
3. **Future Learning**: 
   - Advanced SonarQube configuration
   - Custom quality profiles
   - Quality gate configuration

---

## Reflection Questions

1. What are the benefits of static code analysis?
2. When would you choose SonarCloud vs self-hosted?
3. Why are authentication tokens important?
4. How does SonarQube help improve code quality?

---

## Task Checklist

- [ ] Read and understood the theory section
- [ ] Completed all prerequisite checks
- [ ] Chose SonarCloud OR self-hosted option
- [ ] Created account/organization (SonarCloud) OR deployed SonarQube (self-hosted)
- [ ] Created project in SonarQube
- [ ] Generated authentication token
- [ ] Noted project key and organization key (SonarCloud) OR project key and server URL (self-hosted)
- [ ] Verified SonarQube is accessible
- [ ] Reviewed troubleshooting section
- [ ] Applied best practices
- [ ] Ready to move to next task

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed  
**Date Started:** [Date]  
**Date Completed:** [Date]  
**Time Spent:** [Hours/Days]  
**Mentor Notes:** [Space for mentor feedback]

