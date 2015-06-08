#!/bin/bash
HOST=$1
SRC_PATH=$2
DST_PATH=$3
EXCLUDES="$4"

mkdir -p ${HOME}/.ssh/ctl/

quit() {
    ssh -S ${HOME}/.ssh/ctl/${HOST} -O exit ${HOST}
    echo "Exitting."
    exit 0
}

trap 'quit' SIGINT

echo "Excluding: ${EXCLUDES}"

ssh -nNf -M -S ~/.ssh/ctl/${HOST} ${HOST}
SSH_PID=$!

echo "Started SSH in PID ${SSH_PID}"


while [ 1 ]; do
    rsync --delete-after -avrz --no-l ${EXCLUDES} -e "ssh -S ${HOME}/.ssh/ctl/${HOST}" ${SRC_PATH} ${HOST}:${DST_PATH}
    sleep 1
done

kill ${SSH_PID}
