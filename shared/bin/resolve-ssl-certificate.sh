#!/usr/bin/env bash

if [ ! -z "$WEBSERVER_SSL_SERVER_CERTIFICATE" ] && [ ! -z "$WEBSERVER_SSL_SERVER_KEY" ] && [ ! -z "$WEBSERVER_SSL_CLIENT_CERTIFICATE" ]; then
  echo "$WEBSERVER_SSL_SERVER_CERTIFICATE" > /etc/impresscms/server.key
  echo "$WEBSERVER_SSL_SERVER_KEY" > /etc/impresscms/server.crt
  echo "$WEBSERVER_SSL_CLIENT_CERTIFICATE" > /etc/impresscms/server.pem;
elif [ -z "$WEBSERVER_SSL_SERVER_CERTIFICATE" ] && [ ! -z "$WEBSERVER_SSL_SERVER_KEY" ] && [ ! -z "$WEBSERVER_SSL_CLIENT_CERTIFICATE" ]; then
  echo "Error: Environment variable WEBSERVER_SSL_SERVER_CERTIFICATE is empty but WEBSERVER_SSL_SERVER_KEY and WEBSERVER_SSL_CLIENT_CERTIFICATE is not"
  echo "       Make all them empty or fill."
  exit 1
elif [ ! -z "$WEBSERVER_SSL_SERVER_CERTIFICATE" ] && [ -z "$WEBSERVER_SSL_SERVER_KEY" ] && [ ! -z "$WEBSERVER_SSL_CLIENT_CERTIFICATE" ]; then
  echo "Error: Environment variable WEBSERVER_SSL_SERVER_KEY is empty but WEBSERVER_SSL_SERVER_CERTIFICATE and WEBSERVER_SSL_CLIENT_CERTIFICATE is not"
  echo "       Make all them empty or fill."
  exit 2
elif [ ! -z "$WEBSERVER_SSL_SERVER_CERTIFICATE" ] && [ ! -z "$WEBSERVER_SSL_SERVER_KEY" ] && [ -z "$WEBSERVER_SSL_CLIENT_CERTIFICATE" ]; then
  echo "Error: Environment variable WEBSERVER_SSL_CLIENT_CERTIFICATE is empty but WEBSERVER_SSL_SERVER_KEY and WEBSERVER_SSL_SERVER_CERTIFICATE is not"
  echo "       Make all them empty or fill."
  exit 3
elif [ -z "$WEBSERVER_SSL_SERVER_CERTIFICATE" ] && [ -z "$WEBSERVER_SSL_SERVER_KEY" ] && [ ! -z "$WEBSERVER_SSL_CLIENT_CERTIFICATE" ]; then
  echo "Error: Environment variables WEBSERVER_SSL_SERVER_CERTIFICATE and WEBSERVER_SSL_SERVER_KEY are empty but WEBSERVER_SSL_CLIENT_CERTIFICATE is not"
  echo "       Make all them empty or fill."
  exit 4
elif [ ! -z "$WEBSERVER_SSL_SERVER_CERTIFICATE" ] && [ -z "$WEBSERVER_SSL_SERVER_KEY" ] && [ -z "$WEBSERVER_SSL_CLIENT_CERTIFICATE" ]; then
  echo "Error: Environment variables WEBSERVER_SSL_CLIENT_CERTIFICATE and WEBSERVER_SSL_SERVER_KEY are empty but WEBSERVER_SSL_SERVER_CERTIFICATE is not"
  echo "       Make all them empty or fill."
  exit 5
elif [ -z "$WEBSERVER_SSL_SERVER_CERTIFICATE" ] && [ ! -z "$WEBSERVER_SSL_SERVER_KEY" ] && [ -z "$WEBSERVER_SSL_CLIENT_CERTIFICATE" ]; then
  echo "Error: Environment variables WEBSERVER_SSL_CLIENT_CERTIFICATE and WEBSERVER_SSL_CLIENT_CERTIFICATE are empty but WEBSERVER_SSL_SERVER_KEY is not"
  echo "       Make all them empty or fill."
  exit 6
elif [ -f /etc/impresscms/server.key ] && [ ! -f /etc/impresscms/server.crt ] && [ ! -f /etc/impresscms/server.pem ]; then
  echo "Error: /etc/impresscms/server.key exist but /etc/impresscms/server.crt and /etc/impresscms/server.key doesn't"
  echo "       Delete all or add all."
  exit 7
elif [ ! -f /etc/impresscms/server.key ] && [ -f /etc/impresscms/server.crt ] && [ ! -f /etc/impresscms/server.pem ]; then
  echo "Error: /etc/impresscms/server.crt exist but /etc/impresscms/server.key and /etc/impresscms/server.pem doesn't"
  echo "       Delete all or add all."
  exit 8
elif [ ! -f /etc/impresscms/server.key ] && [ ! -f /etc/impresscms/server.crt ] && [ -f /etc/impresscms/server.pem ]; then
  echo "Error: /etc/impresscms/server.pem exist but /etc/impresscms/server.key and /etc/impresscms/server.crt doesn't"
  echo "       Delete all or add all."
  exit 9
elif [ ! -f /etc/impresscms/server.key ] && [ -f /etc/impresscms/server.crt ] && [ -f /etc/impresscms/server.pem ]; then
  echo "Error: /etc/impresscms/server.key not exist but /etc/impresscms/server.pem and /etc/impresscms/server.crt does"
  echo "       Delete all or add all."
  exit 10
elif [ -f /etc/impresscms/server.key ] && [ -f /etc/impresscms/server.crt ] && [ ! -f /etc/impresscms/server.pem ]; then
  echo "Error: /etc/impresscms/server.pem not exist but /etc/impresscms/server.key and /etc/impresscms/server.crt does"
  echo "       Delete all or add all."
  exit 11
elif [ -f /etc/impresscms/server.key ] && [ ! -f /etc/impresscms/server.crt ] && [ -f /etc/impresscms/server.pem ]; then
  echo "Error: /etc/impresscms/server.crt not exist but /etc/impresscms/server.key and /etc/impresscms/server.pem does"
  echo "       Delete all or add all."
  exit 12
else

    if [ -z "$RUNNING_MODE" ]; then
      RUNNING_MODE=$(cat /etc/mode);
    fi;

    if [ "$RUNNING_MODE" == "prod" ]; then
      curl https://get.acme.sh | sh -s email="$INSTALL_ADMIN_EMAIL"
    else
      generate-fake-ssl-certificate.sh
    fi;

fi;