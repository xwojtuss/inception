FROM	alpine:3.21.2

COPY tools/entrypoint.sh /
COPY conf/my.cnf /etc/my.cnf
COPY conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
RUN chmod +x /entrypoint.sh
RUN	apk update && apk add mariadb mariadb-client openrc openssl
RUN	mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql
RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld
RUN mkdir -p /etc/ssl/certs /etc/ssl/private

COPY conf/my.cnf /etc/my.cnf
EXPOSE	3306

ENTRYPOINT [ "/entrypoint.sh" ]
#CMD [ "mariadbd-safe", "--user=mysql", "--datadir=/var/lib/mysql", "--console" ]
