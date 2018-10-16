#!/bin/bash --login

source $HOME/bin/set-vars.sh

cd $RAILS_HOME
bundle exec bin/delayed_job -p $RAILS_ENV --pid-dir=$PID_DIR stop

