#!/bin/bash

monitor_count=$(swaymsg -t get_outputs -p | grep Output | wc -l)

if [ $monitor_count == "2" ]; then
    # 1-screen setup (home)
    middle_display=$(swaymsg -t get_outputs -p | grep Output | grep -v eDP | cut -f2 -d' ')
    laptop_display="eDP-1"
    swaymsg output ${laptop_display} pos 4920 2950
    swaymsg output ${middle_display} pos 4920 1870 mode 1920x1080@60Hz
    swaymsg workspace 1 output ${middle_display}
    swaymsg workspace 2 output ${middle_display}
    swaymsg workspace 3 output ${middle_display}
    swaymsg workspace 4 output ${middle_display}
    swaymsg workspace 5 output ${middle_display}
    swaymsg workspace 9 output ${laptop_display}
fi
