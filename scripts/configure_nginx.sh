#!/bin/bash
set -e

# Parameters
REGISTRY_DOMAIN="$1"
VPS_IP="$2"
REGISTRY_DIR="$3"
EMAIL="$4"

# Expand ~ to $HOME if present
REGISTRY_DIR="${REGISTRY_DIR/#\~/$HOME}"

# Export variables for envsubst
export REGISTRY_DOMAIN
export VPS_IP

#delete $REGISTRY_DOMAIN
REGISTRY_DOMAIN=""

# Function to configure Nginx with domain (HTTP only)
configure_nginx_with_domain_http() {
    echo "Configuring Nginx with domain (HTTP only)"

    # Substitute placeholders in the HTTP template
    envsubst '\$REGISTRY_DOMAIN' < "$REGISTRY_DIR/nginx-with-domain.conf.template" > "$REGISTRY_DIR/nginx.conf"

    # Enable the site by creating a symbolic link
    ln -sf "$REGISTRY_DIR/nginx.conf" /etc/nginx/sites-available/docker-registry.conf

    # Enable the site
    ln -sf /etc/nginx/sites-available/docker-registry.conf /etc/nginx/sites-enabled/

    # Test Nginx configuration
    nginx -t

    # Reload Nginx to apply changes
    systemctl reload nginx

    echo "Nginx configured with domain (HTTP only) successfully."
}

# Function to obtain SSL certificate and configure Nginx for HTTPS
obtain_ssl_and_configure_nginx() {
    echo "Obtaining SSL certificate using Certbot"

    # Install Certbot if not already installed
    apt-get update
    apt-get install -y certbot python3-certbot-nginx

    # Obtain SSL certificate and configure Nginx
    certbot --nginx -d "$REGISTRY_DOMAIN" --non-interactive --agree-tos -m "$EMAIL" --redirect

    echo "SSL certificate obtained and Nginx configured with HTTPS successfully."
}

# Function to configure Nginx without domain
configure_nginx_without_domain() {
    echo "Configuring Nginx without domain (using IP address)"

    # Substitute placeholders in the template
    envsubst '\$VPS_IP' < "$REGISTRY_DIR/nginx-without-domain.conf.template" > "$REGISTRY_DIR/nginx.conf"

    # Enable the site by creating a symbolic link
    ln -sf "$REGISTRY_DIR/nginx.conf" /etc/nginx/sites-available/docker-registry.conf

    # Enable the site
    ln -sf /etc/nginx/sites-available/docker-registry.conf /etc/nginx/sites-enabled/

    # Test Nginx configuration
    nginx -t

    # Restart Nginx to apply changes
    systemctl restart nginx

    echo "Nginx configured without domain successfully."
}

# Main Execution
if [ -z "$REGISTRY_DOMAIN" ]; then
    configure_nginx_without_domain
else
    configure_nginx_with_domain_http
    obtain_ssl_and_configure_nginx
fi
