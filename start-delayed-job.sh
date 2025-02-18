#!/bin/bash --login

source $HOME/bin/set-vars.sh

cd $RAILS_HOME
bundle install
bundle exec bin/delayed_job -p $RAILS_ENV --pid-dir=$PID_DIR restart &
sleep 2
pgrep -f $RAILS_ENV/delayed_job > $PID_DIR/delayed_job.pid


