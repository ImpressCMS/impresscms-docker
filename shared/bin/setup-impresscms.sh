#!/usr/bin/env bash

set -e

pushd /srv/www

echo "Migrating..."
./bin/phoenix migrate -vv 2>&1 | indent.sh

popd
