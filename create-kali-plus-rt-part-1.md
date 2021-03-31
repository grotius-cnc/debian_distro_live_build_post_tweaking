In this document we dive into rebranding a Linux Distro in a more special way.
Normally we modify the files trough the terminal. 
But if we want to check gui colors, background colors, etc. We need a desktop visualisation.
                
The steps of this document :

1. Download iso, copy the iso on usb, copy the files to pc include hidden file, unsquash. ( see previous documents )
2. Log into the "squasfs-root" dir and start up a chroot desktop environment.

Download : http://cdimage.kali.org/kali-images/kali-2021.1/kali-linux-2021.1-live-amd64.iso

Copy iso to usb :

    sudo dd bs=4M if=kali-linux-2021.1-live-amd64.iso of=/dev/sdb conv=fdatasync status=progress

    Copy the iso files from usb (include hidden file ./disk) to your pc in a folder named /rebranded/

#### host terminal:

    sudo su
    cd /rebranded/live/
    unsquashfs filesystem.squashfs # This will produce the folder /squashfs-root

    apt-get install xserver-xephyr ssh ufw dbus-x11 xterm # possible deps.
    Xephyr -ac -screen 1024x768 -br -reset -terminate 2> /dev/null :1 & 

    mount --bind /dev squashfs-root/dev
    mount --bind /dev/pts squashfs-root/dev/pts
    mount --bind /sys squashfs-root/sys
    mount --bind /sys squashfs-root/proc
    mount --bind /run squashfs-root/run
    mount --bind /run/udev squashfs-root/run/udev
    mount --bind /tmp squashfs-root/tmp
    chroot squashfs-root

##### now switches to chroot terminal:
    
    apt-get install xserver-xephyr ssh ufw dbus-x11 xterm # possible deps
    export DISPLAY=:1
    xclock
    startxfce4 &

![chrooted-desktop-environment](https://user-images.githubusercontent.com/44880102/113175620-9feed800-9219-11eb-95be-f5d019f09afe.png)


        
        
        
 
 
        

        





