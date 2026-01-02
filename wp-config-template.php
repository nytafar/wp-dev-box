<?php
/**
 * The base configuration for WordPress
 *
 * This file is configured to use environment variables for security.
 * Copy .env.example to .env and update with your settings.
 *
 * @package WordPress
 */

// ** Database settings ** //
define('DB_NAME', getenv('WORDPRESS_DB_NAME') ?: 'wpdb');
define('DB_USER', getenv('WORDPRESS_DB_USER') ?: 'wpuser');
define('DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD') ?: 'changeme');
define('DB_HOST', getenv('WORDPRESS_DB_HOST') ?: 'db:3306');
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');

/**#@+
 * Authentication unique keys and salts.
 * Auto-generated from WordPress.org API for security.
 * These are fetched once and cached in wp-content for persistence.
 */
$salt_file = '/var/www/html/wp-content/.salts.php';

if (file_exists($salt_file)) {
	require $salt_file;
} else {
	// Fetch salts from WordPress.org API
	$salts = file_get_contents('https://api.wordpress.org/secret-key/1.1/salt/');

	if ($salts) {
		// Save to file for persistence
		@mkdir(dirname($salt_file), 0755, true);
		file_put_contents($salt_file, "<?php\n" . $salts);
		require $salt_file;
	} else {
		// Fallback to random generation if API fails
		define('AUTH_KEY', bin2hex(random_bytes(32)));
		define('SECURE_AUTH_KEY', bin2hex(random_bytes(32)));
		define('LOGGED_IN_KEY', bin2hex(random_bytes(32)));
		define('NONCE_KEY', bin2hex(random_bytes(32)));
		define('AUTH_SALT', bin2hex(random_bytes(32)));
		define('SECURE_AUTH_SALT', bin2hex(random_bytes(32)));
		define('LOGGED_IN_SALT', bin2hex(random_bytes(32)));
		define('NONCE_SALT', bin2hex(random_bytes(32)));
	}
}

/**#@-*/

/**
 * WordPress database table prefix.
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 */
define('WP_DEBUG', false);

/**
 * Redis Object Cache configuration
 */
define('WP_REDIS_HOST', 'redis');
define('WP_REDIS_PORT', 6379);
define('WP_CACHE', true);

/* Add any custom values between this line and the "stop editing" line. */

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if (!defined('ABSPATH')) {
	define('ABSPATH', __DIR__ . '/');
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
