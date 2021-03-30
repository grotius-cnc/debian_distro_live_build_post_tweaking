In this document we dive into rebranding a Linux Distro in a more special way.
Normally we modify the files trough the terminal. 

But if we want to check gui colors, background colors, etc. We need a desktop visualisation.

The steps :

1. Download iso, copy the iso on usb, copy the files to pc include hidden file, unsquash. ( see previous documents )
2. Log into the "squasfs-root" dir and start up a chroot desktop environment.

Host terminal :
        
        sudo su

        echo "deb http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list
        echo "deb-src http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list
        echo "deb http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list
        echo "deb-src http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list
        apt-get update
        apt-get install dbus-x11
        
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

Start new host terminal :
 
        sudo su
        xhost + # access control disabled, clients can connect from any host
        startx -- :1 vt8 # CNTR+ALT+F8 to show tty8, CNTR+ALT+F7 to go back.
        
        # :1 = display nr, display nr 0 is your host display nr.
        # vt8 = tty8 window.

Chroot terminal :

        # We need to add sources to get dbus-x11 installed in our chroot environment.
        echo "deb http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list
        echo "deb-src http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list
        echo "deb http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list
        echo "deb-src http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list
        apt-get update
        apt-get install dbus-x11

        # Export our chroot environment to tty8 window with previous vt8 command.
        export DISPLAY=:1
        echo $DISLPAY # check if ok.!

        xfce4-session # works!! Goto display 1 with CNRL+ALT+F8, CNTR+ALT+F7 to go back.
        
        Preview of the chroot desktop environment.
   ![chroot-desktop](https://user-images.githubusercontent.com/44880102/113069570-9ff5c600-918e-11eb-991e-f2ee806bdab7.png)


        
        
       
        
        
        
        
 
 
        

        





