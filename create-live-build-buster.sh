#!/bin/bash

DIR="$(pwd)"

# Without the correct sources, the iso will be build withour error. During the final install you get a error.
# Update the /etc/apt/sources.list
echo "deb http://ftp.de.debian.org/debian buster main contrib non-free" > /etc/apt/sources.list # > = only this text in the file
echo "deb http://security.debian.org/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list # >> = append
echo "deb-src http://security.debian.org/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list # >> = append
apt-get update # update the sources.list with the system

# if the iso builder is not present, install it.
apt-get install live-build debootstrap squashfs-tools xorriso grub-pc-bin grub-efi-amd64-bin mtools isolinux

# The skynet directory will hold the final hybrid ISO. This live-build process takes about 4-6 hours.
mkdir -p skynet
cd skynet

rm -rf auto
rm -rf cache
rm -rf chroot
rm -rf config
rm -rf local
lb clean

lb config \
  --linux-packages linux-image-4.19.0-12-rt \
  --binary-images iso-hybrid \
  --mode debian \
  --architectures amd64 \
  --linux-flavours amd64 \
  --distribution buster \
  --archive-areas "main contrib non-free" \
  --updates true \
  --security true \
  --cache true \
  --apt-recommends true \
  --debian-installer live \
  --debian-installer-gui true \
  --win32-loader false \
  --iso-application skynet \
  --iso-preparer grotius \
  --iso-publisher grotius \
  --iso-volume skynet \
  
mkdir -p $DIR/skynet/config/package-lists/
echo task-xfce-desktop > $DIR/skynet/config/package-lists/desktop.list.chroot

echo linux-headers-4.19.0-12-common-rt linux-headers-4.19.0-12-rt-amd64  > $DIR/skynet/config/package-lists/packages.list.chroot

# Iso Offline installer
echo grub-common grub2-common grub-pc-bin efibootmgr grub-efi-amd64 \
grub-efi-amd64-bin grub-efi-amd64-signed grub-efi-ia32-bin \
libefiboot1 libefivar1 mokutil shim-helpers-amd64-signed \
shim-signed-common shim-unsigned > $DIR/skynet/config/package-lists/grubuefi.list.binary

lb build



















