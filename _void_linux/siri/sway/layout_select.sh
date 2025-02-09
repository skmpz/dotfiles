#!/bin/bash

# Get connected outputs
connected_outputs=$(swaymsg -t get_outputs | jq -r '.[] | select(.active == true) | .model')

# Define your monitor setup
if echo "$connected_outputs" | grep -q "U2720Q"; then
    # 1-screen setup
    swaymsg output HDMI-A-1 pos 4005 390
    swaymsg workspace 1 output HDMI-A-1
    swaymsg workspace 2 output HDMI-A-1
    swaymsg workspace 3 output HDMI-A-1
    swaymsg workspace 4 output HDMI-A-1
    swaymsg workspace 5 output eDP-2
else
    # 3-screen setup
    output DP-6 pos 3980 390
    output DP-7 pos 1820 0 transform 270
    output HDMI-A-1 pos 7820 0 transform 90
    workspace 1 output DP-7
    workspace 2 output HDMI-A-1
    workspace 3 output DP-6
    workspace 4 output DP-6
    workspace 9 output eDP-2
fi
