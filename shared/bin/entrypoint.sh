#!/usr/bin/env bash

set -e

RUNNING_MODE=$(cat /etc/mode)

. update-environment-config.sh

echo "Waiting for MySQL connection..."
dockerize -wait "tcp://$DB_HOST:$DB_PORT" -wait-retry-interval 5s | indent.sh

echo "Setuping impresscms..."
. setup-impresscms.sh | indent.sh

echo "Setuping php.."
launch-php-fpm.sh | indent.sh

echo "Setuping webserver..."
launch-web-server.sh | indent.sh

echo "Touchoing log files..."
touch $PHP_FPM_ERROR_LOG
touch $WEBSERVER_ERROR_LOG
touch $WEBSERVER_ACCESS_LOG

echo "All setuping done. Running."
tail -f /var/log/{nginx,php8}/*.log
