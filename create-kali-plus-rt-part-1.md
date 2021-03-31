In this document we dive into rebranding a Linux Distro in a more special way.
Normally we modify the files trough the terminal. 

But if we want to check gui colors, background colors, etc. We need a desktop visualisation.

This document can be used as background info to acces a linux server and create a external desktop enterily
from the host os. 

During the development of this document i had a few severe os problems. Commands like $ startx -- :1 vt8 
can be very destructive when used wrong. But yeah, it's solved.

One problem was when i rebooted my pc. I could not login as my normal user. When i logged in, the login
screen came back. The login srceen was ended up in a endless loop state.
My solution was to login as root. and do a command : $ chown $USER /home/$USER/ where $USER is your username.
Then it was solved. If your home dir is big. It can take a while, no worry.

When you cannot log in as root the solution is to do a CNTR+ALT+F2 to go into the tty2 screen.
Then do a $ sudo su, and a $ reboot. Then you can login as root and set the above chown commands to reset
your user.
                
The steps of this document :

1. Download iso, copy the iso on usb, copy the files to pc include hidden file, unsquash. ( see previous documents )
2. Log into the "squasfs-root" dir and start up a chroot desktop environment.

#### Here we go :

Host terminal

        cd yourpath/live/
        sudo su
        
        # Add sources to the host pc. We need dbus-x11
        echo "deb http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list
        echo "deb-src http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list
        echo "deb http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list
        echo "deb-src http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list
        apt-get update
        apt-get install dbus-x11
        
        cd /live/
        unsquashfs filesystem.squashfs # This will produce the folder /live/squashfs-root/ 

        mount --bind /dev squashfs-root/dev
        mount --bind /sys squashfs-root/sys
        mount --bind /sys squashfs-root/proc
        
        mount --bind /run squashfs-root/run
        mount --bind /run/udev squashfs-root/run/udev
    
        mount --bind /tmp squashfs-root/tmp
        
        chroot squashfs-root

Host switches to chroot terminal, go on in the same terminal :

        # In chroot mode now.
        export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
        export LC_ALL=C
        dhclient # If you think you need internet acces.

Start new host terminal :
 
        sudo su
        xhost + # access control disabled, clients can connect from any host
        startx -- :1 vt8 
        
        # CNTR+ALT+F8 to show tty8, 
        # CNTR+ALT+F7 to go back and show tty7, your host desktop environment.
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
        # echo $DISLPAY 
        startxfce4 
  
        # CNRL+ALT+F8 to goto display 1 with chroot desktop. It takes a while for it's fully loaded.
        # CNTR+ALT+F7 to go back to your host desktop environment.
        

        
        
        
 
 
        

        




