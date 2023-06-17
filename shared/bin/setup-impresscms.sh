#!/usr/bin/env bash

set -e
set -o pipefail

pushd /srv/www

  echo "Migrating..."
  while true; do
      php ./bin/phoenix migrate -vv 2>&1 | indent.sh

      if [ $? -eq 0 ]; then
          break
      fi

      sleep 1
  done

popd
