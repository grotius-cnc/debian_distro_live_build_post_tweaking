In this document we dive into rebranding a Linux Distro in a more special way.
Normally we modify the files trough the terminal. 

But if we want to check gui colors, background colors, etc. We need a desktop visualisation.

The steps :

1. Download iso, copy the iso on usb, copy the files to pc include hidden file, unsquash. ( see previous documents )
2. Log into the "squasfs-root" dir and start up a chroot desktop environment.

Host terminal :

        sudo su
        cd kali/rebranded/live/
        unsquashfs filesystem.squashfs # This will produce the folder /squashfs-root

        mount --bind /dev squashfs-root/dev
        mount --bind /sys squashfs-root/sys
        mount --bind /sys squashfs-root/proc
        
        mount --bind /run squashfs-root/run
        mount --bind /tmp squashfs-root/tmp
        
        chroot squashfs-root

Host switches to chroot terminal.

        # In chroot now.
        export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
        export LC_ALL=C
        dhclient

Host terminal :
 
        xhost + # access control disabled, clients can connect from any host
        startx -- :1 vt8 # CNTR+ALT+F8 to show tty8, CNTR+ALT+F7 to go back.
        
        # It looks like the second display works.
        # Mabye export our chroot environment to display nr 1. 

Chroot terminal :

        export DISPLAY=:1
        echo $DISLPAY # check if ok.
        xclock # to check if display 1 show's the clock. Goto display 1 with CNRL+ALT+F8.
        # CNRTL+Z to break command.
        
        
        
        
 
 
        

        





