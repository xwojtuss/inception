CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER IF NOT EXISTS 'wordpress'@'%' IDENTIFIED BY 'wordpresspassword';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'%';
ALTER USER 'wordpress'@'%' REQUIRE SSL;
FLUSH PRIVILEGES;
