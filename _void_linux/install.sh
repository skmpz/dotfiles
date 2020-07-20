#!/bin/bash

# ------------------------- settings ---------------------------
s_log_cols=50           # log length
s_line_cols=80          # hr line length
s_sudo_perm="YES"       # sudo perm needed
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
    echo -e "${BLUE}laptop/home/vm    install mode    [required]${NC}"
    _line
    exit 1
}

# arg count
if [ $# -lt 1 ]; then show_usage ;fi

# parse arguments
for i in "$@"
do
    case $i in
        vm) mode="VM"; shift 1 ;;
        home) mode="HOME"; shift 1 ;;
        laptop) mode="LAPTOP"; shift 1 ;;
        *) ;;
    esac
done

# check arguments
if [ "$mode" != "HOME" ] && [ "$mode" != "VM" ] && [ "$mode" != "LAPTOP" ]; then show_usage; fi
# ------------------------- arguments --------------------------

_start "Installing system"
sudo xbps-install -Sy \
alsa-oss \
alsa-utils \
alsa-utils \
arc-icons \
arc-theme \
autoconf \
automake \
bash-completion \
bc \
binwalk \
blueman \
caja \
caja-open-terminal \
calibre \
chromium-browser \
clang \
clang-tidy \
cmake \
cppcheck \
curl \
engrampa \
feh \
fonts-font-awesome \
fonts-inconsolata \
foremost \
gdb \
gedit \
google-mock \
googletest \
gparted \
i3lock \
i3status \
imagemagick \
mate-terminal \
mpv \
neovim \
netdiscover \
nmap \
nodejs \
nomacs \
openjdk-8-jdk \
p7zip \
pulseaudio \
python \
python-neovim \
python3 \
rofi \
rsync \
rxvt-unicode \
scrot \
ttf-dejavu \
ttf-ubuntu-font-family \
unrar \
upower \
vim \
wget \
wireshark-gtk \
xclip \
xcursor-themes \
xorg \
xterm \
xutils-dev \
>> $LOGFILE 2>&1
_check_ok $?

    # _start "Installing extra tools"
    # rm -rf i3-gaps cquery
    # git clone https://www.github.com/Airblader/i3 i3-gaps >> $LOGFILE 2>&1
    # cd i3-gaps >> $LOGFILE 2>&1
    # git checkout gaps  >> $LOGFILE 2>&1
    # git pull >> $LOGFILE 2>&1
    # autoreconf --force --install >> $LOGFILE 2>&1
    # rm -rf build >> $LOGFILE 2>&1
    # mkdir build >> $LOGFILE 2>&1
    # cd build >> $LOGFILE 2>&1
    # ../configure --prefix=/usr --sysconfdir=/etc >> $LOGFILE 2>&1
    # make -j4 >> $LOGFILE 2>&1
    # sudo make install >> $LOGFILE 2>&1
    # cd ../..
    # git clone --recursive https://github.com/cquery-project/cquery.git >> $LOGFILE 2>&1
    # cd cquery
    # git submodule update --init >> $LOGFILE 2>&1
    # mkdir build && cd build
    # cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=release -DCMAKE_EXPORT_COMPILE_COMMANDS=YES >> $LOGFILE 2>&1
    # cmake --build . >> $LOGFILE 2>&1
    # cmake --build . --target install >> $LOGFILE 2>&1
    # _check_ok $?

# # yay -S hopper burpsuite python2-pwntools --noconfirm >> $LOGFILE 2>&1
# # _check_no_ok $?
# # gem install zsteg >> $LOGFILE 2>&1

# # if [ "$mode" == "HOMEA" ]; then
# #     _start "Installing Plex"
# #     yay -S plex-media-server --noconfirm >> $LOGFILE 2>&1
# #     _check_no_ok $?
# #     sudo systemctl enable plexmediaserver >> $LOGFILE 2>&1
# #     _check_ok $?
# # fi

# if [ "$mode" == "VM" ]; then
    # _start "Setting up vm modules"
    # sudo pacman -S virtualbox-guest-utils virtualbox-guest-modules-arch --noconfirm --needed >> $LOGFILE 2>&1
    # _check_no_ok $?
    # printf "vboxguest\nvboxsf\nvboxvideo\n" > vboxservice.conf
    # _check_no_ok $?
    # sudo cp vboxservice.conf /etc/modules-load.d/ >> $LOGFILE 2>&1
    # _check_no_ok $?
    # sudo systemctl enable vboxservice.service > /dev/null 2>> $LOGFILE
    # _check_ok $?
# fi

