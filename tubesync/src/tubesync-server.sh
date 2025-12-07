#!/bin/sh -eux

# Need to identify host IP
# Requires network-observe?
# export TUBESYNC_HOSTS=10.0.0.2
export LISTEN_HOST=10.0.0.2
export TUBESYNC_DEBUG=true

python3 "${SNAP_COMMON}/tubesync/manage.py" showmigrations -v 3 --list
python3 "${SNAP_COMMON}/tubesync/manage.py" migrate

gunicorn tubesync.wsgi:application --capture-output \
    -c "${SNAP_COMMON}/tubesync/tubesync/gunicorn.py"
