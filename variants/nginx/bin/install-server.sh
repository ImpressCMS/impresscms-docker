#!/usr/bin/env sh

apk add --no-cache \
        nginx \
        nginx-mod-http-brotli

mkdir -p /var/lib/nginx/cache/

mkdir -p /etc/nginx/http.d/