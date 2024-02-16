### Void Linux setup

Install - Boot from usb flash drive then:
```sh
bash
wpa_passphrase <AP> <PW> >> /etc/wpa_supplicant/wpa_supplicant.conf
rm -rf /run/wpa_supplicant/*
wpa_supplicant -B -i <iface> -c /etc/wpa_supplicant/wpa_supplicant.conf
export SSL_NO_VERIFY_PEER=1
xbps-install -Syu xbps git
git clone https://github.com/skmpz/dotfiles
./dotfiles/_void_linux/void-install-libc.sh
```
Setup - Login to system and then:
```sh
wpa_passphrase <AP> <PW> | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf
sudo wpa_supplicant -B -i <iface> -c /etc/wpa_supplicant/wpa_supplicant.conf
sudo xbps-install -Syu xbps git
git clone https://github.com/skmpz/dotfiles
./dotfiles/_void_linux/void-setup-sway <target>
```

---
##### setup ssh
---

Git: 
```sh
git config --global user.name "user"
git config --global user.email user@email.com
git config --global pull.rebase false
cd $HOME/dotfiles
git remote set-url origin git@github.com:skmpz/dotfiles.git
git pull
```

Void packages:
```sh
cd $HOME
git clone git@github.com:skmpz/void-packages.git
cd void-packages
git remote add upstream https://github.com/void-linux/void-packages.git
git pull --rebase upstream master
echo XBPS_ALLOW_RESTRICTED=yes >> $HOME/void-packages/etc/conf
```

Void utils:
```sh
cd $HOME
git clone git@github.com:skmpz/void-utils.git utils
v_update_apps
```

Void xtools:
```sh
cd $HOME
git clone git@github.com:leahneukirchen/xtools.git
```

Dropbox
```sh
dropbox start -i
```
