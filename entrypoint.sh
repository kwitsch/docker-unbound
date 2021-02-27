#!/bin/sh -e

if [ "$1" = 'unbound' ]; then

    exec "$@" -d
fi

exit 0