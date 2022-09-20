#!/usr/bin/env bash

set -e

PHP_FPM_START_SERVERS=$(((${PHP_FPM_MIN_SPARE_SERVERS} + ${PHP_FPM_MAX_SPARE_SERVERS}) / 2)) \
  dockerize \
    -template /srv/templates/php-fpm.conf.tmpl:/etc/php/php-fpm.conf \
    -template /srv/templates/php-fpm.d-www.conf.tmpl:/etc/php/php-fpm.d/www.conf \
    -stderr "$WEBSERVER_ERROR_LOG" \
    php-fpm