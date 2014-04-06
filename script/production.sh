if [ $1 != 'skip' ]; then
    RAILS_ENV=production bundle exec rake assets:precompile
fi
sudo rails server -p 80 -e production
