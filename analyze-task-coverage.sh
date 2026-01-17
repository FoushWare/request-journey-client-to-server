#!/bin/bash

# GitHub Issues to Tasks Coverage Analyzer
# This script analyzes which GitHub issues have corresponding task files

set -e

WORKSPACE="/Users/a.fouad/SideProjects/Request-journey/request-journey-client-to-server"
ISSUES_DIR="$WORKSPACE/issues"
TASKS_DIR="$WORKSPACE/tasks"

echo "📊 GitHub Issues to Tasks Coverage Analysis"
echo "==========================================="
echo ""

# Function to check if a task exists for an issue number
check_task_exists() {
    local issue_num=$1
    local found=0
    
    # Search in all task files for the issue reference
    if grep -r "Issue.*#$issue_num\|GitHub Issue.*#$issue_num\|issue.*#$issue_num" "$TASKS_DIR" 2>/dev/null | grep -q ".*"; then
        found=1
    fi
    
    echo $found
}

# Count issues
TOTAL_ISSUES=$(ls -1 "$ISSUES_DIR"/issue-*.md 2>/dev/null | wc -l)
COVERED_TASKS=0
UNCOVERED_ISSUES=()

echo "Analyzing $TOTAL_ISSUES issues..."
echo ""

# Check each issue
for issue_file in "$ISSUES_DIR"/issue-*.md; do
    filename=$(basename "$issue_file")
    issue_num=$(echo "$filename" | sed 's/issue-//;s/\.md//')
    
    # Skip README
    [[ "$filename" == "README.md" ]] && continue
    
    # Check if task exists
    if [ "$(check_task_exists "$issue_num")" -eq 1 ]; then
        ((COVERED_TASKS++))
    else
        UNCOVERED_ISSUES+=($issue_num)
    fi
done

COVERAGE=$((COVERED_TASKS * 100 / TOTAL_ISSUES))

echo "Coverage Summary:"
echo "=================="
echo "Total Issues: $TOTAL_ISSUES"
echo "Covered by Tasks: $COVERED_TASKS"
echo "Uncovered: ${#UNCOVERED_ISSUES[@]}"
echo "Coverage: $COVERAGE%"
echo ""

if [ ${#UNCOVERED_ISSUES[@]} -gt 0 ]; then
    echo "Uncovered Issues (first 20):"
    for i in "${!UNCOVERED_ISSUES[@]}"; do
        if [ $i -lt 20 ]; then
            echo "  - Issue #${UNCOVERED_ISSUES[$i]}"
        fi
    done
    if [ ${#UNCOVERED_ISSUES[@]} -gt 20 ]; then
        echo "  ... and $((${#UNCOVERED_ISSUES[@]} - 20)) more"
    fi
fi

echo ""
echo "Task Files by Category:"
echo "======================="
for category_dir in "$TASKS_DIR"/*/ ; do
    if [ -d "$category_dir" ]; then
        category=$(basename "$category_dir")
        task_count=$(ls -1 "$category_dir"/task-*.md 2>/dev/null | wc -l)
        if [ $task_count -gt 0 ]; then
            echo "  $category: $task_count tasks"
        fi
    fi
done

echo ""
echo "✅ Analysis complete!"
