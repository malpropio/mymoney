#!/bin/bash
file="/opt/codedeploy-agent/passenger.80.pid"
if [ -f "$file" ]
then
  rvmsudo passenger stop -p80
else
  echo "$file not found."
fi
