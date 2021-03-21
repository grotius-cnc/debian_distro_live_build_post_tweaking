Another attempt to update the kernel as chroot.
This attempt worked !

Fresh host system install from usb, to ensure we have a correct starting point, and our host system will be the same as our target os.
*https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/weekly-live-builds/amd64/iso-hybrid/debian-live-testing-amd64-xfce+nonfree.iso*

#### Add sources :

	sudo echo "deb http://ftp.de.debian.org/debian bullseye main contrib non-free" > /etc/apt/sources.list 
	sudo echo "deb-src http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list
	sudo echo "deb http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list
	sudo echo "deb-src http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list
	sudo apt-get update 

	sudo apt-get install linux-image-5.10.0-4-rt-amd64

#### Reboot. Started in new kernel, remove old kernel :

	sudo apt-get remove linux-image-5.10.0-4-amd64

#### Reboot. Everything ok.

	mount

Saved output to a textfile "original-mount.txt", 20 mountpoints in file, this to check if later umount is correct.

#### Install programs:

	sudo apt-get install squashfs-tools xorriso isolinux geany

#### Unsquash original dvd /live/filesystem.squashfs

Copy the iso file from your usb to your system dir, including the hidden file ./disk

1. Make a /original directory, copy the usb files to here.
2. Make a /remastered directory. copy the usb files to here.

In the /remasterd/live dir do "as root" :  
  
    unsquashfs filesystem.squashfs

This will produce the directory : /remasterd/live/squashfs-root/ 
Remove the original filesystem.squashfs file in /remastered/live/ :

    rm -rf filesystem.squashfs

#### Chroot

In /remastered/live/ do :

    mount --bind /dev squashfs-root/dev
    mount --bind /dev/pts squashfs-root/dev/pts
    mount --bind /sys squashfs-root/sys
    mount --bind /proc squashfs-root/proc
    chroot squashfs-root
    export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    export LC_ALL=C
    dhclient
    sudo echo "deb http://ftp.de.debian.org/debian bullseye main contrib non-free" > /etc/apt/sources.list 
    sudo echo "deb-src http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list
    sudo echo "deb http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list
    sudo echo "deb-src http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list
    apt-get update
    apt-get install linux-image-5.10.0-4-rt-amd64 # Install new kernel.
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

#### Todo, add dependencies :

	as chroot, update /etc/apt/sources.list
	
	apt-get install linux-headers-5.10.0-4-rt-amd64
  
	apt-get install dctrl-tools dkms \
	mercurial mercurial-common quilt live-build autoconf cmake make gcc geany build-essential \
	debhelper libudev-dev tcl8.6-dev tk8.6-foodev libtk-img bwidget tclx8.4 \
	asciidoc dblatex docbook-xsl dvipng ghostscript graphviz groff imagemagick inkscape \
	source-highlight w3c-linkchecker xsltproc texlive-extra-utils texlive-font-utils texlive-fonts-recommended \
	texlive-lang-cyrillic texlive-lang-french texlive-lang-german texlive-lang-polish texlive-lang-spanish \
	python-tk libxmu-dev libgtk2.0-dev gettext intltool libboost-python-dev libmodbus-dev libusb-1.0-0-dev psmisc \
	source-highlight w3c-linkchecker texlive-font-utils texlive-lang-cyrillic \
	texlive-lang-french texlive-lang-german texlive-lang-polish texlive-lang-spanish libglu1-mesa-dev \
	libgl1-mesa-dev libgtk2.0-dev intltool libboost-python-dev libmodbus-dev libusb-1.0-0-dev psmisc \
	python-is-python2 python-dev-is-python2 python3-yapps libncurses-dev ncurses-doc \
	libboost-all-dev python3-tk libeigen3-dev deepin-calculator \
	librecad git pciutils yapps2 
	
