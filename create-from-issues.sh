#!/bin/bash

# Convert GitHub Issues to Tasks, Plans, and Docs
# Usage: ./create-from-issues.sh [issue-number-or-all]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ISSUES_DIR="$SCRIPT_DIR/issues"
TASKS_DIR="$SCRIPT_DIR/tasks"
PLANS_DIR="$SCRIPT_DIR/plans"
DOCS_DIR="$SCRIPT_DIR/docs"
IMPLEMENTATION_DIR="$SCRIPT_DIR/implementation"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Ensure directories exist
mkdir -p "$TASKS_DIR" "$PLANS_DIR" "$DOCS_DIR" "$IMPLEMENTATION_DIR"

# Function to extract issue details from markdown file
extract_issue_details() {
    local issue_file="$1"
    
    if [[ ! -f "$issue_file" ]]; then
        return 1
    fi
    
    local issue_number=$(basename "$issue_file" .md | sed 's/issue-//')
    local title=$(grep "^# Issue" "$issue_file" | sed 's/.*: //')
    local status=$(grep "^**Status**" "$issue_file" | sed 's/.*: //')
    local labels=$(grep "^**Labels**" "$issue_file" | sed 's/.*: //')
    local description=$(sed -n '/## Description/,/^## /p' "$issue_file" | tail -n +2 | head -n -1)
    
    echo "$issue_number"
    echo "$title"
    echo "$status"
    echo "$labels"
    echo "$description"
}

