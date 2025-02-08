

all:
	docker build -t nginx srcs/requirements/nginx/;
	docker build -t mariadb srcs/requirements/mariadb/;

nginx:
	docker build -t nginx srcs/requirements/nginx/;
	docker run -it --rm -d -p 80:80 --name nginx_cont nginx;

nginx_stop:
	docker stop nginx_cont;

nginx_fclean: nginx_clean
	docker rmi nginx;

mariadb:
	docker build -t mariadb srcs/requirements/mariadb/;
	docker run --mount type=volume,src=database,dst=/var/lib/mysql -d --rm -p 3306:3306 --name mariadb_cont mariadb;

mariadb_stop:
	docker stop mariadb_cont;

mariadb_fclean: mariadb_clean
	docker rmi mariadb;


re: nginx mariadb

clean: nginx_clean

fclean: nginx_fclean
