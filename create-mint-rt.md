#### https://gnipsel.com/linuxcnc/uspace/linuxmint19-rt.html
#### Dowload iso cd, burn it on a usb storage device and follow the steps : 
#### https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/blob/main/create-bullseye-rt.md

#### To get internet as chroot in mint.
	host pc file : /etc/resolv.conf
	copy this file to your unpacked iso, squashfs-root/etc/ 
	
#### Chroot

	mount --bind /dev squashfs-root/dev
	mount --bind /dev/pts squashfs-root/dev/pts
	mount --bind /sys squashfs-root/sys
	mount --bind /proc squashfs-root/proc
	chroot squashfs-root
	export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
	export LC_ALL=C
	
	ping www.google.nl  (cntr+z to stop)

	echo"deb http://packages.linuxmint.com rafaela main upstream import" > /etc/apt/sources.list
	echo"deb http://extra.linuxmint.com rafaela main" >> /etc/apt/sources.list
	echo"deb http://archive.ubuntu.com/ubuntu trusty main restricted universe multiverse" >> /etc/apt/sources.list
	echo"deb http://archive.ubuntu.com/ubuntu trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list
	echo"deb http://security.ubuntu.com/ubuntu/ trusty-security main restricted universe multiverse" >> /etc/apt/sources.list
	echo"deb http://archive.canonical.com/ubuntu/ trusty partner" >> /etc/apt/sources.list

	apt-get update

	apt-get install -y build-essential bin86 kernel-package libssl-dev
	apt-get install -y libqt4-dev libncurses5-dev pkg-config

	mkdir -p /home/rtlinux && cd /home/rtlinux

#### Find some kernels, this is a gamble for me.
    wget https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.11.4.tar.xz \
    https://mirrors.edge.kernel.org/pub/linux/kernel/projects/rt/5.11/patch-5.11.4-rt11.patch.gz

    tar -xpf linux-5.11.4.tar.xz
    gunzip patch-5.11.4-rt11.patch.gz
    cp patch-5.11.4-rt11.patch linux-5.11.4
    cd linux-5.11.4
    cat patch-5.11.4-rt11.patch | patch -p1

#### Needed by xconfig
    apt-get install qt5-default qttools5-dev-tools qttools5-dev

#### X display needed by xconfig. Let's install one.
    apt-get install dbus-x11 xorg xinit xnest

#### I did this in the chroot environment and in the host system environment, somehow when "make xconfig" was done a x window popped up.
    xhost +local:
    echo $DISPLAY
    export DISPLAY=:0

    make xconfig
  
#### Now you are in the kernel configurator window, this seems to be oke configured for preempt rt, i selected also "enable parport" and closed the window.
    apt-get install libelf-dev
    make -j2

    sudo make modules_install
    sudo make install

    update-grub

    umount /dev /dev/pts /sys /proc
    exit
    cd

#### Reboot host pc, to be sure. Copy some file's higher in file hierargy
    cp /casper/squashfs-root/boot/initrd.img-5.11.4-rt11 /casper
    cp /casper/squashfs-root/boot/vmlinuz-5.11.4-rt11 /casper
    cp /casper/squashfs-root/boot/config-5.11.4-rt11 /casper
    cp /casper/squashfs-root/boot/System.map-5.11.4-rt11 /casper

#### Repack the iso.
    mksquashfs squashfs-root/ filesystem.squashfs -comp xz

#### Edit /.disk/info
    Linux Mint 19.1 Rtos

#### Create new iso in top level dir :
    xorriso -as mkisofs -V 'Linux Mint 19.1 Rtos' \
    -o Linux-Mint-19.1-Rtos.iso -J -J -joliet-long -cache-inodes \
    -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
    -b isolinux/isolinux.bin \
    -c isolinux/boot.cat -boot-load-size 4 -boot-info-table -no-emul-boot -eltorito-alt-boot \
    -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus .

#### Output 2.2Gb iso. 
#### Output 2.1Gb filesystem.squashfs on iso with a max to 4Gb = ((4 max - 2.1 used ) * 2.7 ratio) = 5.13 Gb may be extra used.

#### Put it on a usb storage device.
    sudo dd bs=4M if=Linux-Mint-19.1-Rtos.iso of=/dev/sdb conv=fdatasync status=progress

#### For info, files in the same dir, no need to remove original :
	/remasterd/casper/initrd.lz #original
	/remasterd/casper/initrd.img-5.11.4-rt11
	/remasterd/casper/vmlinuz #original
	/remasterd/casper/vmlinuz-5.11.4-rt11
	/remasterd/casper/System.map-5.11.4-rt11
	/remasterd/casper/config-5.11.4-rt11
	/remasterd/casper/filesystem.squashfs
	
	These files are still original :
	/remastered/boot/grub/crub.cfg
	/remastered/boot/grub/loopback.cfg
	/remastered/isolinux/isolinux.cfg

