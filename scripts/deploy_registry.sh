#!/bin/bash
set -e

# Parameters
REGISTRY_USERNAME="$1"
REGISTRY_PASSWORD="$2"

# Define registry directory
REGISTRY_DIR="/home/${VPS_USER}/docker-registry"

# Define container name
CONTAINER_NAME="docker-registry"

# Function to check if the container is running
is_container_running() {
    docker ps --filter "name=^/${CONTAINER_NAME}$" --filter "status=running" | grep "${CONTAINER_NAME}" > /dev/null 2>&1
}

# Function to check if the container exists
does_container_exist() {
    docker ps -a --filter "name=^/${CONTAINER_NAME}$" | grep "${CONTAINER_NAME}" > /dev/null 2>&1
}

# Check if Docker registry container is running
if is_container_running; then
    echo "Docker registry container '${CONTAINER_NAME}' is already running. Skipping deployment."
    exit 0
fi

# If container exists but is not running, start it
if does_container_exist; then
    echo "Docker registry container '${CONTAINER_NAME}' exists but is not running. Starting the container."
    docker start "${CONTAINER_NAME}"
    exit 0
fi

# Proceed with deployment since container does not exist
echo "Docker registry container '${CONTAINER_NAME}' does not exist. Proceeding with deployment."

# Navigate to the registry directory
cd "$REGISTRY_DIR"

# Set up authentication
mkdir -p auth
if [ ! -f auth/htpasswd ]; then
    htpasswd -bc auth/htpasswd "$REGISTRY_USERNAME" "$REGISTRY_PASSWORD"
    echo "Authentication setup completed with user: $REGISTRY_USERNAME."
else
    echo "Authentication file already exists. Skipping htpasswd creation."
fi

# Start Docker registry using docker-compose
docker-compose up -d
echo "Docker registry deployed and started successfully."

# Verify that the container is running
if is_container_running; then
    echo "Docker registry container '${CONTAINER_NAME}' is now running."
else
    echo "Failed to start Docker registry container '${CONTAINER_NAME}'. Please check the logs."
    exit 1
fi
