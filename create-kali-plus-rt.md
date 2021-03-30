In this document we dive into rebranding a Linux Distro in a more special way.
Normally we modify the files trough the terminal. 

But if we want to check gui colors, background colors, etc. We need a desktop visualisation.

The steps :

1. Download iso, copy the iso on usb, copy the files to pc include hidden file, unsquash. ( see previous documents )
2. Log into the "squasfs-root" dir and start up a chroot desktop environment.
  
        sudo su
        cd kali/rebranded/live/
        unsquashfs filesystem.squashfs # This will produce the folder /squashfs-root

        mount --bind /dev squashfs-root/dev
        mount --bind /sys squashfs-root/sys
        mount --bind /sys squashfs-root/proc
        
        mount --bind /run squashfs-root/run
        mount --bind /tmp squashfs-root/tmp
        
        chroot squashfs-root
        
        # In chroot now.
        export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
        export LC_ALL=C
        dhclient
        
        echo $DISPLAY
        export DISPLAY=:0

 Host terminal :
 xhost +local:
 
 
        

        





