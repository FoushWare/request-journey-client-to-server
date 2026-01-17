# Development Workflow Guide

## Quick Start

### Initial Setup

```bash
# Clone the repository
git clone <repo-url>
cd request-journey-client-to-server

# Ensure you're on master
git checkout master

# Create your development branches (already done)
# - master (production)
# - develop (development integration)
# - release/1.0.0 (release branch)
```

### Sync Issues from GitHub

```bash
# Sync all GitHub issues to local issues/ folder
./sync-github-issues.sh

# Or provide owner/repo explicitly
./sync-github-issues.sh owner/repo

# Or with GitHub token for higher rate limits
./sync-github-issues.sh owner/repo $GITHUB_TOKEN
```

### Create Tasks, Plans, and Docs from Issues

```bash
# Create tasks, plans, and docs for all issues
./create-from-issues.sh all

# Or for a specific issue (e.g., issue #123)
./create-from-issues.sh 123
```

## Git Flow Workflow

### 1. Feature Development

```bash
# Update develop branch
git checkout develop
git pull origin develop

# Create feature branch from develop
git checkout -b feature/my-feature

# Make changes and commit
git add .
git commit -m "feat: add my feature"

# Push to remote
git push origin feature/my-feature

# Create Pull Request to develop
# - Get code reviewed
# - Address feedback
# - Merge once approved
```

### 2. Release Process

When ready to release:

```bash
# Update develop branch
git checkout develop
git pull origin develop

# Create release branch with semantic versioning
git checkout -b release/1.1.0

# Update version numbers and changelog
# Edit: package.json, version.txt, CHANGELOG.md, etc.
git add .
git commit -m "chore: bump version to 1.1.0"
git push origin release/1.1.0

# Create PR to master
# - Review release notes
# - Verify all checks pass
# - Get approval

# After approval, merge to master
# Then tag the release
git checkout master
git tag -a v1.1.0 -m "Release version 1.1.0"
git push origin v1.1.0

# Merge release branch back to develop
git checkout develop
git merge release/1.1.0
git push origin develop

# Delete release branch
git push origin --delete release/1.1.0
git branch -d release/1.1.0
```

### 3. Hotfix Process (Emergency Fixes)

```bash
# Create hotfix branch from master
git checkout master
git pull origin master
git checkout -b hotfix/critical-issue

# Fix the issue
git add .
git commit -m "fix: address critical issue"
git push origin hotfix/critical-issue

# Create PR to master
# - Get immediate review
# - Merge when approved

# After master merge, tag the hotfix
git checkout master
git tag -a v1.1.1 -m "Hotfix version 1.1.1"
git push origin v1.1.1

# Ensure hotfix goes to develop
git checkout develop
git merge hotfix/critical-issue
git push origin develop

# Delete hotfix branch
git push origin --delete hotfix/critical-issue
git branch -d hotfix/critical-issue
```

## Issue to Implementation Workflow

### Step 1: Review GitHub Issue

1. Go to GitHub repository
2. Review open issues
3. Identify issues to work on

### Step 2: Sync Issues

```bash
./sync-github-issues.sh
```

This creates markdown files in the `issues/` folder.

### Step 3: Create Project Artifacts

```bash
# Generate tasks, plans, and documentation
./create-from-issues.sh <issue-number>

# Or for all issues
./create-from-issues.sh all
```

This creates:
- **Task**: `tasks/<category>/task-<number>.md`
- **Plan**: `plans/plan-issue-<number>.md`
- **Documentation**: `docs/issue-<number>-implementation.md`

### Step 4: Create Feature Branch

```bash
git checkout develop
git pull origin develop
git checkout -b feature/issue-<number>-<description>
```

### Step 5: Implement Feature

1. Follow the task checklist
2. Make changes in appropriate directories:
   - **Code**: `implementation/` subdirectories
   - **Tests**: `tests/` or colocated with code
   - **Documentation**: Update in `docs/`
3. Commit with semantic commit messages:
   - `feat: description` - new feature
   - `fix: description` - bug fix
   - `docs: description` - documentation
   - `refactor: description` - refactoring

### Step 6: Create Pull Request

```bash
# Push your feature branch
git push origin feature/issue-<number>-<description>

# Create PR on GitHub
# - Title: "feat: issue #123 - description"
# - Link original issue in description
# - Add labels (feature, in-progress, etc.)
# - Add reviewers
```

### Step 7: Code Review

1. Wait for reviewer feedback
2. Make requested changes
3. Push updates: `git push origin feature/issue-<number>-<description>`
4. Address all comments

### Step 8: Merge to Develop

```bash
# Once approved and CI passes, merge PR to develop
# (usually done via GitHub UI)

# Delete feature branch after merge
git push origin --delete feature/issue-<number>-<description>
git branch -d feature/issue-<number>-<description>
```

### Step 9: Update Task Status

