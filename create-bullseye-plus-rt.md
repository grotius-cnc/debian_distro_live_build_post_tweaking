    
Problem with debian bullseye is the size of the dvd. 3.7Gb
There is almost no space left to pre-install additional software.

We downloaded the debian bullseye alpha-3 dvd, and unpacked it.
    
    mdir dvd
    cd dvd
  
    debootstrap --arch=amd64 bullseye squashfs-root
    
    mount --bind /proc squashfs-root/proc
    mount --bind /sys squashfs-root/sys
    mount --bind /dev squashfs-root/dev
    
    chroot squashfs-root

    export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    export LC_ALL=C
    dhclient

    apt-get install linux-image-$(uname -r)
    apt-get install linux-headers-$(uname -r)
    apt-get install task-xfce-desktop --no-install-recommends
    # + 300Mb +241Mb +433Mb
    


    


    
    
    
    
    
    
    
    
    
    
    
    
    
