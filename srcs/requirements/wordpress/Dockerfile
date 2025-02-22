FROM	alpine:3.21.2

RUN		apk update && apk add php-cli php82 php82-phar fcgi php82-cgi php82-fpm php82-mysqli openrc php-mbstring php-curl curl php82-iconv php82-mysqli
RUN ln -s /usr/bin/php82 /usr/bin/php

WORKDIR /var/www/html

COPY conf/wp-config.php /var/www/html/wp-config.php
COPY conf/php-fpm.conf /etc/php82/php-fpm.conf
COPY conf/www.conf /etc/php82/php-fpm.d/www.conf

COPY tools/ssl/certs/ca-cert.pem /etc/ssl/certs/
COPY tools/ssl/certs/mariadb-client-cert.pem /etc/ssl/certs/
COPY tools/ssl/private/mariadb-client-key.pem /etc/ssl/private/

RUN chmod 600 /etc/ssl/certs/mariadb-client-cert.pem /etc/ssl/private/mariadb-client-key.pem

COPY tools/entrypoint.sh /
RUN chmod +x /entrypoint.sh
RUN echo "memory_limit=512M" > /etc/php82/conf.d/custom.ini

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp-cli
RUN echo "variables_order = EGPCS" >> /etc/php82/php.ini

RUN wp-cli core download

# RUN chmod -R 755 /var/www/html

EXPOSE 9000

ENTRYPOINT [ "/entrypoint.sh" ]
