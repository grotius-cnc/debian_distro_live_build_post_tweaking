[![Download Linux Debian 11 Bullseye Rtos  ](https://a.fsdn.com/con/app/sf-download-button)](https://sourceforge.net/projects/linux-debian-bullseye-11-rtos/files/latest/download)\
[![Download Linux Mint 19 StormHold  Rtos ](https://img.shields.io/sourceforge/dt/linux-mint-rtos.svg)](https://sourceforge.net/projects/linux-mint-rtos/files/latest/download)

Another attempt to update the kernel as chroot.
This attempt worked !

Fresh host system install from usb, to ensure we have a correct starting point, and our host system will be the same as our target os.
*https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/weekly-live-builds/amd64/iso-hybrid/debian-live-testing-amd64-xfce+nonfree.iso*

#### Add sources :

	sudo echo "deb http://ftp.de.debian.org/debian bullseye main contrib non-free" > /etc/apt/sources.list 
	sudo echo "deb-src http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list
	sudo echo "deb http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list
	sudo echo "deb-src http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list
	# For newest kernels :
        echo "deb http://deb.debian.org/debian sid main contrib non-free" >> /etc/apt/sources.list
        echo "deb-src http://deb.debian.org/debian sid main contrib non-free" >> /etc/apt/sources.list
    
	sudo apt-get update 

	sudo apt-get install linux-image-5.10.0-5-rt-amd64

#### Reboot. Started in new kernel, remove old kernel :

	sudo apt-get remove linux-image-5.10.0-4-amd64

#### Reboot. Everything ok.

	mount

Saved output to a textfile "original-mount.txt", 20 mountpoints in file, this to check if later umount is correct.

#### Install programs as Chroot :

	sudo apt-get install squashfs-tools xorriso isolinux geany
	
	mkdir /home
	cd home
	apt-get install git autoconf
	git clone https://github.com/LinuxCNC/linuxcnc.git
	cd /home/linuxcnc/debian
	./configure uspace

	cd /home/linuxcnc/
	dpkg-checkbuilddeps

	echo "deb http://deb.debian.org/debian buster main contrib non-free" > /etc/apt/sources.list
	echo "deb-src http://deb.debian.org/debian buster main contrib non-free" >> /etc/apt/sources.list
	echo "deb http://security.debian.org/debian-security buster/updates main contrib" >> /etc/apt/sources.list
	echo "deb-src http://security.debian.org/debian-security buster/updates main contrib" >> /etc/apt/sources.list

	sudo echo "deb http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list 
	sudo echo "deb-src http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list
	sudo echo "deb http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list
	sudo echo "deb-src http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list
	apt-get update

	apt-get install debhelper libudev-dev tcl8.6-dev tk8.6-dev libtk-img bwidget tclx 
	apt-get install asciidoc dblatex docbook-xsl dvipng ghostscript graphviz groff imagemagick inkscape python-lxml 
	apt-get install source-highlight w3c-linkchecker xsltproc texlive-extra-utils texlive-font-utils texlive-fonts-recommended 
	apt-get install texlive-lang-cyrillic texlive-lang-french texlive-lang-german texlive-lang-polish texlive-lang-spanish 
	apt-get install texlive-latex-recommended  python-tk libxmu-dev libglu1-mesa-dev libgl1-mesa-dev
	apt-get install libgtk2.0-dev gettext intltool libboost-python-dev netcat libmodbus-dev yapps2
	apt-get install libreadline-gplv2-dev python2-dev python-gtk2
	apt-get install python-gtk2 python-is-python2 python-dev-is-python2 
	apt-get install python3-tk wget

	cd /home/linuxcnc/src
	./autogen.sh
	./configure --with-python=python3
	make -j2

	#### If it compiles oke. We know dependencies for linuxcnc are ok.


	#### Install linuxcnc.deb package to /opt/
	cd /home/software
	wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.1/linuxcnc.deb
	dpkg -i linuxcnc.deb


	#### Install ethercat-master

	# For newer kernels activate the sid repository, otherwise :
	apt-get install linux-headers-$(uname -r)

	cd /home/software
	wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.0/ethercat-master.deb
	dpkg -i ethercat-master.deb

	# To be sure
	chmod 777 /etc/sysconfig/ethercat
	chmod 777 /etc/init.d/ethercat

	# Set the crontab -e parameters to boot ethercat at pc's boot time
	sudo crontab -e

	@reboot echo MASTER0_DEVICE="$(cat /sys/class/net/enp0s25/address)" > /etc/sysconfig/ethercat 
	@reboot echo "DEVICE_MODULES=generic" >> /etc/sysconfig/ethercat 
	@reboot /etc/init.d/ethercat start

	# Install linuxcnc-ethercat
	cd /home/software
	wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.3/linuxcnc-ethercat.deb
	dpkg -i linuxcnc-ethercat.deb

	# Qtvcp libs.
	apt-get install qttools5-dev-tools qttools5.dev

	# Calculator
	apt-get install qalculate

	# Install qt
	cd /home/software
	wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.2/qt-creator.deb
	dpkg -i qt-creator.deb

	# Delete temp sources
	rm -rf /home/software

	# Exit chroot environent.
	umount /dev /dev/pts /sys /proc  # umount /dev gives the message "busy.." 
	exit
	# Reboot host pc

#### Unsquash original dvd /live/filesystem.squashfs

Copy the iso file from your usb to your system dir, including the hidden file ./disk

1. Make a /original directory, copy the usb files to here.
2. Make a /remastered directory. copy the usb files to here.

In the /remasterd/live dir do "as root" :  
  
    sudo unsquashfs filesystem.squashfs

This will produce the directory : /remasterd/live/squashfs-root/ 
Remove the original filesystem.squashfs file in /remastered/live/ :

    rm -rf filesystem.squashfs

#### Chroot

In /remastered/live/ do as root :

    mount --bind /dev squashfs-root/dev
    mount --bind /dev/pts squashfs-root/dev/pts
    mount --bind /sys squashfs-root/sys
    mount --bind /proc squashfs-root/proc
    chroot squashfs-root
    export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    export LC_ALL=C
    dhclient
    echo "deb http://ftp.de.debian.org/debian bullseye main contrib non-free" > /etc/apt/sources.list 
    echo "deb-src http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list
    echo "deb http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list
    echo "deb-src http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list
    
    # For newest kernels :
    echo "deb http://deb.debian.org/debian sid main contrib non-free" >> /etc/apt/sources.list
    echo "deb-src http://deb.debian.org/debian sid main contrib non-free" >> /etc/apt/sources.list
    
    apt-get update
    apt-get install linux-image-5.10.0-5-rt-amd64 # Install new kernel.
    apt autoremove
    apt-get remove linux-image-5.10.0-4-amd64 # Remove old kernel.
    apt-get install squashfs-tools xorriso isolinux geany # Add some extra programs to test.

    umount /dev /dev/pts /sys /proc  # umount /dev gives the message "busy.." 
    exit
    mount
  
Save the mount output to "remastered-mount.txt".
Compare previous saved "original-mount.txt" with "remastered-mount.txt".
 
In my case the "remastered-mount.txt" file has 2 mount positions to much. I did a reboot and check.
I solved it by :

    sudo umount /sys/kernel/debug/tracing

#### Copy the new initrd, vmlinuz, config, system.map to a higher directory in the hierarchy.

    cp /live/squashfs-root/boot/* /live
    
or :    

    sudo cp /live/squashfs-root/boot/config-5.10.0-4-rt-amd64 /live/config-5.10.0-4-rt-amd64 
    sudo cp /live/squashfs-root/boot/initrd.img-5.10.0-4-rt-amd64 /live/initrd.img-5.10.0-4-rt-amd64
    sudo cp /live/squashfs-root/boot/System.map-5.10.0-4-rt-amd64 /live/System.map-5.10.0-4-rt-amd64
    sudo cp /live/squashfs-root/boot/live/vmlinuz-5.10.0-4-rt-amd64 /live/vmlinuz-5.10.0-4-rt-amd64

#### Repack the squashfs-root dir.
	
    mksquashfs squashfs-root/ filesystem.squashfs -comp xz
    
    note : the filesystem.squashfs is limited to 4gb. The pack ratio = 2.95
    If your squashfs-root directory = 13 Gb, the packet filesystem.squashfs will be : 4.4 Gb = 13/4.4=2.95.
    So for 4gb your squashfs-root dir may be max 11.8 Gb.

#### Remove or move the modified squashfs-root directory out of the new iso hierarchy.

    rm -rf /remastered/live/squashfs-root

#### Replace the grub.cfg file

    cp /boot/grub/grub.cfg /remastered/boot/grub/

#### Edit the info file in /remastered/.disk/info

    Debian 11 Bullseye Rtos

#### Create new iso /remastered/

    xorriso -as mkisofs -V 'Debian 11 Bullseye Rtos' \
    -o Debian-11-Bullseye-Rtos.iso -J -J -joliet-long -cache-inodes \
    -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
    -b isolinux/isolinux.bin \
    -c isolinux/boot.cat -boot-load-size 4 -boot-info-table -no-emul-boot -eltorito-alt-boot \
    -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus .

#### Put the new iso file on your usb device in /remastered/

    sudo dd bs=4M if=Debian-11-Bullseye-Rtos.iso of=/dev/sdb conv=fdatasync status=progress

#### Install new iso file onto a pc, terminal output :

	user@debian:~$ uname -a
	Linux debian 5.10.0-4-rt-amd64 #1 SMP PREEMPT_RT Debian 5.10.19-1 (2021-03-02) x86_64 GNU/Linux
	user@debian:~$ 
	
So it worked ! Also geany is present in the system menu. I am happy !!!	

[![Download Linux Debian 11 Bullseye Rtos  ](https://a.fsdn.com/con/app/sf-download-button)](https://sourceforge.net/projects/linux-debian-bullseye-11-rtos/files/latest/download)







