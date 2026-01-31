#!/bin/bash

monitor_count=$(swaymsg -t get_outputs -p | grep Output | wc -l)

if [ $monitor_count == "1" ]; then
    laptop_display=$(swaymsg -t get_outputs -p | grep Output | grep eDP | cut -f2 -d' ')
    swaymsg output ${laptop_display} scale 1
elif [ $monitor_count == "2" ]; then
    # 1-screen setup
    middle_display=$(swaymsg -t get_outputs -p | grep Output | grep -v eDP | cut -f2 -d' ')
    laptop_display=$(swaymsg -t get_outputs -p | grep Output | grep eDP | cut -f2 -d' ')
    swaymsg output ${laptop_display} pos 4950 2550 scale 1
    swaymsg output ${middle_display} pos 5280 1470
    swaymsg workspace 1 output ${middle_display}
    swaymsg workspace 2 output ${middle_display}
    swaymsg workspace 3 output ${middle_display}
    swaymsg workspace 4 output ${middle_display}
    swaymsg workspace 5 output ${middle_display}
    swaymsg workspace 9 output ${laptop_display}
else
    # 3-screen setup
    middle_display=$(swaymsg -t get_outputs -p | grep 6PB0P44 | cut -f2 -d' ')
    left_display=$(swaymsg -t get_outputs -p | grep DP9Q9V3 | cut -f2 -d' ')
    right_display=$(swaymsg -t get_outputs -p | grep DP9P9V3 | cut -f2 -d' ')
    laptop_display=$(swaymsg -t get_outputs -p | grep Output | grep eDP | cut -f2 -d' ')
    swaymsg output ${laptop_display} pos 4477 4436
    swaymsg output ${middle_display} pos 3840 2276
    swaymsg output ${left_display} pos 1680 1976 transform 270
    swaymsg output ${right_display} pos 7680 1958 transform 90
    swaymsg workspace 1 output ${left_display}
    swaymsg workspace 2 output ${right_display}
    swaymsg workspace 3 output ${middle_display}
    swaymsg workspace 4 output ${middle_display}
    swaymsg workspace 9 output ${laptop_display}
fi
