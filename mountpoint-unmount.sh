#!/bin/bash

source ./set-vars.sh

mkdir -p $MOUNTPOINT_DIR

mountpoint -q $MOUNTPOINT_DIR && fusermount -uz $MOUNTPOINT_DIR
