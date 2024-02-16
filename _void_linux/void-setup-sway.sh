#!/bin/bash

# print usage and exit
function show_usage {
    echo "[usage] ./$(basename $0) [target]"
    exit 1
}

# arg count
if [ $# -lt 1 ]; then show_usage ;fi

# parse arguments
for i in "$@"
do
    case $i in
        box)   target="box";   shift 1 ;;
        zen)   target="zen";   shift 1 ;;
        envie) target="envie"; shift 1 ;;
        *) ;;
    esac
done

# check arguments
if [ "$target" != "box" ] && [ "$target" != "zen" ] && [ "$target" != "envie" ]; then show_usage; fi

# user
user=$(echo $USER)

# install base apps
echo "Installing system.."
sudo xbps-install -Sy void-repo-nonfree
sudo xbps-install -Sy \
ImageMagick \
NetworkManager \
Waybar \
alacritty \
arc-icon-theme \
arc-theme \
bash-completion \
bc \
blueman \
bluez \
brightnessctl \
caja \
caja-dropbox \
caja-open-terminal \
calibre \
chrony \
cmake \
clang \
clang-tools-extra \
cronie \
curl \
dbus-elogind \
dejavu-fonts-ttf \
dropbox \
dunst \
elogind \
engrampa \
evince \
ffmpeg \
firefox \
font-adobe-source-code-pro \
font-awesome5 \
font-ibm-plex-otf \
font-inconsolata-otf \
gcc \
grim \
gvfs \
intel-video-accel \
jq \
keepassxc \
leafpad \
libspa-bluetooth \
mate-terminal \
mesa-dri \
mpv \
neovim \
nerd-fonts \
network-manager-applet \
nmap \
nodejs \
nomacs \
noto-fonts-emoji \
noto-fonts-ttf \
ntp \
openssl-devel \
pavucontrol \
pipewire \
pkg-config \
polkit \
pulseaudio-utils \
python3 \
python3-neovim \
qt5-wayland \
ripgrep \
rsync \
rust-analyzer \
rustup \
socklog-void \
sshpass \
slurp \
sof-firmware \
sof-tools \
sway \
swayidle \
swaylock \
tmux \
ttf-ubuntu-font-family \
unzip \
upower \
vulkan-loader \
wdisplays \
weechat \
wget \
wl-clipboard \
wofi \
xcursor-vanilla-dmz \
xdg-utils \
xorg-fonts \
xtools \
yt-dlp \
zip || exit 1

# setup configuration
echo "Setting up config files.."
cd $HOME
sudo chown $user:$user -R .
rm -rf $HOME/.bash/
rm -rf $HOME/.bashrc
rm -rf $HOME/.gtkrc-2.0
rm -rf $HOME/.cache/nvim
rm -rf $HOME/.config/gtk-3.0/
rm -rf $HOME/.config/mimeapps.list
rm -rf $HOME/.config/user-dirs.dirs
rm -rf $HOME/.config/sway/
rm -rf $HOME/.local/share/fonts
rm -rf $HOME/.local/share/nvim
rm -rf $HOME/.icons/default/
rm -rf $HOME/screens/
rm -rf $HOME/start.sh
rm -rf $HOME/.tmux.conf

# machine specific
if [ "$target" == "box" ]; then
    path="$HOME/dotfiles/_void_linux/box"
    # sudo xbps-install -Sy nvidia
    sudo xbps-install -Sy mesa-vulkan-radeon amdvlk mesa-vaapi mesa-vdpau
elif [ "$target" == "zen" ]; then
    path="$HOME/dotfiles/_void_linux/zen"
    sudo xbps-install -Sy tlp mesa-vulkan-intel intel-video-accel
    sudo ln -sf /etc/sv/tlp/ /var/service/
elif [ "$target" == "envie" ]; then
    path="$HOME/dotfiles/_void_linux/envie"
    sudo xbps-install -Sy tlp mesa-vulkan-intel intel-video-accel
    sudo ln -sf /etc/sv/tlp/ /var/service/
