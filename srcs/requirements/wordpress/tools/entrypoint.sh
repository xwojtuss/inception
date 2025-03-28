#!/bin/sh

cp /run/secrets/ca_cert /etc/ssl/certs/ca-cert.pem
cp /run/secrets/mariadb_client_cert /etc/ssl/certs/mariadb-client-cert.pem
cp /run/secrets/mariadb_client_key /etc/ssl/private/mariadb-client-key.pem

chmod 600 /etc/ssl/certs/mariadb-client-cert.pem /etc/ssl/private/mariadb-client-key.pem

if [ ! -f /var/www/html/wp-config.php ]; then
	export AUTH_KEYS=$(cat /run/secrets/auth)
	if [ $(sed -n '1p' $CREDENTIALS_FILE | grep -i "admin" > /dev/null) ]; then
		exit 1
	fi
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp-cli
	wp-cli core download --allow-root
	cp /wp-config.php.template /var/www/html/
	export REDIS_PASS=$(cat /run/secrets/redis_pass)
	envsubst '$AUTH_KEYS $REDIS_PASS' < /var/www/html/wp-config.php.template > /var/www/html/wp-config.php
	unset AUTH_KEYS
	unset REDIS_PASS
	sleep 5
	wp-cli core install --allow-root --url=$DOMAIN_NAME --title=Inception --admin_user=$(sed -n '1p' $CREDENTIALS_FILE) --admin_password=$(sed -n '3p' $CREDENTIALS_FILE) --admin_email=$(sed -n '2p' $CREDENTIALS_FILE)
	#chown -R nobody:nobody /var/www/html/wp-content
	#chmod -R 755 /var/www/html/wp-content
	wp-cli plugin install --allow-root redis-cache
	cp /var/www/html/wp-content/plugins/redis-cache/includes/object-cache.php /var/www/html/wp-content/
	wp-cli plugin activate --allow-root redis-cache
	mkdir -p /var/www/html/wp-content/uploads/cv /var/www/html/wp-content/uploads/cv/js /var/www/html/wp-content/uploads/event-manager
	mv /event-manager.php /var/www/html/wp-content/uploads/event-manager/index.php
	mv /portrait.png /var/www/html/wp-content/uploads/cv/portrait.png
	mv /index.html /var/www/html/wp-content/uploads/cv/index.html
	mv /styles.css /var/www/html/wp-content/uploads/cv/styles.css
	mv /script.js /var/www/html/wp-content/uploads/cv/js/script.js
	#chown -R nobody:nobody /var/www/html/wp-content
fi

exec php-fpm82 -F
