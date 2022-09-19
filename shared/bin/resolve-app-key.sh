#!/usr/bin/env bash

if [ ! -f /etc/impresscms/app-key ]; then
  echo "Saving backup APP_KEY..."
  if [ "$APP_KEY" != "" ]; then
    echo "$APP_KEY" > /etc/impresscms/app-key
  else
    php ./bin/console generate:app:key > /etc/impresscms/app-key
  fi;
  chmod a=r /etc/impresscms/app-key
fi;

if [ "$APP_KEY" == "" ]; then
  echo "Loading APP_KEY..."
  APP_KEY=$(cat /etc/impresscms/app-key)
  export APP_KEY="$APP_KEY"
fi;