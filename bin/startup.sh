#!/bin/bash

i3-msg 'workspace "  &#xf268;  "; exec urxvt'
sleep 0.5
i3-msg 'workspace "  &#xf268;  "; exec urxvt'
sleep 0.5
i3-msg 'workspace "  &#xf268;  "; exec chromium "https://mail.google.com/mail/u/0/#inbox" "https://mail.google.com/mail/u/1/#inbox" "https://vault.bitwarden.com/#/" "https://web.whatsapp.com/" "http://localhost:32400/web/index.html" "https://www.youtube.com/"'
sleep 10
i3-msg 'workspace "  &#xf268;  "; resize grow width 20 px or 20 ppt;'
sleep 0.5
i3-msg 'workspace "  &#xf268;  "; focus left;'
sleep 0.5
i3-msg 'workspace "  &#xf268;  "; split v'
sleep 0.5
i3-msg 'workspace "  &#xf268;  "; exec urxvt'
sleep 0.5
i3-msg 'workspace "  &#xf268;  "; focus left;'
sleep 0.5
i3-msg 'workspace "  &#xf268;  "; split v'
sleep 0.5
i3-msg 'workspace "  &#xf268;  "; exec urxvt'
sleep 0.5

i3-msg 'workspace "  &#xf02d;  "; exec urxvt'
sleep 0.5
i3-msg 'workspace "  &#xf02d;  "; exec transmission-gtk'
sleep 5
i3-msg 'workspace "  &#xf02d;  "; exec calibre'
sleep 5
i3-msg 'workspace "  &#xf02d;  "; resize grow width 14 px or 14 ppt;'
sleep 0.5
i3-msg 'workspace "  &#xf02d;  "; focus left;'
sleep 0.5
i3-msg 'workspace "  &#xf02d;  "; resize grow width 4 px or 4 ppt;'
sleep 0.5
i3-msg 'workspace "  &#xf02d;  "; split v'
sleep 0.5
i3-msg 'workspace "  &#xf02d;  "; exec urxvt'
sleep 0.5
i3-msg 'workspace "  &#xf02d;  "; focus left;'
sleep 0.5
i3-msg 'workspace "  &#xf02d;  "; split v'
sleep 0.5
i3-msg 'workspace "  &#xf02d;  "; exec urxvt'
sleep 0.5

i3-msg 'workspace "  &#xf120;  "; exec urxvt'
sleep 0.5
i3-msg 'workspace "  &#xf120;  "; exec urxvt'
sleep 0.5
i3-msg 'workspace "  &#xf120;  "; exec urxvt'
sleep 0.5
i3-msg 'workspace "  &#xf120;  "; split v'
sleep 0.5
i3-msg 'workspace "  &#xf120;  "; exec urxvt'
sleep 0.5
i3-msg 'workspace "  &#xf120;  "; focus left;'
sleep 0.5
i3-msg 'workspace "  &#xf120;  "; resize grow width 14 px or 14 ppt;'
sleep 0.5
i3-msg 'workspace "  &#xf120;  "; focus left;'
sleep 0.5
i3-msg 'workspace "  &#xf120;  "; split v'
sleep 0.5
i3-msg 'workspace "  &#xf120;  "; exec urxvt'
sleep 0.5

i3-msg 'workspace "  &#xf1de;  "; exec urxvt -e bash -c "nvim ~/.config/i3/config && bash"'
sleep 0.5
i3-msg 'workspace "  &#xf1de;  "; exec urxvt -e bash -c "nvim ~/.config/nvim/init.vim && bash"'
sleep 0.5
i3-msg 'workspace "  &#xf1de;  "; exec urxvt -e bash -c "top && bash"'
sleep 0.5
i3-msg 'workspace "  &#xf1de;  "; split v'
sleep 0.5
i3-msg 'workspace "  &#xf1de;  "; exec urxvt -e bash -c "synergys -f -c ~/dotfiles/bin/synergy.conf && bash"'
sleep 0.5
i3-msg 'workspace "  &#xf1de;  "; focus left;'
sleep 0.5
i3-msg 'workspace "  &#xf1de;  "; split v'
sleep 0.5
i3-msg 'workspace "  &#xf1de;  "; exec urxvt -e bash -c "sudo journalctl -f && bash"'
sleep 0.5
i3-msg 'workspace "  &#xf1de;  "; focus left;'
sleep 0.5
i3-msg 'workspace "  &#xf1de;  "; split v'
sleep 0.5
i3-msg 'workspace "  &#xf1de;  "; exec urxvt -e bash -c "nvim ~/dotfiles/freebsd/bin/startup.sh && bash"'
sleep 0.5
i3-msg 'workspace "  &#xf268;  "'
sleep 0.5
i3-msg 'workspace "  &#xf120;  "'
