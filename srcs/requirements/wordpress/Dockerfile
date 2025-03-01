FROM	alpine:3.21.2

RUN		apk update && apk add php-cli php82 php82-phar fcgi php82-cgi php82-fpm php82-mysqli openrc php82-mbstring php82-curl curl php82-iconv php82-mysqli gettext php82-openssl php82-posix php82-sockets
RUN ln -s /usr/bin/php82 /usr/bin/php

WORKDIR /var/www/html

COPY conf/wp-config.php.template /wp-config.php.template
COPY conf/php-fpm.conf /etc/php82/php-fpm.conf
COPY conf/www.conf /etc/php82/php-fpm.d/www.conf

COPY tools/entrypoint.sh /
RUN chmod +x /entrypoint.sh
RUN echo "memory_limit=512M" > /etc/php82/conf.d/custom.ini

EXPOSE 9000

ENTRYPOINT [ "/entrypoint.sh" ]
