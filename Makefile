

all: nginx

nginx:
	docker build -t nginx srcs/requirements/nginx/;
	docker run -d -p 80:80 --name nginx_cont nginx;

nginx_stop:
	docker stop nginx_cont;

nginx_clean: nginx_stop
	docker rm nginx_cont;

nginx_fclean: nginx_clean
	docker rmi nginx;

re: nginx_clean nginx

clean: nginx_clean

fclean: nginx_fclean