fi

# create folders
mkdir -p $HOME/.bash/
mkdir -p $HOME/.config/gtk-3.0/
mkdir -p $HOME/.config/sway/
mkdir -p $HOME/.local/share/fonts/
mkdir -p $HOME/.icons/default/
mkdir -p $HOME/screens/

# wofi
if test -L $HOME/.config/wofi; then unlink $HOME/.config/wofi
elif test -d $HOME/.config/wofi; then rm -rf $HOME/.config/wofi
fi
ln -sf $HOME/dotfiles/wofi/ $HOME/.config/

# dunst
if test -L $HOME/.config/dunst; then unlink $HOME/.config/dunst
elif test -d $HOME/.config/dunst; then rm -rf $HOME/.config/dunst
fi
ln -sf $HOME/dotfiles/dunst/ $HOME/.config/

# alacritty
if test -L $HOME/.config/alacritty; then unlink $HOME/.config/alacritty
elif test -d $HOME/.config/alacritty; then rm -rf $HOME/.config/alacritty
fi
ln -sf $path/alacritty/ $HOME/.config/

# waybar
if test -L $HOME/.config/waybar; then unlink $HOME/.config/waybar
elif test -d $HOME/.config/waybar; then rm -rf $HOME/.config/waybar
fi
ln -sf $HOME/dotfiles/waybar/ $HOME/.config/

# nvim
if test -L $HOME/.config/nvim; then unlink $HOME/.config/nvim
elif test -d $HOME/.config/nvim; then rm -rf $HOME/.config/nvim
fi
ln -sf $HOME/dotfiles/nvim/ $HOME/.config/

# other
ln -sf $path/sway/config $HOME/.config/sway/config.local
ln -sf $path/gtk/gtkrc-2.0 $HOME/.gtkrc-2.0
ln -sf $path/gtk/settings.ini $HOME/.config/gtk-3.0/

# file links
ln -sf $HOME/dotfiles/sway/start.sh $HOME/start.sh
ln -sf $HOME/dotfiles/tmux/tmux.conf $HOME/.tmux.conf
ln -sf $HOME/dotfiles/bash/bashrc $HOME/.bashrc
ln -sf $HOME/dotfiles/mime/mimeapps.list $HOME/.config/mimeapps.list
ln -sf $HOME/dotfiles/user-dirs/user-dirs.dirs $HOME/.config/user-dirs.dirs
ln -sf $HOME/dotfiles/sway/config $HOME/.config/sway/config.base

# fonts
cp -r $HOME/dotfiles/fonts/* $HOME/.local/share/fonts/

# git aware prompt
git clone https://github.com/skmpz/git-aware-prompt $HOME/.bash/git-aware-prompt

# cursor setup
printf "[icon theme]\nInherits=Vanilla-DMZ\n" > $HOME/.icons/default/index.theme

# rust
rustup-init -y

# scala
curl -fL "https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz" | gzip -d > cs
chmod +x cs
echo "N" | ./cs setup
rm -rf cs

# kill wpa_supplicant
sudo pkill wpa_supplicant

# setup services
sudo ln -sf /etc/sv/dbus/ /var/service/
sudo ln -sf /etc/sv/polkitd/ /var/service/
sudo ln -sf /etc/sv/NetworkManager/ /var/service/
sudo ln -sf /etc/sv/chronyd/ /var/service/
sudo ln -sf /etc/sv/bluetoothd/ /var/service/
sudo ln -sf /etc/sv/cronie/ /var/service/
sudo ln -sf /etc/sv/socklog-unix/ /var/service/
sudo ln -sf /etc/sv/nanoklogd/ /var/service/

# add user to groups
sudo usermod -a -G bluetooth,network,kvm,video,input $user

# remove dirs
rm -rf $HOME/Desktop
rm -rf $HOME/Documents
rm -rf $HOME/Music
rm -rf $HOME/Pictures
rm -rf $HOME/Public
rm -rf $HOME/Templates
rm -rf $HOME/Videos
