FROM	alpine:3.21.2

RUN	apk update && apk add mariadb mariadb-client openrc
ENV	MYSQL_ROOT_PASSWORD=password
RUN	mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
RUN	/usr/bin/mariadb-admin -u root password 'password' --host=localhost --port=3306
RUN	mariadb -u root --password='password' <<-EOSQL
		CREATE DATABASE wordpress;
		GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY 'wordpress password';
		FLUSH PRIVILEGES;
		EXIT
	EOSQL

EXPOSE	3306

CMD	["mariadb", "--user=mysql", "--console"]
