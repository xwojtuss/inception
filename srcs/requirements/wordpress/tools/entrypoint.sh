#!/bin/sh

sleep 7

wp-cli core install --url=wkornato.42.fr --title=Inception --admin_user=root --admin_password=rootpassword --admin_email=wojkor338@gmail.com

exec php-fpm82 -F
exit 0
