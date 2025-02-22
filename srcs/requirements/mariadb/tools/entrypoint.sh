#!/bin/sh

set -e

DB_ROOT_PASSWORD=$(cat ${DB_ROOT_PASSWORD_FILE})
DB_NAME=$(cat ${DB_NAME_FILE})
DB_USER=$(cat ${DB_USER_FILE})
DB_ADMIN=$(cat ${DB_ADMIN_FILE})

if [ -d "/var/lib/mysql/mysql" ]; then
  echo "MariaDB has already been initialized. Skipping initialization."
else
  echo "Initializing MariaDB..."
  mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

  mariadbd --user=mysql --datadir=/var/lib/mysql --skip-networking &
  MARIADB_PID=$!

  echo "Waiting for MariaDB to be ready..."
  until mariadb-admin ping --host=localhost --user=root --silent; do
    sleep 2
  done

  echo "Setting up the users"
  mariadb --user=root <<EOF
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';

    CREATE DATABASE IF NOT EXISTS ${DB_NAME};

    CREATE USER IF NOT EXISTS '${DB_ADMIN}'@'%' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_ADMIN}'@'%';
    ALTER USER '${DB_ADMIN}'@'%' REQUIRE SSL;

    CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASSWORD}';
    GRANT SELECT, INSERT, UPDATE, DELETE ON ${DB_NAME}.* TO '${DB_USER}'@'%';
    ALTER USER '${DB_USER}'@'%' REQUIRE SSL;
    FLUSH PRIVILEGES;
EOF

  echo "MariaDB initialization completed."
  mariadb-admin --user=root --password="${DB_ROOT_PASSWORD}" shutdown
  wait $MARIADB_PID
fi

echo "Starting MariaDB..."
exec mariadbd --user=mysql --datadir=/var/lib/mysql --console

