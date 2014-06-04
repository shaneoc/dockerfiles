#!/bin/bash
set -e

# Check for errors
for f in passwd group shadow smb.conf; do
    if ! [ -e /cfg/$f ]; then
        echo "Error: file /cfg/$f is missing"
        exit 1
    fi
done

if [ ! -d /cfg/smbpasswd ]; then
    echo "Error: directory /cfg/smbpasswd is missing"
    exit 1
fi

while read -d '' -r file <&9; do
    perm=$(stat -c '%U.%G %a' "$file")
    if [ -d "$file" ]; then
        if [ "$perm" != "root.root 755" ]; then
            echo "Error: directory $file has incorrect permissions: $perm"
            echo "Should be: root.root 755"
            exit 1
        fi
    else
        if [ "$perm" != "root.root 644" ]; then
            echo "Error: file $file has incorrect permissions: $perm"
            echo "Should be: root.root 644"
            exit 1
        fi
    fi
done 9< <(find /cfg -path /cfg/smbpasswd -prune -o -print0)

while read -d '' -r file <&9; do
    perm=$(stat -c '%U.%G %a' "$file")
    if [ -d "$file" ]; then
        if [ "$perm" != "root.root 700" ]; then
            echo "Error: directory $file has incorrect permissions: $perm"
            echo "Should be: root.root 700"
            exit 1
        fi
    else
        if [ "$perm" != "root.root 600" ]; then
            echo "Error: file $file has incorrect permissions: $perm"
            echo "Should be: root.root 600"
            exit 1
        fi
    fi
done 9< <(find /cfg/smbpasswd -print0)

if touch /cfg/test.file 2>/dev/null; then
    echo "Error: /cfg should be mounted read-only"
    exit 1
fi

if [ ! -e /config.done ]; then
    rm /etc/samba/smb.conf
    ln -s /cfg/smb.conf /etc/samba/smb.conf

    cat /cfg/passwd >> /etc/passwd
    cat /cfg/group >> /etc/group
    cat /cfg/shadow >> /etc/shadow
fi

smbd -D
nmbd -D

if [ ! -e /config.done ]; then
    for passwd in /cfg/smbpasswd/*; do
        username=$(basename $passwd)
        (cat $passwd; cat $passwd) | smbpasswd -a $username
    done

    touch /config.done
fi

cat /var/log/samba/log.smbd
exec tail -f /var/log/samba/log.smbd
