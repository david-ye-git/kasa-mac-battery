#!/bin/zsh

host=$1

while true
do
    upperChargeLimit=90
    lowerChargeLimit=50
    batteryInfo=$(pmset -g batt | grep -Eo "\d+%")
    batteryPercentage=${batteryInfo%['\%']}
    statuses=$(pmset -g batt | grep -Eo ";.*;" | cut -d';' -f 2 | tr -d '[:blank:]')
    charging="charging"
    discharging="discharging"
    finishingCharge="finishingcharge"
    time=$(date)
    echo "==================================================================="
    echo "$time - Battery: $batteryPercentage% - Status: $statuses"

    if [[ $batteryPercentage -le $lowerChargeLimit && "$statuses" == "$discharging" ]]
    then
        echo "Battery is less than or equal to $lowerChargeLimit% and not charging"
        kasa --host "$host" on
    elif [[ $batteryPercentage -ge $upperChargeLimit && "$statuses" == "$charging" ]]
    then
        echo "Battery is greater than or equal to $upperChargeLimit% and is charging"
        kasa --host "$host" off
    elif [[ "$statuses" == "$finishingCharge" ]]
    then
        echo "Battery is at 100% and is finished charging"
        kasa --host "$host" off
    fi
    echo "Polling again in 10 minutes on host $host"
    sleep 600
done