#!/bin/bash

# print usage and exit
function show_usage {
    echo "[usage] ./$(basename $0) [opts]"
    echo "-----------------------------------------------"
    echo -n "[opts] "
    echo "laptop/home/vm    install mode    [required]"
    echo "-----------------------------------------------"
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

echo "Installing system.."
sudo xbps-install -Sy \
alsa-oss \
alsa-utils \
alsa-utils \
arc-icon-theme \
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
chromium \
clang \
cmake \
cppcheck \
curl \
engrampa \
feh \
font-awesome \
foremost \
gdb \
gedit \
gparted \
i3-gaps \
i3lock \
i3status \
ImageMagick \
mate-terminal \
mpv \
neovim \
nmap \
nodejs \
nomacs \
openjdk8 \
p7zip \
pulseaudio \
python \
python-neovim \
python3 \
rofi \
rsync \
rxvt-unicode \
scrot \
dejavu-fonts-ttf \
ttf-ubuntu-font-family \
upower \
vim \
wget \
wireshark-gtk \
xclip \
xcursor-themes \
xorg \
xterm \

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
