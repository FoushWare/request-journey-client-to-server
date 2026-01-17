#!/bin/bash

# Analyze GitHub Issues vs Local Issues
# This script identifies new, updated, and missing issues

set -e

WORKSPACE="/Users/a.fouad/SideProjects/Request-journey/request-journey-client-to-server"
ISSUES_DIR="$WORKSPACE/issues"
PLANS_DIR="$WORKSPACE/plans"
TASKS_DIR="$WORKSPACE/tasks"

cd "$WORKSPACE"

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║          GITHUB ISSUES SYNC & ANALYSIS REPORT                  ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Get repository info
REPO_URL=$(git remote -v 2>/dev/null | grep fetch | head -1 | awk '{print $2}' | sed 's|.*github.com[:/]\([^/]*\)/\([^/]*\)\.git.*|\1/\2|')
echo "Repository: $REPO_URL"
echo "Analysis Date: $(date)"
echo ""

# Count current local issues
LOCAL_COUNT=$(find "$ISSUES_DIR" -name "issue-*.md" -type f 2>/dev/null | wc -l)
echo "LOCAL ISSUES: $LOCAL_COUNT files"
echo ""

# List issue numbers
echo "Local Issue Numbers:"
find "$ISSUES_DIR" -name "issue-*.md" -type f 2>/dev/null | sed 's/.*issue-//;s/.md//' | sort -n > /tmp/local_issues.txt
head -20 /tmp/local_issues.txt
TOTAL_LINES=$(wc -l < /tmp/local_issues.txt)
echo "... (showing 20 of $TOTAL_LINES total)"
echo ""

# Check GitHub API availability
echo "Checking GitHub API connection..."
if command -v curl &> /dev/null; then
    echo "✓ curl is available"
    
    # Try to get issues count from GitHub API
    if [ -n "$GITHUB_TOKEN" ]; then
        echo "✓ GitHub token is set (higher rate limits)"
        AUTH_HEADER="Authorization: token $GITHUB_TOKEN"
    else
        echo "⚠ No GitHub token set (60 req/hour limit)"
        AUTH_HEADER=""
    fi
    
    # Get basic repo info
    echo ""
    echo "Fetching repository information from GitHub..."
    
    if [ -n "$AUTH_HEADER" ]; then
        REPO_INFO=$(curl -s -H "$AUTH_HEADER" "https://api.github.com/repos/$REPO_URL" 2>/dev/null || echo "{}")
    else
        REPO_INFO=$(curl -s "https://api.github.com/repos/$REPO_URL" 2>/dev/null || echo "{}")
    fi
    
    if echo "$REPO_INFO" | grep -q "open_issues"; then
        GITHUB_ISSUES=$(echo "$REPO_INFO" | grep -o '"open_issues_count":[0-9]*' | grep -o '[0-9]*')
        echo "GitHub Open Issues: $GITHUB_ISSUES"
    else
        echo "⚠ Could not fetch GitHub repo info (rate limit or connection issue)"
    fi
else
    echo "✗ curl not available - cannot sync with GitHub"
fi

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                    RECOMMENDATION                              ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "Current Status:"
echo "  - Local Issues: $LOCAL_COUNT files in issues/ directory"
echo "  - Issues range: $(head -1 /tmp/local_issues.txt) to $(tail -1 /tmp/local_issues.txt)"
echo ""
echo "Next Steps:"
echo "  1. Run: ./sync-github-issues.sh"
echo "     (This will fetch latest issues from GitHub)"
echo ""
echo "  2. Run: ./create-from-issues.sh all"
echo "     (This will generate/update tasks and plans)"
echo ""
echo "  3. Review: tasks/, plans/, docs/ directories"
echo "     (Check for new and updated items)"
echo ""
echo "Repository Information:"
echo "  - Repo: $REPO_URL"
echo "  - Local Path: $WORKSPACE"
echo "  - Issues Dir: $ISSUES_DIR"
echo "  - Plans Dir: $PLANS_DIR"
echo "  - Tasks Dir: $TASKS_DIR"
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                    READY TO SYNC                               ║"
echo "╚════════════════════════════════════════════════════════════════╝"
