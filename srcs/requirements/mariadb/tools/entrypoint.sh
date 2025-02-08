#!/bin/sh

if [ -e /var/lib/mysql/mysql ]; then
  echo "MariaDB has already been initialized. Skipping initialization."
else
  echo "Initializing MariaDB..."
  mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
  echo "MariaDB initialization completed."
fi

exec mariadbd-safe --user=mysql --datadir=/var/lib/mysql --console
exit 0
