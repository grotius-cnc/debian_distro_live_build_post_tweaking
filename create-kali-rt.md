
Downloaded : http://cdimage.kali.org/kali-images/kali-2021.1/kali-linux-2021.1-live-amd64.iso

Copy iso to usb :

    sudo dd bs=4M if=kali-linux-2021.1-live-amd64.iso of=/dev/sdb conv=fdatasync status=progress
    
Copy the iso files (include hidden file ./disk) to /kali/original/ and to /kali/rebranded/.  

As root :

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
    
    
    
    
    
    
    
    
    
    
    
    
