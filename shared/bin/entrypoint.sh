#!/usr/bin/env bash

set -e

. update-environment-config.sh

echo "Waiting for MySQL connection..."
dockerize -wait "tcp://$DB_HOST:$DB_PORT" -wait-retry-interval 5s | indent.sh

echo "Setuping impresscms..."
. setup-impresscms.sh | indent.sh

echo "Setuping php.."
launch-php-fpm.sh | indent.sh

echo "Setuping webserver..."
launch-web-server.sh | indent.sh

echo "Switching to www-data user..."
su - www-data

if [ "$#" -gt 0 ]; then
  echo "Executing command..."
  # shellcheck disable=SC2068
  $@
else
  trap : TERM INT; (while true; do sleep 1000; done) & wait
fi;