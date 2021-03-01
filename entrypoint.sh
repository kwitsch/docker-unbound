#!/bin/sh -e

if [ "$1" = 'unbound' ]; then
    echo "-- Get root.hints"
    curl --resolve www.internic.com:443:"$BOOTSTRAP_DNS" https://www.internic.net/domain/named.root --output /app/data/root.hints
    echo "-----------------"

    echo "-- Get root.key"
    unbound-anchor -4 -v -a /app/data/root.key
    echo "-----------------"

    echo "-- Set permissions"
    chown unbound ./data -R
    chgrp unbound ./data -R
    echo "-----------------"
    
    echo "-- Start unbound"
    exec "$@"
fi

exit 0