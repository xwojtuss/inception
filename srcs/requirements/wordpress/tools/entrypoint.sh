#!/bin/sh

cp run/secrets/ca_cert /etc/ssl/certs/ca-cert.pem
cp run/secrets/mariadb_client_cert /etc/ssl/certs/mariadb-client-cert.pem
cp run/secrets/mariadb_client_key /etc/ssl/private/mariadb-client-key.pem

chmod 600 /etc/ssl/certs/mariadb-client-cert.pem /etc/ssl/private/mariadb-client-key.pem

sleep 7

wp-cli core install --url=wkornato.42.fr --title=Inception --admin_user=root --admin_password=rootpassword --admin_email=wojkor338@gmail.com

exec php-fpm82 -F
exit 0
