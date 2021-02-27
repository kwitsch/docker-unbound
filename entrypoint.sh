#!/bin/sh -e

if [ "$1" = 'unbound' ]; then
    rm /etc/unbound/root.hints
    ln /app/data/root.hints /etc/unbound/root.hints
    rm /etc/unbound/unbound.conf
    ln /app/config/unbound.conf /etc/unbound/unbound.conf
    chown unbound /app/data/root.hints

    exec "$@" -d
fi

exit 0