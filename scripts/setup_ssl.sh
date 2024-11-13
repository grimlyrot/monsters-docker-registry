#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Parameters
REGISTRY_DOMAIN="$1"
EMAIL="$2"

# Define registry directory
REGISTRY_DIR=~/docker-registry

# Navigate to the Docker registry directory
cd "$REGISTRY_DIR"

# Upload nginx.conf from repository
# (Assumes nginx.conf has been uploaded via SCP in the workflow)

# Configure Nginx
sudo cp nginx.conf /etc/nginx/sites-available/docker-registry.conf
echo "Nginx configuration copied to sites-available."

# Remove default Nginx site if it exists to prevent conflicts
sudo rm -f /etc/nginx/sites-enabled/default

# Create symbolic link in sites-enabled
sudo ln -sf /etc/nginx/sites-available/docker-registry.conf /etc/nginx/sites-enabled/docker-registry.conf
echo "Nginx configuration enabled."

# Test Nginx configuration
sudo nginx -t

# Restart Nginx to apply changes
sudo systemctl restart nginx
echo "Nginx restarted with new configuration."

# Obtain SSL certificate using Certbot
sudo certbot --nginx -d "$REGISTRY_DOMAIN" --non-interactive --agree-tos -m "$EMAIL" --redirect
echo "SSL certificate obtained and configured with Nginx."

# Verify Nginx status
sudo systemctl status nginx --no-pager
