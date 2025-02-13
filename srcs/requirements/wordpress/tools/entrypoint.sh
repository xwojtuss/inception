#!/bin/sh

sleep 5

#wp-cli config create --dbname=wordpress --dbhost=db:3306 --dbuser=wordpress --dbpass=wordpresspassword --locale=en_DB

wp-cli core install --url=wkornato.42.fr --title=Inception --admin_user=root --admin_password=rootpassword --admin_email=wojkor338@gmail.com

exec php-fpm82 -F
exit 0
