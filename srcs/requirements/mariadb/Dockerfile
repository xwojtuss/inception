FROM	alpine:3.21.2

COPY tools/entrypoint.sh /
COPY tools/init.sql /docker-entrypoint-initdb.d/init.sql
COPY conf/my.cnf /etc/my.cnf
COPY conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
RUN chmod +x /entrypoint.sh
RUN	apk update && apk add mariadb mariadb-client openrc openssl
RUN	mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql
RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld
# Create directories for storing certificates
RUN mkdir -p /etc/ssl/certs /etc/ssl/private

# Generate the Certificate Authority (CA) private key
#RUN openssl genpkey -algorithm RSA -out /etc/ssl/certs/ca-key.pem

# Generate the self-signed CA certificate
#RUN openssl req -key /etc/ssl/certs/ca-key.pem -new -x509 -out /etc/ssl/certs/ca-cert.pem -days 365 -subj "/CN=db/C=PL/ST=Masovian Voivodeship/L=Warsaw/O=42/OU=Student/CN=wkornato.42.fr" -addext "subjectAltName=DNS:db"

# Generate MariaDB server private key
#RUN openssl genpkey -algorithm RSA -out /etc/ssl/private/mariadb-server-key.pem

# Generate the MariaDB server certificate signing request (CSR)
#RUN openssl req -new -key /etc/ssl/private/mariadb-server-key.pem -out /etc/ssl/certs/mariadb-server-req.csr -subj "/CN=db/C=PL/ST=Masovian Voivodeship/L=Warsaw/O=42/OU=Student/CN=wkornato.42.fr" -addext "subjectAltName=DNS:db"

# Sign the MariaDB server CSR with the CA to generate the server certificate
#RUN openssl x509 -req -in /etc/ssl/certs/mariadb-server-req.csr -CA /etc/ssl/certs/ca-cert.pem -CAkey /etc/ssl/certs/ca-key.pem -CAcreateserial -out /etc/ssl/certs/mariadb-server-cert.pem -days 365

# Generate MariaDB client private key
#RUN openssl genpkey -algorithm RSA -out /etc/ssl/private/mariadb-client-key.pem

# Generate the MariaDB client certificate signing request (CSR)
#RUN openssl req -new -key /etc/ssl/private/mariadb-client-key.pem -out /etc/ssl/certs/mariadb-client-req.csr -subj "/CN=db/C=PL/ST=Masovian Voivodeship/L=Warsaw/O=42/OU=Student/CN=wkornato.42.fr" -addext "subjectAltName=DNS:db"

# Sign the MariaDB client CSR with the CA to generate the client certificate
#RUN openssl x509 -req -in /etc/ssl/certs/mariadb-client-req.csr -CA /etc/ssl/certs/ca-cert.pem -CAkey /etc/ssl/certs/ca-key.pem -CAcreateserial -out /etc/ssl/certs/mariadb-client-cert.pem -days 365

COPY tools/ssl/certs/ /etc/ssl/certs/
COPY tools/ssl/private/ /etc/ssl/private/

RUN chmod 600 /etc/ssl/private/mariadb-server-key.pem
RUN chown mysql:mysql /etc/ssl/private/mariadb-server-key.pem


COPY conf/my.cnf /etc/my.cnf
EXPOSE	3306

ENTRYPOINT [ "/entrypoint.sh" ]
#CMD [ "mariadbd-safe", "--user=mysql", "--datadir=/var/lib/mysql", "--console" ]
