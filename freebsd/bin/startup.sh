#!/usr/local/bin/bash

i3-msg 'workspace "&#xf268; web"; exec urxvt'
sleep 0.5
i3-msg 'workspace "&#xf268; web"; exec urxvt'
sleep 0.5
i3-msg 'workspace "&#xf268; web"; exec chrome "https://mail.google.com/mail/u/0/#inbox" "https://mail.google.com/mail/u/1/#inbox" "https://vault.bitwarden.com/#/" "https://web.whatsapp.com/" "http://localhost:32400/web/index.html" "https://www.youtube.com/"'
sleep 10
i3-msg 'workspace "&#xf268; web"; resize grow width 20 px or 20 ppt;'
sleep 0.5
i3-msg 'workspace "&#xf268; web"; focus left;'
sleep 0.5
i3-msg 'workspace "&#xf268; web"; split v'
sleep 0.5
i3-msg 'workspace "&#xf268; web"; exec urxvt'
sleep 0.5
i3-msg 'workspace "&#xf268; web"; focus left;'
sleep 0.5
i3-msg 'workspace "&#xf268; web"; split v'
sleep 0.5
i3-msg 'workspace "&#xf268; web"; exec urxvt'
sleep 0.5
i3-msg 'workspace "&#xf02d; books"; exec urxvt'
sleep 0.5
i3-msg 'workspace "&#xf02d; books"; exec urxvt'
sleep 0.5
i3-msg 'workspace "&#xf02d; books"; exec calibre'
sleep 5
i3-msg 'workspace "&#xf02d; books"; resize grow width 20 px or 20 ppt;'
sleep 0.5
i3-msg 'workspace "&#xf02d; books"; focus left;'
sleep 0.5
i3-msg 'workspace "&#xf02d; books"; split v'
sleep 0.5
i3-msg 'workspace "&#xf02d; books"; exec urxvt'
sleep 0.5
i3-msg 'workspace "&#xf02d; books"; focus left;'
sleep 0.5
i3-msg 'workspace "&#xf02d; books"; split v'
sleep 0.5
i3-msg 'workspace "&#xf02d; books"; exec urxvt'
sleep 0.5

# i3-msg 'workspace "&#xf268; web"; exec urxvt -e bash -c "nvim /data/other/TODO"'
i3-msg 'workspace "&#xf1de; conf"; exec urxvt -e bash -c "nvim ~/.config/i3/config && bash"'
sleep 0.5
i3-msg 'workspace "&#xf1de; conf"; exec urxvt -e bash -c "nvim ~/.config/nvim/init.vim && bash"'
sleep 0.5
i3-msg 'workspace "&#xf1de; conf"; exec urxvt -e bash -c "top && bash"'
sleep 0.5
i3-msg 'workspace "&#xf1de; conf"; split v'
sleep 0.5
i3-msg 'workspace "&#xf1de; conf"; exec urxvt -e bash -c "synergy-core --server --no-daemon -c ~/dotfiles/freebsd/bin/synergy.conf && bash"'
sleep 0.5
i3-msg 'workspace "&#xf1de; conf"; focus left;'
sleep 0.5
i3-msg 'workspace "&#xf1de; conf"; split v'
sleep 0.5
i3-msg 'workspace "&#xf1de; conf"; exec urxvt -e bash -c "tail -f /var/log/messages && bash"'
sleep 0.5
i3-msg 'workspace "&#xf1de; conf"; focus left;'
sleep 0.5
i3-msg 'workspace "&#xf1de; conf"; split v'
sleep 0.5
i3-msg 'workspace "&#xf1de; conf"; exec urxvt'
sleep 0.5
# i3-msg 'workspace "&#xf1de; conf"; exec calibre'
# sleep 0.5
# i3-msg 'workspace "&#xf1de; conf"; focus left;'
# sleep 0.5
# i3-msg 'workspace "&#xf1de; conf"; split v'
# sleep 0.5
# i3-msg 'workspace "&#xf1de; conf"; exec urxvt'
# sleep 0.5
# i3-msg 'workspace "&#xf1de; conf"; focus left;'
# sleep 0.5
# i3-msg 'workspace "&#xf1de; conf"; split v'
# sleep 0.5
# i3-msg 'workspace "&#xf1de; conf"; exec urxvt'
# sleep 0.5
# i3-msg 'workspace main [1]; exec urxvt'
# sleep 0.5
# i3-msg 'workspace main [1]; split v'
# sleep 0.5
# i3-msg 'workspace main [1]; exec urxvt'
# sleep 0.5
# i3-msg 'workspace main [1]; focus left;'
# sleep 0.5
# i3-msg 'workspace main [1]; resize grow width 18 px or 18 ppt;'
# sleep 0.5
# i3-msg 'workspace main [1]; focus left;'
# sleep 0.5
# i3-msg 'workspace main [1]; split v'
# sleep 0.5
# i3-msg 'workspace main [1]; exec urxvt'
# sleep 0.5
# i3-msg 'workspace cmd [2]; exec urxvt'
# sleep 0.5
# i3-msg 'workspace cmd [2]; exec urxvt'
# sleep 0.5
# i3-msg 'workspace cmd [2]; exec urxvt'
# sleep 0.5
# i3-msg 'workspace cmd [2]; split v'
# sleep 0.5
# i3-msg 'workspace cmd [2]; exec urxvt'
# sleep 0.5
# i3-msg 'workspace cmd [2]; focus left;'
# sleep 0.5
# i3-msg 'workspace cmd [2]; resize grow width 14 px or 14 ppt;'
# sleep 0.5
# i3-msg 'workspace cmd [2]; focus left;'
# sleep 0.5
# i3-msg 'workspace cmd [2]; split v'
# sleep 0.5
# i3-msg 'workspace cmd [2]; exec urxvt'
# sleep 0.5
# i3-msg 'workspace apps [3]; exec urxvt -e bash -c "top && bash"'
# sleep 0.5
# i3-msg 'workspace apps [3]; exec urxvt'
# sleep 0.5
# i3-msg 'workspace apps [3]; exec urxvt -e bash -c "rtorrent"'
# sleep 0.5
# i3-msg 'workspace apps [3]; split v'
# sleep 0.5
# i3-msg 'workspace apps [3]; exec urxvt -e bash -c "synergy-core --server -f -c ~/dotfiles/freebsd/bin/synergy.conf"'
# sleep 0.5
# i3-msg 'workspace apps [3]; focus left'
# sleep 0.5
# i3-msg 'workspace apps [3]; split v'
# sleep 0.5
# i3-msg 'workspace apps [3]; exec urxvt'
# sleep 0.5
# i3-msg 'workspace apps [3]; focus left'
# sleep 0.5
# i3-msg 'workspace apps [3]; split v'
# sleep 0.5
# i3-msg 'workspace apps [3]; exec urxvt'
# sleep 0.5
# i3-msg 'workspace books [4]; exec calibre'
# sleep 5
# i3-msg 'workspace cmd [2]'
# sleep 0.5
# i3-msg 'workspace main [1]'
