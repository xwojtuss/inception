all: srcs/requirements/wordpress/tools/latest.tar.gz
	docker compose -f srcs/docker-compose.yml up -d

clean:
	docker compose -f srcs/docker-compose.yml down
	rm -rf srcs/requirements/wordpress/tools/latest.tar.gz

fclean:
	docker compose -f srcs/docker-compose.yml down --rmi all
	rm -rf srcs/requirements/wordpress/tools/latest.tar.gz

re: clean all

srcs/requirements/wordpress/tools/latest.tar.gz:
	wget -P srcs/requirements/wordpress/tools/ https://wordpress.org/latest.tar.gz

.PHONY: all clean fclean re