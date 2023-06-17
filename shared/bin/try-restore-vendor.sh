#!/usr/bin/env bash

set -e
set -o pipefail

if [ -d /srv/www/vendor ]; then
  echo "Vendor in place. Seems everything ok!"
  echo "If you need, update manually"
  exit 0
fi;

if [ -f /srv/bkp/vendor.7z ]; then
  echo "Restoring from backup /srv/bkp/vendor -> /srv/www"
  7za x -y /srv/bkp/vendor.7z -o/srv/www
  echo "Tip: If update for vendor is needed, run composer manually."
  exit 0
fi;

echo "It seems you running container with mounted web folder without installed composer dependencies. Install them locally first" >&2
exit 1