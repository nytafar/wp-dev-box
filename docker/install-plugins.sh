#!/bin/sh
set -e

# Wait for WordPress to be ready
until wp core is-installed --allow-root 2>/dev/null; do
    echo "Waiting for WordPress to be installed..."
    sleep 5
done

echo "WordPress is installed, checking plugins..."

# Check if auto-install is enabled
AUTO_INSTALL="${AUTO_INSTALL_PLUGINS:-true}"
if [ "$AUTO_INSTALL" != "true" ]; then
    echo "AUTO_INSTALL_PLUGINS is disabled, skipping plugin installation"
    exit 0
fi

# Check if auto-activate is enabled
AUTO_ACTIVATE="${AUTO_ACTIVATE_PLUGINS:-true}"

# Install plugins if WORDPRESS_PLUGINS is set
if [ -n "$WORDPRESS_PLUGINS" ]; then
    echo "Installing plugins: $WORDPRESS_PLUGINS"
    echo "Auto-activate: $AUTO_ACTIVATE"
    
    # Split comma-separated plugin list (sh-compatible way)
    echo "$WORDPRESS_PLUGINS" | tr ',' '\n' | while read -r plugin; do
        # Trim whitespace
        plugin=$(echo "$plugin" | xargs)
        
        if [ -n "$plugin" ]; then
            echo "Processing plugin: $plugin"
            
            # Extract plugin name (before colon if version specified)
            plugin_name="${plugin%%:*}"
            
            # Check if plugin is already installed
            if wp plugin is-installed "$plugin_name" --allow-root 2>/dev/null; then
                echo "Plugin $plugin_name already installed"
                
                # Activate if auto-activate is enabled and not already active
                if [ "$AUTO_ACTIVATE" = "true" ]; then
                    if ! wp plugin is-active "$plugin_name" --allow-root 2>/dev/null; then
                        echo "Activating plugin: $plugin_name"
                        wp plugin activate "$plugin_name" --allow-root 2>/dev/null || echo "Failed to activate $plugin"
                    fi
                fi
            else
                echo "Installing plugin: $plugin"
                
                if [ "$AUTO_ACTIVATE" = "true" ]; then
                    # Install and activate
                    wp plugin install "$plugin" --activate --allow-root 2>/dev/null || echo "Failed to install $plugin"
                else
                    # Install only, don't activate
                    wp plugin install "$plugin" --allow-root 2>/dev/null || echo "Failed to install $plugin"
                fi
            fi
        fi
    done
    
    echo "Plugin installation complete"
else
    echo "No plugins specified in WORDPRESS_PLUGINS"
fi

echo "Plugin installer finished"
