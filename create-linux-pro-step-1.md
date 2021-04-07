

#### Update software list host pc:

    sudo su
	apt-get install live-build debootstrap squashfs-tools xorriso grub-pc-bin grub-efi-amd64-bin mtools isolinux xserver-xephyr dbus-x11 

#### Update sources list host pc:

	sudo su
	echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" > /etc/apt/sources.list 
	echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list 

	echo "deb http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list 
	echo "deb-src http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list 
	echo "deb http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list 
	echo "deb-src http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list 

	echo "deb http://deb.debian.org/debian buster main contrib non-free" >> /etc/apt/sources.list 
	echo "deb-src http://deb.debian.org/debian buster main contrib non-free" >> /etc/apt/sources.list 
	echo "deb http://security.debian.org/debian-security buster/updates main contrib" >> /etc/apt/sources.list 
	echo "deb-src http://security.debian.org/debian-security buster/updates main contrib" >> /etc/apt/sources.list
	apt-get update 

#### Easy way to create a iso:

	sudo su
	rm -rf auto
	rm -rf cache
	rm -rf chroot
	rm -rf config
	rm -rf local
	lb clean

	lb config \
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
	  
	echo task-xfce-desktop > $(pwd)/config/package-lists/desktop.list.chroot

	lb build
	
#### Copy iso to usb:
	sudo dd bs=4M if=live-image-amd64.hybrid.iso of=/dev/sdb conv=fdatasync status=progress

#### Unpack iso filesystem.squashfs:
	unsquashfs filesystem.squashfs
		
#### Chroot into /binary/squashfs-root/
	sudo su
	mount --bind /dev squashfs-root/dev
	mount --bind /dev/pts squashfs-root/dev/pts
	mount --bind /sys squashfs-root/sys
	mount --bind /proc squashfs-root/proc
	mount --bind /run squashfs-root/run
	mount --bind /run/udev squashfs-root/run/udev
	mount --bind /tmp squashfs-root/tmp
	mount --bind /var/lib squashfs-root/var/lib 
	mount --bind /etc squashfs-root/etc
	chroot squashfs-root /usr/bin/bash

	#### Or if xephyr display is given error, after mount's do a :
	chroot squashfs-root

#### In chroot now:

	export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
	export LC_ALL=C
	dhclient

#### Update sources list in chroot environment:

	echo "deb http://ftp.de.debian.org/debian bullseye main contrib non-free" > /etc/apt/sources.list 
	echo "deb-src http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list 
	echo "deb http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list 
	echo "deb-src http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list 

	echo "deb http://deb.debian.org/debian buster main contrib non-free" >> /etc/apt/sources.list 
	echo "deb-src http://deb.debian.org/debian buster main contrib non-free" >> /etc/apt/sources.list 
	echo "deb http://security.debian.org/debian-security buster/updates main contrib" >> /etc/apt/sources.list 
	echo "deb-src http://security.debian.org/debian-security buster/updates main contrib" >> /etc/apt/sources.list
	apt-get update 

#### For example add Kali's repository:
#### Download kali's keyring : 
	http://http.kali.org/kali/pool/main/k/kali-archive-keyring/kali-archive-keyring_2020.2_all.deb
#### Install kali's keyring : 
	dpkg -i kali-archive-keyring_2020.2_all.deb
#### Add kali's repository:
	echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" > /etc/apt/sources.list 
	echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list 
	apt-get update
	
#### Install software:
	apt-get dist-upgrade
	apt-get install xserver-xephyr dbus-x11 isolinux
	apt-get install inkscape live-build debootstrap squashfs-tools xorriso grub-pc-bin grub-efi-amd64-bin mtools 

#### Set up display in host pc, open up new terminal :
	Xephyr -ac -screen 1600x900 -br -reset -terminate 2> /dev/null :1 & 

#### Back to chroot terminal, start the xfce4 desktop environment:
	export DISPLAY=:1
	xclock
	# CNTRL+Z
	startxfce4 &  
	# If Xephyr is not starting look at the create-linux-pro-step-2.md file.
	
![root-environment](https://user-images.githubusercontent.com/44880102/113708243-fbecad00-96ae-11eb-99da-1c6622bcb8d7.png)
	
#### Set gui colors, theme, https://www.xfce-look.org/browse/cat/
#### Copy your favority theme to /usr/share/themes or borrow one from kali's theme's dir.
#### Open Settings > Appearance > Style to select the default theme.
#### https://forum.xfce.org/viewtopic.php?id=11119

#### Try creating a .desktop file in /etc/xdg/autostart with the following content:

	[Desktop Entry]
	Encoding=UTF-8
	Version=0.9.4
	Type=Application
	Name=Change Theme
	Comment=Change the theme on startup
	Exec=/usr/local/bin/change-theme
	OnlyShowIn=XFCE;
	StartupNotify=false
	Terminal=false
	Hidden=false

#### Create the file /usr/local/bin/change-theme with the content:

	#!/bin/bash
	xfconf-query -c xsettings -p /Net/ThemeName -s  "Kali-Dark"
	
#### Set the login screen theme (Kali-Dark) & background (color #23252e) in /etc/lightdm/lightdm-gtk-greeter.conf

#### Test command to change theme:
		xfconf-query -c xsettings -p /Net/ThemeName -s  "Xfce"
		
#### Desktop settings, copy /root/.config/xfce4/*   to /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/
	   
#### Replace boot background in /isolinux/splash.png (isolinux is used as starter)
#### Replace boot background in /boot/grub/splash.png 	
#### Edit colors in /isolinux/stdmenu.cfg

#### Close chroot environment, a reboot can be faster :
	exit
	mount
	umount -l /yourpath/dev

#### Repack filesystem:
	mksquashfs squashfs-root/ filesystem.squashfs -comp xz

#### Edit the ./disk/info file

#### Create iso:
	xorriso -as mkisofs -iso-level 3 -V 'Linux Pro' \
	-o Linux-Pro.iso -J -J -joliet-long -cache-inodes \
	-isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
	-b isolinux/isolinux.bin \
	-c isolinux/boot.cat -boot-load-size 4 -boot-info-table -no-emul-boot -eltorito-alt-boot \
	-e efi.img -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus .

#### Copy the remastered iso to usb:
	sudo dd bs=4M if=Linux-Pro.iso of=/dev/sdb conv=fdatasync status=progress









