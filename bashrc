#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

check() {
    if [ $1 -ne 0 ]; then
        echo -e "[\e[31mFAIL\e[0m]"
        exit
    fi
}

check_ok() {
    if [ $1 -eq 0 ]; then
        echo -e "[\e[32mOK\e[0m]"
    else
        echo -en "[\e[31mFAIL\e[0m]"
        # exit
    fi
}

function si {
    FILE=$(ls -lt /data/downloads/deco* | head -1 | awk '{print $9}')
    echo -en "[-] \e[94mClearing old installers..........\e[0m "
    ssh vm 'rm -rf /root/Downloads/dec*' > /dev/null 2>&1
    check $?
    ssh vm 'rm -rf /root/Downloads/inst*' > /dev/null 2>&1
    check $?
    echo -e "[\e[32mOK\e[0m]"
    echo -en "[-] \e[94mCopying new installer............\e[0m "
    scp $FILE vm:/root/Downloads/ > /dev/null 2>&1
    check $?
    echo -e "[\e[32mOK\e[0m]"
    echo -en "[-] \e[94mExtracting new installer.........\e[0m "
    ssh vm 'tar xf /root/Downloads/dec* -C /root/Downloads/' > /dev/null 2>&1
    check $?
    echo -e "[\e[32mOK\e[0m]"
    echo -e "[-] \e[94mINSTALLING.......................\e[0m "
    ssh vm 'cd /root/Downloads/insta* && ./install.sh && /root/after_install.sh'
}

function cpusb {
    echo -en "[-] \e[94mMounting USB.................\e[0m "
    sudo mount /dev/sdc1 /mnt > /dev/null 2>&1
    check_ok $?

    echo -en "[-] \e[94mClean old client.............\e[0m "
    sudo rm -rf /mnt/WI_BE_Client/
    check_ok $?

    echo -en "[-] \e[94mCopying new client...........\e[0m "
    sudo cp -r $HOME/src/WI_BE_Client/ /mnt/ > /dev/null 2>&1
    echo -e "[\e[32mOK\e[0m]"

    echo -en "[-] \e[94mUnmounting USB...............\e[0m "
    sudo umount /mnt/ > /dev/null 2>&1
    check_ok $?
}

alias nvs='nvim -S ~/.sess'
alias ls='ls --color=auto'
alias ll='ls --color=auto -alh'
alias hh='hashcat --help | grep -i'
alias hashcat='rm -rf ~/.hashcat/hashcat.pot;hashcat'
alias a='cd /home/sk/src/aircrack/'
alias c='cd /home/sk/src/WI_BE_Client/'
alias d='cd /data/downloads/'
alias e='cd /home/sk/src/WIFI_BE/'
alias h='cd /home/sk/src/hostapd/'
alias p='cd /home/sk/src/sproxy/'
alias x='cd /home/sk/src/WIFI_Client/'
alias v='vim'
alias nv='nvim'
alias ls='ls --color=auto'
alias ll='ls --color=auto -alh'
alias hh='hashcat --help | grep -i'
alias hashcat='rm -rf ~/.hashcat/hashcat.pot;hashcat'
alias search='sudo pacman -Ss'
alias up='sudo pacman -Syu'
alias gco='git commit -am'
alias gdt='git difftool -d'
alias gpush='git push'
alias gpull='git pull'
alias gclo='git clone'
alias gch='git checkout'
alias gdf='git diff'
alias gst='git status'
alias f='find . -name'
alias grp='grep -nIr'
alias glog='git log --pretty=format:"%h|%an|%s"| column -t -s "|" -o "|" | awk '"'"'BEGIN{FS="|";} function green(s) { printf "\033[1;32m" s "\033[0m " } function blue(s) { printf "\033[1;34m" substr(s,1,3) "\033[0m " } {print green($1),blue($2),$3}'"'"' | more -10'
alias gtg='git describe --tag'
alias rse='rsync -arv /home/sk/src/WIFI_BE/ vm:/decoder/WIFI_BE/'
alias rss='rsync -arv /home/sk/src/sproxy/ vm:/root/sproxy'
alias rsc2='rsync -arv --exclude="*.o" --exclude="*.out" --exclude=".git/" /home/sk/src/WI_BE_Client/ board2:/root/WI_BE_Client/ --delete'
alias rsc3='rsync -arv --exclude="*.o" --exclude="*.out" --exclude=".git/" /home/sk/src/WI_BE_Client/ board3:/root/WI_BE_Client/ --delete'
alias rsc4='rsync -arv --exclude="*.o" --exclude="*.out" --exclude=".git/" /home/sk/src/WI_BE_Client/ board4:/root/WI_BE_Client/ --delete'
alias rsc5='rsync -arv --exclude="*.o" --exclude="*.out" --exclude=".git/" /home/sk/src/WI_BE_Client/ board5:/root/WI_BE_Client/ --delete'
alias rsc2h='rsync -arv /home/sk/WI_BE_Client/ board2:/root/WI_BE_Client/'
alias rscb='rsync -arv /home/sk/src/WI_BE_Client/ vm:/root/WI_BE_Client/'
alias rse='rsync -arv /home/sk/src/WIFI_BE/ vm:/decoder/WIFI_BE/'
alias rseh='rsync -arv /home/sk/WIFI_BE/ vm:/decoder/WIFI_BE/'
alias rsh2='rsync -arv /home/sk/src/hostapd board2:/root/'
alias scc='scp -r /home/sk/src/WI_BE_Client/ board:/root/WI_BE_Client/'
alias scc2='scp -r /home/sk/src/WI_BE_Client/ board2:/root/WI_BE_Client/'
alias sce='scp -r /home/sk/src/WIFI_BE/ vm:/decoder/WIFI_BE/'
alias nano='figlet "use vim"'
alias gedit='figlet "use vim"'
alias emacs='figlet "use vim"'
alias tailf='tail -f'
alias nvclear='rm -rf ~/.local/share/nvim/swap/*'
alias make='make -j8'
export LD_LIBRARY_PATH=/usr/local/lib64/
PS1='[\u@\h \W]\$ '
export GITAWAREPROMPT=~/.bash/git-aware-prompt
source "${GITAWAREPROMPT}/main.sh"
export PS1="\${debian_chroot:+(\$debian_chroot)}\[\033[01;33m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "
bind -r '\C-s'
stty -ixon

