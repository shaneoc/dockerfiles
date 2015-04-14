#!/bin/bash

if ! [ -e "/cfg/stunnel.conf" ]; then
    echo "Error: file /cfg/$file is missing"
    exit 1
fi

if touch /cfg/test.file 2>/dev/null; then
    echo "Error: /cfg should be mounted read-only"
    exit 1
fi

exec /usr/bin/stunnel4 /cfg/stunnel.conf
