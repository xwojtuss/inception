FROM	alpine:3.21.2

RUN	apk update && apk add php82 php82-session php82-json php82-mysqli php82-pdo \
    php82-pdo_mysql php82-mbstring php82-openssl php82-gd php82-dom php82-xml php82-curl
RUN mkdir -p /adminer/plugins

WORKDIR /adminer

RUN wget -O plugins/plugin.php https://raw.githubusercontent.com/vrana/adminer/master/plugins/plugin.php;
RUN wget -O plugins/login-ssl.php https://raw.githubusercontent.com/vrana/adminer/master/plugins/login-ssl.php;
RUN wget -O adminer.php https://github.com/vrana/adminer/releases/download/v4.17.1/adminer-4.17.1.php
COPY tools/index.php /adminer/index.php


EXPOSE	8080

CMD [ "php82", "-S", "0.0.0.0:8080", "-t", "/adminer" ]
