# Git Flow Branching Strategy

## Overview
This project follows Git Flow, a robust version control strategy that supports parallel development, releases, and hotfixes.

## Branch Structure

### Main Branches

#### `master` (Production)
- **Purpose**: Production-ready code only
- **Protected**: Yes
- **Merge from**: `release/*` branches and hotfixes
- **Merge to**: Never directly commit here
- **Tag**: Every merge to master should be tagged with version (e.g., `v1.0.0`)

#### `develop` (Development)
- **Purpose**: Integration branch for features
- **Protected**: Yes
- **Merge from**: Feature branches (`feature/*`)
- **Merge to**: Never directly commit here
- **Deploy target**: Staging/Development environment

### Supporting Branches

#### `release/*` (Release Branches)
- **Naming**: `release/1.0.0`, `release/1.1.0`, etc.
- **Purpose**: Prepare production release
- **Created from**: `develop`
- **Merge back to**: `master` (with tag) and `develop`
- **Lifecycle**: Short-lived (days to weeks)
- **Use case**: 
  - Version bumping
  - Release documentation
  - Last-minute bug fixes only

#### `feature/*` (Feature Branches)
- **Naming**: `feature/user-authentication`, `feature/api-gateway`, etc.
- **Purpose**: Develop new features or improvements
- **Created from**: `develop`
- **Merge back to**: `develop`
- **Lifecycle**: Short-lived (days to weeks)
- **PR Required**: Yes, before merging to develop

#### `hotfix/*` (Hotfix Branches)
- **Naming**: `hotfix/critical-bug`, `hotfix/security-patch`, etc.
- **Purpose**: Emergency fixes for production issues
- **Created from**: `master`
- **Merge back to**: `master` (with tag) and `develop`
- **Lifecycle**: Very short-lived (hours to days)

## Workflow

### Creating a Feature Branch
```bash
git checkout develop
git pull origin develop
git checkout -b feature/feature-name
# Make changes and commit
git push origin feature/feature-name
# Create Pull Request to develop
```

### Creating a Release Branch
```bash
git checkout develop
git pull origin develop
git checkout -b release/X.Y.Z
# Bump versions, update changelog
git commit -am "Bump version to X.Y.Z"
git push origin release/X.Y.Z
# Create Pull Request to master
```

### Creating a Hotfix Branch
```bash
git checkout master
git pull origin master
git checkout -b hotfix/issue-name
# Fix the issue
git commit -am "Fix: description"
git push origin hotfix/issue-name
# Create Pull Request to master
```

## Pull Request Flow

1. **Feature → Develop**
   - Requires code review
   - Must pass CI/CD checks
   - Delete branch after merge

2. **Release → Master**
   - Requires code review
   - Creates release tag
   - Merge commit required (no squash)

3. **Release → Develop**
   - Automatic or manual sync
   - Ensures develop gets version updates

4. **Hotfix → Master**
   - Requires at least one approval
   - Creates hotfix tag (e.g., `v1.0.1`)

5. **Hotfix → Develop**
   - Ensures hotfix is in next release

## Naming Conventions

### Branches
- `feature/feature-description` - New features
- `release/X.Y.Z` - Release candidates
- `hotfix/issue-description` - Production fixes
- `bugfix/bug-description` - Bug fixes (branch from develop if long-lived)
- `docs/documentation-topic` - Documentation updates
- `test/test-scenario` - Testing and experimentation

### Commits
- `feat: description` - New feature
- `fix: description` - Bug fix
- `docs: description` - Documentation
- `style: description` - Code style changes
- `refactor: description` - Code refactoring
- `perf: description` - Performance improvement
- `test: description` - Test additions/changes
- `chore: description` - Maintenance tasks

### Tags
- `v1.0.0` - Release versions (semantic versioning)
- `v1.0.0-rc1` - Release candidates
- `v1.0.1` - Hotfix versions

## CI/CD Integration

- All branches trigger CI/CD pipelines
- Feature branches require passing all checks before merging to develop
- Release branches trigger creation of pre-release artifacts
- Master merges trigger production deployment

## Team Guidelines

1. Always create a branch for changes - no direct commits to master or develop
2. Keep feature branches short-lived (< 2 weeks)
3. Regular sync with develop to avoid large merge conflicts
4. One feature = one PR = one branch
5. Use issue numbers in branch names when possible: `feature/issue-123-description`

## Emergency Procedures

### If hotfix is needed while in release:
1. Create hotfix from master
2. Merge to master (create tag)
3. Merge to release and develop
4. Continue release process from develop

### Rolling back a release:
1. Create hotfix from master (previous version)
2. Tag it appropriately
3. Deploy hotfix version
4. Investigate release version issue
5. Address in develop for next release
