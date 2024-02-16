#!/bin/bash

set -e

# wpa_passphrase <AP> <PW> | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf
# wpa_supplicant -B -i <iface> -c /etc/wpa_supplicant/wpa_supplicant.conf
# xbps-install -Syu xbps git
# git clone https://github.com/skmpz/dotfiles
# cd dotfiles
# ./_void_linux/void-libc.sh

# root password
echo "---------------------------------------------------------------"
echo "root password"
echo "---------------------------------------------------------------"
echo -n "pass (first): "; read -s root_pass_first; echo
echo -n "pass (again): "; read -s root_pass; echo
if [ "$root_pass_first" != "$root_pass" ]; then
    echo "passwords dont match"
    exit 1
fi
echo "root pass set"

# user name and pass
echo "---------------------------------------------------------------"
echo "user name and password"
echo "---------------------------------------------------------------"
read -p "username: " user_name
echo -n "pass (first): "; read -s user_pass_first; echo
echo -n "pass (again): "; read -s user_pass; echo
if [ "$user_pass_first" != "$user_pass" ]; then
    echo "passwords dont match"
    exit 1
fi
echo "user pass set"

# hostname
echo "---------------------------------------------------------------"
echo "hostname"
echo "---------------------------------------------------------------"
read -p "hostname: " hostname
echo "hostname set"

# disk
echo "---------------------------------------------------------------"
echo "disk setup"
echo "---------------------------------------------------------------"
options=$(lsblk | awk '/disk/ { print $1 "->" $4 }')
PS3='sel: '
select opt in $options; do
    if [ ! -z $opt ]; then
        disk="/dev/$(echo ${opt} | awk -F'-' '{print $1}')"
        break
    else
        printf 'invalid\n'
    fi
done
echo "disk set to ${disk}"

# encryption
echo "---------------------------------------------------------------"
echo "encryption"
echo "---------------------------------------------------------------"
echo -n "pass: "; read -s encryption_pass_first; echo
echo -n "confirm: "; read -s encryption_pass; echo
if [ "$encryption_pass_first" != "$encryption_pass" ]; then
    echo "passwords dont match"
    exit 1
fi
echo "encryption pass set"

# confirm configs
echo "---------------------------------------------------------------"
echo "configurations confirm"
echo "---------------------------------------------------------------"
echo "username: ${user_name}"
echo "password: ${user_pass}"
echo "root password: ${root_pass}"
echo "hostname: ${hostname}"
echo "disk: ${disk}"
echo "encryption pass: ${encryption_pass}"
echo "---------------------------------------------------------------"
read -p "press enter to confirm or CTRL-C to stop and start over"

# start installation
echo "---------------------------------------------------------------"
echo "wiping disk (${disk})"
echo "---------------------------------------------------------------"
dd if=/dev/zero of=${disk} bs=1M || true

echo "---------------------------------------------------------------"
echo "creating partitions"
echo "---------------------------------------------------------------"
[ -d /sys/firmware/efi ] && uefi=1
if [ $uefi -eq 1 ]; then
    sfdisk $disk <<EOF
    label: gpt
    ,512M,U,*
    ,,L
EOF
fi

echo "---------------------------------------------------------------"
echo "setup disk encryption"
echo "---------------------------------------------------------------"
echo -n "${encryption_pass}" | cryptsetup luksFormat --type luks1 ${disk}p2
echo -n "${encryption_pass}" | cryptsetup luksOpen ${disk}p2 void_enc
vgcreate void_enc /dev/mapper/void_enc
lvcreate --name root -L 20G void_enc
lvcreate --name swap -L 4G void_enc
lvcreate --name home -l 100%FREE void_enc

echo "---------------------------------------------------------------"
echo "creating filesystems"
echo "---------------------------------------------------------------"
mkfs.vfat ${disk}p1
mkfs.ext4 -L root /dev/void_enc/root
mkfs.ext4 -L root /dev/void_enc/home
mkswap /dev/void_enc/swap

echo "---------------------------------------------------------------"
echo "mounting filesystems"
echo "---------------------------------------------------------------"
mount /dev/void_enc/root /mnt
for dir in dev proc sys run; do mkdir -p /mnt/$dir ; mount --rbind /$dir /mnt/$dir ; mount --make-rslave /mnt/$dir ; done
mkdir -p /mnt/home
mkdir -p /mnt/boot/efi
mount /dev/void_enc/home /mnt/home
mount ${disk}p1 /mnt/boot/efi/

echo "---------------------------------------------------------------"
echo "setting repo keys"
echo "---------------------------------------------------------------"
mkdir -p /mnt/var/db/xbps/keys/
cp -a /var/db/xbps/keys/* /mnt/var/db/xbps/keys/

echo "---------------------------------------------------------------"
echo "installing base"
echo "---------------------------------------------------------------"
xbps-install -Sy -R https://repo-default.voidlinux.org/current -r /mnt base-system cryptsetup grub-x86_64-efi lvm2

blkid=$(blkid -o value -s UUID ${disk}p2)
echo "---------------------------------------------------------------"
echo "finalizing setup"
echo "---------------------------------------------------------------"
cat << EOF | chroot /mnt
chown root:root /
chmod 755 /
(echo ${root_pass}; echo ${root_pass}) | passwd
echo ${hostname} > /etc/hostname
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "en_US.UTF-8 UTF-8" >> /etc/default/libc-locales
xbps-reconfigure -f glibc-locales
ln -sf /etc/sv/dhcpcd /var/service/
useradd ${user_name}
usermod -a -G wheel,floppy,audio,video,cdrom,optical,storage,network,bluetooth,kvm ${user_name}
(echo ${user_pass}; echo ${user_pass}) | passwd ${user_name}

echo "${user_name} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

echo "KEYMAP=us" >> /etc/rc.conf
echo "TIMEZONE=Asia/Nicosia" >> /etc/rc.conf

echo "tmpfs               /tmp       tmpfs   defaults,nosuid,nodev 0  0" > /etc/fstab
echo "/dev/void_enc/root  /          ext4    defaults              0  0" >> /etc/fstab
echo "/dev/void_enc/home  /home      ext4    defaults              0  0" >> /etc/fstab
echo "/dev/void_enc/swap  swap       swap    defaults              0  0" >> /etc/fstab
echo "${disk}p1      /boot/efi  vfat    defaults              0  0" >> /etc/fstab

echo "GRUB_ENABLE_CRYPTODISK=y" > /etc/default/grub
echo "GRUB_DEFAULT=0" >> /etc/default/grub
echo "GRUB_TIMEOUT=5" >> /etc/default/grub
echo "GRUB_DISTRIBUTOR=\"Void\"" >> /etc/default/grub
echo "GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=4 slub_debug=P page_poison=1 rd.lvm.vg=void_enc rd.luks.uuid=${blkid}\"" >> /etc/default/grub

dd bs=1 count=64 if=/dev/urandom of=/boot/volume.key
echo -n "${encryption_pass}" | cryptsetup luksAddKey ${disk}p2 /boot/volume.key
chmod 000 /boot/volume.key
chmod -R g-rwx,o-rwx /boot

echo "void_enc   ${disk}p2   /boot/volume.key   luks" >> /etc/crypttab

echo "install_items+=\" /boot/volume.key /etc/crypttab \"" > /etc/dracut.conf.d/10-crypt.conf

grub-install ${disk}

xbps-reconfigure -fa
EOF

umount -R /mnt
echo "---------------------------------------------------------------"
echo "finished - reboot now"
echo "---------------------------------------------------------------"
