########################################## VARIANT DATA ################################################################
FROM alpine:latest AS variant_data

ARG VARIANT=nginx

COPY ./variants/${VARIANT}/bin/*.sh /usr/local/bin/
COPY ./variants/${VARIANT}/templates/ /srv/templates/

RUN chmod +x /usr/local/bin/*.sh

########################################## BASE ########################################################################
FROM powerman/dockerize:latest AS base

ARG VARIANT=nginx

# ImpressCMS env variables
ENV URL=http://localhost \
    DB_TYPE=pdo.mysql \
    DB_HOST="" \
    DB_USER=root \
    DB_PASS="" \
    DB_PCONNECT=0 \
    DB_NAME=icms \
    DB_CHARSET=utf8 \
    DB_COLLATION=utf8_general_ci \
    DB_PREFIX="" \
    APP_KEY="" \
    DB_PORT=3306 \
    INSTALL_ADMIN_PASS="" \
    INSTALL_ADMIN_LOGIN="" \
    INSTALL_ADMIN_NAME="" \
    INSTALL_ADMIN_EMAIL=""

# WebServer Env variables
ENV WEBSERVER_ERROR_LOG="/var/log/${VARIANT}/error.log" \
    WEBSERVER_ACCESS_LOG="/var/log/${VARIANT}/access.log" \
    WEBSERVER_GZIP=off

# PHP ENV variables
ENV PHP_FPM_POOLS=2 \
    PHP_FPM_MAX_CHILDREN=5 \
    PHP_FPM_MIN_SPARE_SERVERS=5 \
    PHP_FPM_MAX_SPARE_SERVERS=10 \
    PHP_FPM_MAX_REQUESTS=1000 \
    PHP_FPM_ERROR_LOG=/dev/stderr \
    PHP_FPM_LOG_ERRORS=on \
    PHP_FPM_DISPLAY_ERRORS=off \
    PHP_FPM_EXPOSE_PHP=off

COPY --from=variant_data /usr/local/bin/*.sh /usr/local/bin/
COPY --from=variant_data /srv/templates/ /srv/templates/

RUN apk add --no-cache \
      bash  && \
    adduser -S www-data -G www-data

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

ADD src /srv/www

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