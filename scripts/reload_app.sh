#!/bin/bash

echo "reloading app as $(whoami)"
echo "current directory: $(pwd)"

file="/opt/codedeploy-agent/passenger.80.pid"
if [ -f "$file" ]
then
  passenger stop -p80
else
  echo "$file not found."
fi

passenger start /var/apps/mymoney

#Slack Notification
curl -X POST --data-urlencode 'payload={"text": "Deployment '${DEPLOYMENT_ID}' of '${APPLICATION_NAME}' on '${DEPLOYMENT_GROUP_NAME}' has completed"}' https://hooks.slack.com/services/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
