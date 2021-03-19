#!/bin/bash

# This is a testfile. Id did not work the last time i used it.

DIR="$(pwd)"

# if the iso builder is not present, install it.
apt-get install live-build debootstrap squashfs-tools xorriso grub-pc-bin grub-efi-amd64-bin mtools isolinux

# The skynet directory will hold the final hybrid ISO. This live-build process takes about 4-6 hours.
mkdir -p iso
cd iso

rm -rf auto
rm -rf cache
rm -rf chroot
rm -rf config
rm -rf local
lb clean

# Check if your kernel sources are not outdated, older kernels may be deleted from current source list :
# https://packages.debian.org/stable/

lb config \
  --binary-images iso-hybrid \
  --mode debian \
  --architectures amd64 \
  --distribution bullseye \
  --archive-areas "main contrib non-free" \
  --apt-recommends false \
  --debian-installer live \
  --debian-installer-gui true \
  --win32-loader false \
  --iso-application skynet \
  --iso-preparer grotius \
  --iso-publisher grotius \
  --iso-volume skynet \
  --apt-secure false 
  
  
echo "deb http://ftp.de.debian.org/debian bullseye main contrib non-free" > $DIR/iso/config/archives/live.list.chroot 
echo "deb-src http://ftp.de.debian.org/debian bullseye main contrib non-free" >> $DIR/iso/config/archives/live.list.chroot
echo "deb http://security.debian.org/debian-security/ bullseye-security main" >> $DIR/iso/config/archives/live.list.chroot
echo "deb-src http://security.debian.org/debian-security/ bullseye-security main" >> $DIR/iso/config/archives/live.list.chroot

# sources for libreadline are coming from older repository.
#echo "deb http://deb.debian.org/debian buster main contrib non-free" >> $DIR/iso/config/archives/live.list.chroot
#echo "deb-src http://deb.debian.org/debian buster main contrib non-free" >> $DIR/iso/config/archives/live.list.chroot
#echo "deb http://security.debian.org/debian-security buster/updates main contrib" >> $DIR/iso/config/archives/live.list.chroot
#echo "deb-src http://security.debian.org/debian-security buster/updates main contrib" >> $DIR/iso/config/archives/live.list.chroot
  
echo task-xfce-desktop > config/package-lists/desktop.list.chroot
  
#--linux-packages linux-image-5.10.0-4-rt \

#echo linux-headers-5.10.0-4-rt-amd64 > $DIR/iso/config/package-lists/packages.list.chroot
  
#echo dctrl-tools dkms \
#mercurial mercurial-common quilt live-build autoconf cmake make gcc geany build-essential \
#debhelper libudev-dev tcl8.6-dev tk8.6-dev libtk-img bwidget tclx8.4 \
#asciidoc dblatex docbook-xsl dvipng ghostscript graphviz groff imagemagick inkscape \
#source-highlight w3c-linkchecker xsltproc texlive-extra-utils texlive-font-utils texlive-fonts-recommended \
#texlive-lang-cyrillic texlive-lang-french texlive-lang-german texlive-lang-polish texlive-lang-spanish \
#python-tk libxmu-dev libgtk2.0-dev gettext intltool libboost-python-dev libmodbus-dev libusb-1.0-0-dev psmisc \
#source-highlight w3c-linkchecker texlive-font-utils texlive-lang-cyrillic \
#texlive-lang-french texlive-lang-german texlive-lang-polish texlive-lang-spanish libglu1-mesa-dev \
#libgl1-mesa-dev libgtk2.0-dev intltool libboost-python-dev libmodbus-dev libusb-1.0-0-dev psmisc \
#python-is-python2 python-dev-is-python2 python3-yapps libncurses-dev ncurses-doc \
#libboost-all-dev python3-tk libeigen3-dev deepin-calculator \
#librecad git pciutils yapps2 > $DIR/iso/config/package-lists/program.list.chroot

# Iso Offline installer
#echo grub-common grub2-common grub-pc-bin efibootmgr grub-efi-amd64 \
#grub-efi-amd64-bin grub-efi-amd64-signed grub-efi-ia32-bin \
#libefiboot1 libefivar1 mokutil shim-helpers-amd64-signed \
#shim-signed-common shim-unsigned > $DIR/iso/config/package-lists/grubuefi.list.binary

lb build















