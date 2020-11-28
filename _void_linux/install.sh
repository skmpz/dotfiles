#!/bin/bash

# print usage and exit
function show_usage {
    echo "[usage] ./$(basename $0) [opts]"
    echo "-----------------------------------------------"
    echo -n "[opts] "
    echo "laptop/desktop    install target    [required]"
    echo "-----------------------------------------------"
    exit 1
}

# arg count
if [ $# -lt 1 ]; then show_usage ;fi

# parse arguments
for i in "$@"
do
    case $i in
        desktop) target="desktop"; shift 1 ;;
        laptop) target="laptop"; shift 1 ;;
        *) ;;
    esac
done

# check arguments
if [ "$target" != "desktop" ] && [ "$target" != "laptop" ]; then show_usage; fi
# ------------------------- arguments --------------------------

# user
user=$(echo $USER)

# install base apps
echo "Installing system.."
sudo xbps-install -Sy \
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
hexchat \
i3-gaps \
i3lock \
i3status \
imwheel \
iwd \
lm_sensors \
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
picom \
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
xclip \
xcursor-themes \
xorg \
xterm \
xtools \
xz \
zip

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
rm -rf $HOME/.imwheelrc
rm -rf $HOME/.Xresources
rm -rf $HOME/.Xresources.local
rm -rf $HOME/.config/i3/
rm -rf $HOME/.config/gtk-3.0/
rm -rf $HOME/.config/nvim/
rm -rf $HOME/.config/polybar/
rm -rf $HOME/.local/share/fonts
rm -rf $HOME/.urxvt/
rm -rf $HOME/screens/
mkdir -p $HOME/.bash/
mkdir -p $HOME/.config/i3/
mkdir -p $HOME/.config/polybar/
mkdir -p $HOME/.config/nvim/
mkdir -p $HOME/.config/gtk-3.0/
mkdir -p $HOME/.local/share/fonts/
mkdir -p $HOME/.urxvt/ext/
mkdir -p $HOME/screens/
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
git clone https://github.com/skmpz/git-aware-prompt $HOME/.bash/git-aware-prompt
cp $HOME/dotfiles/urxvt/font-size $HOME/.urxvt/ext/
cp -r $HOME/dotfiles/fonts/* $HOME/.local/share/fonts/
ln -sf $HOME/dotfiles/neovim/init.vim $HOME/.config/nvim/init.vim
ln -sf $HOME/dotfiles/x/Xresources $HOME/.Xresources
ln -sf $HOME/dotfiles/i3/config.base $HOME/.config/i3/config.base
ln -sf $HOME/dotfiles/bash/inputrc $HOME/.inputrc
ln -sf $HOME/dotfiles/polybar/launch.sh $HOME/.config/polybar/
ln -sf $HOME/dotfiles/imwheel/imwheelrc $HOME/.imwheelrc

# setup device specific stuff
if [ "$target" == "desktop" ]; then
    path="$HOME/dotfiles/_void_linux/desktop"
    sudo xbps-install -Sy nvidia
elif [ "$target" == "laptop" ]; then
    path="$HOME/dotfiles/_void_linux/laptop"
    sudo xbps-install -Sy nvidia
fi

# set configs
ln -sf $path/x/xinitrc $HOME/.xinitrc
ln -sf $path/x/Xresources.local $HOME/.Xresources.local
ln -sf $path/i3/config.local $HOME/.config/i3/config.local
ln -sf $path/bash/bashrc $HOME/.bashrc
ln -sf $path/polybar/config.ini $HOME/.config/polybar/
ln -sf $path/polybar/modules.ini $HOME/.config/polybar/
ln -sf $path/polybar/launch.sh $HOME/.config/polybar/
ln -sf $path/gtk/gtkrc-2.0 $HOME/.gtkrc-2.0
ln -sf $path/gtk/settings.ini $HOME/.config/gtk-3.0/

# setup vim
nvim +PlugInstall +qall
nvim +UpdateRemotePlugins +qall
nvim +"CocInstall coc-clangd" +qall

# setup home dir
sudo chown $user:$user -R $HOME

# setup services
sudo ln -sf /etc/sv/dbus/ /var/service/
sudo ln -sf /etc/sv/bluetoothd/ /var/service/
sudo ln -sf /etc/sv/wpa_supplicant/ /var/service/
sudo ln -sf /etc/sv/chronyd/ /var/service/
sudo ln -sf /usr/share/zoneinfo/Asia/Dubai /etc/localtime

# add user to groups
sudo usermod -a -G bluetooth,network $user
