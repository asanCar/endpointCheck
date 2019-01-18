#!/usr/bin/env bash

## Prevent duplicate executions
PIDFILE=/var/log/check.pid
if [ -f "$PIDFILE" ]; then
  PID=$(cat "$PIDFILE")
  ps -p $PID > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    ## Process already running
    exit 1
  else
    ## Process not found assume not running
    echo $$ > "$PIDFILE"
    if [ $? -ne 0 ]; then
    ## Could not create PID file
      exit 1
    fi
  fi
else
  echo $$ > "$PIDFILE"
  if [ $? -ne 0 ]; then
    ## Could not create PID file
    exit 1
  fi
fi

## Endpoint URL to check
url="<url>"

## Slack app webhook
slackUrl="<slackUrl>"

status=$(curl -LI $url -o /dev/null -w '%{http_code}\n' -s)
if [[ "$status" != "200" ]]; then
    slackMessage='{
       "attachments":[
          {
             "title":"Status Check Failed!",
             "text":"Go to log: <https://url.com|Here>",
             "fields":[
                {
                   "title":"HTTP Code",
                   "value":'"$status"'
                }
             ],
             "ts":'"$(date +%s)"',
             "color":"danger"
          }
       ]
    }'

    ## Send crash alert to Slack chat
    curl -X POST -H 'Content-type: application/json' --data "$slackMessage" "$slackUrl"

    while [ "$status" != "200" ]; do
        ## Checks every minute for app recovery
        sleep 60
        status=$(curl -LI $url -o /dev/null -w '%{http_code}\n' -s)
    done

    slackMessage='{
       "attachments":[
          {
             "title":"App is up again!",
             "ts":'"$(date +%s)"',
             "color":"good"
          }
       ]
    }'

    ## Send app recovery alert to Slack chat
    curl -X POST -H 'Content-type: application/json' --data "$slackMessage" "$slackUrl"
fi

## Remove lock file
rm "$PIDFILE"