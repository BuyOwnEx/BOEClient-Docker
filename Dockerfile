FROM php:7.4.18-fpm-alpine


RUN apt-get update \
&& apt-get install -y libpq-dev \
&& docker-php-ext-install ctype fileinfo json mbstring tokenizer xml pdo pdo_pgsql pdo_mysql bcmath 

# Install composer
ENV COMPOSER_HOME /composer
ENV PATH ./vendor/bin:/composer/vendor/bin:$PATH
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

# Setup working directory
WORKDIR /var/www/html
