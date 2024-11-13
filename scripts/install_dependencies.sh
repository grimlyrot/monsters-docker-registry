#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Update package list
sudo apt-get update

# Install Docker if not installed
if ! command -v docker &> /dev/null; then
    sudo apt-get install -y docker.io
    sudo systemctl enable docker
    sudo systemctl start docker
    echo "Docker installed and started."
fi

# Install Docker Compose if not installed
if ! command -v docker-compose &> /dev/null; then
    sudo apt-get install -y docker-compose
    echo "Docker Compose installed."
fi

# Install Nginx, Certbot, and Apache utilities
sudo apt-get install -y nginx certbot python3-certbot-nginx apache2-utils
echo "Nginx, Certbot, and Apache utilities installed."

# Enable and start Nginx
sudo systemctl enable nginx
sudo systemctl start nginx
echo "Nginx enabled and started."

# Verify Nginx status
sudo systemctl status nginx --no-pager
