all: create-secrets generate-certs
	docker-compose -f srcs/docker-compose.yml up -d

clean:
	docker-compose -f srcs/docker-compose.yml down

fclean:
	docker-compose -f srcs/docker-compose.yml down --rmi all -v

re: fclean all

free: fclean
	docker system prune --all --volumes
	rm -f srcs/.env secrets/*
	rm -rf /home/wkornato/data/wordpress /home/wkornato/data/databases

create-secrets:
	@if [ ! -f srcs/.env ]; then \
		echo "DOMAIN_NAME=wkornato.42.fr" > srcs/.env; \
		echo "DB_ROOT_PASSWORD_FILE=/run/secrets/db_root_password" >> srcs/.env; \
		echo "DB_PASSWORD_FILE=/run/secrets/db_password" >> srcs/.env; \
		echo "DB_NAME_FILE=/run/secrets/db_name" >> srcs/.env; \
		echo "DB_USER_FILE=/run/secrets/db_user" >> srcs/.env; \
		echo "DB_ADMIN_FILE=/run/secrets/db_admin" >> srcs/.env; \
		echo "WORDPRESS_DB_HOST=db:3306" >> srcs/.env; \
		echo "CREDENTIALS_FILE=/run/secrets/credentials" >> srcs/.env; \
		echo "FTP_CREDENTIALS_FILE=/run/secrets/ftp_credentials" >> srcs/.env; \
	fi

	@if [ ! -f secrets/db_user.txt ]; then \
		echo "---Wordpress database user---"; \
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
		echo "---WordPress database admin---"; \
		while true; do \
			printf "Enter the admin name: "; \
			read DB_ADMIN; \
			if echo "$$DB_ADMIN" | grep -i "admin" > /dev/null; then \
				echo "Error: The username must not contain 'admin'. Try again."; \
			else \
				printf "$$DB_ADMIN" > secrets/db_admin.txt; \
				break; \
			fi; \
		done; \
	fi

	@if [ ! -f secrets/db_root_password.txt ]; then \
		printf "Enter the admin password: "; \
		read DB_ROOT_PASSWD; \
		printf $$DB_ROOT_PASSWD > secrets/db_root_password.txt; \
	fi

	@if [ ! -f secrets/db_name.txt ]; then \
		echo "---Wordpress database---"; \
		printf "Enter the database name: "; \
		read DB_NAME; \
		printf $$DB_NAME > secrets/db_name.txt; \
	fi

	@if [ ! -f secrets/credentials.txt ]; then \
		echo "---Wordpress page admin credentials---"; \
		printf "Enter the username: "; \
		read CREDENTIALS_USERNAME; \
		echo $$CREDENTIALS_USERNAME > secrets/credentials.txt; \
		printf "Enter the email: "; \
		read CREDENTIALS_EMAIL; \
		echo $$CREDENTIALS_EMAIL >> secrets/credentials.txt; \
		printf "Enter the password: "; \
		read CREDENTIALS_PASSWORD; \
		echo $$CREDENTIALS_PASSWORD >> secrets/credentials.txt; \
	fi

	@if [ ! -f secrets/ftp_credentials.txt ]; then \
		echo "---FTP credentials---"; \
		printf "Enter the username: "; \
		read FTP_CREDENTIALS_USERNAME; \
		echo $$FTP_CREDENTIALS_USERNAME > secrets/ftp_credentials.txt; \
		printf "Enter the password: "; \
		read FTP_CREDENTIALS_PASSWORD; \
		echo $$FTP_CREDENTIALS_PASSWORD >> secrets/ftp_credentials.txt; \
	fi

	@if [ ! -f secrets/auth.txt ]; then \
		curl https://api.wordpress.org/secret-key/1.1/salt/ > secrets/auth.txt; \
	fi

	@if [ ! -f secrets/redis_pass.txt ]; then \
		echo "---Redis---"; \
		printf "Enter the redis password: "; \
		read REDIS_PASS; \
		printf $$REDIS_PASS > secrets/redis_pass.txt; \
	fi
	
generate-certs:
	@if [ ! -f secrets/nginx-selfsigned.key ] || [ ! -f secrets/nginx-selfsigned.crt ]; then \
		echo "Generating Nginx self-signed certificate..."; \
		openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout secrets/nginx-selfsigned.key \
		-out secrets/nginx-selfsigned.crt \
		-subj "/CN=nginx/C=PL/ST=Masovian Voivodeship/L=Warsaw/O=42/OU=Student" \
		-addext "subjectAltName=DNS:nginx"; \
	fi

	@if [ ! -f secrets/ca-cert.pem ]; then \
		echo "Generating MariaDB CA certificate..."; \
		mkdir -p tmp; \
		openssl genpkey -algorithm RSA -out tmp/ca-key.pem; \
		openssl req -new -x509 -key tmp/ca-key.pem -out secrets/ca-cert.pem -days 365 \
		-subj "/CN=mariadb/C=PL/ST=Masovian Voivodeship/L=Warsaw/O=42/OU=Student" \
		-addext "subjectAltName=DNS:mariadb"; \
	fi

	@if [ ! -f secrets/mariadb-server-key.pem ] || [ ! -f secrets/mariadb-server-cert.pem ]; then \
		echo "Generating MariaDB server certificate..."; \
		openssl genpkey -algorithm RSA -out secrets/mariadb-server-key.pem; \
		openssl req -new -key secrets/mariadb-server-key.pem -out tmp/mariadb-server-req.csr \
		-subj "/CN=mariadb/C=PL/ST=Masovian Voivodeship/L=Warsaw/O=42/OU=Student" \
		-addext "subjectAltName=DNS:mariadb"; \
		openssl x509 -req -in tmp/mariadb-server-req.csr -CA secrets/ca-cert.pem -CAkey tmp/ca-key.pem \
		-CAcreateserial -out secrets/mariadb-server-cert.pem -days 365; \
	fi

	@if [ ! -f secrets/mariadb-client-key.pem ] || [ ! -f secrets/mariadb-client-cert.pem ]; then \
		echo "Generating MariaDB client certificate..."; \
		openssl genpkey -algorithm RSA -out secrets/mariadb-client-key.pem; \
		openssl req -new -key secrets/mariadb-client-key.pem -out tmp/mariadb-client-req.csr \
		-subj "/CN=mariadb/C=PL/ST=Masovian Voivodeship/L=Warsaw/O=42/OU=Student" \
		-addext "subjectAltName=DNS:mariadb"; \
		openssl x509 -req -in tmp/mariadb-client-req.csr -CA secrets/ca-cert.pem -CAkey tmp/ca-key.pem \
		-CAcreateserial -out secrets/mariadb-client-cert.pem -days 365; \
	fi

	@if [ ! -f secrets/vsftpd-selfsigned.key ] || [ ! -f secrets/vsftpd-selfsigned.crt ]; then \
		echo "Generating vsftpd self-signed certificate..."; \
		openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout secrets/vsftpd-selfsigned.key \
		-out secrets/vsftpd-selfsigned.crt \
		-subj "/CN=vsftpd/C=PL/ST=Masovian Voivodeship/L=Warsaw/O=42/OU=Student" \
		-addext "subjectAltName=DNS:vsftpd"; \
	fi

	rm -rf tmp
	
rm-volumes:
	rm -rf /home/wkornato/data/wordpress /home/wkornato/data/databases

.PHONY: all clean fclean re free create-secrets generate-certs rm-volumes
