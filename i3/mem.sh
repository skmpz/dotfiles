#!/bin/bash

TOTAL=$(free -mh | tail -2 | head -1 | awk -F' ' '{print $2}')
TOTAL_NUM=$(echo ${TOTAL%?})
USED=$(free -mh | tail -2 | head -1 | awk -F' ' '{print $3}')
USED_NUM=$(echo ${USED%?})
BUFFERS=$(free -mh | tail -2 | head -1 | awk -F' ' '{print $6}')
BUFFERS_NUM=$(echo ${BUFFERS%?} | cut -f1 -d'.')
PERC=$(echo $((100*$USED_NUM/$TOTAL_NUM)))
echo $((USED_NUM+BUFFERS_NUM))G/${TOTAL_NUM}G [$PERC%]

