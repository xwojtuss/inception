<?php

define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
define( 'WP_DEBUG_DISPLAY', false );
@ini_set('display_errors', 0);
define('SCRIPT_DEBUG', true);

define('MYSQL_CLIENT_FLAGS', MYSQLI_CLIENT_SSL);

define('FORCE_SSL_ADMIN', true);
define('WP_HOME', 'wkornato.42.fr');
define('WP_SITEURL', 'wkornato.42.fr');

define('PHPMAILER_INIT_SMTP', false);

define('MYSQL_SSL_CA', '/etc/ssl/certs/ca-cert.pem');
define('MYSQL_SSL_CERT', '/etc/ssl/certs/mariadb-client-cert.pem');
define('MYSQL_SSL_KEY', '/etc/ssl/private/mariadb-client-key.pem');

define( 'DB_NAME', 'wordpress' );
define( 'DB_USER', 'wordpress' );
define( 'DB_PASSWORD', 'wordpresspassword' );
define( 'DB_HOST', 'db' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

define( 'DB_SOCKET', '' );

$table_prefix = 'wp_';

if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';
