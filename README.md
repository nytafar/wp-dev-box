# WP-Dev-Box - WordPress Docker Compose Template

Simple and production-ready WordPress template with Nginx, MariaDB, Redis, WP-CLI, auto-backups, and multi-instance support.

## Three Setup Scenarios

### Scenario 1: Zero-Configuration (Clone and Run)
**Best for:** Quick testing, development, proof-of-concepts

```bash
git clone https://github.com/nytafar/wp-dev-box.git
cd wp-dev-box
docker compose up -d
```

**What happens automatically:**
- ✅ `.env` and `wp-config.php` created from templates
- ✅ WordPress auto-installed with default settings
- ✅ Site ready at http://localhost
- Default admin: `admin` / `changeme_admin_password`

### Scenario 2: Custom Configuration
**Best for:** Development with specific settings

```bash
git clone https://github.com/nytafar/wp-dev-box.git
cd wp-dev-box

# Configure your settings
cp .env.example .env
nano .env  # Edit admin password, site title, plugins, etc.

# Start and auto-install with your settings
docker compose up -d
```

**What happens automatically:**
- ✅ `wp-config.php` created from template
- ✅ WordPress auto-installed with YOUR settings from `.env`
- ✅ Site ready with your configuration

**To disable auto-install:** Set `AUTO_INSTALL_WORDPRESS=false` in `.env` and use the web installer instead.

### Scenario 3: Full Manual Control
**Best for:** Production, advanced customization

```bash
git clone https://github.com/nytafar/wp-dev-box.git
cd wp-dev-box

# Configure environment
cp .env.example .env
nano .env

# Customize WordPress configuration
cp wp-config-template.php wp-config.php
nano wp-config.php  # Add custom defines, plugins, etc.

# Disable auto-install in .env
# AUTO_INSTALL_WORDPRESS=false

# Start stack
docker compose up -d

# Complete WordPress setup via web installer
open http://localhost
```

**Full control over:**
- ✅ All environment variables
- ✅ WordPress configuration (wp-config.php)
- ✅ Installation process (web installer or WP-CLI)

---

## Features

✅ **Production-Ready Stack**: Nginx, PHP 8.2 FPM, MariaDB 10.11, Redis 7  
✅ **Auto-Install Option**: WordPress installs automatically (or use web installer)  
✅ **Smart Bootstrap**: Missing config files created automatically  
✅ **Multi-Instance Support**: Run multiple WordPress sites simultaneously  
✅ **Automatic Plugin Installation**: Specify plugins in .env file  
✅ **Auto-Generated Security Salts**: Unique keys from WordPress.org API  
✅ **WP-CLI Included**: Command-line WordPress management  
✅ **Daily Backups**: Automated database and file backups  
✅ **Redis Object Cache**: Built-in caching for performance  

## Quick Commands

```bash
# Start the stack
docker compose up -d

# Stop the stack
docker compose down

# View logs
docker compose logs -f

# Access WP-CLI
docker compose run --rm cli wp --info

# Install plugins
docker compose run --rm cli wp plugin install plugin-name --activate

# Create database backup
docker compose run --rm backup /bin/sh /backup/run.sh
```

## Environment Variables

Key variables in `.env`:

```bash
# Auto-install toggle
AUTO_INSTALL_WORDPRESS=true  # Set to false to use web installer

# Database
MARIADB_PASSWORD=changeme_db_password

# WordPress Admin
WORDPRESS_ADMIN_USER=admin
WORDPRESS_ADMIN_PASSWORD=changeme_admin_password
WORDPRESS_ADMIN_EMAIL=admin@example.com

# Site Settings
WORDPRESS_SITE_TITLE=My WordPress Site
WORDPRESS_LOCALE=en_US

# Plugins (comma-separated, optional versions)
WORDPRESS_PLUGINS=woocommerce:10.4.3,query-monitor

# Multi-instance
COMPOSE_PROJECT_NAME=mysite
HTTP_PORT=80  # Change for additional instances
```

## Multi-Instance Setup

Run multiple sites on different ports:

```bash
# Instance 1 (default .env, port 80)
docker compose up -d

# Instance 2 (custom env, port 8080)
cp .env.example .env.site2
# Edit .env.site2: Set COMPOSE_PROJECT_NAME=site2, HTTP_PORT=8080
docker compose --env-file .env.site2 up -d
```

Access at:
- Instance 1: http://localhost
- Instance 2: http://localhost:8080

##Security Notes

⚠️ **Before Production:**
1. Change ALL passwords in `.env`
2. Security salts auto-generate (no action needed)
3. Set up HTTPS/SSL certificates
4. Configure firewall rules
5. Set up regular off-site backup sync

## Troubleshooting

**WordPress not installing?**
- Check `docker compose logs wordpress-installer`
- Verify ` AUTO_INSTALL_WORDPRESS=true` in `.env`
- Ensure database is healthy: `docker compose ps`

**HTTP 500 Error?**
- Check logs: `docker compose logs wordpress nginx`
- Verify wp-config.php exists and is valid
- Restart: `docker compose restart wordpress nginx`

**Port already in use?**
- Change `HTTP_PORT` in `.env`
- Or stop conflicting instance

**Reset everything:**
```bash
docker compose down -v
rm .env wp-config.php
docker compose up -d
```

## License

MIT License - use freely in your projects!
