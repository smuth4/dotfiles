#!/bin/bash
url=https://alerta.smuth.me/api/alerts/count
alerts="$(curl -s "$url" |& jq '.statusCounts.open')"
if ((alerts>0)); then
  echo "$alerts" #e077 
elif [[ $alerts == "null" && "$(curl -s "$url" |& jq -r '.status')" == "ok" ]]; then
  echo ""
else
  echo "ERR"
fi
