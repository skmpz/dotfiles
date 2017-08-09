#!/bin/bash

USED=`df -h -P -l "$1" | tail -1 | awk '{print $3}'`
SIZE=`df -h -P -l "$1" | tail -1 | awk '{print $2}'`
PERC=`df -h -P -l "$1" | tail -1 | awk '{print $5}'`
echo "$USED/$SIZE [$PERC]"
