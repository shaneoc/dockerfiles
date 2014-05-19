#!/bin/bash

# Check for errors
if [ $# -ne 2 ]; then
    echo "Error: you need to specify the uid and gid to download with"
    exit 1
fi

if ! [ -d /config ]; then
    echo "Error: /config should be mounted as a volume"
    exit 1
fi

if ! [ -d /downloads ]; then
    echo "Error: /downloads should be mounted as a volume"
    exit 1
fi

for dir in watch incomplete finished; do
    if ! [ -d /downloads/$dir ]; then
        echo "Error: /downloads/$dir does not exist or is not a directory"
        exit 1
    fi
done

if ! [ -e "/config.done" ]; then
    # Create user
    uid="$1"
    gid="$2"
    groupadd -g "$gid" --non-unique transmission
    useradd -u "$uid" -g "$gid" --non-unique --no-user-group transmission

    touch /config.done
fi

# Copy default settings if it doesn't exist
if ! [ -e /config/settings.json ]; then
    echo "Copying default settings"
    install -o transmission -g transmission -m 600 /settings.json \
        /config/settings.json
fi

exec sudo -u transmission transmission-daemon -f --config-dir "/config"
