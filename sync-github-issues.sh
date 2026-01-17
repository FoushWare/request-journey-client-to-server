#!/bin/bash

# GitHub Issues Sync Script
# Syncs all GitHub issues from remote repository to local issues/ folder
# Usage: ./sync-github-issues.sh [owner/repo] [optional: github-token]

set -e

# Configuration
REPO_PATH="${1:-.}"
OWNER_REPO="${2:-$(git -C "$REPO_PATH" config --get remote.origin.url | sed 's/.*[:/]\([^/]*\)\/\([^/]*\)\.git$/\1\/\2/')}"
GITHUB_TOKEN="${3:-$GITHUB_TOKEN}"
ISSUES_DIR="$REPO_PATH/issues"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

# Validate inputs
if [[ -z "$OWNER_REPO" ]]; then
    log_error "Could not determine repository. Please provide owner/repo as argument."
    exit 1
fi

log_info "Repository: $OWNER_REPO"
log_info "Issues directory: $ISSUES_DIR"

# Create issues directory if it doesn't exist
mkdir -p "$ISSUES_DIR"

# Setup GitHub API URL
GITHUB_API="https://api.github.com/repos/$OWNER_REPO"

# Setup curl headers
if [[ -n "$GITHUB_TOKEN" ]]; then
    AUTH_HEADER="Authorization: token $GITHUB_TOKEN"
    log_info "Using GitHub token for authentication"
else
    log_warning "No GitHub token provided. API rate limits will be lower (60 requests/hour)"
    log_warning "Set GITHUB_TOKEN environment variable for higher limits (5000 requests/hour)"
fi

# Function to make GitHub API calls
github_api_call() {
    local endpoint="$1"
    local query="${2:-}"
    
    local url="$GITHUB_API$endpoint"
    if [[ -n "$query" ]]; then
        url="$url?$query"
    fi
    
    if [[ -n "$GITHUB_TOKEN" ]]; then
        curl -s -H "$AUTH_HEADER" -H "Accept: application/vnd.github.v3+json" "$url"
    else
        curl -s -H "Accept: application/vnd.github.v3+json" "$url"
    fi
}

# Function to convert GitHub issue to markdown
issue_to_markdown() {
    local issue_json="$1"
    local issue_number=$(echo "$issue_json" | jq -r '.number')
    local title=$(echo "$issue_json" | jq -r '.title')
    local body=$(echo "$issue_json" | jq -r '.body // ""')
    local state=$(echo "$issue_json" | jq -r '.state')
    local created_at=$(echo "$issue_json" | jq -r '.created_at')
    local updated_at=$(echo "$issue_json" | jq -r '.updated_at')
    local author=$(echo "$issue_json" | jq -r '.user.login')
    local labels=$(echo "$issue_json" | jq -r '.labels[].name' | tr '\n' ', ' | sed 's/,$//')
    local assignees=$(echo "$issue_json" | jq -r '.assignees[].login' | tr '\n' ', ' | sed 's/,$//')
    local milestone=$(echo "$issue_json" | jq -r '.milestone.title // "None"')
    local url=$(echo "$issue_json" | jq -r '.html_url')
    local pr_url=$(echo "$issue_json" | jq -r '.pull_request.html_url // ""')
    
    cat > "$ISSUES_DIR/issue-$issue_number.md" << EOF
# Issue #$issue_number: $title

**Status**: $state  
**Created**: $created_at  
**Updated**: $updated_at  
**Author**: @$author  
**URL**: [$url]($url)

## Details

**Labels**: $labels  
**Assignees**: $assignees  
**Milestone**: $milestone  

EOF

    if [[ -n "$pr_url" ]]; then
        echo "**Related PR**: [$pr_url]($pr_url)" >> "$ISSUES_DIR/issue-$issue_number.md"
        echo "" >> "$ISSUES_DIR/issue-$issue_number.md"
    fi
    
    if [[ -n "$body" && "$body" != "null" ]]; then
        echo "## Description" >> "$ISSUES_DIR/issue-$issue_number.md"
        echo "" >> "$ISSUES_DIR/issue-$issue_number.md"
        echo "$body" >> "$ISSUES_DIR/issue-$issue_number.md"
        echo "" >> "$ISSUES_DIR/issue-$issue_number.md"
    fi
}

# Fetch all issues
log_info "Fetching issues from GitHub..."

page=1
per_page=100
total_fetched=0
closed_count=0
open_count=0

while true; do
    log_info "Fetching page $page..."
    
    response=$(github_api_call "/issues" "state=all&per_page=$per_page&page=$page&sort=updated&direction=desc")
    
    # Check if response is an error
    if echo "$response" | jq -e '.message' > /dev/null 2>&1; then
        error_msg=$(echo "$response" | jq -r '.message')
        log_error "GitHub API error: $error_msg"
        exit 1
    fi
    
    # Check if we got any issues
    issue_count=$(echo "$response" | jq 'length')
    
    if [[ $issue_count -eq 0 ]]; then
        log_info "Finished fetching all issues"
        break
    fi
    
    # Process each issue
    echo "$response" | jq -c '.[]' | while read -r issue; do
        issue_number=$(echo "$issue" | jq -r '.number')
        state=$(echo "$issue" | jq -r '.state')
        
        issue_to_markdown "$issue"
        
        if [[ "$state" == "closed" ]]; then
            ((closed_count++))
        else
            ((open_count++))
        fi
        
        log_info "Synced issue #$issue_number ($state)"
    done
    
    total_fetched=$((total_fetched + issue_count))
    
    # Check if there are more pages
    if [[ $issue_count -lt $per_page ]]; then
        break
    fi
    
    page=$((page + 1))
done

log_success "Issue sync complete!"
log_success "Total issues synced: $total_fetched"
log_info "Open issues: $open_count"
log_info "Closed issues: $closed_count"

# Create a sync summary file
cat > "$ISSUES_DIR/.sync-summary.txt" << EOF
Last synced: $(date)
Total issues: $total_fetched
Open: $open_count
Closed: $closed_count
Repository: $OWNER_REPO
EOF

log_success "Sync summary saved to $ISSUES_DIR/.sync-summary.txt"
