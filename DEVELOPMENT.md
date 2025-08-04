# Cozy Cat Kitchen Development Guide

This document outlines the Git branching strategy and development workflow for the Cozy Cat Kitchen e-commerce project.

## Branching Strategy

### Main Branches

1. **`main`**
   - Production-ready code only
   - Protected branch (direct commits disabled)
   - Updated only via Pull Requests from `staging`
   - Always deployable

2. **`staging`**
   - Pre-production environment
   - Used for final testing before production
   - Updated via Pull Requests from `develop`

3. **`develop`**
   - Primary development branch
   - Integration branch for all features
   - Should always be in a deployable state

### Support Branches

1. **`feature/*`**
   - For developing new features
   - Branch from: `develop`
   - Merge into: `develop`
   - Naming: `feature/descriptive-name` (e.g., `feature/user-authentication`)

2. **`bugfix/*`**
   - For bug fixes
   - Branch from: `develop`
   - Merge into: `develop`
   - Naming: `bugfix/issue-description` (e.g., `bugfix/login-validation`)

3. **`release/*`** (Optional)
   - For release preparation
   - Branch from: `develop`
   - Merge into: `develop` and `main`
   - Naming: `release/v1.0.0`

## Workflow

### Starting a New Feature

```bash
# Make sure you're on the develop branch
git checkout develop

# Pull the latest changes
git pull origin develop

# Create and switch to a new feature branch
git checkout -b feature/your-feature-name
```

### Committing Changes

1. Stage your changes:
   ```bash
   git add .
   ```

2. Commit using the provided template:
   ```bash
   git commit
   ```
   (This will open the configured commit message template)

3. Push your branch:
   ```bash
   git push -u origin feature/your-feature-name
   ```

### Finishing a Feature

1. Make sure all tests pass
2. Ensure your branch is up to date with `develop`
3. Create a Pull Request (PR) from `feature/*` to `develop`
4. After code review and approval, merge the PR
5. Delete the feature branch after merging

### Releasing to Staging

1. Create a PR from `develop` to `staging`
2. After testing in staging, create a PR from `staging` to `main` for production deployment

## Useful Aliases (Optional)

Add these to your `~/.gitconfig` for convenience:

```ini
[alias]
    # Create and switch to a new feature branch
    fnew = "!git checkout -b feature/$(date +%Y%m%d)-$(git rev-parse --abbrev-ref HEAD | cut -d'/' -f2- | tr '[:upper:]' '[:lower:]' | tr ' ' '-')-$(git rev-parse --short HEAD)"
    
    # Update current branch with latest from develop
    sync = "!git fetch origin && git rebase origin/develop"
    
    # Show branch tree
    tree = log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all
```

## Best Practices

- Always pull the latest changes before starting work
- Keep commits small and focused
- Write clear, descriptive commit messages
- Test your changes before pushing
- Never push directly to `main` or `staging` - always use PRs
- Delete merged branches to keep the repository clean
- Keep `develop` stable and deployable at all times
