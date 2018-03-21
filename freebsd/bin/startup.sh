#!/usr/local/bin/bash

i3-msg 'workspace main [1]; exec urxvt -e bash -c "nvim /data/other/TODO"'
sleep 0.5
i3-msg 'workspace main [1]; exec chrome "http://www.gmail.com"'
sleep 10
i3-msg 'workspace main [1]; exec urxvt'
sleep 0.5
i3-msg 'workspace main [1]; split v'
sleep 0.5
i3-msg 'workspace main [1]; exec urxvt'
sleep 0.5
i3-msg 'workspace main [1]; focus left;'
sleep 0.5
i3-msg 'workspace main [1]; resize grow width 18 px or 18 ppt;'
sleep 0.5
i3-msg 'workspace main [1]; focus left;'
sleep 0.5
i3-msg 'workspace main [1]; split v'
sleep 0.5
i3-msg 'workspace main [1]; exec urxvt'
sleep 0.5
i3-msg 'workspace cmd [2]; exec urxvt'
sleep 0.5
i3-msg 'workspace cmd [2]; exec urxvt'
sleep 0.5
i3-msg 'workspace cmd [2]; exec urxvt'
sleep 0.5
i3-msg 'workspace cmd [2]; split v'
sleep 0.5
i3-msg 'workspace cmd [2]; exec urxvt -e bash -c "top && bash"'
sleep 0.5
i3-msg 'workspace cmd [2]; focus left;'
sleep 0.5
i3-msg 'workspace cmd [2]; resize grow width 14 px or 14 ppt;'
sleep 0.5
i3-msg 'workspace cmd [2]; focus left;'
sleep 0.5
i3-msg 'workspace cmd [2]; split v'
sleep 0.5
i3-msg 'workspace cmd [2]; exec urxvt'
sleep 0.5
i3-msg 'workspace apps [3]; exec urxvt'
sleep 0.5
i3-msg 'workspace apps [3]; exec urxvt'
sleep 0.5
i3-msg 'workspace apps [3]; exec urxvt -e bash -c "rtorrent"'
sleep 0.5
i3-msg 'workspace apps [3]; split v'
sleep 0.5
i3-msg 'workspace apps [3]; exec urxvt -e bash -c "synergy-core --server -f -c ~/dotfiles/freebsd/bin/synergy.conf"'
sleep 0.5
i3-msg 'workspace apps [3]; focus left'
sleep 0.5
i3-msg 'workspace apps [3]; split v'
sleep 0.5
i3-msg 'workspace apps [3]; exec urxvt'
sleep 0.5
i3-msg 'workspace apps [3]; focus left'
sleep 0.5
i3-msg 'workspace apps [3]; split v'
sleep 0.5
i3-msg 'workspace apps [3]; exec urxvt'
sleep 0.5
i3-msg 'workspace books [4]; exec calibre'
sleep 5
i3-msg 'workspace cmd [2]'
sleep 0.5
i3-msg 'workspace main [1]'
