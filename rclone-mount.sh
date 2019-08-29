#!/bin/bash

source /home/downloader/bin/set-vars.sh

mkdir -p $RCLONE_MOUNTPOINT
mkdir -p $RCLONE_PIDDIR

mountpoint -q $RCLONE_MOUNTPOINT && fusermount -uz $RCLONE_MOUNTPOINT
rclone mount $RCLONE_REMOTE:$RCLONE_BUCKET $RCLONE_MOUNTPOINT --read-only &
echo $! > $RCLONE_PIDFILE
