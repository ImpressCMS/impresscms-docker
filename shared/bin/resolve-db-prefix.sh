#!/usr/bin/env bash

if [ ! -f /etc/impresscms/db_prefix ]; then
  echo "Saving backup DB_PREFIX..."
  if [ "$DB_PREFIX" != "" ]; then
    echo "$DB_PREFIX" > /etc/impresscms/db_prefix
  else
    echo $RANDOM | md5sum | head -c 5 > /etc/impresscms/db_prefix
  fi;
  chmod a=r /etc/impresscms/app_key
fi;

if [ "$APP_KEY" == "" ]; then
  echo "Loading DB_PREFIX..."
  DB_PREFIX=$(cat /etc/impresscms/db_prefix)
  export DB_PREFIX
fi;