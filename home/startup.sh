#!/bin/bash

i3-msg 'workspace "  &#xf268;₂ "; exec urxvt'
sleep 0.5
i3-msg 'workspace "  &#xf268;₂ "; exec urxvt'
sleep 0.5
i3-msg 'workspace "  &#xf268;₂ "; exec chromium-browser "https://mail.google.com/mail/u/0/#inbox" "https://mail.google.com/mail/u/1/#inbox" "https://vault.bitwarden.com/#/" "https://web.whatsapp.com/" "http://localhost:32400/web/index.html" "https://www.youtube.com/"'
sleep 10
i3-msg 'workspace "  &#xf268;₂ "; resize grow width 20 px or 20 ppt;'
sleep 0.5
i3-msg 'workspace "  &#xf268;₂ "; focus left;'
sleep 0.5
i3-msg 'workspace "  &#xf268;₂ "; split v'
sleep 0.5
i3-msg 'workspace "  &#xf268;₂ "; exec urxvt'
sleep 0.5
i3-msg 'workspace "  &#xf268;₂ "; focus left;'
sleep 0.5
i3-msg 'workspace "  &#xf268;₂ "; split v'
sleep 0.5
i3-msg 'workspace "  &#xf268;₂ "; exec urxvt'
sleep 0.5

i3-msg 'workspace "  &#xf0ae;₃ "; exec urxvt'
sleep 0.5
i3-msg 'workspace "  &#xf0ae;₃ "; exec transmission-gtk'
sleep 5
i3-msg 'workspace "  &#xf0ae;₃ "; exec calibre'
sleep 5
i3-msg 'workspace "  &#xf0ae;₃ "; resize grow width 14 px or 14 ppt;'
sleep 0.5
i3-msg 'workspace "  &#xf0ae;₃ "; focus left;'
sleep 0.5
i3-msg 'workspace "  &#xf0ae;₃ "; resize grow width 4 px or 4 ppt;'
sleep 0.5
i3-msg 'workspace "  &#xf0ae;₃ "; split v'
sleep 0.5
i3-msg 'workspace "  &#xf0ae;₃ "; exec urxvt'
sleep 0.5
i3-msg 'workspace "  &#xf0ae;₃ "; focus left;'
sleep 0.5
i3-msg 'workspace "  &#xf0ae;₃ "; split v'
sleep 0.5
i3-msg 'workspace "  &#xf0ae;₃ "; exec urxvt'
sleep 0.5

i3-msg 'workspace "  &#xf121;₁ "; exec urxvt'
sleep 0.5
i3-msg 'workspace "  &#xf121;₁ "; exec urxvt'
sleep 0.5
i3-msg 'workspace "  &#xf121;₁ "; exec urxvt'
sleep 0.5
i3-msg 'workspace "  &#xf121;₁ "; split v'
sleep 0.5
i3-msg 'workspace "  &#xf121;₁ "; exec urxvt'
sleep 0.5
i3-msg 'workspace "  &#xf121;₁ "; focus left;'
sleep 0.5
i3-msg 'workspace "  &#xf121;₁ "; resize grow width 14 px or 14 ppt;'
sleep 0.5
i3-msg 'workspace "  &#xf121;₁ "; focus left;'
sleep 0.5
i3-msg 'workspace "  &#xf121;₁ "; split v'
sleep 0.5
i3-msg 'workspace "  &#xf121;₁ "; exec urxvt'
sleep 0.5

i3-msg 'workspace "  &#xf1de;₄ "; exec urxvt -e bash -c "nvim ~/.config/i3/config && bash"'
sleep 0.5
i3-msg 'workspace "  &#xf1de;₄ "; exec urxvt -e bash -c "nvim ~/.config/nvim/init.vim && bash"'
sleep 0.5
i3-msg 'workspace "  &#xf1de;₄ "; exec urxvt -e bash -c "top && bash"'
sleep 0.5
i3-msg 'workspace "  &#xf1de;₄ "; split v'
sleep 0.5
i3-msg 'workspace "  &#xf1de;₄ "; exec urxvt -e bash -c "synergys -f -c ~/dotfiles/bin/synergy.conf && bash"'
sleep 0.5
i3-msg 'workspace "  &#xf1de;₄ "; focus left;'
sleep 0.5
i3-msg 'workspace "  &#xf1de;₄ "; split v'
sleep 0.5
i3-msg 'workspace "  &#xf1de;₄ "; exec urxvt -e bash -c "sudo journalctl -f && bash"'
sleep 0.5
i3-msg 'workspace "  &#xf1de;₄ "; focus left;'
sleep 0.5
i3-msg 'workspace "  &#xf1de;₄ "; split v'
sleep 0.5
i3-msg 'workspace "  &#xf1de;₄ "; exec urxvt -e bash -c "nvim ~/dotfiles/freebsd/bin/startup.sh && bash"'
sleep 0.5
i3-msg 'workspace "  &#xf268;₂ "'
sleep 0.5
i3-msg 'workspace "  &#xf121;₁ "'
