#!/bin/bash

cd iso
mount --bind /dev ./chroot/dev/
mount --bind /dev/pts ./chroot/dev/pts/
mount --bind /dev/shm ./chroot/dev/shm # REQUIRED
mount --bind /proc ./chroot/proc/
mount --bind /sys  ./chroot/sys/
mount --bind /run ./chroot/run # for x11 mouse and keyboard functioning!
chroot ./chroot

# when in live mode, internet connection : 
	# dhclient -v 
	# sudo apt-get install qtcreator etc. to tweak your debian installation to your needs.
	# 
	# exit
