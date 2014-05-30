#!/bin/bash

# Check for errors
if ! [ -e /cfg/config.yml ]; then
    echo "Error: file /cfg/config.yml is missing"
    exit 1
fi

if touch /cfg/test.file 2>/dev/null; then
    echo "Error: /cfg should be mounted read-only"
    exit 1
fi

exec sudo -i -u flexget flexget daemon start
