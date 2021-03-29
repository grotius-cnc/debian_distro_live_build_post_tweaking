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

Add this line :

    @reboot  /etc/init.d/set-random-mac  
    
    # The script "set-random-mac" will be a c++ program that chooses a random mac for you at boot time.
    The base command to set a mac adres is : ifconfig eth0 hw ether 00:00:00:00:00:00
     
Ok we need qt-creator to write our c++ code wich will set our mac adres to a random value at boot time. 
This is a compiled script, the source code is not visible.
The package will install qt-creator in the /opt/ dir and make a system menu launcner for us.
The great part is. We will write this code inside the chroot environment.

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

Go on in chroot terminal and start the qt-creator program by :

    cd /opt/qt-creator/Tools/QtCreator/bin/
    ./qtcreator.sh

And wholla, we are inside the qt gui now in a chroot environment, wow :

![chroot_qt](https://user-images.githubusercontent.com/44880102/112773564-7dd03c80-9004-11eb-8f02-219542bd1cc9.png)

Ok now create a new project, qt console application. I named it : "set-random-mac", I set the filepath to /home/software/

I see we need to set the version path. Like this is oke. You have to search in your chroot path.

![qt-version](https://user-images.githubusercontent.com/44880102/112774116-95a8c000-9006-11eb-9b1a-6a5c2d217fd0.png)

Now select Desktop and Next.

![desktop-next](https://user-images.githubusercontent.com/44880102/112774156-bc66f680-9006-11eb-8ff8-9b3055eb3064.png)

And select Finish. Now we can code. Isn't this a beauty :

![set-mac-for-my-kali](https://user-images.githubusercontent.com/44880102/112775578-4dd86780-900b-11eb-81e4-d5fc25f52a9c.png)

Ok lets copy our brand new code to the /etc/init.d/ dir.

cd home/software/build-set-random-mac-Desktop-Debug
    cp home/software/build-set-random-mac-Desktop-Debug/set-random-mac /etc/init.d/
    
![init-d-ok](https://user-images.githubusercontent.com/44880102/112776175-fb984600-900c-11eb-8750-492dc470b1c2.png)

Ok for now lets leave the chroot environment, don't forget to remove your sources :

    umount /sys /proc /dev 
    exit
    # extra control steps to umount :
    mount
    # i had to to this one just to be sure :
    umount -l /home/user/kali/rebranded/live/squashfs-root/dev
    
 ![umount](https://user-images.githubusercontent.com/44880102/112776457-bcb6c000-900d-11eb-9a94-df396e10ab1e.png)

Rename iso, edit /rebranded/.disk/info file
 
        Debian-Kali-5.10.0-5-rt-amd64
        
Copy these files from /live/squashfs-root/boot to /live. Copy the files higher in hierarchy.

        config-5.10.0-5-rt-amd64
        initrd.img-5.10.0-5-rt-amd64
        System.map-5.10.0-5-rt-amd64
        vmlinuz-5.10.0-5-rt-amd64
    
Delete /rebranded/live/filesystem.squashfs

        rm /rebranded/live/filesystem.squashfs
        
Resquash in /rebranded/live/

        mksquashfs squashfs-root/ filesystem.squashfs -comp xz


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
