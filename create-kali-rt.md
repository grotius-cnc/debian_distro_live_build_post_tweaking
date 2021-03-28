
Downloaded : http://cdimage.kali.org/kali-images/kali-2021.1/kali-linux-2021.1-live-amd64.iso

sudo dd bs=4M if=kali-linux-2021.1-live-amd64.iso of=/dev/sdb conv=fdatasync status=progress

cd /live
sudo unsquashfs filesystem.squashfs
