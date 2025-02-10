#!/bin/bash

source /home/downloader/bin/set-vars.sh

mkdir -p $MOUNTPOINT_DIR
mkdir -p $MOUNTPOINT_PIDDIR

mountpoint -q $MOUNTPOINT_DIR && fusermount -uz $MOUNTPOINT_DIR
mount-s3 --read-only $MOUNTPOINT_BUCKET $MOUNTPOINT_DIR &
echo $! > $MOUNTPOINT_PIDFILE