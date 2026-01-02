#!/bin/bash
set -e

# Wait for WordPress to be ready
until wp core is-installed --allow-root 2>/dev/null; do
    echo "Waiting for WordPress to be installed..."
    sleep 5
done

echo "WordPress is installed, checking plugins..."

# Install plugins if WORDPRESS_PLUGINS is set
if [ -n "$WORDPRESS_PLUGINS" ]; then
    echo "Installing/activating plugins: $WORDPRESS_PLUGINS"
    
    # Split comma-separated plugin list
    IFS=',' read -ra PLUGINS <<< "$WORDPRESS_PLUGINS"
    
    for plugin in "${PLUGINS[@]}"; do
        # Trim whitespace
        plugin=$(echo "$plugin" | xargs)
        
        if [ -n "$plugin" ]; then
            echo "Processing plugin: $plugin"
            
            # Check if plugin is already installed
            if wp plugin is-installed "${plugin%%:*}" --allow-root 2>/dev/null; then
                echo "Plugin ${plugin%%:*} already installed"
                wp plugin activate "${plugin%%:*}" --allow-root 2>/dev/null || true
            else
                echo "Installing plugin: $plugin"
                wp plugin install "$plugin" --activate --allow-root 2>/dev/null || echo "Failed to install $plugin"
            fi
        fi
    done
    
    echo "Plugin installation complete"
fi

echo "Entrypoint script finished"
