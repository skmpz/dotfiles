#!/bin/bash

i3-msg 'workspace "  &#xf121;₁ "; exec urxvt'
sleep 0.5
i3-msg 'workspace "  &#xf121;₁ "; exec urxvt'
sleep 0.5
i3-msg 'workspace "  &#xf268;₂ "; exec chromium "https://mail.google.com/mail/u/0/#inbox" "https://mail.google.com/mail/u/1/#inbox" "https://vault.bitwarden.com/#/" "https://web.whatsapp.com/" "https://www.youtube.com/"'
sleep 5
i3-msg 'workspace "  &#xf0ae;₃ "; exec firefox'
sleep 5
i3-msg 'workspace "  &#xf1de;₄ "; exec cherrytree'
sleep 5
i3-msg 'workspace "  &#xf0ae;₅ "; exec burpsuite'
sleep 5
