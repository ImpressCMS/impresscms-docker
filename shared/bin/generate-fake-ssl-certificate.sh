#!/usr/bin/env bash

rm -rf /etc/impresscms/server.key
rm -rf /etc/impresscms/server.crt
rm -rf /etc/impresscms/server.pem
openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=Another ImpressCMS site in development mode/CN=$WEBSERVER_DOMAIN" -addext "subjectAltName=DNS:$WEBSERVER_DOMAIN" -newkey rsa:2048 -keyout /etc/impresscms/server.key -out /etc/impresscms/server.crt;
openssl dhparam -out /etc/impresscms/server.pem 4096
