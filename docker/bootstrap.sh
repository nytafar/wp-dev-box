# Zero-Friction Setup Bootstrap Script

echo "🔧 Bootstrapping environment..."

# Function to safely bootstrap a file from a template
bootstrap_file() {
    local template=$1
    local target=$2
    
    # If Docker created a directory for the missing bind mount, remove it
    if [ -d "$target" ]; then
        echo "Removing auto-created directory: $target"
        rm -rf "$target"
    fi
    
    # Copy template if target is missing
    if [ ! -f "$target" ]; then
        echo "Creating $target from template..."
        cp "$template" "$target"
    fi
}

bootstrap_file "/app-host/.env.example" "/app-host/.env"
bootstrap_file "/app-host/wp-config-template.php" "/app-host/wp-config.php"

echo "✅ Bootstrap complete."
