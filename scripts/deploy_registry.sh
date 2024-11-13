#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Parameters
REGISTRY_USERNAME="$1"
REGISTRY_PASSWORD="$2"

# Define registry directory
REGISTRY_DIR=~/docker-registry

# Check if Docker registry is already deployed
if [ -d "$REGISTRY_DIR" ] && [ -f "$REGISTRY_DIR/docker-compose.yml" ]; then
    echo "Docker registry is already deployed. Skipping deployment."
    exit 0
fi

# Create Docker registry directory
mkdir -p "$REGISTRY_DIR"
echo "Docker registry directory created at $REGISTRY_DIR."

# Navigate to the Docker registry directory
cd "$REGISTRY_DIR"

# Upload docker-compose.yml from repository
# (Assumes docker-compose.yml has been uploaded via SCP in the workflow)

# Set up authentication
mkdir -p auth
if [ ! -f auth/htpasswd ]; then
    htpasswd -bc auth/htpasswd "$REGISTRY_USERNAME" "$REGISTRY_PASSWORD"
    echo "Authentication setup completed with user: $REGISTRY_USERNAME."
else
    echo "Authentication file already exists. Skipping htpasswd creation."
fi

# Start Docker registry
docker-compose up -d
echo "Docker registry started."
