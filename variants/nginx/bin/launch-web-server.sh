#!/usr/bin/env bash

if [ ! -f "$WEBSERVER_ERROR_LOG" ]; then
  touch "$WEBSERVER_ERROR_LOG"
fi;

if [ ! -f "$WEBSERVER_ACCESS_LOG" ]; then
  touch "$WEBSERVER_ACCESS_LOG"
fi;

echo "Touching web log files..."
echo "  $WEBSERVER_ERROR_LOG"
LOG_DIRNAME=$(dirname "$WEBSERVER_ERROR_LOG")
if [ ! -d "$LOG_DIRNAME" ]; then
  mkdir -p "$LOG_DIRNAME"
fi
touch "$WEBSERVER_ERROR_LOG"
echo "  $WEBSERVER_ACCESS_LOG"
LOG_DIRNAME=$(dirname "$WEBSERVER_ACCESS_LOG")
if [ ! -d "$LOG_DIRNAME" ]; then
  mkdir -p "$LOG_DIRNAME"
fi
touch "$WEBSERVER_ACCESS_LOG"

mkdir -p /etc/nginx/extra

dockerize \
  -template /srv/templates/nginx.conf.tmpl:/etc/nginx/nginx.conf \
  -template /srv/templates/http.d/default.conf.tmpl:/etc/nginx/http.d/default.conf \
  -template /srv/templates/http.d/default-ssl.conf.tmpl:/etc/nginx/http.d/default-ssl.conf \
  -template /srv/templates/extra/self-signed.conf.tmpl:/etc/nginx/extra/self-signed.conf

nginx -g 'daemon off;'