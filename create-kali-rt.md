
Downloaded : http://cdimage.kali.org/kali-images/kali-2021.1/kali-linux-2021.1-live-amd64.iso

sudo dd bs=4M if=kali-linux-2021.1-live-amd64.iso of=/dev/sdb conv=fdatasync status=progress

as root :

cd /live
unsquashfs filesystem.squashfs

mount --bind /dev squashfs-root/dev
mount --bind /dev/pts squashfs-root/dev/pts
mount --bind /sys squashfs-root/sys
mount --bind /proc squashfs-root/proc
chroot squashfs-root
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export LC_ALL=C
dhclient

![chroot-login](https://user-images.githubusercontent.com/44880102/112771304-31333400-8ff9-11eb-93aa-355c770ae935.png)

