#!/usr/bin/env bash

RED='\033[0;31m'
NC='\033[0m'

for var in ICMS_DB_HOST ICMS_DB_USER ICMS_DB_PASS ICMS_DB_NAME ICMS_DB_PCONNECT ICMS_URL ICMS_DB_TYPE ICMS_DB_CHARSET ICMS_DB_COLLATION; do
    if [[ "$$var" == "" ]]; then
        echo -e "${RED}Error:${NC} $var variable not set but required"
        exit 1
    fi;
done

if [[ "$ICMS_DB_PCONNECT" == "0" || "$ICMS_DB_PCONNECT" == "1" ]]; then
    echo -e "${RED}Error:${NC} ICMS_DB_PCONNECT variable must be 0 or 1"
    exit 2
fi;

source /etc/impresscms/env

LAST_CONFIG_HASH=$(cat /etc/impresscms/all-env.md5)

if [[ "$ICMS_DB_PREFIX" == "" ]]; then
    ICMS_DB_PREFIX=$(rand-str 5)
fi;

if [[ "$ICMS_DB_SALT" == "" ]]; then
    ICMS_DB_SALT=$(rand-str 32)
fi;

HASH_OF_CURRENT_VARS=$(hash-args $ICMS_DB_SALT $ICMS_DB_PREFIX $ICMS_DB_HOST $ICMS_DB_USER $ICMS_DB_PASS $ICMS_DB_NAME $ICMS_DB_PCONNECT $ICMS_URL $ICMS_DB_TYPE $ICMS_DB_CHARSET $ICMS_DB_COLLATION)

if [[ "$HASH_OF_CURRENT_VARS" != "$LAST_CONFIG_HASH" ]]; then

    impresscms-save-config $ICMS_DB_PREFIX $ICMS_DB_SALT

    echo $HASH_OF_CURRENT_VARS > /etc/impresscms/all-env.md5

    sed -e "s/{DB_PREFIX}/$ICMS_DB_PREFIX/g" /srv/templates/impresscms.sql > /tmp/impresscms.sql
    sed -i -e "s/{ICMS_DB_CHARSET}/$ICMS_DB_CHARSET/g" /tmp/impresscms.sql
    sed -i -e "s/{ICMS_DB_COLLATION}/$ICMS_DB_COLLATION/g" /tmp/impresscms.sql

    mysql -hICMS_DB_HOST -u$ICMS_DB_USER -p$ICMS_DB_PASS $ICMS_DB_NAME -e "source /tmp/impresscms.sql;"

    rm -rf /tmp/impresscms.sql

fi;

apachectl -DFOREGROUND