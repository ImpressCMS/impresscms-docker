#!/usr/bin/env bash

RUNNING_MODE=$(cat /etc/mode)

pushd /srv/www

if [ "$RUNNING_MODE" == "dev" ]; then
  composer install
fi;

. resolve-app-key.sh
. resolve-db-prefix.sh
set

echo "Migrating..."
./bin/phoenix migrate -vvv | indent.sh

popd