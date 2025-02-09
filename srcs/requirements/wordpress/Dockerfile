FROM	alpine:3.21.2

RUN		apk update && apk add php82 fcgi php82-cgi \
		php82-fpm php82-mysqli openrc php-mbstring php-curl

WORKDIR /var/www/html

COPY conf/wp-config.php /var/www/html/wp-config.php
COPY conf/php-fpm.conf /etc/php82/php-fpm.conf
COPY conf/www.conf /etc/php82/php-fpm.d/www.conf

COPY tools/latest.tar.gz .
RUN tar -xzvf latest.tar.gz && rm latest.tar.gz
RUN sh -c "mv wordpress/* ."

RUN chmod -R 755 /var/www/html

EXPOSE 9000

CMD ["php-fpm82", "-F"]