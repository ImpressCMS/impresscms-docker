#!/usr/bin/env bash

ICMS_DB_PREFIX=$1
ICMS_DB_SALT=$2

cat > /etc/impresscms/env << EOF
    ICMS_DB_PREFIX=$ICMS_DB_PREFIX
    ICMS_DB_SALT=$ICMS_DB_SALT
EOF