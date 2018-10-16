#!/bin/bash --login

source $HOME/bin/set-vars.sh

cd $RAILS_HOME
bundle install
bundle exec passenger start -e $RAILS_ENV -d --pid-file=$PASSENGER_PID_FILE