#### Todo :
	Install linuxcnc and ethercat.
	Test one time more.

#### Second login as chroot :

#### this is my second login after iso was oke.

#### Add linuxcnc 
	sudo apt-key adv --keyserver hkp://keys.gnupg.net:80 --recv-key EF1B07FEE0EE663E
	sudo apt-add-repository 'deb http://buildbot.linuxcnc.org/ stretch master-rtpreempt' # or add it with echo ..
	sudo apt-get update
	sudo apt-get -y install linuxcnc-uspace
	sudo apt-get -y install linuxcnc-uspace-dev

#### Add ethercat-master
	apt-get install git autoconf libtool thunar

	cd /home
	git clone https://gitlab.com/etherlab.org/ethercat.git ethercat-master
	    cd ethercat-master
	    git checkout stable-1.5 
	    ./bootstrap
	    ./configure --help

		# error :
		# --with-linux-dir=<DIR>  Linux kernel sources [running kernel]
		# This was tricky.. The kernel headers where in the /home dir because we compiled a custom kernel over there, normal they are in /usr/src/
		# The configure script will find the headers normally in /usr/src/

	    ./configure --enable-generic --disable-8139too --with-linux-dir=/home/rtlinux/linux-5.11.4/
	    make
	    make all modules
	    make modules_install install
	    # depmod 
	    
	    # to be sure :
		chmod 777 /etc/init.d/ethercat 
	    
#### Run a script at boot time
	sudo crontab -e

	@reboot echo MASTER0_DEVICE="$(cat /sys/class/net/enp0s25/address)" > /etc/sysconfig/ethercat 
	@reboot echo "DEVICE_MODULES=generic" >> /etc/sysconfig/ethercat 
	@reboot /etc/init.d/ethercat start
	
#### Install linuxcnc-ethercat

        cd /home
	git clone https://github.com/grotius-cnc/linuxcnc-ethercat.git
	cd linuxcnc-ethercat
	nano configure.mk
	# Line 1 : COMP=/usr/bin/halcompile
	make
	
	# error : expat.h not found. I suggest we miss a library.
	
	sudo apt-get install dctrl-tools dkms autoconf cmake make gcc build-essential debhelper
	sudo apt-get install libudev-dev tcl8.6-dev tk8.6-dev libtk-img bwidget tclx8.4 asciidoc dblatex # in this line a dep is libexpat1.
	
	make
	make install
	
	# Copy lcec.so to linuxcnc rtlib.
	cp /home/linuxcnc-ethercat/src/lcec.so /usr/lib/linuxcnc/modules/
	
#### Create a configuration testfile

	mkdir /home/ethercat-bus-test
	cd /home/ethercat-bus-test
	
        touch /home/ethercat-bus-test/ethercat-conf.xml 
	nano /home/ethercat-bus-test/ethercat-conf.xml 
	
		<masters>
		<master idx="0" appTimePeriod="15000" refClockSyncCycles="1000000">
		<slave idx="0" type="EK1100" name="Terminal"/>
		<slave idx="1" type="EL2124" name="output_stepper_1"/>
		<slave idx="2" type="EL2124" name="output_stepper_2"/>
		</master>
		</masters>
		
	touch /home/ethercat-bus-test/commands.txt
	nano /home/ethercat-bus-test/commands.txt

		$ halshow
		halcmd:
		> loadrt threads name1=base-thread fp1=0 period1=15000 name2=servo-thread period2=1000000
		> loadusr -W /home/linuxcnc-ethercat/src/lcec_conf /home/ethercat-bus-test/ethercat-conf.xml 
		> loadrt lcec

#### Done. Let's repack and test the iso.

	# Repack the squashfs-root dir into a filesystem.squashfs, put the dir outside the iso folder
	mksquashfs squashfs-root/ filesystem.squashfs -comp xz

	# Edit /.disk/info
	Linux Mint 19.1 Rtos Lcnc Ethcat

	# Create iso
	xorriso -as mkisofs -V 'Linux Mint 19.1 Rtos Lcnc Ethcat' \
	-o Linux-Mint-19.1-Rtos-Lcnc-Ethcat.iso -J -J -joliet-long -cache-inodes \
	-isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
	-b isolinux/isolinux.bin \
	-c isolinux/boot.cat -boot-load-size 4 -boot-info-table -no-emul-boot -eltorito-alt-boot \
	-e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus .

	 # Copy iso to usb storage device   
	 sudo dd bs=4M if=Linux-Mint-19.1-Rtos-Lcnc-Ethcat.iso of=/dev/sdb conv=fdatasync status=progress
	 
#### The product for download, don't forget to subscribe and hit the bell.

 	https://sourceforge.net/projects/temponary/files/Linux-Mint-19.1-Rtos-Lcnc-Ethcat.iso/download

