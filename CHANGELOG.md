# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v1.0.2 - Plugin Auto-Install & Auto-Activate

### Added
- `AUTO_INSTALL_PLUGINS` environment variable (defaults to `true`)
  - Set to `false` to skip automatic plugin installation
- `AUTO_ACTIVATE_PLUGINS` environment variable (defaults to `true`)
  - Set to `false` to install plugins without activating them
- Automatic plugin installation on `docker compose up -d` (removed from tools profile)

### Fixed
- Plugin installer script compatibility with Alpine Linux (sh instead of bash)
- Plugin installer now runs automatically on stack startup
- Plugins specified in `WORDPRESS_PLUGINS` now install and activate correctly

### Changed
- Plugin-installer service runs by default but respects AUTO_INSTALL_PLUGINS flag
- Improved plugin installation logging and error handling

## [1.0.1] - 2026-01-02

### Added
- `AUTO_INSTALL_WORDPRESS` environment variable to enable/disable automatic WordPress installation (defaults to `true`)
- Automatic bootstrap of missing `.env` and `wp-config.php` files from templates
- Docker DNS resolver to nginx configuration for better hostname resolution
- Three documented setup scenarios in README (zero-config, custom, full manual)
- Comprehensive troubleshooting section in README

### Fixed
- WordPress salts file path issue - changed from `__DIR__/wp-content/.salts.php` to `/var/www/html/wp-content/.salts.php` to prevent bind mount path conflicts
- Nginx startup failures due to DNS resolution timing issues
- WordPress auto-installer now runs automatically on `docker compose up -d` (removed from tools profile)

### Changed
- Improved README with three clear setup scenarios
- wordpress-installer service now runs by default but respects AUTO_INSTALL_WORDPRESS flag
- Bootstrap service (init) runs non-blocking, doesn't prevent stack startup

## [1.0.0] - 2026-01-02

### Added
- Initial release
- Production-ready WordPress stack with Nginx, PHP 8.2 FPM, MariaDB 10.11, Redis 7
- WP-CLI integration for command-line WordPress management
- Automatic daily backups with configurable retention
- Multi-instance support via COMPOSE_PROJECT_NAME
- Automatic plugin installation from environment variable
- Auto-generated security salts from WordPress.org API
- Redis object cache pre-configured
- Environment-based configuration via .env
- Local bind mount for wp-content directory
- Comprehensive documentation and examples
