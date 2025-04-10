#!/bin/bash

# Get connected outputs
connected_outputs=$(swaymsg -t get_outputs | jq -r '.[] | select(.active == true) | .model')

# Define your monitor setup
if echo "$connected_outputs" | grep -q "U2720Q"; then
    # 1-screen setup
    swaymsg output eDP-1 pos 4920 2950
    swaymsg output DP-1 pos 4920 1870 mode 1920x1080@60Hz
    swaymsg workspace 1 output HDMI-A-1
    swaymsg workspace 2 output HDMI-A-1
    swaymsg workspace 3 output HDMI-A-1
    swaymsg workspace 4 output HDMI-A-1
    swaymsg workspace 5 output HDMI-A-1
    swaymsg workspace 9 output eDP-1
fi
