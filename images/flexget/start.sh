#!/bin/bash
set -e

# Check for errors
if [ ! -e /cfg/config.yml ]; then
    echo "Error: file /cfg/config.yml is missing"
    exit 1
fi

if [ ! -e /home/flexget/.flexget ]; then
    ln -s /cfg /home/flexget/.flexget
fi

chown -R flexget.flexget /cfg

exec sudo -i -u flexget flexget daemon start
