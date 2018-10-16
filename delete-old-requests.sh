#!/bin/bash --login

source $HOME/bin/set-vars.sh

cd $RAILS_HOME
bundle exec rake downloader:delete_old_requests