# _start "Setting up config files"
# cd $HOME
# sudo chown sk:sk -R . > /dev/null 2>> $LOGFILE
# rm -rf $HOME/.bash/
# rm -rf $HOME/.bashrc
# rm -rf $HOME/.gtkrc-2.0
# rm -rf $HOME/.xinitrc
# rm -rf $HOME/.Xresources
# rm -rf $HOME/.Xresources.local
# rm -rf $HOME/.config/i3/
# rm -rf $HOME/.config/gtk-3.0/
# rm -rf $HOME/.config/nvim/
# rm -rf $HOME/.local/share/fonts
# rm -rf $HOME/.urxvt/
# rm -rf $HOME/screen/
# mkdir -p $HOME/.bash/
# mkdir -p $HOME/.config/i3/
# mkdir -p $HOME/.config/nvim/
# mkdir -p $HOME/.config/gtk-3.0/
# mkdir -p $HOME/.urxvt/ext/
# mkdir -p $HOME/screen/
# sudo mkdir -p /usr/share/fonts/truetype/
# sudo cp $HOME/dotfiles/fonts/Inconsolata.otf /usr/share/fonts/truetype/
# sudo cp $HOME/dotfiles/fonts/source-code-pro/* /usr/share/fonts/truetype/
# sudo cp $HOME/dotfiles/locale /etc/default/locale
# curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    # https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim >> $LOGFILE 2>&1
    # git clone https://github.com/skmpz/git-aware-prompt $HOME/.bash/git-aware-prompt >> $LOGFILE 2>&1
    # cp $HOME/dotfiles/font-size $HOME/.urxvt/ext/
    # ln -sf $HOME/dotfiles/gtkrc-2.0 $HOME/.gtkrc-2.0
    # ln -sf $HOME/dotfiles/settings.ini $HOME/.config/gtk-3.0/settings.ini
    # ln -sf $HOME/dotfiles/init.vim $HOME/.config/nvim/init.vim
    # ln -sf $HOME/dotfiles/Xresources $HOME/.Xresources
    # ln -sf $HOME/dotfiles/config.base $HOME/.config/i3/config.base
    # ln -sf $HOME/dotfiles/inputrc $HOME/.inputrc
    # if [ "$mode" == "HOME" ]; then
    #     ln -sf $HOME/dotfiles/home/xinitrc $HOME/.xinitrc
    #     ln -sf $HOME/dotfiles/home/Xresources.local $HOME/.Xresources.local
    #     ln -sf $HOME/dotfiles/home/config.local $HOME/.config/i3/config.local
    #     ln -sf $HOME/dotfiles/home/bashrc $HOME/.bashrc
    # elif [ "$mode" == "NUC" ]; then
    #     ln -sf $HOME/dotfiles/nuc/xinitrc $HOME/.xinitrc
    #     ln -sf $HOME/dotfiles/nuc/Xresources.local $HOME/.Xresources.local
    #     ln -sf $HOME/dotfiles/nuc/config.local $HOME/.config/i3/config.local
    #     ln -sf $HOME/dotfiles/nuc/bashrc $HOME/.bashrc
    # elif [ "$mode" == "LAPTOP" ]; then
    #     sudo apt install -y tlp >> $LOGFILE 2>&1
    #     sudo systemctl enable tlp >> $LOGFILE 2>&1
    #     ln -sf $HOME/dotfiles/laptop/xinitrc $HOME/.xinitrc
    #     ln -sf $HOME/dotfiles/laptop/Xresources.local $HOME/.Xresources.local
    #     ln -sf $HOME/dotfiles/laptop/config.local $HOME/.config/i3/config.local
    #     ln -sf $HOME/dotfiles/laptop/bashrc $HOME/.bashrc
    # elif [ "$mode" == "WORK" ]; then
    #     ln -sf $HOME/dotfiles/work/xinitrc $HOME/.xinitrc
    #     ln -sf $HOME/dotfiles/work/Xresources.local $HOME/.Xresources.local
    #     ln -sf $HOME/dotfiles/work/config.local $HOME/.config/i3/config.local
    #     ln -sf $HOME/dotfiles/work/bashrc $HOME/.bashrc
    # elif [ "$mode" == "CONF" ]; then
    #     ln -sf $HOME/dotfiles/cdl/xinitrc $HOME/.xinitrc
    #     ln -sf $HOME/dotfiles/cdl/Xresources.local $HOME/.Xresources.local
    #     ln -sf $HOME/dotfiles/cdl/config.local $HOME/.config/i3/config.local
    #     ln -sf $HOME/dotfiles/cdl/bashrc $HOME/.bashrc
    # elif [ "$mode" == "MAC" ]; then
    #     ln -sf $HOME/dotfiles/mac/xinitrc $HOME/.xinitrc
    #     ln -sf $HOME/dotfiles/mac/Xresources.local $HOME/.Xresources.local
    #     ln -sf $HOME/dotfiles/mac/config.local $HOME/.config/i3/config.local
    #     ln -sf $HOME/dotfiles/mac/bashrc $HOME/.bashrc
    # elif [ "$mode" == "VM" ]; then
    #     ln -sf $HOME/dotfiles/vm/xinitrc $HOME/.xinitrc
    #     ln -sf $HOME/dotfiles/vm/Xresources.local $HOME/.Xresources.local
    #     ln -sf $HOME/dotfiles/vm/config.local $HOME/.config/i3/config.local
    #     ln -sf $HOME/dotfiles/vm/bashrc $HOME/.bashrc
    # fi
    # nvim +PlugInstall +qall >> $LOGFILE 2>&1
    # nvim +UpdateRemotePlugins +qall >> $LOGFILE 2>&1
    # printf "[Icon Theme]\nInherits=whiteglass\n" | sudo tee /usr/share/icons/default/index.theme >> $LOGFILE 2>&1
    # sudo chown sk:sk -R $HOME > /dev/null 2>> $LOGFILE
    # _check_ok $?

# # clean up
# rm -rf $LOGFILE vboxservice.conf

# # print run time
# _line
# end_time=`date +%s`
# echo -en "${YELLOW}Runtime: " #$((end_time-start_time)) sec${NC}"
# date -d@$((end_time-start_time)) -u +%H:%M:%S
# _line
