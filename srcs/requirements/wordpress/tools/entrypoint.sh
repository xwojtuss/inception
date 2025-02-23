#!/bin/sh

cp /run/secrets/ca_cert /etc/ssl/certs/ca-cert.pem
cp /run/secrets/mariadb_client_cert /etc/ssl/certs/mariadb-client-cert.pem
cp /run/secrets/mariadb_client_key /etc/ssl/private/mariadb-client-key.pem

chmod 600 /etc/ssl/certs/mariadb-client-cert.pem /etc/ssl/private/mariadb-client-key.pem

if [ ! -f /var/www/html/wp-config.php ]; then
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp-cli
	wp-cli core download --allow-root
	cp /wp-config.php.template /var/www/html/
	export AUTH_KEYS=$(cat /run/secrets/auth)
	envsubst '$AUTH_KEYS' < /var/www/html/wp-config.php.template > /var/www/html/wp-config.php
	unset AUTH_KEYS
	sleep 5
	wp-cli core install --allow-root --url=$DOMAIN_NAME --title=Inception --admin_user=$(sed -n '1p' $CREDENTIALS_FILE) --admin_password=$(sed -n '3p' $CREDENTIALS_FILE) --admin_email=$(sed -n '2p' $CREDENTIALS_FILE)
	wp-cli plugin install --allow-root redis-cache --activate
	cp /var/www/html/wp-content/plugins/redis-cache/includes/object-cache.php /var/www/html/wp-content/
fi

exec php-fpm82 -F