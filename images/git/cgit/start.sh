if ! [ -d /git ]; then
    echo "Error: /git should be mounted as a volume"
    exit 1
fi

if touch /git/test.file 2>/dev/null; then
    echo "Error: /git should be mounted read-only"
    exit 1
fi

exec /usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf -D
