#!/usr/bin/env bash

dockerize \
  -template /etc/templates/nginx/nginx.conf.tmpl:/etc/nginx/nginx.conf \
  -template /etc/templates/nginx-website.conf.tmpl:/etc/nginx/http.d/default.conf \
  -stderr "$WEBSERVER_ERROR_LOG" \
  nginx