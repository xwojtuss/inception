all: create-secrets generate-certs
	docker-compose -f srcs/docker-compose.yml up -d

clean:
	docker-compose -f srcs/docker-compose.yml down

fclean:
	docker-compose -f srcs/docker-compose.yml down --rmi all -v

re: fclean all

free:
	docker system prune --all --volumes
	rm -f srcs/.env secrets/*

create-secrets:
	@if [ ! -f srcs/.env ]; then \
		echo "DOMAIN_NAME=wkornato.42.fr" > srcs/.env; \
		echo "DB_ROOT_PASSWORD_FILE=/run/secrets/db_root_password" >> srcs/.env; \
		echo "DB_PASSWORD_FILE=/run/secrets/db_password" >> srcs/.env; \
		echo "DB_NAME_FILE=/run/secrets/db_name" >> srcs/.env; \
		echo "DB_USER_FILE=/run/secrets/db_user" >> srcs/.env; \
		echo "DB_ADMIN_FILE=/run/secrets/db_admin" >> srcs/.env; \
		echo "WORDPRESS_DB_HOST=db:3306" >> srcs/.env; \
	fi

	@if [ ! -f secrets/db_user.txt ]; then \
		printf "Enter the user name: "; \
		read DB_USER; \
		printf $$DB_USER > secrets/db_user.txt; \
	fi

	@if [ ! -f secrets/db_password.txt ]; then \
		printf "Enter user password: "; \
		read DB_PASSWD; \
		printf $$DB_PASSWD > secrets/db_password.txt; \
	fi

	@if [ ! -f secrets/db_admin.txt ]; then \
		printf "Enter the admin name: "; \
		read DB_ADMIN; \
		printf $$DB_ADMIN > secrets/db_admin.txt; \
	fi

	@if [ ! -f secrets/db_root_password.txt ]; then \
		printf "Enter the admin password: "; \
		read DB_ROOT_PASSWD; \
		printf $$DB_ROOT_PASSWD > secrets/db_root_password.txt; \
	fi

	@if [ ! -f secrets/db_name.txt ]; then \
		printf "Enter the database name: "; \
		read DB_NAME; \
		printf $$DB_NAME > secrets/db_name.txt; \
	fi

generate-certs:
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout secrets/nginx-selfsigned.key \
	-out secrets/nginx-selfsigned.crt \
	-subj "/CN=nginx/C=PL/ST=Masovian Voivodeship/L=Warsaw/O=42/OU=Student" \
	-addext "subjectAltName=DNS:nginx"

	mkdir -p tmp
	openssl genpkey -algorithm RSA -out tmp/ca-key.pem
	openssl req -new -x509 -key tmp/ca-key.pem -out secrets/ca-cert.pem -days 365 -subj "/CN=mariadb/C=PL/ST=Masovian Voivodeship/L=Warsaw/O=42/OU=Student" -addext "subjectAltName=DNS:mariadb"
	
	openssl genpkey -algorithm RSA -out secrets/mariadb-server-key.pem

	openssl req -new -key secrets/mariadb-server-key.pem -out tmp/mariadb-server-req.csr -subj "/CN=mariadb/C=PL/ST=Masovian Voivodeship/L=Warsaw/O=42/OU=Student" -addext "subjectAltName=DNS:mariadb"
	openssl x509 -req -in tmp/mariadb-server-req.csr -CA secrets/ca-cert.pem -CAkey tmp/ca-key.pem -CAcreateserial -out secrets/mariadb-server-cert.pem -days 365

	openssl genpkey -algorithm RSA -out secrets/mariadb-client-key.pem

	openssl req -new -key secrets/mariadb-client-key.pem -out tmp/mariadb-client-req.csr -subj "/CN=mariadb/C=PL/ST=Masovian Voivodeship/L=Warsaw/O=42/OU=Student" -addext "subjectAltName=DNS:mariadb"
	openssl x509 -req -in tmp/mariadb-client-req.csr -CA secrets/ca-cert.pem -CAkey tmp/ca-key.pem -CAcreateserial -out secrets/mariadb-client-cert.pem -days 365

	rm -rf tmp
	

.PHONY: all clean fclean re free create-secrets remove-secrets
