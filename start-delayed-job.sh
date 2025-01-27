#!/bin/bash --login

source $HOME/bin/set-vars.sh

cd $RAILS_HOME
bundle install
bundle exec bin/delayed_job -p $RAILS_ENV --pid-dir=$PID_DIR start &
sleep 10
awk 'END{print}' log/delayed_job_$RAILS_ENV.log | cut -d "#" -f 2 | cut -d "]" -f 1 > $PID_DIR/delayed_job.pid


