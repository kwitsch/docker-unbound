#!/bin/sh -e

if [ "$1" = 'unbound' ]; then
    echo "-- Replace data"
    cp ./data/root.key.new ./data/root.key
    cp ./data/root.hints.new ./data/root.hints
    echo "-----------------"

    echo "-- Set permissions"
    chown unbound ./data -R
    chgrp unbound ./data -R
    echo "-----------------"

    echo "-- Start unbound"
    exec "$@"
fi

exit 0