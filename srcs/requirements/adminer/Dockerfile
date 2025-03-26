FROM	alpine:3.21.2

RUN	apk update && apk add php82 php82-session php82-json php82-mysqli php82-pdo \
    php82-pdo_mysql php82-mbstring php82-openssl php82-gd php82-dom php82-xml php82-curl
RUN mkdir -p /adminer/adminer-plugins

WORKDIR /adminer

RUN wget -O adminer-plugins/login-ssl.php https://raw.githubusercontent.com/vrana/adminer/master/plugins/login-ssl.php;
RUN wget -O index.php https://github.com/vrana/adminer/releases/download/v5.1.0/adminer-5.1.0.php
COPY tools/adminer-plugins.php /adminer/adminer-plugins.php

EXPOSE	8080

CMD [ "php82", "-S", "0.0.0.0:8080", "-t", "/adminer" ]
