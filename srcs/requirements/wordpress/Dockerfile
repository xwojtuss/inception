FROM	alpine:3.21.2

RUN		apk update && apk add php82 fcgi php82-cgi php82-fpm

WORKDIR	/usr/share/webapps/

COPY	tools/latest.tar.gz .
RUN		tar -xzvf latest.tar.gz && rm latest.tar.gz
RUN		mkdir -p /var/www/localhost/htdocs/wordpress
RUN		ln -s /usr/share/webapps/wordpress /var/www/localhost/htdocs/wordpress

EXPOSE	9000

CMD		["php-fpm82", "-F"]