#!/usr/bin/env bash

if [ ! -f "$WEBSERVER_ERROR_LOG" ]; then
  touch "$WEBSERVER_ERROR_LOG"
fi;

if [ ! -f "$WEBSERVER_ACCESS_LOG" ]; then
  touch "$WEBSERVER_ACCESS_LOG"
fi;

dockerize \
  -template /srv/templates/nginx.conf.tmpl:/etc/nginx/nginx.conf \
  -template /srv/templates/nginx-website.conf.tmpl:/etc/nginx/http.d/default.conf \
  -stderr "$WEBSERVER_ERROR_LOG" \
  nginx