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
