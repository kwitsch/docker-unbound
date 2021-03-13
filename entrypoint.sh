#!/bin/sh -e

if [ "$1" = 'unbound' ]; then

    echo "-- Set nameserver"
    echo "nameserver 127.0.0.1" > /etc/resolv.conf
    echo "-----------------"

    echo "-- Start unbound"
    exec "$@"
fi

exit 0