#!/bin/sh

cp /run/secrets/ca_cert /etc/ssl/certs/ca-cert.pem
cp /run/secrets/mariadb_server_cert /etc/ssl/certs/mariadb-client-cert.pem
cp /run/secrets/mariadb_server_key /etc/ssl/private/mariadb-client-key.pem

chmod 600 /etc/ssl/certs/mariadb-client-cert.pem /etc/ssl/private/mariadb-client-key.pem

exec php82 -S 0.0.0.0:8080 -t /adminer
exit 0