#### Todo, install ethercat bus system.. This can be a hard time !

	This should be included into the iso as a directory that has a desktop launcher to set the mac adress.
	Proposed into the /opt/ folder.
	
	# https://sourceforge.net/u/uecasm/etherlab-patches/ci/default/tree/
	echo "[extensions]" >> /etc/mercurial/hgrc
	echo "mq =" >> /etc/mercurial/hgrc

	hg clone -u 33b922ec1871 http://hg.code.sf.net/p/etherlabmaster/code etherlab
	hg clone http://hg.code.sf.net/u/uecasm/etherlab-patches etherlab/.hg/patches

	cd etherlab
	hg qpush -a

	./bootstrap
	# ./configure --help
        ./configure --enable-generic --disable-8139too 
	make
	make all modules
	
Produces error :
		/home/user/etherlab/master/device.h:95:20: error: field ‘timeval_poll’ has incomplete type
		95 |     struct timeval timeval_poll;
		|                    ^~~~~~~~~~~~
		/home/user/etherlab/master/cdev.c:91:14: error: initialization of ‘vm_fault_t (*)(struct vm_fault *)’ 
		{aka ‘unsigned int 		(*)(struct vm_fault *)’} from incompatible pointer type ‘int (*)(struct vm_fault *)’ 
		[-Werror=incompatible-pointer-types]
		91 |     .fault = eccdev_vma_fault
		|              ^~~~~~~~~~~~~~~~

	
	
Ok. Lets try ec-debianzie instead :

		git clone https://github.com/grotius-cnc/ec-debianize.git
		cd ec-debianize
		./get_source.sh
		cd etherlabmaster
		dpkg-checkbuilddeps (and install missing deps)
		sudo dpkg-buildpackage
	
Produces error : 

		Error! Bad return status for module build on kernel: 5.10.0-4-rt-amd64 (x86_64)
		Consult /var/lib/dkms/etherlabmaster/1.5.2+20190904hg33b922p8ea394/build/make.log for more information.
		dpkg: error processing package etherlabmaster (--install):
		 installed etherlabmaster package post-installation script subprocess returned error exit status 10
		Processing triggers for libc-bin (2.31-9) ...
		Errors were encountered while processing:

Ok. Lets try to build linuxcnc from source :
		
		echo "deb http://deb.debian.org/debian buster main contrib non-free" >> /etc/apt/sources.list 
		echo "deb-src http://deb.debian.org/debian buster main contrib non-free" >> /etc/apt/sources.list
		echo "deb http://security.debian.org/debian-security buster/updates main contrib" >> /etc/apt/sources.list
		echo "deb-src http://security.debian.org/debian-security buster/updates main contrib" >> /etc/apt/sources.list 
		apt-get update
		apt-get install libreadline-gplv2-dev
		
		git clone https://github.com/LinuxCNC/linuxcnc.git
		cd linuxcnc/debian
		./configure uspace
		cd linuxcnc/src
		./autogen.sh
		./configure --with-boost-python=python3 --with-python=python3
		make
		sudo make setuid
		
Linuxcnc is ok. We have to do a dpkg-buildpackage and so on, later on.

Let try ethercat some more :

./configure --disable-eoe --enable-sii-assign \
 --enable-kernel --enable-generic --enable-ccat --disable-8139too \
 --disable-e100 --disable-e1000 --disable-e1000e --disable-r8169 \
 --enable-hrtimer 

		
Lets try a sid kernel :

		echo "deb http://ftp.de.debian.org/debian sid main" >> /etc/apt/sources.list
		apt-get install linux-image-5.10.0-5-rt-amd64-unsigned
		apt-get install linux-headers-5.10.0-5-rt-amd64 
	
Produced error : 
		/home/user/etherlab/master/device.h:95:20: error: field ‘timeval_poll’ has incomplete type
		   95 |     struct timeval timeval_poll;
		      |                    ^~~~~~~~~~~~
		/home/user/etherlab/master/cdev.c:91:14: error: initialization of ‘vm_fault_t (*)(struct vm_fault *)’ {aka ‘unsigned int (*)(struct vm_fault *)’} from incompatible pointer type ‘int (*)(struct vm_fault *)’ [-Werror=incompatible-pointer-types]
		   91 |     .fault = eccdev_vma_fault
		      |              ^~~~~~~~~~~~~~~~








