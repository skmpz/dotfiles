#!/bin/bash

# workspace 1
i3-msg 'workspace 1; exec urxvt'
sleep 0.5
i3-msg 'workspace 1; exec urxvt'
sleep 0.5

# workspace 2
i3-msg 'workspace 2; exec chromium'
sleep 5

# workspace 3
i3-msg 'workspace 3; exec hexchat'
sleep 0.5
