#!/usr/local/bin/bash

TARGET=$(ssh kali cat TARGET)
echo $TARGET

i3-msg "workspace $TARGET"
sleep 1
i3-msg 'exec urxvt -e bash -c "ssh kali && bash"'
sleep 1
i3-msg "exec xdotool type \"mkdir /mnt/notes/$TARGET\" && xdotool key Return"
sleep 1
i3-msg "exec xdotool type \"nmap $TARGET -Pn -sV -T5 -O -A -p- | tee /mnt/notes/$TARGET/nmap.txt\" && xdotool key Return"
sleep 1
i3-msg "split h"
sleep 1
i3-msg "exec urxvt -e bash -c \"ssh kali && bash\""
sleep 1
i3-msg "exec xdotool type \"nikto -h http\""
sleep 1
i3-msg "exec xdotool key colon"
sleep 1
i3-msg "exec xdotool key BackSpace"
sleep 1
i3-msg "exec xdotool type \"//$TARGET | tee /mnt/notes/$TARGET/nikto.txt\" && xdotool key Return"
sleep 1
i3-msg "exec urxvt -e bash -c \"ssh kali && bash\""
sleep 1
i3-msg "exec xdotool type \"gobuster -u http\""
sleep 1
i3-msg "exec xdotool key colon"
sleep 1
i3-msg "exec xdotool key BackSpace"
sleep 1
i3-msg "exec xdotool type \"//$TARGET -w /root/mine/dir.txt -f -l -t 20 | tee /mnt/notes/$TARGET/gobuster.txt\" && xdotool key Return"
sleep 1
i3-msg 'split v'
sleep 1
i3-msg 'exec urxvt -e bash -c "ssh kali && bash"'
sleep 1
i3-msg "exec xdotool type \"enum4linux $TARGET | tee /mnt/notes/$TARGET/enum4linux.txt\" && xdotool key Return"
sleep 1
i3-msg 'focus left'
sleep 1
i3-msg 'split v'
sleep 1
i3-msg 'exec urxvt -e bash -c "ssh kali && bash"'
sleep 1
i3-msg "exec xdotool type \"sslscan $TARGET | tee /mnt/notes/$TARGET/sslscan.txt\" && xdotool key Return"
sleep 1
i3-msg 'focus left'
sleep 1
i3-msg 'split v'
sleep 1
i3-msg 'exec urxvt -e bash -c "ssh kali && bash"'
sleep 1
i3-msg "exec xdotool type \"rpcinfo $TARGET | tee /mnt/notes/$TARGET/rpcinfo.txt\" && xdotool key Return"
