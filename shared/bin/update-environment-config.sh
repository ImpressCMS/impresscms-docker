#!/usr/bin/env bash

set -e

if [ "$APP_KEY" != "" ] && [ "$DB_PREFIX" != "" ]; then
  exit 0
fi;

if [ ! -f /etc/environment ]; then
  touch /etc/environment
fi

. /etc/environment

if [ "$APP_KEY" != "" ] && [ "$DB_PREFIX" != "" ]; then
  exit 0
fi;

if [ "$APP_KEY" == "" ]; then
  echo "Generating APP_KEY..."
  APP_KEY=$(php /srv/www/bin/console generate:app:key)
fi

if [ "$DB_PREFIX" == "" ]; then
  echo "Generating DB_PREFIX..."
  DB_PREFIX=$(echo $RANDOM | md5sum | head -c 5)
fi

echo "Writing /etc/impresscms/environment..."
cat > /etc/impresscms/environment << EOL
#
# This file is parsed by pam_env module
#
# Syntax: simple "KEY=VAL" pairs on separate lines
#

APP_KEY=${APP_KEY}
DB_PREFIX=${DB_PREFIX}

EOL

if [ ! -L "/etc/environment" ]; then
  echo "Making /etc/environment into a link..."
  rm -rf /etc/environment
  ln -s /etc/impresscms/environment /etc/environment
  chmod 0644 /etc/environment
fi

export APP_KEY="$APP_KEY"
export DB_PREFIX="$DB_PREFIX"