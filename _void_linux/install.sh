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
        home) mode="HOME"; shift 1 ;;
        laptop) mode="LAPTOP"; shift 1 ;;
        nuc) mode="NUC"; shift 1 ;;
        *) ;;
    esac
done

# check arguments
if [ "$mode" != "HOME" ] && [ "$mode" != "NUC" ] && [ "$mode" != "LAPTOP" ]; then show_usage; fi
# ------------------------- arguments --------------------------

echo "Installing system.."
sudo xbps-install -Sy \
ImageMagick \
NetworkManager \
alsa-oss \
alsa-utils \
arc-icon-theme \
arc-theme \
autoconf \
automake \
bash-completion \
bc \
binwalk \
blueman \
bluez-alsa \
caja \
caja-open-terminal \
calibre \
chromium \
chrony \
clang \
clang-tools-extra \
cmake \
cppcheck \
curl \
dejavu-fonts-ttf \
dropbox \
engrampa \
evince \
feh \
firefox \
font-adobe-source-code-pro \
font-awesome \
font-inconsolata-otf \
foremost \
gcc \
gdb \
gedit \
gparted \
i3-gaps \
i3lock \
i3status \
make \
mate-terminal \
mpv \
neovim \
network-manager-applet \
nmap \
nodejs \
nomacs \
noto-fonts-emoji \
noto-fonts-ttf \
openjdk8 \
p7zip \
pkg-config \
polybar \
pulseaudio \
python \
python-neovim \
python3 \
python3-neovim \
python3-pip \
rofi \
rsync \
rxvt-unicode \
scrot \
ttf-ubuntu-font-family \
unzip \
upower \
vim \
void-repo-nonfree \
wget \
wireshark-qt \
xclip \
xcursor-themes \
xorg \
xterm \
xtools

echo "Installing additional software"
pip install --upgrade conan

echo "Setting up config files.."
cd $HOME
sudo chown sk:sk -R . > /dev/null 2>> $LOGFILE
rm -rf $HOME/.bash/
rm -rf $HOME/.bashrc
rm -rf $HOME/.gtkrc-2.0
rm -rf $HOME/.xinitrc
rm -rf $HOME/.Xresources
rm -rf $HOME/.Xresources.local
rm -rf $HOME/.config/i3/
rm -rf $HOME/.config/gtk-3.0/
rm -rf $HOME/.config/nvim/
rm -rf $HOME/.config/polybar/
rm -rf $HOME/.local/share/fonts
rm -rf $HOME/.urxvt/
rm -rf $HOME/screen/
mkdir -p $HOME/.bash/
mkdir -p $HOME/.config/i3/
mkdir -p $HOME/.config/polybar/
mkdir -p $HOME/.config/nvim/
mkdir -p $HOME/.config/gtk-3.0/
mkdir -p $HOME/.local/share/fonts/
mkdir -p $HOME/.urxvt/ext/
mkdir -p $HOME/screen/
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
git clone https://github.com/skmpz/git-aware-prompt $HOME/.bash/git-aware-prompt
cp $HOME/dotfiles/urxvt/font-size $HOME/.urxvt/ext/
cp $HOME/dotfiles/fonts/* $HOME/.local/share/fonts/
ln -sf $HOME/dotfiles/gtk/gtkrc-2.0 $HOME/.gtkrc-2.0
ln -sf $HOME/dotfiles/gtk/settings.ini $HOME/.config/gtk-3.0/settings.ini
ln -sf $HOME/dotfiles/neovim/init.vim $HOME/.config/nvim/init.vim
ln -sf $HOME/dotfiles/x/Xresources $HOME/.Xresources
ln -sf $HOME/dotfiles/i3/config.base $HOME/.config/i3/config.base
ln -sf $HOME/dotfiles/bash/inputrc $HOME/.inputrc
ln -sf $HOME/dotfiles/polybar/launch.sh $HOME/.config/polybar/
ln -sf $HOME/dotfiles/polybar/modules.ini $HOME/.config/polybar/
ln -sf $HOME/dotfiles/_void_linux/v_build_pkg.sh $HOME/
ln -sf $HOME/dotfiles/_void_linux/v_check_pkgs.sh $HOME/
if [ "$mode" == "HOME" ]; then
    ln -sf $HOME/dotfiles/home/xinitrc $HOME/.xinitrc
    ln -sf $HOME/dotfiles/home/Xresources.local $HOME/.Xresources.local
    ln -sf $HOME/dotfiles/home/config.local $HOME/.config/i3/config.local
    ln -sf $HOME/dotfiles/home/bashrc $HOME/.bashrc
elif [ "$mode" == "LAPTOP" ]; then
    ln -sf $HOME/dotfiles/_void_linux/laptop/x/xinitrc $HOME/.xinitrc
    ln -sf $HOME/dotfiles/_void_linux/laptop/x/Xresources.local $HOME/.Xresources.local
    ln -sf $HOME/dotfiles/_void_linux/laptop/i3/config.local $HOME/.config/i3/config.local
    ln -sf $HOME/dotfiles/_void_linux/laptop/bash/bashrc $HOME/.bashrc
    ln -sf $HOME/dotfiles/_void_linux/laptop/polybar/config.ini $HOME/.config/polybar/
elif [ "$mode" == "NUC" ]; then
    ln -sf $HOME/dotfiles/_void_linux/nuc/x/xinitrc $HOME/.xinitrc
    ln -sf $HOME/dotfiles/_void_linux/nuc/x/Xresources.local $HOME/.Xresources.local
    ln -sf $HOME/dotfiles/_void_linux/nuc/i3/config.local $HOME/.config/i3/config.local
    ln -sf $HOME/dotfiles/_void_linux/nuc/bash/bashrc $HOME/.bashrc
    ln -sf $HOME/dotfiles/_void_linux/nuc/polybar/config.ini $HOME/.config/polybar/
fi
nvim +PlugInstall +qall
nvim +UpdateRemotePlugins +qall
nvim +"CocInstall coc-clangd" +qall
sudo chown sk:sk -R $HOME

sudo rm -rf /var/service/dhcpcd/
sudo ln -sf /etc/sv/dbus/ /var/service/
sudo ln -sf /etc/sv/bluetoothd/ /var/service/
sudo ln -sf /etc/sv/NetworkManager/ /var/service/
sudo ln -sf /etc/sv/chronyd/ /var/service/
sudo ln -sf /usr/share/zoneinfo/Asia/Dubai /etc/localtime

sudo usermod -a -G bluetooth sk
sudo usermod -a -G network sk
