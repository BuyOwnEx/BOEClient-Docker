FROM nginx

ADD vhost.conf /etc/nginx/conf.d/default.conf

WORKDIR /var/www/html

FROM php:7.4.18-fpm

RUN apt-get update \
&& apt-get install -y libpq-dev libxml2-dev libmcrypt-dev libmemcached-dev \
&& docker-php-ext-install ctype fileinfo json tokenizer xml pdo pdo_pgsql pdo_mysql bcmath opcache

# Install composer
ENV COMPOSER_HOME /composer
ENV PATH ./vendor/bin:/composer/vendor/bin:$PATH
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

# Setup working directory
WORKDIR /var/www/html
