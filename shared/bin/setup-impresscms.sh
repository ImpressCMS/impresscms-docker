#!/usr/bin/env bash

set -e
set -o pipefail

pushd /srv/www

echo "Migrating..."
./bin/phoenix migrate -vv 2>&1 | indent.sh

popd
