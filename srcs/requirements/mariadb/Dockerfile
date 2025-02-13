FROM	alpine:3.21.2

COPY tools/entrypoint.sh /
RUN chmod +x /entrypoint.sh
RUN	apk update && apk add mariadb mariadb-client openrc
RUN	mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql
RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld
COPY conf/my.cnf /etc/my.cnf
EXPOSE	3306

ENTRYPOINT [ "/entrypoint.sh" ]
#CMD [ "mariadbd-safe", "--user=mysql", "--datadir=/var/lib/mysql", "--console" ]
