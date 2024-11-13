#!/bin/bash
set -e

# Parameters
REGISTRY_DOMAIN="$1"
VPS_IP="$2"
REGISTRY_DIR="$3"
EMAIL="$4"

# Function to configure Nginx with domain
configure_nginx_with_domain() {
    echo "Configuring Nginx with domain: $REGISTRY_DOMAIN"

    # Substitute placeholders in the template
    envsubst '\$REGISTRY_DOMAIN' < "$REGISTRY_DIR/nginx-with-domain.conf.template" > "$REGISTRY_DIR/nginx.conf"

    # Enable the site by creating a symbolic link
    ln -sf "$REGISTRY_DIR/nginx.conf" /etc/nginx/sites-available/docker-registry.conf

    # Enable the site
    ln -sf /etc/nginx/sites-available/docker-registry.conf /etc/nginx/sites-enabled/

    # Obtain SSL certificate using Certbot
    apt-get update
    apt-get install -y certbot python3-certbot-nginx

    certbot --nginx -d "$REGISTRY_DOMAIN" --non-interactive --agree-tos -m "$EMAIL" --redirect

    echo "Nginx configured with domain and SSL successfully."
}

# Function to configure Nginx without domain
configure_nginx_without_domain() {
    echo "Configuring Nginx without domain (using IP address): $VPS_IP"

    # Substitute placeholders in the template
    envsubst '\$VPS_IP' < "$REGISTRY_DIR/nginx-without-domain.conf.template" > "$REGISTRY_DIR/nginx.conf"

    # Enable the site by creating a symbolic link
    ln -sf "$REGISTRY_DIR/nginx.conf" /etc/nginx/sites-available/docker-registry.conf

    # Enable the site
    ln -sf /etc/nginx/sites-available/docker-registry.conf /etc/nginx/sites-enabled/

    # Restart Nginx
    systemctl restart nginx

    echo "Nginx configured without domain successfully."
}

# Check if REGISTRY_DOMAIN is provided
if [ -z "$REGISTRY_DOMAIN" ]; then
    configure_nginx_without_domain
else
    configure_nginx_with_domain
fi
