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
	cp /wp-config.php /var/www/html/
	sleep 5
	wp-cli core install --allow-root --url=wkornato.42.fr --title=Inception --admin_user=root --admin_password=rootpassword --admin_email=wojkor338@gmail.com
fi

exec php-fpm82 -F
exit 0
