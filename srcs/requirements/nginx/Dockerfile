FROM	alpine:3.21.2

RUN	apk update && apk add nginx
RUN	mkdir -p /var/www/wkornato

COPY	conf/nginx.conf /etc/nginx/
COPY	conf/index.html /var/www/wkornato/

EXPOSE	80

CMD	["nginx", "-g", "daemon off;"]
