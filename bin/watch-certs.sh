#!/usr/bin/env bash

set -e

mkdir -p "$LIVE_CERT_FOLDER"

# Abort, if already running.
if [[ -n "$(ps | grep watch-certs.sh | grep -v grep)" ]]; then
	echo "Already waiting: ${LIVE_CERT_FOLDER}/last_modified" >&2
	exit 1
fi

if [ ! -f ${LIVE_CERT_FOLDER}/last_modified ]; then
    echo "-" > ${LIVE_CERT_FOLDER}/last_modified
fi

LAST_MODIFIED=`cat ${LIVE_CERT_FOLDER}/last_modified`

while true
do
    if `cat ${LIVE_CERT_FOLDER}/last_modified` != LAST MODIFIED; then
        LAST_MODIFIED=`cat ${LIVE_CERT_FOLDER}/last_modified`
        echo "Certs modified, reloading haproxy";
        install-certs.sh; /reload.sh
    fi
    sleep 30
done