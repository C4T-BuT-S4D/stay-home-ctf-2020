#!/usr/bin/env bash

FILE=/key/.key
if [ ! -f "$FILE" ]; then
    head /dev/urandom | LC_ALL=C tr -dc A-Za-z0-9 | head -c20 > $FILE
fi

NODE_ENV=production KEY=$(cat .key) node main.js