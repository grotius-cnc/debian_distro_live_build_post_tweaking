### This is a separate tutorial for rebranding a existing Debian Linux Distro, "DLD".

I downloaded this dvd :
*https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/weekly-live-builds/amd64/iso-hybrid/debian-live-testing-amd64-xfce+nonfree.iso*

Then i did this tutorial :
*https://www.paranoids.at/create-custom-debian-buster-live/*


#### *I already have done a Debian 10 iso with succes with this script !*


#### I mounted the .iso file and copied the files into a folder. 

#### Unpack the squasfs file located in the /live dir.

	apt-get install squashfs-tools	# This is a dependency.
	unsquashfs filesystem.squashfs  # This will create a /squashfs-root directory.

#### Mount & chroot to the /squashfs-root directory

    mount --bind /dev squashfs-root/dev
    mount --bind /dev/pts squashfs-root/dev/pts
    mount --bind /sys squashfs-root/sys
    mount --bind /proc squashfs-root/proc
    mount --bind /proc squashfs-root/dev
    mount --bind /boot squashfs-root/boot

    chroot squashfs-root
    export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    export LC_ALL=C

    dhclient # get internet connection

    apt-get install geany librecad # for example
    
    # to test, my previous attempt's failed. New system booted in (live) mode :
    apt-get install linux-image-5.10.0-4-rt-amd64 linux-headers-5.10.0-4-rt-ard64


    umount /dev /dev/pts /sys /proc
    exit

#### create squashfs
    mksquashfs squashfs-root/ filesystem.squashfs -comp xz

#### replace the new filesystem.squashfs file with the old one in the live dir.
    rm live/filesystem.squashfs                       # delelte existing file
    cp filesystem.squashfs live/filesystem.squashfs   # replacement new file.
    
#### edit disk info corresponding to xorriso -V option
    vim .disk/info
    Debian 11 Bullseye Rtos
    
#### copy custom squashfs
    

#### create iso
    apt-get install xorriso isolinux	# These are dependencies.

    xorriso -as mkisofs -V 'Debian 11 Bullseye Rtos' \
      -o Debian-11-Bullseye-Rtos.iso -J -J -joliet-long -cache-inodes \
      -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
      -b isolinux/isolinux.bin \
      -c isolinux/boot.cat -boot-load-size 4 -boot-info-table -no-emul-boot -eltorito-alt-boot \
      -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus .

      # For info, isolinux places a system folder with the file : /usr/lib/ISOLINUX/isohdpfx.bin
      
#### create iso on usb drive
	# "if" means input file path.
    	sudo dd bs=4M if=Debian-11-Bullseye-Rtos.iso of=/dev/sdb conv=fdatasync status=progress
		
      
