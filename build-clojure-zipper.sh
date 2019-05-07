#!/bin/bash

source $HOME/bin/set-vars.sh

cd $CLOJURE_ZIPPER_DIR
lein uberjar
cp $CLOJURE_ZIPPER_DIR/target/uberjar/clojure-zipper.jar $HOME/bin/clojure-zipper.jar
