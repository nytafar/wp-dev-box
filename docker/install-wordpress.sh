#!/bin/bash
set -e

echo "WordPress Installation Script"
echo "=============================="

# Wait for WordPress core files to be ready
until [ -f /var/www/html/wp-load.php ]; do
    echo "Waiting for WordPress core files..."
    sleep 2
done

echo "WordPress core files found"

# Check if auto-install is enabled
AUTO_INSTALL="${AUTO_INSTALL_WORDPRESS:-true}"
if [ "$AUTO_INSTALL" != "true" ]; then
    echo "AUTO_INSTALL_WORDPRESS is disabled, skipping automatic installation"
    echo "Please complete WordPress setup via the web installer at your site URL"
    exit 0
fi

# Check if WordPress is already installed
if wp core is-installed --allow-root 2>/dev/null; then
    echo "WordPress is already installed, skipping installation"
    exit 0
fi

echo "WordPress not installed, proceeding with installation..."

# Get configuration from environment variables
SITE_URL="${WORDPRESS_SITE_URL:-http://localhost}"
SITE_TITLE="${WORDPRESS_SITE_TITLE:-My WordPress Site}"
ADMIN_USER="${WORDPRESS_ADMIN_USER:-admin}"
ADMIN_PASSWORD="${WORDPRESS_ADMIN_PASSWORD:-}"
ADMIN_EMAIL="${WORDPRESS_ADMIN_EMAIL:-admin@example.com}"
LOCALE="${WORDPRESS_LOCALE:-en_US}"

# Generate a secure password if not provided
if [ -z "$ADMIN_PASSWORD" ]; then
    ADMIN_PASSWORD=$(tr -dc 'A-Za-z0-9!@#$%^&*' < /dev/urandom | head -c 20)
    echo "Generated admin password: $ADMIN_PASSWORD"
    echo "IMPORTANT: Save this password!"
fi

echo "Installing WordPress..."
echo "  Site URL: $SITE_URL"
echo "  Title: $SITE_TITLE"
echo "  Admin User: $ADMIN_USER"
echo "  Admin Email: $ADMIN_EMAIL"
echo "  Locale: $LOCALE"

# Install WordPress
wp core install \
    --url="$SITE_URL" \
    --title="$SITE_TITLE" \
    --admin_user="$ADMIN_USER" \
    --admin_password="$ADMIN_PASSWORD" \
    --admin_email="$ADMIN_EMAIL" \
    --locale="$LOCALE" \
    --skip-email \
    --allow-root

echo "WordPress installed successfully!"

# Set search engine visibility
SEARCH_VISIBILITY="${WORDPRESS_SEARCH_ENGINE_VISIBILITY:-0}"
if [ "$SEARCH_VISIBILITY" = "1" ]; then
    echo "Discouraging search engines from indexing this site..."
    wp option update blog_public 0 --allow-root
else
    echo "Allowing search engines to index this site"
    wp option update blog_public 1 --allow-root
fi

# Set permalink structure to pretty URLs
echo "Setting permalink structure..."
wp rewrite structure '/%postname%/' --allow-root
wp rewrite flush --allow-root

echo ""
echo "========================================="
echo "WordPress Installation Complete!"
echo "========================================="
echo "Site URL: $SITE_URL"
echo "Admin User: $ADMIN_USER"
if [ -n "${WORDPRESS_ADMIN_PASSWORD}" ]; then
    echo "Admin Password: (from environment)"
else
    echo "Admin Password: $ADMIN_PASSWORD"
fi
echo "========================================="
