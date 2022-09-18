#!/usr/bin/env bash

if [ ! -f /etc/impresscms/app_key ]; then
  echo "Saving backup APP_KEY..."
  if [ "$APP_KEY" != "" ]; then
    echo "$APP_KEY" > /etc/impresscms/app_key
  else
    php ./bin/console generate:app:key > /etc/impresscms/app_key
  fi;
  chmod a=r /etc/impresscms/app_key
fi;

if [ "$APP_KEY" == "" ]; then
  echo "Loading APP_KEY..."
  APP_KEY=$(cat /etc/impresscms/app_key)
  export APP_KEY
fi;