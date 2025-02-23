FROM	alpine:3.21.2

RUN		apk update && apk add redis gettext
COPY tools/entrypoint.sh /
COPY conf/redis.conf.template /etc/redis/redis.conf.template
RUN chmod +x /entrypoint.sh
RUN echo "vm.overcommit_memory = 1" >> /etc/sysctl.conf

EXPOSE 6379

ENTRYPOINT [ "/entrypoint.sh" ]
