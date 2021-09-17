#!/bin/bash
url=https://alert.smuth.me/api/v1/alerts
alerts="$(curl -s "$url" |& jq '.data[] | select(.status.state != "suppressed") | length' |& wc -l)"
if ((alerts>0)); then
  echo "$alerts" #e077 
else
  echo ""
fi
