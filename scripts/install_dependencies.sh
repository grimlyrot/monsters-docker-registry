#!/bin/bash
set -e

# Update package list
apt-get update

# Install Docker
apt-get install -y docker.io

# Install Docker Compose
apt-get install -y docker-compose

# Install Apache2 Utils for htpasswd
apt-get install -y apache2-utils

echo "Dependencies installed successfully."
