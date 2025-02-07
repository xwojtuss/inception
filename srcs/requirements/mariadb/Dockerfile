FROM	alpine:3.21.2

RUN	apk update && apk add mariadb mariadb-client openrc
RUN	mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

EXPOSE	3306

CMD	["mariadbd", "--user=mysql", "--console"]
