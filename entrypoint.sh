#!/bin/sh -e

if [ "$1" = 'unbound' ]; then
    echo "-- Start bootstrap"
    cp ./data/root.hints ./data/root.hints-old
    rm /etc/unbound/unbound.conf
    ln ./config/bootstrap.conf /etc/unbound/unbound.conf
    unbound
    echo "-----------------"

    echo "-- Set nameserver"
    echo "nameserver 127.0.0.1" > /etc/resolv.conf
    echo "-----------------"

    echo "-- Get root.hints"
    curl https://www.internic.net/domain/named.root > /app/data/root.hints
    echo "-----------------"

    echo "-- Get root.key"
    unbound-anchor -4 -v -a /app/data/root.key
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

    echo "-- Start unbound"
    exec "$@"
fi

exit 0