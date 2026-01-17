#!/bin/bash

# Script Usage Examples & Testing Guide
# This file documents how to use the automation scripts

# ============================================================================
# GITHUB ISSUE SYNC SCRIPT - sync-github-issues.sh
# ============================================================================

# Example 1: Basic sync (auto-detect repository from git remote)
# ./sync-github-issues.sh

# Example 2: Sync specific repository
# ./sync-github-issues.sh owner/repository-name

# Example 3: Sync with GitHub token (recommended for high rate limits)
# export GITHUB_TOKEN=ghp_your_token_here
# ./sync-github-issues.sh

# Example 4: Sync with explicit token
# ./sync-github-issues.sh owner/repo ghp_your_token_here

# Environment Variables:
# - GITHUB_TOKEN: Personal access token for GitHub API
#   Scope: repo, read:user
#   Rate limit: 5000 requests/hour (vs 60 without token)

# Output:
# - issues/ - Contains synced GitHub issues as markdown files
# - issues/.sync-summary.txt - Statistics about the sync

# Output Example:
# issues/
# ├── issue-1.md
# ├── issue-2.md
# ├── issue-123.md
# └── .sync-summary.txt

# ============================================================================
# TASK/PLAN/DOC GENERATION SCRIPT - create-from-issues.sh
# ============================================================================

# Example 1: Generate artifacts for all issues
# ./create-from-issues.sh all

# Example 2: Generate artifacts for specific issue
# ./create-from-issues.sh 123

# Output Files Created:
# 1. tasks/<category>/task-<number>.md
#    Categories: features, bugs, infrastructure, documentation, testing
#    Contains: Task checklist, acceptance criteria, implementation details
#
# 2. plans/plan-issue-<number>.md
#    Contains: Phase-based plan, goals, success criteria
#
# 3. docs/issue-<number>-implementation.md
#    Contains: Technical documentation, architecture, testing, deployment

# ============================================================================
# FULL WORKFLOW EXAMPLE
# ============================================================================

# Step 1: Sync all GitHub issues
# ./sync-github-issues.sh
# Output: Creates issues/issue-*.md files

# Step 2: Generate initial tasks for an issue
# ./create-from-issues.sh 42
# Output:
# - tasks/features/task-42.md (if feature)
# - plans/plan-issue-42.md
# - docs/issue-42-implementation.md

# Step 3: Review generated task
# cat tasks/features/task-42.md

# Step 4: Create feature branch and implement
# git checkout develop
# git pull origin develop
# git checkout -b feature/issue-42-user-authentication

# Step 5: Work on implementation using task as guide
# - Follow task checklist
# - Update task status as you progress

# Step 6: Commit with semantic messages
# git add src/auth/
# git commit -m "feat: implement user authentication (issue #42)"
# git add tests/
# git commit -m "test: add authentication tests"

# Step 7: Push and create PR
# git push origin feature/issue-42-user-authentication
# # Create PR on GitHub
# # Request review
# # Address feedback

# Step 8: Merge to develop
# # Approve and merge PR on GitHub
# git checkout develop
# git pull origin develop

# Step 9: Update task status
# # Edit tasks/features/task-42.md
# # Change status to "Completed"

# ============================================================================
# BATCH PROCESSING EXAMPLE
# ============================================================================

# Generate tasks for multiple issues at once:

# For issues 1-10
for i in {1..10}; do
  echo "Creating artifacts for issue $i..."
  # ./create-from-issues.sh $i
done

# For specific issues
for issue in 1 5 12 23 45; do
  echo "Creating artifacts for issue $issue..."
  # ./create-from-issues.sh $issue
done

# ============================================================================
# ERROR HANDLING EXAMPLES
# ============================================================================

# Error: GitHub API rate limit exceeded
# Solution 1: Use GitHub token
export GITHUB_TOKEN=ghp_your_token_here
# ./sync-github-issues.sh

# Solution 2: Wait for rate limit reset (60 minutes)
# Or generate token at https://github.com/settings/tokens

# Error: "Permission denied" on script
# Solution: Make script executable
chmod +x sync-github-issues.sh
chmod +x create-from-issues.sh

# Error: Issue file not found
# Solution: Sync issues first
# ./sync-github-issues.sh

# ============================================================================
# MONITORING & VERIFICATION
# ============================================================================

