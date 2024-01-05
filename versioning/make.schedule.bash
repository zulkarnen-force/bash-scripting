#!/bin/bash
FILE=./log.txt
PLUS_DATE=$(date +%Y-%m-%d -d "+5 days")
CURRENT_DATE=$(date '+%Y-%m-%d')
DEV_URL="http://103.19.182.20/api-superapps/prayers/schedule"
LATEST_DATE=$(cat log.txt)
LATEST_DATE_PLUS=$(date  +%Y-%m-%d -d ''$LATEST_DATE' +5 days')
FIRST_DATE=$(echo $CURRENT_DATE | awk -F- '{$NF = "01"} 1' OFS=-)

make_request() {
    timestamp="$(date +%Y-%m-%d-%T)"
    response=$(curl -sS --location $DEV_URL \
    --header 'Accept: application/json' \
    --form 'startDate='$1'' \
    --form 'endDate='$2'')
    echo "$timestamp: $response" >> logs.txt
    echo "$timestamp: Make request generate jadwal shalats with date from $1 to $2" >> logs.txt
    echo "$2" > log.txt
}

if test -f "$FILE"; then
    make_request $LATEST_DATE $LATEST_DATE_PLUS
else 
    echo "make initial jadwal sholats"
    make_request $FIRST_DATE $PLUS_DATE
fi