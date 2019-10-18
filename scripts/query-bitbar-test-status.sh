#!/usr/bin/env bash

testRunId=$1
state=""
finishedState="FINISHED"
totalDeviceCount="1"
successfulTestCaseCount="0"

while [ "$state" != "$finishedState" ]
do
  sleep 30;
  echo "Awaiting test results..."
  result=$(curl -u "$BITBAR_API_KEY": https://cloud.bitbar.com/api/me/projects/${BITBAR_PROJECT_ID}/runs/${testRunId} | jq -r)

  state=$(echo $result | jq -r '.state')
  totalDeviceCount=$(echo $result | jq -r '.totalDeviceCount')
  successfulTestCaseCount=$(echo $result | jq -r '.successfulTestCaseCount')

  echo "Current state: $state"

  if [ "$state" = "$finishedState" ] && [ "$successfulTestCaseCount" != "$totalDeviceCount" ]
    then
      echo "Tests have failed, aborting..."
      exit 1;
  fi

done

echo "Tests have passed..."
