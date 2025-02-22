FROM	alpine:3.21.2

RUN	apk update && apk add nginx openssl gettext
RUN mkdir -p /etc/ssl/private /etc/ssl/certs && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt \
	-subj "/C=PL/ST=Masovian Voivodeship/L=Warsaw/O=42/OU=Student/CN=wkornato.42.fr"
COPY	conf/nginx.conf.template /etc/nginx/nginx.conf.template
COPY tools/entrypoint.sh /
RUN chmod +x /entrypoint.sh

EXPOSE	443

ENTRYPOINT [ "/entrypoint.sh" ]
#CMD	["nginx", "-g", "daemon off;"]
