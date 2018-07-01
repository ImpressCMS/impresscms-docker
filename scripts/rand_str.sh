#!/usr/bin/env bash

LENGTH=$1
if [[ "$LENGTH" -le "1" ]]; then
    LENGTH=1
fi;

cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $LENGTH | head -n 1