After merge, update task status:
- Edit `tasks/<category>/task-<number>.md`
- Change **Status** to: Completed
- Update **Implementation Details** section if needed

## Directory Structure

```
project-root/
├── master (branch) - Production code
├── develop (branch) - Development integration
├── release/1.x.x (branches) - Release candidates
│
├── issues/ - GitHub issues synced locally
│   ├── issue-1.md
│   ├── issue-2.md
│   └── .sync-summary.txt
│
├── tasks/ - Task files created from issues
│   ├── features/
│   ├── bugs/
│   ├── infrastructure/
│   ├── documentation/
│   └── testing/
│
├── plans/ - Implementation plans
│   ├── plan-issue-1.md
│   └── plan-issue-2.md
│
├── docs/ - Documentation and guides
│   ├── issue-1-implementation.md
│   └── GITFLOW_STRATEGY.md
│
├── implementation/ - Actual implementation code
│   ├── ansible/
│   ├── aws/
│   ├── ci-cd/
│   ├── docker/
│   ├── kubernetes/
│   ├── terraform/
│   └── ... (other tech stacks)
│
├── spec-kit/ - API and architecture specifications
│   ├── api-specs/
│   ├── architecture/
│   ├── database-schemas/
│   ├── deployment-specs/
│   ├── observability-specs/
│   └── security-specs/
│
├── scripts/ - Utility scripts
├── sync-github-issues.sh - GitHub issue sync script
├── create-from-issues.sh - Task/plan/doc generation script
└── GITFLOW_STRATEGY.md - Branching strategy guide
```

## Automation Scripts

### sync-github-issues.sh

Syncs all GitHub issues to local markdown files.

**Usage**:
```bash
./sync-github-issues.sh [owner/repo] [github-token]
```

**Examples**:
```bash
# Auto-detect repo from git remote
./sync-github-issues.sh

# Specify repo explicitly
./sync-github-issues.sh owner/repo-name

# Use GitHub token for higher rate limits
./sync-github-issues.sh owner/repo-name ghp_xxxxx
```

**Environment**:
```bash
# Set token as environment variable
export GITHUB_TOKEN=ghp_xxxxx
./sync-github-issues.sh
```

### create-from-issues.sh

Creates tasks, plans, and documentation from issue files.

**Usage**:
```bash
./create-from-issues.sh <issue-number|all>
```

**Examples**:
```bash
# Create artifacts for issue #42
./create-from-issues.sh 42

# Create artifacts for all issues
./create-from-issues.sh all
```

**Output**:
- Creates `tasks/<category>/task-<number>.md`
- Creates `plans/plan-issue-<number>.md`
- Creates `docs/issue-<number>-implementation.md`

## Best Practices

### Commit Messages

Follow conventional commits:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**:
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation
- `style` - Code style
- `refactor` - Code refactoring
- `perf` - Performance
- `test` - Tests
- `chore` - Maintenance

**Examples**:
```bash
git commit -m "feat(api): add user authentication endpoint"
git commit -m "fix(ui): resolve layout issue on mobile devices"
git commit -m "docs: update installation guide"
```

### Branch Naming

```
feature/<issue-number>-<short-description>
feature/123-user-authentication

bugfix/456-memory-leak

docs/789-api-documentation

release/1.2.0

hotfix/critical-security-issue
```

### Pull Requests

1. **Title**: Should be clear and concise
   - `feat: add user authentication (issue #123)`
   - `fix: resolve memory leak in service`

2. **Description**: Include:
   - Link to issue: `Closes #123` or `Fixes #456`
   - What changed and why
   - Testing performed
   - Screenshots (if UI changes)

3. **Labels**: Add relevant labels
   - `feature`, `bug`, `enhancement`
   - `in-progress`, `ready-for-review`
   - `documentation`, `testing`

### Code Review

- Respond to feedback promptly
- Don't take criticism personally
- Explain complex changes
- Ask questions if feedback is unclear
- Push updates after addressing feedback

## Troubleshooting

### Issue: Too many commits in PR

**Solution**: Squash commits before merge
```bash
git rebase -i develop
# Mark commits as 'squash' or 's'
# Resolve any conflicts
git push -f origin feature/branch-name
```

### Issue: Your branch is behind develop

**Solution**: Sync and rebase
```bash
git fetch origin
git rebase origin/develop
# Resolve conflicts if any
git push -f origin feature/branch-name
```

### Issue: Accidentally committed to master

**Solution**: Move commits to a new branch
```bash
git branch feature/new-branch
git reset --hard origin/master
git checkout feature/new-branch
```

### Issue: GitHub API rate limit

**Solution**: Use personal access token
```bash
export GITHUB_TOKEN=ghp_xxxxx
./sync-github-issues.sh
```

## Getting Help

- Check `GITFLOW_STRATEGY.md` for branching details
- Review task template in `docs/task-template.md`
- Look at existing tasks for examples
- Create issues for blockers or questions

---

**Last Updated**: January 17, 2026
