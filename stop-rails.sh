#!/bin/bash --login

source $HOME/bin/set-vars.sh

cd $RAILS_HOME
bundle exec passenger stop --pid-file=$PASSENGER_PID_FILE

