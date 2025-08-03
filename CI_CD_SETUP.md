# CI/CD Setup for Cozy Cat Kitchen

This document explains the CI/CD pipeline setup for the Cozy Cat Kitchen eCommerce store.

## GitHub Actions Workflows

### 1. CI Pipeline (`.github/workflows/ci.yml`)
- Runs on: PRs to `develop`, `staging`, `main` and pushes to `feature/*`, `bugfix/*`, `release/*`
- Performs:
  - Node.js setup
  - Dependency installation (`npm ci`)
  - Linting (if configured)
  - Build
  - Tests (if configured)

### 2. Staging Deployment (`.github/workflows/deploy-staging.yml`)
- Triggers on: Push to `staging` branch or manual trigger
- Deploys to: Render Staging environment
- Requires: `RENDER_DEPLOY_HOOK_STAGING` secret

### 3. Production Deployment (`.github/workflows/deploy-prod.yml`)
- Triggers on: Push to `main` branch or manual trigger
- Deploys to: Render Production environment
- Requires: `RENDER_DEPLOY_HOOK_PROD` secret

## Required GitHub Secrets

1. Go to your GitHub repository
2. Navigate to Settings > Secrets and variables > Actions
3. Click "New repository secret"
4. Add these secrets:
   - `RENDER_DEPLOY_HOOK_STAGING`: Webhook URL for staging deployments (from Render)
   - `RENDER_DEPLOY_HOOK_PROD`: Webhook URL for production deployments (from Render)

## Getting Render Deploy Hooks

1. Go to your Render Dashboard
2. Select your service
3. Navigate to the "Manual Deploy" section
4. Click "Copy Deploy Hook URL"
5. Add this URL to the corresponding GitHub secret

## Branch Protection (Recommended)

1. Go to Settings > Branches
2. Add branch protection rules for:
   - `main`: Require pull request reviews before merging
   - `staging`: (Optional) Add similar protections as main
   - `develop`: (Optional) Add status checks to pass before merging
