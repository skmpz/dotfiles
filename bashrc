#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias nv='nvim'
alias bck='rsync -e ssh -avzh /data/ contabo:/root/data --delete --exclude .Trash* --exclude downloads/ --exclude lost+found/ --exclude movies/ --exclude series/ --exclude series_cur/ --exclude shows/ --progress'
alias bck_media='rsync -e ssh -avzh /data/series/ contabo:/root/series/ --delete --progress'
alias pkg='sudo pkg'
alias upd='sudo portmaster -dya --no-confirm'
alias d='cd /data/downloads'
alias reboot='sudo shutdown -r now'
alias gch='git checkout'
alias gst='git status'
alias gco='git commit -am'
alias gdf='git diff'
alias gpush='git push'

PS1='[\u@\h \W]\$ '
export GITAWAREPROMPT=~/.bash/git-aware-prompt
source "${GITAWAREPROMPT}/main.sh"
export PS1="\${debian_chroot:+(\$debian_chroot)}\[\033[01;33m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "
