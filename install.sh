#!/bin/bash

# ------------------------- settings ---------------------------
s_log_cols=50           # log length
s_line_cols=80          # hr line length
s_sudo_perm="YES"        # sudo perm needed
s_line_color="BLUE"     # hr line color
s_main_color="YELLOW"   # main action color
s_plus_color="WHITE"    # sign color
s_ok_color="GREEN"      # ok color
s_info_color="PURPLE"   # info color
s_fail_color="RED"      # fail color
# ------------------------- settings ---------------------------

# ----------------------- helper funcs -------------------------
# colors
NC="\033[0m"        RED="\033[0;31m"   GREEN="\033[0;32m"
YELLOW="\033[0;33m" WHITE="\033[0;97m" BLUE="\033[0;34m"
PURPLE="\033[0;35m" CYAN="\033[0;36m"  GREY="\033[0;90m"

# check function (with ok output)
function _check_ok {
    if [ $1 == 0 ]; then
        echo -en "[${!s_ok_color}OK${NC}]"
        if [ ! -z "$2" ]; then echo -e "[${!s_info_color}${2}${NC}]"; else echo ""; fi
    else
        echo -e "[${!s_fail_color}FAIL${NC}]"; exit 1
    fi
}

# check function (without ok output)
function _check_no_ok {
    if [ $1 == 0 ]; then return; else echo -e "[${!s_fail_color}FAIL${NC}]"; exit 1; fi
}

# section start
function _start {
    str_len=${#1}
    str_len=$((s_log_cols-str_len))
    echo -en "${!s_main_color}[${!s_plus_color}+${!s_main_color}] $1 "
    v=$(printf "%-${str_len}s" ".")
    echo -en "${v// /.} ${NC}"
    echo "------- $1" >> $LOGFILE
}

# no check ok
function _ok {
    echo -en "[${!s_ok_color}OK${NC}]"
    if [ ! -z "$1" ]; then echo -e "[${PURPLE}${1}${NC}]"; else echo ""; fi
}

# no check fail
function _fail {
    echo -en "[${!s_fail_color}FAIL${NC}]"
    if [ ! -z "$1" ]; then echo -e "[${PURPLE}${1}${NC}]"; else echo ""; fi
    exit 1
}

# hr line
function _line {
    v=$(printf "%-${s_line_cols}s" "-")
    echo -e "${!s_line_color}${v// /-} ${NC}"
}

# sudo perm
function _sudo {
    sudo ls > /dev/null
}
# ----------------------- helper funcs -------------------------

# ------------------------ initialize --------------------------
CWD=$PWD
LOGFILE="$CWD/.${0//.\/}.log"   # set logfile
echo "" > $LOGFILE              # empty logfile
start_time=`date +%s`           # start timer
if [ "$s_sudo_perm" == "YES" ]; then _sudo; fi
_line
# ------------------------ initialize --------------------------

# ------------------------- arguments --------------------------
# print usage and exit
function show_usage {
    echo -e "[${RED}usage${NC}] ${!s_main_color}./$(basename $0) [opts]${NC}"
    _line
    echo -en "[${WHITE}opts${NC}] "
    echo -e "${BLUE}--vm/--work/--laptop/--home    install mode    [required]${NC}"
    _line
    exit 1
}

# arg count
if [ $# -lt 1 ]; then show_usage ;fi

# parse arguments
for i in "$@"
do
    case $i in
        --vm) mode="VM"; shift 1 ;;
        --home) mode="HOME"; shift 1 ;;
        --laptop) mode="LAPTOP"; shift 1 ;;
        --work) mode="WORK"; shift 1 ;;
        *) ;;
    esac
done

# check arguments
if [ "$mode" != "HOME" ] && [ "$mode" != "VM" ] && [ "$mode" != "LAPTOP" ] && [ "$mode" != "WORK" ]; then show_usage; fi
# ------------------------- arguments --------------------------

_start "Setting passwordless sudo"
echo "%wheel ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers >> $LOGFILE 2>&1
_check_ok $?

_start "Getting pacman up to date"
sudo pacman -Syy --noconfirm --needed >> $LOGFILE 2>&1
_check_ok $?

_start "Installing system"
sudo pacman -S adobe-source-code-pro-fonts aircrack-ng alsa-oss alsa-utils alsa-utils arc-gtk-theme arc-icon-theme bash-completion bc binwalk caja caja-open-terminal calibre cherrytree chromium clang cmake engrampa evince fbreader feh fzf foremost gedit gparted i3-gaps i3lock i3status imagemagick jdk8-openjdk luarocks mate-terminal mpv neovim nodejs nomacs openssh otf-font-awesome perl-image-exiftool polkit pulseaudio python-neovim python2 python2-neovim python3 rofi rsync ruby rxvt-unicode sbt scala scrot synergy tmux transmission-gtk ttf-dejavu ttf-droid ttf-inconsolata ttf-ubuntu-font-family unrar upower urxvt-perls vim wget wireshark-gtk xclip xcursor-themes xorg xorg-twm xorg-xclock xorg-xinit xterm --noconfirm --needed >> $LOGFILE 2>&1
_check_ok $?

