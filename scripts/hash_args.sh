#!/usr/bin/env bash

PARAMS_STR=""
while (( "$#" )); do
  PARAMS_STR="$1; $PARAMS_STR"
  shift
done

echo $PARAMS_STR | md5