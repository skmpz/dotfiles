#!/bin/bash

# workspace 1
i3-msg 'workspace 1; exec walc'
sleep 5
i3-msg 'workspace 1; exec chromium'
sleep 5
i3-msg 'workspace 1; focus left'
sleep 2
i3-msg 'workspace 1; split v'
sleep 2
i3-msg 'workspace 1; exec boostnote'
sleep 2
i3-msg 'workspace 1; focus right'
sleep 2
i3-msg 'workspace 1; resize grow width 10 px or 10 ppt;'
sleep 2

# workspace 3
# i3-msg 'workspace 3; exec hexchat'
# sleep 5

# workspace 3
i3-msg 'workspace 2; exec urxvt'
sleep 0.5
i3-msg 'workspace 2; exec urxvt'
sleep 0.5