_start "Installing extra tools"
git clone https://aur.archlinux.org/yay.git > /dev/null >> $LOGFILE 2>&1
_check_no_ok $?
cd yay >> $LOGFILE 2>&1
makepkg -si --noconfirm >> $LOGFILE 2>&1
_check_no_ok $?
cd ..
yay -S hopper --noconfirm >> $LOGFILE 2>&1
_check_no_ok $?
gem install zsteg >> $LOGFILE 2>&1
_check_ok $?

if [ "$mode" == "HOME" ]; then
    _start "Installing Plex"
    yay -S plex-media-server --noconfirm >> $LOGFILE 2>&1
    _check_no_ok $?
    sudo systemctl enable plexmediaserver >> $LOGFILE 2>&1
    _check_ok $?
fi

if [ "$mode" == "VM" ]; then
    _start "Setting up vm modules"
    sudo pacman -S virtualbox-guest-utils virtualbox-guest-modules-arch --noconfirm --needed >> $LOGFILE 2>&1
    _check_no_ok $?
    printf "vboxguest\nvboxsf\nvboxvideo\n" > vboxservice.conf
    _check_no_ok $?
    sudo cp vboxservice.conf /etc/modules-load.d/ >> $LOGFILE 2>&1
    _check_no_ok $?
    sudo systemctl enable vboxservice.service > /dev/null 2>> $LOGFILE
    _check_ok $?
fi

test
_start "Setting up config files"
rm -rf $HOME/.bash/
rm -rf $HOME/.bashrc
rm -rf $HOME/.gtkrc-2.0
rm -rf $HOME/.xinitrc
rm -rf $HOME/.Xresources
rm -rf $HOME/.config/i3/*
rm -rf $HOME/.config/gtk-3.0/settings.ini
rm -rf $HOME/.config/nvim/init.vim
rm -rf $HOME/.local/share/fonts
rm -rf $HOME/.urxvt/
mkdir -p $HOME/.bash/
mkdir -p $HOME/.config/i3/
mkdir -p $HOME/.config/nvim/
mkdir -p $HOME/.config/gtk-3.0/
mkdir -p $HOME/.urxvt/ext/
mkdir -p $HOME/screen/
sudo mkdir -p /usr/share/fonts/truetype/
sudo cp fonts/Inconsolata.otf /usr/share/fonts/truetype/
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim >> $LOGFILE 2>&1
git clone https://github.com/skmpz/git-aware-prompt $HOME/.bash/git-aware-prompt >> $LOGFILE 2>&1
cp $HOME/dotfiles/font-size $HOME/.urxvt/ext/
ln -s $HOME/dotfiles/bashrc $HOME/.bashrc
ln -s $HOME/dotfiles/gtkrc-2.0 $HOME/.gtkrc-2.0
ln -s $HOME/dotfiles/settings.ini $HOME/.config/gtk-3.0/settings.ini
ln -s $HOME/dotfiles/init.vim $HOME/.config/nvim/init.vim
ln -s $HOME/dotfiles/Xresources $HOME/.Xresources
ln -s $HOME/dotfiles/config.base $HOME/.config/i3/config.base
if [ "$mode" == "HOME" ]; then
    ln -s $HOME/dotfiles/home/xinitrc $HOME/.xinitrc
    ln -s $HOME/dotfiles/home/Xresources.local $HOME/.Xresources.local
    ln -s $HOME/dotfiles/home/config.local $HOME/.config/i3/config.local
elif [ "$mode" == "LAPTOP" ]; then
    ln -s $HOME/dotfiles/laptop/xinitrc $HOME/.xinitrc
    ln -s $HOME/dotfiles/laptop/Xresources.local $HOME/.Xresources.local
    ln -s $HOME/dotfiles/laptop/config.local $HOME/.config/i3/config.local
elif [ "$mode" == "WORK" ]; then
    ln -s $HOME/dotfiles/work/xinitrc $HOME/.xinitrc
    ln -s $HOME/dotfiles/work/Xresources.local $HOME/.Xresources.local
    ln -s $HOME/dotfiles/work/config.local $HOME/.config/i3/config.local
elif [ "$mode" == "VM" ]; then
    ln -s $HOME/dotfiles/vm/xinitrc $HOME/.xinitrc
    ln -s $HOME/dotfiles/vm/Xresources.local $HOME/.Xresources.local
    ln -s $HOME/dotfiles/vm/config.local $HOME/.config/i3/config.local
fi
nvim +PlugInstall +qall >> $LOGFILE 2>&1
nvim +UpdateRemotePlugins +qall >> $LOGFILE 2>&1
printf "[Icon Theme]\nInherits=whiteglass\n" | sudo tee /usr/share/icons/default/index.theme >> $LOGFILE 2>&1
_check_ok $?

# clean up
rm -rf $LOGFILE vboxservice.conf yay

# print run time
_line
end_time=`date +%s`
echo -en "${YELLOW}Runtime: " #$((end_time-start_time)) sec${NC}"
date -d@$((end_time-start_time)) -u +%H:%M:%S
_line
