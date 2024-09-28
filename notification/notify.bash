#!/bin/bash

send_notification() {
     zenity --notification --title="Success" --text="$1"
}

target=https://materai.id/
target_notify="https://api.callmebot.com/whatsapp.php?phone=6285722382371&apikey=6771611&text=is up. Status code"
retries=3
while [ $retries -gt 0 ]; do
     echo "Checking if $target is up..."
    status_code=$(curl -s -o /dev/null -w "%{http_code}" $target)
    if [ $status_code -ne 200 ]; then
        msg="Error: $target is down. Status code: $status_code"
        echo $msg
        retries=$((retries - 1))
        send_notification "$msg"
        if [ $retries -eq 0 ]; then
          exit 1
        fi
        continue
    fi
    msg="$target is up. Status code: $status_code"
    echo $msg
    send_notification "$msg"
    retries=$((retries - 1))
    if [ $retries -eq 0 ]; then
        exit 1
    fi
    continue
done