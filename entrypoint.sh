#!/bin/sh -e

if [ "$1" = 'unbound' ]; then

    exec "$@"
fi

exit 0