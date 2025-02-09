FROM	alpine:3.21.2

RUN	apk update && apk add nginx openssl

RUN mkdir -p /etc/ssl/private /etc/ssl/certs && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=PL/ST=Masovian Voivodeship/L=Warsaw/O=42/OU=Student/CN=wkornato.42.fr"

COPY	conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE	443

CMD	["nginx", "-g", "daemon off;"]
