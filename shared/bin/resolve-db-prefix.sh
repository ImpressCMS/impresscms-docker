#!/usr/bin/env bash

if [ ! -f /etc/impresscms/db-prefix ]; then
  echo "Saving backup DB_PREFIX..."
  if [ "$DB_PREFIX" != "" ]; then
    echo "$DB_PREFIX" > /etc/impresscms/db-prefix
  else
    echo $RANDOM | md5sum | head -c 5 > /etc/impresscms/db-prefix
  fi;
  chmod a=r /etc/impresscms/db-prefix
fi;

if [ "$DB_PREFIX" == "" ]; then
  echo "Loading DB_PREFIX..."
  DB_PREFIX=$(cat /etc/impresscms/db-prefix)
  export DB_PREFIX="$DB_PREFIX"
fi;