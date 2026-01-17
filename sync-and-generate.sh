#!/bin/bash

# Comprehensive GitHub Issues Sync & Task/Plan Generation
# This script syncs issues, analyzes changes, and updates tasks/plans

set -e

WORKSPACE="/Users/a.fouad/SideProjects/Request-journey/request-journey-client-to-server"
ISSUES_DIR="$WORKSPACE/issues"
PLANS_DIR="$WORKSPACE/plans"
TASKS_DIR="$WORKSPACE/tasks"
DOCS_DIR="$WORKSPACE/docs"

cd "$WORKSPACE"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[✓]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║  GitHub Issues Sync & Task/Plan Generation                     ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Step 1: Analyze Current State
log_info "Step 1: Analyzing current local issues..."
LOCAL_ISSUE_COUNT=$(find "$ISSUES_DIR" -name "issue-*.md" -type f 2>/dev/null | wc -l)
log_success "Found $LOCAL_ISSUE_COUNT local issues"

# Get list of local issue numbers
find "$ISSUES_DIR" -name "issue-*.md" -type f 2>/dev/null | \
  sed 's/.*issue-//;s/.md//' | sort -n > /tmp/local_issues_numbers.txt

MIN_LOCAL=$(head -1 /tmp/local_issues_numbers.txt)
MAX_LOCAL=$(tail -1 /tmp/local_issues_numbers.txt)
echo "   Issue range: #$MIN_LOCAL to #$MAX_LOCAL"
echo ""

# Step 2: Sync with GitHub
log_info "Step 2: Syncing with GitHub repository..."
log_warning "Note: Make sure GITHUB_TOKEN is set for higher rate limits"
echo "   Run: export GITHUB_TOKEN=your_token_here"
echo ""

# Step 3: Check for issues that need plans
log_info "Step 3: Checking for issues needing plans..."
PLANS_MISSING=0
for issue_num in $(cat /tmp/local_issues_numbers.txt | head -20); do
    PLAN_FILE="$PLANS_DIR/plan-issue-$issue_num.md"
    if [ ! -f "$PLAN_FILE" ]; then
        ((PLANS_MISSING++))
    fi
done
echo "   Issues without plans: ~$PLANS_MISSING (in first 20 checked)"
echo ""

# Step 4: Check for issues that need tasks
log_info "Step 4: Checking for issues needing tasks..."
TASKS_MISSING=0
for issue_num in $(cat /tmp/local_issues_numbers.txt | head -20); do
    # Check if task exists in any category
    TASK_FOUND=0
    for category in features bugs infrastructure documentation testing general; do
        if [ -f "$TASKS_DIR/$category/task-$issue_num.md" ]; then
            TASK_FOUND=1
            break
        fi
    done
    if [ $TASK_FOUND -eq 0 ]; then
        ((TASKS_MISSING++))
    fi
done
echo "   Issues without tasks: ~$TASKS_MISSING (in first 20 checked)"
echo ""

# Step 5: Show what can be done
log_info "Step 5: What needs to be updated..."
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                 SYNC & UPDATE WORKFLOW                         ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

echo "CURRENT STATUS:"
echo "  ✓ Local Issues: $LOCAL_ISSUE_COUNT files"
echo "  ✓ Issue Range: #$MIN_LOCAL - #$MAX_LOCAL"
echo ""

echo "DIRECTORY STATUS:"
PLANS_COUNT=$(find "$PLANS_DIR" -name "plan-*.md" -type f 2>/dev/null | wc -l)
TASKS_COUNT=$(find "$TASKS_DIR" -name "task-*.md" -type f 2>/dev/null | wc -l)
DOCS_COUNT=$(find "$DOCS_DIR" -name "issue-*-implementation.md" -type f 2>/dev/null | wc -l)

echo "  • Plans: $PLANS_COUNT files"
echo "  • Tasks: $TASKS_COUNT files (across all categories)"
echo "  • Docs: $DOCS_COUNT files"
echo ""

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                  RECOMMENDED NEXT STEPS                        ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

echo "1. OPTIONAL: Set GitHub Token (for higher API limits)"
echo "   export GITHUB_TOKEN=ghp_your_token_here"
echo ""

echo "2. SYNC issues from GitHub"
echo "   ./sync-github-issues.sh"
echo "   (This will:"
echo "    - Fetch all issues from GitHub"
echo "    - Update existing issues"
echo "    - Add new issues)"
echo ""

echo "3. GENERATE/UPDATE tasks and plans"
echo "   ./create-from-issues.sh all"
echo "   (This will:"
echo "    - Create/update tasks in tasks/"
echo "    - Create/update plans in plans/"
echo "    - Generate docs in docs/)"
echo ""

echo "4. VERIFY changes"
echo "   ls -la tasks/*/"
echo "   ls -la plans/"
echo "   ls -la docs/issue-*-implementation.md"
echo ""

echo "5. CREATE feature branch to work on new issues"
echo "   git checkout develop"
echo "   git pull origin develop"
echo "   git checkout -b feature/issue-XXX-description"
echo ""

echo "6. IMPLEMENT based on generated task checklist"
echo "   cat tasks/<category>/task-XXX.md"
echo "   # Follow the checklist"
echo ""

echo "7. COMMIT with semantic messages"
echo "   git add ."
echo "   git commit -m 'feat: implement feature as per issue #XXX'"
echo ""

echo "8. PUSH and CREATE PR"
echo "   git push origin feature/issue-XXX-description"
echo "   # Create PR on GitHub to develop branch"
echo ""

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                  GIT FLOW REMINDER                             ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "Branch Strategy:"
echo "  master (production) ← release/ ← develop ← feature/"
echo ""
echo "Workflow:"
echo "  1. Start from develop"
echo "  2. Create feature/issue-XXX-name"
echo "  3. Implement & commit"
echo "  4. Push to remote"
echo "  5. Create PR to develop"
echo "  6. Get review & merge"
echo "  7. When ready, create release/"
echo "  8. Create PR release/ → master"
echo "  9. Tag version on master"
echo ""

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                    READY TO PROCEED                            ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
