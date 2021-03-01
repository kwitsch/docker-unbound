#!/bin/sh -e

if [ "$1" = 'unbound' ]; then
    echo "-- Get root.hints from https://www.internic.net/domain/named.root"
    curl https://www.internic.net/domain/named.root > ./data/root.hints
    echo "-----------------"

    echo "-- Verify anchor(root.key)"
    unbound-anchor -4 -v -a ./data/root.key
    echo "-----------------"

    echo "-- Set permissions"
    chown unbound ./data -R
    chgrp unbound ./data -R
    echo "-----------------"

    echo "-- Start unbound"
    exec "$@"
fi

exit 0