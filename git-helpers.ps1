<#
.SYNOPSIS
    Git workflow helpers for Cozy Cat Kitchen development
.DESCRIPTION
    This script provides PowerShell functions to streamline common Git workflows.
    To use these functions, source this script in your PowerShell session:
    .\git-helpers.ps1
#>

# Start a new feature
function gfeature {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Name
    )
    
    # Make sure we're on develop and up to date
    git checkout develop
    git pull origin develop
    
    # Create feature branch with timestamp and sanitized name
    $timestamp = Get-Date -Format "yyyyMMdd"
    $safe_name = $Name.ToLower() -replace '[^a-z0-9-]', '-'
    $branch_name = "feature/${timestamp}-${safe_name}"
    
    git checkout -b $branch_name
    Write-Host "✅ Created and switched to new feature branch: $branch_name" -ForegroundColor Green
}

# Start a bugfix
function gbugfix {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Description
    )
    
    # Make sure we're on develop and up to date
    git checkout develop
    git pull origin develop
    
    # Create bugfix branch with timestamp and sanitized name
    $timestamp = Get-Date -Format "yyyyMMdd"
    $safe_name = $Description.ToLower() -replace '[^a-z0-9-]', '-'
    $branch_name = "bugfix/${timestamp}-${safe_name}"
    
    git checkout -b $branch_name
    Write-Host "✅ Created and switched to new bugfix branch: $branch_name" -ForegroundColor Green
}

# Sync current branch with develop
function gsync {
    $current_branch = git rev-parse --abbrev-ref HEAD
    
    if (@('main', 'develop', 'staging') -contains $current_branch) {
        Write-Host "⚠️  You're on $current_branch. Pulling latest changes..." -ForegroundColor Yellow
        git pull origin $current_branch
        return
    }
    
    Write-Host "🔄 Syncing $current_branch with develop..." -ForegroundColor Cyan
    git stash
    git checkout develop
    git pull origin develop
    git checkout $current_branch
    git rebase develop
    git stash pop
    Write-Host "✅ $current_branch is now up to date with develop" -ForegroundColor Green
}

# Push current branch and set upstream
function gpush {
    $current_branch = git rev-parse --abbrev-ref HEAD
    
    if (@('main', 'develop', 'staging') -contains $current_branch) {
        Write-Host "⚠️  You're trying to push to $current_branch directly. This is not recommended." -ForegroundColor Yellow
        $confirmation = Read-Host "Are you sure you want to continue? (y/N)"
        if ($confirmation -ne 'y') {
            Write-Host "Push cancelled." -ForegroundColor Red
            return
        }
    }
    
    git push -u origin $current_branch
}

# Create a pull request
function gpr {
    $current_branch = git rev-parse --abbrev-ref HEAD
    $target_branch = "develop"
    
    if ($current_branch -eq "develop") {
        $target_branch = "staging"
    } elseif ($current_branch -eq "staging") {
        $target_branch = "main"
    }
    
    Write-Host "📝 Creating PR from $current_branch to $target_branch..." -ForegroundColor Cyan
    
    # Push the branch if not already pushed
    git push -u origin $current_branch 2> $null
    
    # Open the PR in the default browser
    $pr_url = "https://github.com/aditya01889/cozystore/compare/${target_branch}...${current_branch}?expand=1"
    Write-Host "🌐 Opening PR in your browser: $pr_url" -ForegroundColor Cyan
    Start-Process $pr_url
}

# Show branch status
function gstatus {
    $current_branch = git rev-parse --abbrev-ref HEAD
    Write-Host "🌿 Current branch: $current_branch" -ForegroundColor Green
    
    Write-Host "`n🔄 Changes not staged for commit:" -ForegroundColor Yellow
    git diff --name-only --diff-filter=ACMRTUXB
    
    Write-Host "`n📦 Changes to be committed:" -ForegroundColor Green
    git diff --cached --name-only
    
    Write-Host "`n📊 Branch status:" -ForegroundColor Cyan
    git status -sb
}

# Show help
function ghelp {
    Write-Host "`n🌟 Cozy Cat Kitchen Git Workflow Helpers" -ForegroundColor Magenta
    Write-Host "==================================" -ForegroundColor Magenta
    Write-Host "gfeature <name>  - Start a new feature branch" -ForegroundColor Cyan
    Write-Host "gbugfix <desc>   - Start a new bugfix branch" -ForegroundColor Cyan
    Write-Host "gsync            - Sync current branch with develop" -ForegroundColor Cyan
    Write-Host "gpush            - Push current branch and set upstream" -ForegroundColor Cyan
    Write-Host "gpr              - Create a PR for the current branch" -ForegroundColor Cyan
    Write-Host "gstatus          - Show current branch status" -ForegroundColor Cyan
    Write-Host "ghelp            - Show this help message" -ForegroundColor Cyan
    
    Write-Host "`nExample workflow:" -ForegroundColor Yellow
    Write-Host "  > gfeature user-authentication" -ForegroundColor White
    Write-Host "  # Make your changes..." -ForegroundColor Gray
    Write-Host "  > git add ." -ForegroundColor White
    Write-Host "  > git commit -m 'feat(auth): add user login functionality'" -ForegroundColor White
    Write-Host "  > gpush" -ForegroundColor White
    Write-Host "  > gpr" -ForegroundColor White
    Write-Host ""
}

# Show help when script is run directly
if ($MyInvocation.InvocationName -ne '.') {
    ghelp
    Write-Host "`n❗ To use these functions in your current session, run:" -ForegroundColor Yellow
    Write-Host "  .\$($MyInvocation.MyCommand.Name)" -ForegroundColor White
    Write-Host "`n  Or add to your PowerShell profile to make them always available:" -ForegroundColor Yellow
    Write-Host "  Add-Content -Path `$PROFILE -Value "". '$(Get-Location)\$($MyInvocation.MyCommand.Name)'`" -ForegroundColor White
} else {
    Write-Host "🌟 Cozy Cat Kitchen Git Helpers loaded!" -ForegroundColor Green
    Write-Host "Type 'ghelp' to see available commands." -ForegroundColor Green
}
