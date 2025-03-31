#!/bin/bash

# Get connected outputs
connected_outputs=$(swaymsg -t get_outputs | jq -r '.[] | select(.active == true) | .model')

# Define your monitor setup
if echo "$connected_outputs" | grep -q "U2720Q"; then
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
    swaymsg output eDP-1 pos 4823 4436
    swaymsg output DP-4 pos 3840 2276
    swaymsg output DP-2 pos 1680 1976 transform 270
    swaymsg output HDMI-A-1 pos 7680 1958 transform 90
    swaymsg workspace 1 output DP-2
    swaymsg workspace 2 output HDMI-A-1
    swaymsg workspace 3 output DP-4
    swaymsg workspace 4 output DP-4
    swaymsg workspace 9 output eDP-1
fi
