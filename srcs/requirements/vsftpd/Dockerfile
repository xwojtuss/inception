FROM alpine:3.21.2

RUN apk update && apk add vsftpd shadow && \
    mkdir -p /var/run/vsftpd/empty && \
    mkdir -p /home/vsftpd && \
    mkdir -p /etc/ssl/certs /etc/ssl/private

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf

EXPOSE 21
EXPOSE 10000-10100

ENTRYPOINT [ "/entrypoint.sh" ]
