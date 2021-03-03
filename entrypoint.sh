#!/bin/sh -e

if [ "$1" = 'unbound' ]; then
    if [ ! -f ./data/root.hints ]; then
        echo "-- Start bootstrap"
        ln ./config/bootstrap.conf /etc/unbound/unbound.conf
        unbound
        echo "-----------------"

        echo "-- Set nameserver"
        echo "nameserver 127.0.0.1" > /etc/resolv.conf
        echo "-----------------"

        echo "-- Get root.hints from internic.net"
        curl -s https://www.internic.net/domain/named.root > ./data/root.hints
        echo "-----------------"

        echo "-- Verify anchor(root.key)"
        unbound-anchor -4 -v -a ./data/root.key
        echo "-----------------"

        echo "-- Set permissions"
        chown unbound ./data -R
        chgrp unbound ./data -R
        echo "-----------------"

        echo "-- End bootstrap"
        killall unbound
        rm /etc/unbound/unbound.conf
        ln ./config/unbound.conf /etc/unbound/unbound.conf
        echo "-----------------"
    fi

    echo "-- Start unbound"
    exec "$@"
fi

exit 0