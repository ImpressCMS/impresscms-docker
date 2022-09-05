########################################## BASE ########################################################################
FROM powerman/dockerize:latest AS base

RUN apk add --no-cache \
      bash  && \
    adduser -S www-data -G www-data

RUN apk add --no-cache \
        nginx \
        nginx-mod-http-brotli  && \
    mkdir -p /var/lib/nginx/cache/ && \
    chown www-data:www-data /var/lib/nginx/cache/

RUN apk add --no-cache \
      composer \
      fcgi \
      php-fpm \
      php-json \
      php-pdo \
      php-gd \
      php-curl \
      php-mbstring \
      php-session \
      php-ctype \
      php-fileinfo \
      php-gettext \
      php-iconv \
      php-opcache \
      php-pcntl \
      php-pdo_mysql \
      php-phar \
      php-posix \
      php-cli && \
    mkdir -p /run/php-fpm/ && \
    chown www-data:www-data /run/php-fpm/ && \
    ln -s $(realpath /etc/php*) /etc/php

EXPOSE 80 443

########################################## PROD ########################################################################

FROM base AS prod

ADD ./src/ /srv/www

VOLUME /srv/www/modules
VOLUME /srv/www/language
VOLUME /srv/www/storage
VOLUME /srv/www/htdocs/libraries
VOLUME /srv/www/htdocs/include
VOLUME /srv/www/htdocs/themes
VOLUME /srv/www/htdocs/uploads
VOLUME /srv/www/htdocs/vendor

USER www-data

########################################## DEV ########################################################################

FROM base AS dev

RUN mkdir -p /srv/www && \
    chown www-data:www-data /srv/www

USER www-data