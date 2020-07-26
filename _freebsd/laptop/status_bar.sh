#!/bin/sh

/usr/bin/i3status | while :
do
    # read line
    # Put uptime
    uptime=`uptime | awk '{print $3 " " $4}' | sed 's/,.*//'`

    VERSION=" FreeBSD $(uname -r)"

    MUTE=$(pactl list sinks | grep -A8 'Sink #0' | grep Mute | awk '{print $2}')
    if [ "$MUTE" != "yes" ]; then
        VOL_PERC=$(pactl list sinks | grep Volume | grep -v Base | tail -1 | awk '{print $5}')
        VOL_NUM=$(echo $VOL_PERC | tr -d '%')
        if [ "$VOL_NUM" -ge 0 ] && [ "$VOL_NUM" -lt 10 ]; then
            VOL=" $VOL_PERC"
        elif [ "$VOL_NUM" -ge 5 ] && [ "$VOL_NUM" -lt 55 ]; then
            VOL=" $VOL_PERC"
        else
            VOL=" $VOL_PERC"
        fi
    else
        VOL=" MUTE"
    fi
    DATE=$(date +'%A %d/%m/%Y')
    TIME=$(date +'%H:%M')
    LOAD=$(uptime | awk '{print $(NF-2)}' | tr -d ',')
    H_USED=$(df -h / | tail -1 | awk '{print $3}')
    H_TOTAL=$(df -h /home/ | tail -1 | awk '{print $2}')
    H_PERC=$(df -h /home/ | tail -1 | awk '{print $5}')
    MEM_USED=$(freecolor -m -o | grep Mem | awk '{print $3}')
    MEM_TOTAL=$(freecolor -m -o | grep Mem | awk '{print $2}')
    IP_GET=$(ifconfig | grep -A8 wlan0 | grep inet | grep -v inet6 | awk '{print $2}')
    if [ -z "$IP_GET"]; then
        IP="N/A"
    else
        SSID=$(ifconfig | grep -A8 wlan0 | grep ssid | awk '{print $2}')
        IP="$IP_GET [$SSID]"
    fi

    BATTERY_PERC=$(apm | grep -A4 "Battery 0" | grep life | awk '{print $NF}')
    BATTERY_STATE=$(apm | grep -A4 "Battery 0" | grep Status | awk '{print $NF}')
    BATTERY_NUM=$(echo $BATTERY_PERC | tr -d '%')
    if [ "$BATTERY_NUM" -ge 0 ] && [ "$BATTERY_NUM" -lt 5 ]; then
        BATTERY=" $BATTERY_PERC"
    elif [ "$BATTERY_NUM" -ge 5 ] && [ "$BATTERY_NUM" -lt 30 ]; then
        BATTERY=" $BATTERY_PERC"
    elif [ "$BATTERY_NUM" -ge 30 ] && [ "$BATTERY_NUM" -lt 60 ]; then
        BATTERY=" $BATTERY_PERC"
    elif [ "$BATTERY_NUM" -ge 60 ] && [ "$BATTERY_NUM" -lt 85 ]; then
        BATTERY=" $BATTERY_PERC"
    else
        BATTERY=" $BATTERY_PERC"
    fi
    if [ "$BATTERY_STATE" == "charging" ]; then
        BATTERY="$BATTERY []"
    fi
    full="$VERSION |  $H_USED/$H_TOTAL [$H_PERC] |  $MEM_USED/$MEM_TOTAL |  $IP |  $uptime |  $LOAD | $VOL | $BATTERY |  $DATE |  $TIME ";
    echo "$full"
    sleep 1
done
