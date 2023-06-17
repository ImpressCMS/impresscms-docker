#!/usr/bin/env bash

set -e
set -o pipefail

echo "Touching PHP file ($PHP_FPM_ERROR_LOG)..."
LOG_DIRNAME=$(dirname "$PHP_FPM_ERROR_LOG")
if [ ! -d "$LOG_DIRNAME" ]; then
  mkdir -p "$LOG_DIRNAME"
fi
touch "$PHP_FPM_ERROR_LOG"

PHP_FPM_START_SERVERS=$(((${PHP_FPM_MIN_SPARE_SERVERS} + ${PHP_FPM_MAX_SPARE_SERVERS}) / 2))
echo "PHP_FPM_START_SERVERS = [$PHP_FPM_START_SERVERS]"

PHP_FPM_START_SERVERS=$PHP_FPM_START_SERVERS dockerize \
    -template /srv/templates/php-fpm.conf.tmpl:/etc/php/php-fpm.conf \
    -template /srv/templates/php-fpm.d-www.conf.tmpl:/etc/php/php-fpm.d/www.conf

php-fpm -R -F --pid /var/run/php-fpm.pid