FROM	alpine:3.21.2

RUN	apk update && apk add php82 fcgi php82-cgi
RUN	mkdir -p /usr/share/webapps/
RUN	cd /usr/share/webapps/ && wget https://wordpress.org/latest.tar.gz
RUN	tar -xzvf latest.tar.gz && rm latest.tar.gz
RUN	chwon -R nginx /usr/share/webapps/
RUN	ln -s /usr/share/webapps/wordpress/ /var/www/localhost/htdocs/wordpress

COPY	conf/nginx.conf /etc/nginx/
COPY	conf/index.html /var/www/wkornato/

EXPOSE	80

CMD	["nginx", "-g", "daemon off;"]
