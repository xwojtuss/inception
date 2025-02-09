FROM	alpine:3.21.2

RUN	apk update && apk add nginx certbot
RUN mkdir -p /var/www/certbot
RUN certbot certonly --webroot --agree-tos --email wkornato@42warsaw.pl --non-interactive -w /var/www/certbot -d wkornato.42.fr

COPY	conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE	443

CMD	["nginx", "-g", "daemon off;"]
