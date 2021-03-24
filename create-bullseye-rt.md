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
    echo "deb http://ftp.de.debian.org/debian bullseye main contrib non-free" > /etc/apt/sources.list 
    echo "deb-src http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list
    echo "deb http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list
    echo "deb-src http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list
    
    # For newest kernels :
    echo "deb http://deb.debian.org/debian sid main contrib non-free" >> /etc/apt/sources.list
    echo "deb-src http://deb.debian.org/debian sid main contrib non-free" >> /etc/apt/sources.list
    
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









