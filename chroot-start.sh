#!/bin/bash

# This script has to copied by hand into the terminal in parts... Sorry guy's.

# Copy part 1 :
cd iso
sudo chroot ./chroot

# Copy Part 2 :
# Here, your are in the chroot of your Debian liveCD
mount none -t proc /proc
mount none -t sysfs /sys
mount none -t devpts /dev/pts
export HOME=/root
export LC_ALL=C
export PS1="\e[01;31m(live):\W \$ \e[00m"

# Copy part 3 :
# Here the tweak scripts is done !
	dhclient -v # establish the internet connection to this virtual environment.
	
	# Update the /etc/apt/sources.list
	echo "deb http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list	# add the debian 11 bullseye archive to our os.
	apt-get update # update the sources.list with the system
	apt-get full-upgrade # update to debian 11, this will take a while.
	
	# add the realtime kernel packages. For ethercat we need also the kernel header files.
	# We add dependencies for linuxcnc, opencascade cad and kdl kinematics.

	apt-get install dctrl-tools dkms \
	linux-image-5.10.0-4-rt-amd64 linux-headers-5.10.0-4-amd64 linux-headers-5.10.0-4-common linux-headers-amd64 \
	mercurial mercurial-common quilt live-build autoconf cmake make gcc geany build-essential \
	debhelper libudev-dev tcl8.6-dev tk8.6-dev libtk-img bwidget tclx8.4 \
	asciidoc dblatex docbook-xsl dvipng ghostscript graphviz groff imagemagick inkscape \
	source-highlight w3c-linkchecker xsltproc texlive-extra-utils texlive-font-utils texlive-fonts-recommended \
	texlive-lang-cyrillic texlive-lang-french texlive-lang-german texlive-lang-polish texlive-lang-spanish \
	python-tk libxmu-dev libgtk2.0-dev gettext intltool libboost-python-dev libmodbus-dev libusb-1.0-0-dev psmisc \
	source-highlight w3c-linkchecker texlive-font-utils texlive-lang-cyrillic \
	texlive-lang-french texlive-lang-german texlive-lang-polish texlive-lang-spanish libglu1-mesa-dev \
	libgl1-mesa-dev libgtk2.0-dev intltool libboost-python-dev libmodbus-dev libusb-1.0-0-dev psmisc \
	python-is-python2 python-dev-is-python2 python3-yapps libncurses-dev ncurses-doc \
	libboost-all-dev python3-tk libreadline-gplv2-dev libeigen3-dev deepin-calculator python-gtk2 \
	librecad 

	sudo apt-get upgrade

# Copy part 3 :
umount /proc /sys /dev/pts
exit
# exit chroot
cd ..

# This is how it looks like to be live :
#
# (live):/ $ mount none -t proc /proc
# (live):/ $ mount none -t sysfs /sys
# (live):/ $ mount none -t devpts /dev/pts
# (live):/ $ export HOME=/root
# (live):/ $ export LC_ALL=C
# (live):/ $ export PS1="\e[01;31m(live):\W \$ \e[00m"
# (live):/ $
# (live):/ $ dhclient -v 
# (live):/ $ sudo apt-get install qtcreator etc. to tweak your debian installation to your needs.
# (live):/ $
# (live):/ $
# (live):/ $ umount /proc /sys /dev/pts
# $ exit

# Reference : https://github.com/Oros42/CustomDebian
