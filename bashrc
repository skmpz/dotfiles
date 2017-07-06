#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias v='vim'
alias nv='nvim'
alias ls='ls --color=auto'
alias ll='ls --color=auto -alh'
alias hh='hashcat --help | grep -i'
alias d='cd /data/downloads/'
alias c='cd /data/code'
alias s='nv /data/documents/series'
alias hashcat='rm -rf ~/.hashcat/hashcat.pot;hashcat'
alias search='sudo pacman -Ss'
alias up='sudo pacman -Syu'
alias gco='git commit -am'
alias gpush='git push'
alias gpull='git pull'
alias gclo='git clone'
alias gch='git checkout'
alias gdf='git diff'
alias gst='git status'
alias f='find . -name'
alias grp='grep -nIr'
PS1='[\u@\h \W]\$ '
export GITAWAREPROMPT=~/.bash/git-aware-prompt
source "${GITAWAREPROMPT}/main.sh"
export PS1="\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "
bind -r '\C-s'
stty -ixon
