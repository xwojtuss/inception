all:
	mkdir -p srcs/requirements/mariadb/tools/ssl/certs srcs/requirements/mariadb/tools/ssl/private srcs/requirements/wordpress/tools/ssl/certs srcs/requirements/wordpress/tools/ssl/private
	openssl genpkey -algorithm RSA -out srcs/requirements/mariadb/tools/ssl/certs/ca-key.pem
	openssl req -new -x509 -key srcs/requirements/mariadb/tools/ssl/certs/ca-key.pem -out srcs/requirements/mariadb/tools/ssl/certs/ca-cert.pem -days 365 -subj "/CN=db/C=PL/ST=Masovian Voivodeship/L=Warsaw/O=42/OU=Student" -addext "subjectAltName=DNS:db"
	openssl genpkey -algorithm RSA -out srcs/requirements/mariadb/tools/ssl/private/mariadb-server-key.pem
	openssl req -new -key srcs/requirements/mariadb/tools/ssl/private/mariadb-server-key.pem -out srcs/requirements/mariadb/tools/ssl/certs/mariadb-server-req.csr -subj "/CN=db/C=PL/ST=Masovian Voivodeship/L=Warsaw/O=42/OU=Student" -addext "subjectAltName=DNS:db"
	openssl x509 -req -in srcs/requirements/mariadb/tools/ssl/certs/mariadb-server-req.csr -CA srcs/requirements/mariadb/tools/ssl/certs/ca-cert.pem -CAkey srcs/requirements/mariadb/tools/ssl/certs/ca-key.pem -CAcreateserial -out srcs/requirements/mariadb/tools/ssl/certs/mariadb-server-cert.pem -days 365
	openssl genpkey -algorithm RSA -out srcs/requirements/mariadb/tools/ssl/private/mariadb-client-key.pem
	openssl req -new -key srcs/requirements/mariadb/tools/ssl/private/mariadb-client-key.pem -out srcs/requirements/mariadb/tools/ssl/certs/mariadb-client-req.csr -subj "/CN=db/C=PL/ST=Masovian Voivodeship/L=Warsaw/O=42/OU=Student" -addext "subjectAltName=DNS:db"
	openssl x509 -req -in srcs/requirements/mariadb/tools/ssl/certs/mariadb-client-req.csr -CA srcs/requirements/mariadb/tools/ssl/certs/ca-cert.pem -CAkey srcs/requirements/mariadb/tools/ssl/certs/ca-key.pem -CAcreateserial -out srcs/requirements/mariadb/tools/ssl/certs/mariadb-client-cert.pem -days 365
	chmod -R 755 srcs/requirements/mariadb/tools/ssl
	cp -rf srcs/requirements/mariadb/tools/ssl/certs/ca-cert.pem srcs/requirements/wordpress/tools/ssl/certs/
	cp -rf srcs/requirements/mariadb/tools/ssl/certs/mariadb-client-cert.pem srcs/requirements/wordpress/tools/ssl/certs/
	cp -rf srcs/requirements/mariadb/tools/ssl/private/mariadb-client-key.pem srcs/requirements/wordpress/tools/ssl/private/
	chmod -R 755 srcs/requirements/wordpress/tools/ssl
	docker-compose -f srcs/docker-compose.yml up -d

clean:
	docker-compose -f srcs/docker-compose.yml down

fclean:
	docker-compose -f srcs/docker-compose.yml down --rmi all -v

re: fclean all

free:
	docker system prune --all --volumes

.PHONY: all clean fclean re free
