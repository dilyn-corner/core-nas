#!/bin/sh -eux

python3 "${SNAP_COMMON}/tubesync/manage.py" djangohuey --queue "$1"
