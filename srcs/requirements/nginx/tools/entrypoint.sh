#!/bin/sh

cp /run/secrets/nginx_key /etc/ssl/private/nginx-selfsigned.key
cp /run/secrets/nginx_cert /etc/ssl/certs/nginx-selfsigned.crt

envsubst '$DOMAIN_NAME' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
exec nginx -g "daemon off;"