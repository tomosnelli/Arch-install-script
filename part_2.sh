bash set_env.sh
ls /usr/share/zoneinfo
echo -n "Enter Country: "
read country
ls /usr/share/zoneinfo/$country
echo -n "Enter timezone: "
read timezone
ln -sf /usr/share/zoneinfo/$country/$timezone /etc/localtime
hwclock --systohc
# run python script here for /etc/locale.gen
yes | pacman -S python
python locale.py
locale-gen
touch /etc/locale.conf && echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "Generated locale and set language"
mkdir /etc/hostname
echo -n "Enter name for your computer: "
read hostname
echo $hostname >> /etc/hostname
echo -e "127.0.0.1	localhost\n::1	localhost\n127.0.1.1	$hostname.localdomain	$hostname" >> /etc/hosts
echo -n "Set your root password: "
read -s password
passwd << EOF
$password
$password
EOF
yes | pacman -S sudo
echo "Create a normal user."
echo -n "Enter user name: "
read $name
useradd -m $name
echo -n "Set password for $name: "
read -s user_password
password $name << EOF
$user_password
$user_password
EOF
usermod -aG wheel,audio,video,optical,storage $name
# edit sudoers with python script
python edit_sudoers.py

# install and setup grub for efi boot. Almost done!
yes | pacman -S grub efibootmgr dosfstools os-prober mtools networkmanager git vim
mkdir /boot/EFI
# carefull of this line. modify to path of selected disk before running
mount ${DISK}1 /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager
# reboot time
exit
# after exit...
# umount -l /mnt
# and umount the initially mounted usb drive
# then reboot!
