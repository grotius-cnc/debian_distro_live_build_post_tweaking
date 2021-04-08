
#### This document solves a chroot dist-upgrade bug related to grub.

    wget https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/debian-live-10.9.0-amd64-xfce.iso

    sudo su

    mkdir iso && cd iso
    cp -rf /media/iso/* .
    cd /live
    unsquashfs filesystem.squashfs
    rm filesystem.squashfs

    mount --bind /proc squashfs-root/proc
    mount --bind /sys squashfs-root/sys
    mount --bind /dev squashfs-root/dev

    chroot squashfs-root

    export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    export LC_ALL=C
    dhclient

    apt-get install linux-image-5.10.0-5-rt-amd64

    umount /dev /proc /sys
    mount
    umount -l yourpath/dev etc.

    mksquashfs squashfs-root/ filesystem.squashfs -comp xz

    mv -rf /squashfs-root outside the iso dir.

    edit ./disk/info -> Linux Test

    xorriso -as mkisofs -iso-level 3 -V 'Linux Test' \
    -o Linux-Test.iso -J -J -joliet-long -cache-inodes \
    -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
    -b isolinux/isolinux.bin \
    -c isolinux/boot.cat -boot-load-size 4 -boot-info-table -no-emul-boot -eltorito-alt-boot \
    -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus .

    Copy the remastered iso to usb:
    sudo dd bs=4M if=Linux-Test.iso of=/dev/sdb conv=fdatasync status=progress

#### Runtest : Ok

#### Edited isolinux menu to start only graphical installer + edited splash.png
#### Chroot again :

    apt-get dist-upgrade

#### Runtest : Failed at install : "The grub-pc  package failed to install into /target/

    apt-get install grub-pc
    grub-update
    # During the dist-upgrade as chroot, somehow it forget's to reinstall or update grub.

#### Runtest : Install ok.

