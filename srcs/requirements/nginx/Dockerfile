FROM	alpine:3.21.2

RUN	apk update && apk add nginx openssl gettext
RUN mkdir -p /etc/ssl/private /etc/ssl/certs;
COPY	conf/nginx.conf.template /etc/nginx/nginx.conf.template
COPY tools/entrypoint.sh /
RUN chmod +x /entrypoint.sh

EXPOSE	443

ENTRYPOINT [ "/entrypoint.sh" ]
#CMD	["nginx", "-g", "daemon off;"]
