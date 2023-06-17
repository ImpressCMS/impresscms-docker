#!/usr/bin/env bash

RUNNING_MODE=$(cat /etc/mode)

COMMAND="$@"
if [ -z "$COMMAND" ]; then
  COMMAND="/sbin/runsvdir /opt/services"
fi;

set +e

echo "Checking vendor..."
. try-restore-vendor.sh | indent.sh
if [ $? -ne 0 ]; then
  echo "Error: There where some problem when checking vendor (exiting)"
  exit 1
fi;

echo "Updating ENV variables..."
. update-environment-config.sh
if [ $? -ne 0 ]; then
  echo "Error: There where some problem when updating environment (exiting)"
  exit 2
fi;

echo "Resolving SSL Certificates..."
. resolve-ssl-certificate.sh
if [ $? -ne 0 ]; then
  echo "Error: There where some problem when resolving SSL certificates (exiting)"
  exit 2
fi;

echo "Waiting for MySQL connection..."
dockerize -wait "tcp://$DB_HOST:$DB_PORT" -wait-retry-interval 5s | indent.sh
if [ $? -ne 0 ]; then
  echo "Error: There where some problem when waiting for MySQL (exiting)"
  exit 6
fi;

echo "Setuping impresscms..."
. setup-impresscms.sh | indent.sh
if [ $? -ne 0 ]; then
  echo "Error: There where some problem when setuping ImpressCMS (exiting)"
  exit 3
fi;

echo "All setuping done. Running."

$COMMAND
if [ $? -ne 0 ]; then
  echo "Error: Command failed (exiting)"
  exit 6
else
  echo "Command execution finished  (exiting)"
fi;

set -e