FROM	alpine:3.21.2

RUN	apk update && apk add nginx

COPY	conf/nginx.conf /etc/nginx/

EXPOSE	80 443

CMD	["nginx", "-g", "daemon off;"]
