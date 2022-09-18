#!/usr/bin/env bash

echo "Setuping php.."
launch-php-fpm.sh

echo "Setuping webserver..."
launch-web-server.sh

echo "Switching to www-data user..."
su - www-data

if [ "$#" -gt 0 ]; then
  echo "Executing command..."
  # shellcheck disable=SC2068
  $@
else
  trap : TERM INT; (while true; do sleep 1000; done) & wait
fi;