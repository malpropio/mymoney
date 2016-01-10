#Slack Notification
curl -X POST --data-urlencode 'payload={"text": "Deployment '${DEPLOYMENT_ID}' of '${APPLICATION_NAME}' on '${DEPLOYMENT_GROUP_NAME}' has started"}' https://hooks.slack.com/services/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

DIR=$(pwd)
cd /var/apps/mymoney
echo "updating gems and migrations. running as $(whoami)"
echo "current directory: $(pwd)"
bundle install #--deployment --without development test
bundle exec rake db:migrate RAILS_ENV=production
cd $DIR
