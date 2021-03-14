
#!/bin/bash

# To execute this file after cloning from github, make it executable. $ chmod 777 create-live-build.sh

# This script is to build Debian 11 Bullseye with RealTime kernel.
# This script is not tested yet.

DIR="$(pwd)"

# Without the correct sources, the iso will be build withour error. During the final install you get a error.
# This methode is overwriting the /etc/apt/sources.list
echo "deb http://ftp.de.debian.org/debian buster main contrib non-free" > /etc/apt/sources.list # > = only this text in the file
echo "deb http://security.debian.org/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list # >> = append
echo "deb-src http://security.debian.org/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list # >> = append
echo "deb http://ftp.de.debian.org/debian bullseye main" >> /etc/apt/sources.list # >> = append
apt-get update # update the sources.list with the system

# if the iso builder is not present, install it.
apt-get install live-build debootstrap squashfs-tools xorriso grub-pc-bin grub-efi-amd64-bin mtools isolinux
# isolinux is needed in the xorriso build command and refers to : /usr/lib/ISOLINUX/isohdpfx.bin
# wich is standard not included in debian at the moment.

# The skynet directory will hold the final hybrid ISO. This live-build process takes about 4-6 hours.
mkdir -p iso
cd iso

rm -rf auto
rm -rf cache
rm -rf chroot
rm -rf config
rm -rf local
lb clean

# Now testing this command with "--debian-installer true" instead of "--debian-installer live"
# Find your kernel : https://packages.debian.org/bullseye/kernel/
# lb config manual : https://manpages.debian.org/buster/live-build/lb_config.1.en.html
# --security false, this because the security repository's have no release file, build error.

lb config \
  --linux-packages linux-image-5.10.0-4-rt \
  --binary-images iso-hybrid \
  --mode debian \
  --architectures amd64 \
  --linux-flavours amd64 \
  --distribution bullseye \
  --archive-areas "main contrib non-free" \
  --updates true \
  --security false \
  --cache true \
  --apt-recommends true \
  --debian-installer true \
  --debian-installer-gui true \
  --win32-loader false \
  --iso-application skynet \
  --iso-preparer grotius \
  --iso-publisher grotius \
  --iso-volume skynet \


################################### DESKTOP ENVIRONMENT ##########################################################
#
#	The desktop environment is up to the user.

	mkdir -p $DIR/iso/config/package-lists/
	echo task-xfce-desktop > $DIR/iso/config/package-lists/desktop.list.chroot

# Iso Offline installer
	echo grub-common grub2-common grub-pc-bin efibootmgr grub-efi-amd64 grub-efi-amd64-bin \
	grub-efi-amd64-signed grub-efi-ia32-bin libefiboot1 libefivar1 mokutil shim-helpers-amd64-signed shim-signed-common \
	shim-unsigned > $DIR/iso/config/package-lists/grubuefi.list.binary

lb build






