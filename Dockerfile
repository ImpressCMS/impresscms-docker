########################################## VARIANT DATA ################################################################
FROM alpine:latest AS variant_data

ARG VARIANT=nginx

COPY ./shared/bin/*.sh /usr/local/bin/
COPY ./shared/templates/ /srv/templates/
COPY ./variants/${VARIANT}/bin/*.sh /usr/local/bin/
COPY ./variants/${VARIANT}/templates/ /srv/templates/

RUN chmod +x /usr/local/bin/*.sh

########################################## BASE ########################################################################
FROM alpine:latest AS base

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
ENV WEBSERVER_ERROR_LOG=/dev/stderr \
    WEBSERVER_ACCESS_LOG=/dev/stdout \
    WEBSERVER_GZIP=off \
    WEBSERVER_POST_MAX_SIZE=20M

# PHP ENV variables
ENV PHP_FPM_MAX_CHILDREN=10 \
    PHP_FPM_MIN_SPARE_SERVERS=5 \
    PHP_FPM_MAX_SPARE_SERVERS=10 \
    PHP_FPM_MAX_REQUESTS=1000 \
    PHP_FPM_ERROR_LOG=/dev/stderr \
    PHP_FPM_LOG_ERRORS=on \
    PHP_FPM_DISPLAY_ERRORS=off \
    PHP_FPM_MEMORY_LIMIT=256M

COPY --from=variant_data /usr/local/bin/*.sh /usr/local/bin/
COPY --from=variant_data /srv/templates/ /srv/templates/
COPY --from=powerman/dockerize:latest /usr/local/bin/* /usr/local/bin/

ADD ./src/ /srv/www/

RUN apk add --no-cache \
      bash \
      sudo && \
    adduser -S www-data -G www-data -h /srv/www -s /bin/bash -H -D && \
    mkdir -p /var/log/${VARIANT} && \
    chown -R www-data:www-data /srv

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
    mkdir -p /var/run/php/ && \
    chown www-data:www-data /var/run/php/ && \
    ln -s $(realpath /etc/php*) /etc/php && \
    ln -s $(realpath /usr/sbin/php-fpm8*) /usr/sbin/php-fpm && \
    rm -rf /etc/php/php-fpm.conf && \
    rm -rf /etc/php/php-fpm.d/www.conf

RUN /usr/local/bin/install-server.sh && \
    rm -rf /usr/local/bin/install-server.sh

EXPOSE 80 443

ENTRYPOINT entrypoint.sh

########################################## PROD ########################################################################

FROM base AS prod

VOLUME /srv/www/modules
VOLUME /srv/www/language
VOLUME /srv/www/storage
VOLUME /srv/www/htdocs/libraries
VOLUME /srv/www/htdocs/include
VOLUME /srv/www/htdocs/themes
VOLUME /srv/www/htdocs/uploads
VOLUME /srv/www/htdocs/vendor

########################################## DEV ########################################################################

FROM base AS dev

RUN apk add --no-cache \
        util-linux \
        mc