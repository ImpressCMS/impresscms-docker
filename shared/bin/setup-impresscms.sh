#!/usr/bin/env bash

set -e

RUNNING_MODE=$(cat /etc/mode)

pushd /srv/www

if [ "$RUNNING_MODE" == "dev" ]; then
  composer install 2>&1
fi;

echo "Migrating..."
./bin/phoenix migrate -vv 2>&1 | indent.sh

popd