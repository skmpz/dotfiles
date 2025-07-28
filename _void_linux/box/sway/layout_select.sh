#!/bin/bash

monitor_count=$(swaymsg -t get_outputs -p | grep Output | wc -l)

if [ $monitor_count == "2" ]; then
    # 1-screen setup
    middle_display=$(swaymsg -t get_outputs -p | grep Output | grep -v eDP | cut -f2 -d' ')
    laptop_display=$(swaymsg -t get_outputs -p | grep Output | grep eDP | cut -f2 -d' ')
    swaymsg output ${laptop_display} pos 4952 2550
    swaymsg output ${middle_display} pos 4005 390
    swaymsg workspace 1 output ${middle_display}
    swaymsg workspace 2 output ${middle_display}
    swaymsg workspace 3 output ${middle_display}
    swaymsg workspace 4 output ${middle_display}
    swaymsg workspace 5 output ${middle_display}
    swaymsg workspace 9 output ${laptop_display}
else
    # 3-screen setup
    middle_display=$(swaymsg -t get_outputs -p | grep 3CKKXN3 | cut -f2 -d' ')
    left_display=$(swaymsg -t get_outputs -p | grep FN84K9A40G2L | cut -f2 -d' ')
    right_display=$(swaymsg -t get_outputs -p | grep FN84K993041L | cut -f2 -d' ')
    swaymsg output ${middle_display} pos 3840 810
    swaymsg output ${left_display} pos 1680 0 transform 270
    swaymsg output ${right_display} pos 7680 0 transform 270
    swaymsg workspace 1 output ${left_display}
    swaymsg workspace 2 output ${right_display}
    swaymsg workspace 8 output ${right_display}
    swaymsg workspace 3 output ${middle_display}
    swaymsg workspace 4 output ${middle_display}
fi
