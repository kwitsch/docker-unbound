#!/bin/sh -e

if [ "$1" = 'unbound' ]; then
    echo "-- Replace data"
    cp ./data/root.key.new ./data/root.key
    cp ./data/root.hints.new ./data/root.hints
    echo "-----------------"

    echo "-- Set nameserver"
    echo "nameserver 127.0.0.1" > /etc/resolv.conf
    echo "-----------------"

    echo "-- Set permissions"
    chown unbound ./data -R
    chgrp unbound ./data -R
    echo "-----------------"

    echo "-- Start unbound"
    exec "$@"
fi

exit 0