# Function to create task from issue
create_task_from_issue() {
    local issue_file="$1"
    
    # Read issue details
    local issue_num=$(grep "Issue #" "$issue_file" | head -1 | sed 's/.*Issue #\([0-9]*\).*/\1/')
    local title=$(grep "^# Issue" "$issue_file" | sed 's/.*: //')
    local status=$(grep "^**Status**" "$issue_file" | sed 's/.*: //')
    local description=$(sed -n '/## Description/,/^## /p' "$issue_file" | tail -n +2 | head -n -1)
    local url=$(grep "^\*\*URL\*\*" "$issue_file" | sed 's/.*\[\(.*\)\].*/\1/')
    
    # Determine task category from labels
    local category="general"
    if grep -q "feature" "$issue_file"; then
        category="features"
    elif grep -q "bug" "$issue_file"; then
        category="bugs"
    elif grep -q "infrastructure" "$issue_file"; then
        category="infrastructure"
    elif grep -q "documentation" "$issue_file"; then
        category="documentation"
    elif grep -q "testing" "$issue_file"; then
        category="testing"
    fi
    
    # Create task directory
    mkdir -p "$TASKS_DIR/$category"
    
    # Create task file
    local task_file="$TASKS_DIR/$category/task-${issue_num}.md"
    
    cat > "$task_file" << EOF
# Task #${issue_num}: ${title}

**Status**: Not Started  
**Priority**: Medium  
**Type**: Task  
**Issue**: [#${issue_num}](${url})  
**Category**: ${category}  

## Objective

${description:-Implement feature or fix as described in the GitHub issue.}

## Acceptance Criteria

- [ ] Task implemented according to issue specifications
- [ ] Code reviewed and approved
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] PR created and merged

## Implementation Details

See the original GitHub issue for complete details:
[Issue #${issue_num}](${url})

## Related Issues

- Original GitHub Issue #${issue_num}

## Notes

Task created from GitHub issue on $(date)
EOF

    log_success "Created task: $task_file"
}

# Function to create plan from issue
create_plan_from_issue() {
    local issue_file="$1"
    
    local issue_num=$(grep "Issue #" "$issue_file" | head -1 | sed 's/.*Issue #\([0-9]*\).*/\1/')
    local title=$(grep "^# Issue" "$issue_file" | sed 's/.*: //')
    local url=$(grep "^\*\*URL\*\*" "$issue_file" | sed 's/.*\[\(.*\)\].*/\1/')
    
    local plan_file="$PLANS_DIR/plan-issue-${issue_num}.md"
    
    cat > "$plan_file" << EOF
# Plan: ${title}

**Status**: Planning  
**Issue**: [#${issue_num}](${url})  
**Created**: $(date)  

## Overview

Plan for addressing GitHub issue #${issue_num}.

## Goals

1. Understand the issue requirements
2. Design a solution
3. Plan implementation approach
4. Create necessary tasks
5. Execute and verify

## Phases

### Phase 1: Analysis
- [ ] Review issue details thoroughly
- [ ] Identify dependencies
- [ ] Assess impact

### Phase 2: Design
- [ ] Design solution approach
- [ ] Consider edge cases
- [ ] Document architecture

### Phase 3: Implementation
- [ ] Create development branch
- [ ] Implement solution
- [ ] Add tests
- [ ] Update documentation

### Phase 4: Review & Merge
- [ ] Create pull request
- [ ] Address review feedback
- [ ] Merge to develop/master
- [ ] Verify deployment

## Success Criteria

- [ ] Issue resolved
- [ ] All tests passing
- [ ] Code reviewed and approved
- [ ] Documentation complete

## References

- Original Issue: [#${issue_num}](${url})

---
Plan created on $(date)
EOF

    log_success "Created plan: $plan_file"
}

# Function to create documentation from issue
create_docs_from_issue() {
    local issue_file="$1"
    
    local issue_num=$(grep "Issue #" "$issue_file" | head -1 | sed 's/.*Issue #\([0-9]*\).*/\1/')
    local title=$(grep "^# Issue" "$issue_file" | sed 's/.*: //')
    local url=$(grep "^\*\*URL\*\*" "$issue_file" | sed 's/.*\[\(.*\)\].*/\1/')
    
    local doc_file="$DOCS_DIR/issue-${issue_num}-implementation.md"
    
    cat > "$doc_file" << EOF
# Implementation Documentation: ${title}

**Issue**: [#${issue_num}](${url})  
**Date**: $(date)  

## Overview

This document describes the implementation of GitHub issue #${issue_num}.

## Problem Statement

See the original GitHub issue: [#${issue_num}](${url})

## Solution Approach

1. **Design**
   - Describe the overall design

2. **Implementation**
   - Detail the implementation approach
   - Include code structure
   - Document key functions/classes

3. **Testing**
   - Outline testing strategy
   - Include test cases

4. **Deployment**
   - Describe deployment approach
   - Include any migration steps

## Technical Details

### Architecture

- Document any architectural changes

### Dependencies

- List any new dependencies added

### Database Changes

- Document any schema changes

### API Changes

- Document any API modifications

## Testing

### Unit Tests

- [ ] Add unit tests

### Integration Tests

- [ ] Add integration tests

### E2E Tests

- [ ] Add end-to-end tests

## Deployment

### Pre-deployment

- [ ] Database migrations
- [ ] Configuration updates

### Deployment Steps

1. Step 1
2. Step 2
3. Step 3

### Post-deployment

- [ ] Verification
- [ ] Monitoring

## Rollback Plan

If issues arise:
1. Rollback steps
2. Communication plan

## Monitoring

- [ ] Set up monitoring
- [ ] Define alerts
- [ ] Create runbooks

## References

- Original Issue: [#${issue_num}](${url})
- Related Code: (will be updated with links)

---
Documentation created on $(date)
EOF

    log_success "Created documentation: $doc_file"
}

# Main function
main() {
    local issue_pattern="${1:-.}"
    
    if [[ "$issue_pattern" == "all" ]]; then
        log_info "Processing all issues..."
        for issue_file in "$ISSUES_DIR"/issue-*.md; do
            if [[ -f "$issue_file" ]]; then
                log_info "Processing: $(basename $issue_file)"
                create_task_from_issue "$issue_file"
                create_plan_from_issue "$issue_file"
                create_docs_from_issue "$issue_file"
            fi
        done
    elif [[ "$issue_pattern" =~ ^[0-9]+$ ]]; then
        log_info "Processing issue #$issue_pattern..."
        local issue_file="$ISSUES_DIR/issue-${issue_pattern}.md"
        if [[ -f "$issue_file" ]]; then
            create_task_from_issue "$issue_file"
            create_plan_from_issue "$issue_file"
            create_docs_from_issue "$issue_file"
        else
            log_error "Issue file not found: $issue_file"
            exit 1
        fi
    else
        log_error "Invalid argument: $issue_pattern"
        log_info "Usage: $0 [issue-number|all]"
        exit 1
    fi
    
    log_success "Process complete!"
}

# Run main function
main "$@"
