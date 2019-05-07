#!/bin/bash

source ./set-vars.sh

mkdir -p $RCLONE_MOUNTPOINT

mountpoint -q $RCLONE_MOUNTPOINT && fusermount -uz $RCLONE_MOUNTPOINT
