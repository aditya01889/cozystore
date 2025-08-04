#!/bin/bash

# Git Workflow Helpers for Cozy Cat Kitchen
# Save this file as git-helpers.sh and source it in your shell:
# source ./git-helpers.sh

# Start a new feature
function gfeature() {
    if [ -z "$1" ]; then
        echo "Usage: gfeature <feature-name>"
        return 1
    fi
    
    # Make sure we're on develop and up to date
    git checkout develop
    git pull origin develop
    
    # Create feature branch with timestamp and sanitized name
    local timestamp=$(date +%Y%m%d)
    local safe_name=$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')
    local branch_name="feature/${timestamp}-${safe_name}"
    
    git checkout -b "$branch_name"
    echo "✅ Created and switched to new feature branch: $branch_name"
}

# Start a bugfix
function gbugfix() {
    if [ -z "$1" ]; then
        echo "Usage: gbugfix <bug-description>"
        return 1
    fi
    
    # Make sure we're on develop and up to date
    git checkout develop
    git pull origin develop
    
    # Create bugfix branch with timestamp and sanitized name
    local timestamp=$(date +%Y%m%d)
    local safe_name=$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')
    local branch_name="bugfix/${timestamp}-${safe_name}"
    
    git checkout -b "$branch_name"
    echo "✅ Created and switched to new bugfix branch: $branch_name"
}

# Sync current branch with develop
function gsync() {
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    
    if [ "$current_branch" = "main" ] || [ "$current_branch" = "develop" ] || [ "$current_branch" = "staging" ]; then
        echo "⚠️  You're on $current_branch. Pulling latest changes..."
        git pull origin "$current_branch"
        return 0
    fi
    
    echo "🔄 Syncing $current_branch with develop..."
    git stash
    git checkout develop
    git pull origin develop
    git checkout "$current_branch"
    git rebase develop
    git stash pop
    echo "✅ $current_branch is now up to date with develop"
}

# Push current branch and set upstream
function gpush() {
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    
    if [ "$current_branch" = "main" ] || [ "$current_branch" = "develop" ] || [ "$current_branch" = "staging" ]; then
        echo "⚠️  You're trying to push to $current_branch directly. This is not recommended."
        read -p "Are you sure you want to continue? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Push cancelled."
            return 1
        fi
    fi
    
    git push -u origin "$current_branch"
}

# Create a pull request
function gpr() {
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    local target_branch="develop"
    
    if [ "$current_branch" = "develop" ]; then
        target_branch="staging"
    elif [ "$current_branch" = "staging" ]; then
        target_branch="main"
    fi
    
    echo "📝 Creating PR from $current_branch to $target_branch..."
    
    # Push the branch if not already pushed
    git push -u origin "$current_branch" 2> /dev/null || true
    
    # Open the PR in the default browser
    local pr_url="https://github.com/aditya01889/cozystore/compare/${target_branch}...${current_branch}?expand=1"
    echo "🌐 Opening PR in your browser: $pr_url"
    open "$pr_url"
}

# Show branch status
function gstatus() {
    echo "🌿 Current branch: $(git rev-parse --abbrev-ref HEAD)"
    echo "🔄 Changes not staged for commit:"
    git diff --name-only --diff-filter=ACMRTUXB
    echo "\n📦 Changes to be committed:"
    git diff --cached --name-only
    echo "\n📊 Branch status:"
    git status -sb
}

# Show help
function ghelp() {
    echo "\n🌟 Cozy Cat Kitchen Git Workflow Helpers"
    echo "=================================="
    echo "gfeature <name>  - Start a new feature branch"
    echo "gbugfix <desc>   - Start a new bugfix branch"
    echo "gsync            - Sync current branch with develop"
    echo "gpush            - Push current branch and set upstream"
    echo "gpr              - Create a PR for the current branch"
    echo "gstatus          - Show current branch status"
    echo "ghelp            - Show this help message"
    echo ""
    echo "Example workflow:"
    echo "  $ gfeature user-authentication"
    echo "  # Make your changes..."
    echo "  $ git add ."
    echo "  $ git commit -m 'feat(auth): add user login functionality'"
    echo "  $ gpush"
    echo "  $ gpr"
    echo ""
}

# Show help by default
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    ghelp
    return 0
fi

echo "🌟 Cozy Cat Kitchen Git Helpers loaded!"
echo "Type 'ghelp' to see available commands."
