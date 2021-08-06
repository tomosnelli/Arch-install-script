# this part is manual
# mkdir script
# mount /dev/sda script
# end of manual part
timedatectl set-ntp true
fdisk -l
echo -n "Enter Disk path: "
read diskPath
echo "Enter Partition size. Format is '+#M', '+#G'"
echo -n "Boot partition size (260M or more): "
read bootSize
echo -n "Swap partition size (RAM size or RAM*2 is recommended): "
read swapSize
echo "Root partition will take the reset of disk space"
fdisk $diskPath <<EOF
d

d

d

g
n
1

$bootSize
n
2

$swapSize

n
3


t
1
1
t
2
19
w
EOF
mkfs.fat -F 32 ${diskPath}1
mkswap ${diskPath}2
swapon ${diskPath}2
mkfs.ext4 ${diskPath}3
mount ${diskPath}3 /mnt
# need to mount usb disk other than /mnt
pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
# need to copy files to /mnt here to avoid them being overwritten
cp /root/script/install_script/locale.py /mnt
cp /root/script/install_script/part_2.sh /mnt
cp /root/script/install_script/edit_sudoers.py /mnt
echo "export DISK=$diskPath" >> /mnt/set_env.sh
arch-chroot /mnt
