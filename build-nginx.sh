#!/bin/bash

#build and install nginx and nginx2 for medusa user
source $HOME/bin/set-vars.sh

cd $NGINX_SRC_DIR

make clean

./configure --prefix=$NGINX_TARGET_DIR --user=$NGINX_USER --group=$NGINX_GROUP --add-module=$MOD_ZIP_DIR --add-module=$HTTP_DIGEST_AUTH_DIR

make
make install

make clean

./configure --prefix=$NGINX2_TARGET_DIR --user=$NGINX_USER --group=$NGINX_GROUP --add-module=$HTTP_DIGEST_AUTH_DIR

make 
make install

