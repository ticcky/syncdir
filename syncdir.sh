#!/bin/bash
HOST=$1
SRC_PATH=$2
DST_PATH=$3
EXTRA_RSYNC_PARAMS="$4"

quit() {
    ssh -S ${HOME}/.ssh/ctl/${HOST} -O exit ${HOST}
    echo "Exitting."
    exit 0
}

trap 'quit' SIGINT

echo "extra rsync params: ${EXTRA_RSYNC_PARAMS}"

ssh -nNf -M -S ~/.ssh/ctl/${HOST} ${HOST}
SSH_PID=$!

while [ 1 ]; do
    rsync --delete-after -avrz --no-l ${EXTRA_RSYNC_PARAMS} -e "ssh -S ${HOME}/.ssh/ctl/${HOST}" ${SRC_PATH} ${HOST}:${DST_PATH}
    sleep 1
done

kill ${SSH_PID}
