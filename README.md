# Private Docker Registry Deployment

This repository contains the configuration files and GitHub Actions workflow to deploy a private Docker registry on a VPS via SSH, secured with SSL.

## Setup

### 1. Configure GitHub Secrets

Add the following secrets to your GitHub repository:

- `SSH_PRIVATE_KEY` - Your SSH private key.
- `VPS_HOST` - VPS IP or domain.
- `VPS_USER` - SSH username.
- `REGISTRY_USERNAME` - Docker registry username.
- `REGISTRY_PASSWORD` - Docker registry password.
- `REGISTRY_DOMAIN` - Domain name for the registry.
- `EMAIL` - Email for SSL certificate registration.
- `EMAIL_USERNAME` - SMTP server username.
- `EMAIL_PASSWORD` - SMTP server password.

### 2. Deployment

Push to the `main` branch to trigger the deployment workflow.

```bash
git add .
git commit -m "Initial deployment"
git push origin main
