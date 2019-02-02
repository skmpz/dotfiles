#!/bin/sh

/usr/bin/i3status | while :
do
    # read line
    # Put uptime
    uptime=`uptime | awk '{print $3 " " $4}' | sed 's/,.*//'`

    VERSION=$(uname -r)

    MUTE=$(pactl list sinks | grep -A8 'Sink #1' | grep Mute | awk '{print $2}')
    if [ "$MUTE" == "no" ]; then
	VOL=$(pactl list sinks | grep Volume | grep -v Base | tail -1 | awk '{print $5}')
    else
        VOL="MUTE"
    fi
    DATE=$(date +'%A %d/%m/%Y')
    TIME=$(date +'%H:%M')
    LOAD=$(uptime | awk '{print $(NF-2)}' | tr -d ',')
    H_USED=$(df -h / | tail -1 | awk '{print $3}')
    H_TOTAL=$(df -h /home/ | tail -1 | awk '{print $2}')
    H_PERC=$(df -h /home/ | tail -1 | awk '{print $5}')
    D_USED=$(df -h /data/ | tail -1 | awk '{print $3}')
    D_TOTAL=$(df -h /data/ | tail -1 | awk '{print $2}')
    D_PERC=$(df -h /data/ | tail -1 | awk '{print $5}')
    MEM_USED=$(free -mh | grep Mem | awk '{print $3}')
    MEM_TOTAL=$(free -mh | grep Mem | awk '{print $2}')
    IP=$(ip a | grep -A3 enp6s0 | grep -w inet | awk '{print $2}' | cut -f1 -d'/')
    full=" $VERSION |  $H_USED/$H_TOTAL [$H_PERC] |  $D_USED/$D_TOTAL [$D_PERC] |  $MEM_USED/$MEM_TOTAL |  $IP |  $uptime |  $LOAD |  $VOL |  $DATE |  $TIME ";
    echo "$full"
    sleep 1
done
