#Загрузить базовый образ Ubuntu 18.04
FROM ubuntu:18.04

#Интерактивный режим
ENV DEBIAN_FRONTEND noninteractive

#Обновить программный репозиторий Ubuntu
RUN apt-get update

#allow starting recently installed packages
RUN echo "exit 0" > /usr/sbin/policy-rc.d

#Установить nginx, php-fpm
RUN apt-get install -y nginx php php-fpm php7.2-mysql php7.2-pgsql php-mbstring php-dom php-zip net-tools wget htop less nano git unzip curl

#Определение переменных среды
ENV nginx_vhost /etc/nginx/sites-available/default
ENV php_conf /etc/php/7.2/fpm/php.ini
ENV nginx_conf /etc/nginx/nginx.conf

#Конфигугация виртуального хоста nginx для работы с php-fpm
COPY vhost.conf ${nginx_vhost}
RUN sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${php_conf} && \
echo "\ndaemon off;" >> ${nginx_conf}

RUN mkdir -p /run/php && \
chown -R www-data:www-data /var/www/html && \
chown -R www-data:www-data /run/php

CMD /usr/sbin/php-fpm7.2 -D; nginx

#Порты для nginx
EXPOSE 80 443

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Setup working directory
WORKDIR /var/www/html

#Clone repo from github
RUN rm -r ./* && \
git clone https://github.com/BuyOwnEx/BOEClient.git ./

COPY .env ./

ENV COMPOSER_ALLOW_SUPERUSER 1
RUN composer install

# get install nodejs and npm
RUN curl -sL https://deb.nodesource.com/setup_12.x | -E bash -
RUN apt-get install -y nodejs
RUN npm install
RUN npm run dev

RUN chown -R www-data:www-data /var/www/html

RUN rm -rf /var/lib/apt/lists/*

#disallow starting recently installed packages
RUN echo "exit 101" > /usr/sbin/policy-rc.d
