all:
	mkdir -p srcs/requirements/mariadb/tools/ssl/certs srcs/requirements/mariadb/tools/ssl/private srcs/requirements/wordpress/tools/ssl/certs srcs/requirements/wordpress/tools/ssl/private
	# Generate CA key and certificate
	openssl genpkey -algorithm RSA -out srcs/requirements/mariadb/tools/ssl/certs/ca-key.pem
	openssl req -new -x509 -key srcs/requirements/mariadb/tools/ssl/certs/ca-key.pem -out srcs/requirements/mariadb/tools/ssl/certs/ca-cert.pem -days 365 -subj "/CN=db/C=PL/ST=Masovian Voivodeship/L=Warsaw/O=42/OU=Student" -addext "subjectAltName=DNS:db"

	# Generate MariaDB server key and certificate
	openssl genpkey -algorithm RSA -out srcs/requirements/mariadb/tools/ssl/private/mariadb-server-key.pem
	openssl req -new -key srcs/requirements/mariadb/tools/ssl/private/mariadb-server-key.pem -out srcs/requirements/mariadb/tools/ssl/certs/mariadb-server-req.csr -subj "/CN=db/C=PL/ST=Masovian Voivodeship/L=Warsaw/O=42/OU=Student" -addext "subjectAltName=DNS:db"
	openssl x509 -req -in srcs/requirements/mariadb/tools/ssl/certs/mariadb-server-req.csr -CA srcs/requirements/mariadb/tools/ssl/certs/ca-cert.pem -CAkey srcs/requirements/mariadb/tools/ssl/certs/ca-key.pem -CAcreateserial -out srcs/requirements/mariadb/tools/ssl/certs/mariadb-server-cert.pem -days 365

	# Generate MariaDB client key and certificate
	openssl genpkey -algorithm RSA -out srcs/requirements/mariadb/tools/ssl/private/mariadb-client-key.pem
	openssl req -new -key srcs/requirements/mariadb/tools/ssl/private/mariadb-client-key.pem -out srcs/requirements/mariadb/tools/ssl/certs/mariadb-client-req.csr -subj "/CN=db/C=PL/ST=Masovian Voivodeship/L=Warsaw/O=42/OU=Student" -addext "subjectAltName=DNS:db"
	openssl x509 -req -in srcs/requirements/mariadb/tools/ssl/certs/mariadb-client-req.csr -CA srcs/requirements/mariadb/tools/ssl/certs/ca-cert.pem -CAkey srcs/requirements/mariadb/tools/ssl/certs/ca-key.pem -CAcreateserial -out srcs/requirements/mariadb/tools/ssl/certs/mariadb-client-cert.pem -days 365
	chmod -R 755 srcs/requirements/mariadb/tools/ssl
	# Copy certificates to WordPress directory
	cp -rf srcs/requirements/mariadb/tools/ssl srcs/requirements/wordpress/tools/
	chmod -R 755 srcs/requirements/wordpress/tools/ssl
	# Start Docker containers
	docker-compose -f srcs/docker-compose.yml up -d

clean:
	docker-compose -f srcs/docker-compose.yml down

fclean:
	docker-compose -f srcs/docker-compose.yml down --rmi all -v

re: fclean all

.PHONY: all clean fclean re
