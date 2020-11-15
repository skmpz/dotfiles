#!/bin/bash

# print usage and exit
function show_usage {
    echo "[usage] ./$(basename $0) [opts]"
    echo "-----------------------------------------------"
    echo -n "[opts] "
    echo "laptop/home    install mode    [required]"
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
        *) ;;
    esac
done

# check arguments
if [ "$mode" != "HOME" ] && [ "$mode" != "LAPTOP" ]; then show_usage; fi
# ------------------------- arguments --------------------------

# user
user=$(echo $USER)

# install base apps
echo "Installing system.."
sudo xbps-install -Sy \
ImageMagick \
alsa-oss \
alsa-utils \
arc-icon-theme \
arc-theme \
autoconf \
automake \
bash-completion \
bc \
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
dhclient \
dropbox \
engrampa \
evince \
feh \
firefox \
font-adobe-source-code-pro \
font-awesome \
font-inconsolata-otf \
fzf \
gcc \
gdb \
gedit \
gparted \
i3-gaps \
i3lock \
i3status \
iwd \
make \
mate-terminal \
mpv \
neovim \
net-tools \
nmap \
nodejs \
nomacs \
noto-fonts-emoji \
noto-fonts-ttf \
openjdk8 \
openvpn \
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
synergy \
ttf-ubuntu-font-family \
unzip \
upower \
vim \
void-repo-nonfree \
weechat \
wget \
xclip \
xcursor-themes \
xorg \
xterm \
xtools

# install additional stuff
echo "Installing additional software"
pip install --upgrade conan

# setup configuration
echo "Setting up config files.."
cd $HOME
sudo chown $user:$user -R .
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
rm -rf $HOME/screens/
rm -rf $HOME/tools/
mkdir -p $HOME/.bash/
mkdir -p $HOME/.config/i3/
mkdir -p $HOME/.config/polybar/
mkdir -p $HOME/.config/nvim/
mkdir -p $HOME/.config/gtk-3.0/
mkdir -p $HOME/.local/share/fonts/
mkdir -p $HOME/.urxvt/ext/
mkdir -p $HOME/screens/
mkdir -p $HOME/tools/
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
ln -sf $HOME/dotfiles/_void_linux/v_pkg_build.sh $HOME/
ln -sf $HOME/dotfiles/_void_linux/v_check_pkgs.sh $HOME/

# setup device specific stuff
if [ "$mode" == "HOME" ]; then
    :
elif [ "$mode" == "LAPTOP" ]; then
    sudo xbps-install -Sy nvidia
    ln -sf $HOME/dotfiles/_void_linux/laptop/x/xinitrc $HOME/.xinitrc
    ln -sf $HOME/dotfiles/_void_linux/laptop/x/Xresources.local $HOME/.Xresources.local
    ln -sf $HOME/dotfiles/_void_linux/laptop/i3/config.local $HOME/.config/i3/config.local
    ln -sf $HOME/dotfiles/_void_linux/laptop/bash/bashrc $HOME/.bashrc
    ln -sf $HOME/dotfiles/_void_linux/laptop/polybar/config.ini $HOME/.config/polybar/
fi

# setup fuzzypkg
git clone https://github.com/skmpz/fuzzypkg $HOME/tools/fuzzypkg

# setup vim
nvim +PlugInstall +qall
nvim +UpdateRemotePlugins +qall
nvim +"CocInstall coc-clangd" +qall

# setup home dir
sudo chown $user:$user -R $HOME

# setup services
# sudo rm -rf /var/service/dhcpcd/
sudo ln -sf /etc/sv/dbus/ /var/service/
sudo ln -sf /etc/sv/bluetoothd/ /var/service/
sudo ln -sf /etc/sv/iwd/ /var/service/
# sudo ln -sf /etc/sv/NetworkManager/ /var/service/
sudo ln -sf /etc/sv/chronyd/ /var/service/
sudo ln -sf /usr/share/zoneinfo/Asia/Dubai /etc/localtime

# add user to groups
sudo usermod -a -G bluetooth,network $user
