#!/bin/bash

monitor_count=$(swaymsg -t get_outputs -p | grep Output | wc -l)

if [ $monitor_count == "2" ]; then
    # 1-screen setup
    swaymsg output eDP-1 pos 4952 2550
    swaymsg output HDMI-A-1 pos 4005 390
    swaymsg workspace 1 output HDMI-A-1
    swaymsg workspace 2 output HDMI-A-1
    swaymsg workspace 3 output HDMI-A-1
    swaymsg workspace 4 output HDMI-A-1
    swaymsg workspace 5 output HDMI-A-1
    swaymsg workspace 9 output eDP-1
else
    # 3-screen setup
    middle_display=$(swaymsg -t get_outputs -p | grep 6PB0P44 | cut -f2 -d' ')
    left_display=$(swaymsg -t get_outputs -p | grep DP9Q9V3 | cut -f2 -d' ')
    right_display="HDMI-A-1"
    laptop_display="eDP-1"
    swaymsg output ${laptop_display} pos 4823 4436
    swaymsg output ${middle_display} pos 3840 2276
    swaymsg output ${left_display} pos 1680 1976 transform 270
    swaymsg output ${right_display} pos 7680 1958 transform 90
    swaymsg workspace 1 output ${left_display}
    swaymsg workspace 2 output ${right_display}
    swaymsg workspace 3 output ${middle_display}
    swaymsg workspace 4 output ${middle_display}
    swaymsg workspace 9 output ${laptop_display}
fi
