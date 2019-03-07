#!/bin/bash

i3-msg 'workspace "  &#xf121;₁ "; exec urxvt'
sleep 0.5
i3-msg 'workspace "  &#xf121;₁ "; exec chromium-browser'
sleep 6
i3-msg 'workspace "  &#xf121;₁ "; resize grow width 14 px or 14 ppt;'
sleep 0.5
i3-msg 'workspace "  &#xf121;₁ "; focus left;'
i3-msg 'workspace "  &#xf121;₁ "; split v'
sleep 0.5
i3-msg 'workspace "  &#xf121;₁ "; exec urxvt'
sleep 0.5

i3-msg 'workspace "  &#xf268;₂ "; exec urxvt'
sleep 0.5
i3-msg 'workspace "  &#xf268;₂ "; exec urxvt'
sleep 0.5

i3-msg 'workspace "  &#xf0ae;₃ "; exec urxvt'
sleep 0.5
i3-msg 'workspace "  &#xf0ae;₃ "; exec urxvt'
sleep 0.5
i3-msg 'workspace "  &#xf0ae;₃ "; split v'
sleep 0.5
i3-msg 'workspace "  &#xf0ae;₃ "; exec urxvt'
sleep 0.5

i3-msg 'workspace "  &#xf1de;₄ "; exec cherrytree /home/sk/work/notes/notes_work.ctx'
sleep 6
i3-msg 'workspace "  &#xf121;₁ "'
