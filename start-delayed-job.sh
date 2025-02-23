#!/bin/bash --login

source $HOME/bin/set-vars.sh

cd $RAILS_HOME
bundle install
bundle exec bin/delayed_job -p $RAILS_ENV --pid-dir=$PID_DIR restart &
sleep 15
pgrep -f $RAILS_ENV/delayed_job | tail -n 1 > $DELAYED_JOB_PID_FILE


