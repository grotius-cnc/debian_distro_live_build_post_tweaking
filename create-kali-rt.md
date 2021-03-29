This is a tiny tryout to get Kali rolling a realtime kernel and more..

Downloaded : http://cdimage.kali.org/kali-images/kali-2021.1/kali-linux-2021.1-live-amd64.iso

Copy iso to usb :

    sudo dd bs=4M if=kali-linux-2021.1-live-amd64.iso of=/dev/sdb conv=fdatasync status=progress
    
Copy the iso files (include hidden file ./disk) to /kali/original/ and to /kali/rebranded/.  

We could do a debootstrap. But first let's explore the original Kali iso.

#### As root :

    cd kali/rebranded/live/
    unsquashfs filesystem.squashfs # This will produce the folder /squashfs-root

    mount --bind /dev squashfs-root/dev
    mount --bind /sys squashfs-root/sys
    mount --bind /proc squashfs-root/proc
    chroot squashfs-root
    export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    export LC_ALL=C
    dhclient

![chroot-login](https://user-images.githubusercontent.com/44880102/112771304-31333400-8ff9-11eb-93aa-355c770ae935.png)

Okey now we are inside. It looks quite serious now. Lets see what resources they use.

    cat /etc/apt/sources.list
![sources-list](https://user-images.githubusercontent.com/44880102/112771631-c4209e00-8ffa-11eb-9e80-74c35131af2f.png)
    
Lets add the sid list.

    echo "deb http://ftp.de.debian.org/debian sid main" >> /etc/apt/sources.list
    apt-get update   
    
![repository](https://user-images.githubusercontent.com/44880102/112771911-1b733e00-8ffc-11eb-980f-a49ac67dfe17.png)

Lets try to install a realtime kernel-image and the kernel headers.
    
     apt-get install linux-image-5.10.0-5-rt-amd64 # https://packages.debian.org/sid/amd64/linux-image-5.10.0-5-rt-amd64/download
     apt-get install linux-kbuild-5.10 # to solve a problem
     apt-get install linux-headers-5.10.0-5-rt-amd64
     
     apt-get remove linux-image-amd64
     apt-get remove linux-image-5.10.0-kali3-amd64
     update-initramfs -u 

For our kali undercover c++ program we need Tor.

     apt-get install tor # To my surprise Tor isn't on Kali by default.
     
Let's see what crontab -e has inside.

    crontab -e # Is empty by default. Wtf.
    
    @reboot  /etc/init.d/networking stop
    @reboot  /etc/init.d/set-random-mac  
    @reboot  /etc/init.d/networking start
    
    # The script "set-random-mac" will be a c++ program that chooses a random mac for you at boot time.
    The base command to set a mac adres is : ifconfig eth0 hw ether 00:00:00:00:00:00
     
Ok we need qt-creator to write our c++ code wich will set our mac adres to a random value at boot time. 
This is a compiled script, the source code is not visible.
The package will install qt-creator in the /opt/ dir and make a system menu launcner for us.

    mkdir /home/software && cd /home/software/
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.2/qt-creator.deb
    dpkg -i qt-creator.deb
    rm -rfv /home/software/qt-creator.deb # Erase source.

![qt](https://user-images.githubusercontent.com/44880102/112773035-4b254480-9002-11eb-8b07-1c24a9fa425e.png)

Oke lets start the program ct-creator in chroot. But we need to set a display.

    xhost +local:
    echo $DISPLAY
    export DISPLAY=:0
    
Start normal terminal on host pc :

    xhost +local:

And wholla, we are inside a gui now in the chroot environment, wow :

![chroot_qt](https://user-images.githubusercontent.com/44880102/112773564-7dd03c80-9004-11eb-8f02-219542bd1cc9.png)

    
    
    
    
    
    
    
    
