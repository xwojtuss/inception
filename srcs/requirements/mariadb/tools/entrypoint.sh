#!/bin/sh

if [ -e /var/lib/mysql/mysql ]; then
  echo "MariaDB has already been initialized. Skipping initialization."
else
  echo "Initializing MariaDB..."
  mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
 mysqld_safe --user=mysql &
  
  until mysqladmin ping --host=127.0.0.1 --user=root --password="$MYSQL_ROOT_PASSWORD" --silent; do
    echo "Waiting for MariaDB to be ready..."
    sleep 2
  done

  mysql -u root -p"$MYSQL_ROOT_PASSWORD" < /docker-entrypoint-initdb.d/init.sql
  echo "MariaDB initialization completed."
fi

exec mariadbd-safe --user=mysql --datadir=/var/lib/mysql --console
exit 0
