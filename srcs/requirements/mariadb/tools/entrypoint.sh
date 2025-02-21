#!/bin/sh

set -e  # Exit script on error

if [ -d "/var/lib/mysql/mysql" ]; then
  echo "MariaDB has already been initialized. Skipping initialization."
else
  echo "Initializing MariaDB..."
  mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

  # Start MariaDB in the background
  mariadbd --user=mysql --datadir=/var/lib/mysql --skip-networking &
  MARIADB_PID=$!

  echo "Waiting for MariaDB to be ready..."
  until mariadb-admin ping --host=localhost --user=root --silent; do
    sleep 2
  done

  # Set up root password and run the initialization SQL file
  echo "Setting up root user and running init.sql..."
  mariadb --user=root <<EOF
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
EOF

  if [ -f /docker-entrypoint-initdb.d/init.sql ]; then
    mariadb --user=root --password="${MYSQL_ROOT_PASSWORD}" < /docker-entrypoint-initdb.d/init.sql
  fi

  echo "MariaDB initialization completed."

  # Shut down temporary MariaDB instance
  mariadb-admin --user=root --password="${MYSQL_ROOT_PASSWORD}" shutdown

  wait $MARIADB_PID  # Ensure the background MariaDB process is stopped
fi

# Start MariaDB in the foreground
echo "Starting MariaDB..."
exec mariadbd --user=mysql --datadir=/var/lib/mysql --console

