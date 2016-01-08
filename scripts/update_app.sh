echo "updating gems and migrations. running as $(whoami)"
echo "current directory: $(pwd)"
bundle install --deployment --without development test
bundle exec rake db:migrate RAILS_ENV=production