# Check sync status
cat issues/.sync-summary.txt
# Output:
# Last synced: Thu Jan 17 10:30:45 PST 2026
# Total issues: 150
# Open: 45
# Closed: 105
# Repository: owner/repo-name

# List generated tasks
ls -la tasks/*/
# Output: All generated task files

# Count tasks by category
echo "Features:" && ls tasks/features/*.md 2>/dev/null | wc -l
echo "Bugs:" && ls tasks/bugs/*.md 2>/dev/null | wc -l
echo "Infrastructure:" && ls tasks/infrastructure/*.md 2>/dev/null | wc -l

# View task details
cat tasks/features/task-42.md

# ============================================================================
# AUTOMATION SCRIPT FOR BULK OPERATIONS
# ============================================================================

# Script to sync and generate all at once:

#!/bin/bash
sync_and_generate_all() {
    echo "Step 1: Syncing GitHub issues..."
    ./sync-github-issues.sh
    
    echo "Step 2: Generating tasks, plans, and documentation..."
    ./create-from-issues.sh all
    
    echo "Step 3: Verifying output..."
    echo "Tasks created:"
    find tasks -name "*.md" | wc -l
    
    echo "Plans created:"
    find plans -name "*.md" | wc -l
    
    echo "Docs created:"
    find docs -name "issue-*-implementation.md" | wc -l
    
    echo "Complete!"
}

# Usage: Call the function
# sync_and_generate_all

# ============================================================================
# ADVANCED USAGE
# ============================================================================

# Filter issues by label before generating tasks:
# (Manual approach - edit issues/ files before running create-from-issues.sh)

# Generate only for specific category:
# Modify create-from-issues.sh to filter by labels

# Custom task template:
# Edit the task generation section in create-from-issues.sh

# Scheduled sync (using cron):
# Add to crontab:
# 0 9 * * * cd /path/to/project && ./sync-github-issues.sh
# This runs sync daily at 9 AM

# ============================================================================
# GIT FLOW INTEGRATION
# ============================================================================

# Create feature branch from task:
# git checkout develop
# git pull origin develop
# ISSUE=42
# git checkout -b feature/issue-$ISSUE-description

# Create PR with issue link:
# Hub or GitHub CLI:
# gh pr create --base develop --title "feat: issue #42 - description"

# Auto-link in commit messages:
# git commit -m "feat: implement feature

# Closes #42"

# ============================================================================
# REPORTING & ANALYTICS
# ============================================================================

# Count total issues processed
find issues -name "issue-*.md" | wc -l

# Count tasks by status
grep -r "^**Status**: Completed" tasks/ | wc -l
grep -r "^**Status**: Not Started" tasks/ | wc -l
grep -r "^**Status**: In Progress" tasks/ | wc -l

# Find high-priority tasks
grep -r "Priority.*High" tasks/

# Find tasks by category
find tasks/features -name "*.md" | wc -l
find tasks/bugs -name "*.md" | wc -l
find tasks/infrastructure -name "*.md" | wc -l

# ============================================================================
# TROUBLESHOOTING CHECKLIST
# ============================================================================

# Issue: Scripts not found
# Check: ls -la *.sh

# Issue: Permission errors
# Check: ls -la sync-github-issues.sh
# Fix: chmod +x sync-github-issues.sh

# Issue: Issues not syncing
# Check: Internet connection
# Check: GitHub token validity
# Check: API rate limits

# Issue: Task generation fails
# Check: Issue files exist (./sync-github-issues.sh first)
# Check: jq is installed (json processor)
# Fix: brew install jq

# Issue: Git conflicts
# Check: git status
# Resolve: See WORKFLOW_GUIDE.md

# ============================================================================
# DEPENDENCIES
# ============================================================================

# Required:
# - bash - Script interpreter
# - git - Version control
# - curl - HTTP client (for API calls)
# - jq - JSON processor

# Installation (macOS):
# brew install curl jq

# Installation (Linux - Ubuntu/Debian):
# sudo apt-get install curl jq

# Installation (Linux - CentOS/RHEL):
# sudo yum install curl jq

# ============================================================================
# NOTES
# ============================================================================

# 1. Always sync issues before generating tasks
# 2. Use GitHub token for better reliability
# 3. Review generated files before committing
# 4. Update task status as you work
# 5. Follow semantic commit messages
# 6. Create PRs for all changes (even from master start)
# 7. Keep branches short-lived
# 8. Communicate via PR comments

# ============================================================================
