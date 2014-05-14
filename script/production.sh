#!/bin/sh
if [ $1 != 'skip' ]; then
    RAILS_ENV=production bundle exec rake assets:precompile
fi
rails server -p 8082 -e production
