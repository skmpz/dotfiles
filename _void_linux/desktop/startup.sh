#!/bin/bash

# workspace 1
i3-msg 'workspace 1; exec walc'
sleep 3
i3-msg 'workspace 1; exec google-chrome-stable'
sleep 3
i3-msg 'workspace 1; focus left'
sleep 1
i3-msg 'workspace 1; split v'
sleep 1
i3-msg 'workspace 1; exec urxvt'
sleep 1
i3-msg 'workspace 1; focus right'
sleep 1
i3-msg 'workspace 1; resize grow width 10 px or 10 ppt;'
sleep 1

# workspace 2
i3-msg 'workspace 2; exec firefox'
sleep 3
i3-msg 'workspace 2; exec boostnote'
sleep 3

# workspace 5
i3-msg 'workspace 5; exec hexchat'
sleep 3

# workspace 6
i3-msg 'workspace 6; exec teams-for-linux'
sleep 3

# workspace 3
i3-msg 'workspace 3; exec urxvt'
sleep 1
i3-msg 'workspace 3; exec urxvt'
sleep 1

# workspace 4
i3-msg 'workspace 4; exec urxvt'
sleep 1
i3-msg 'workspace 4; exec urxvt'
sleep 1

# set current to main
i3-msg 'workspace 1'
i3-msg 'workspace 3'
