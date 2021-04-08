
#### This document solves a chroot dist-upgrade bug related to grub.

    sudo su
    wget https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/debian-live-10.9.0-amd64-xfce.iso

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
    exit
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

#### Chroot again :

    sudo su
    apt-get autoremove
    apt-get install wget
    cd /home
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.6/kali-dark-theme.deb
    dpkg -i kali-dark-theme.deb
    
    apt-get install qalculate

    # Set sources :
    echo "deb http://ftp.de.debian.org/debian bullseye main contrib non-free" > /etc/apt/sources.list 
    echo "deb-src http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list 
    echo "deb http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list 
    echo "deb-src http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list 
    apt-get update
    
    apt-get install xserver-xephyr dbus-x11 isolinux live-build debootstrap squashfs-tools xorriso
    
    # Logout as chroot.
    
#### Chroot with target desktop environment :

    sudo su
    mount --bind /dev squashfs-root/dev
    mount --bind /dev/pts squashfs-root/dev/pts
    mount --bind /sys squashfs-root/sys
    mount --bind /proc squashfs-root/proc
    mount --bind /run squashfs-root/run
    mount --bind /run/udev squashfs-root/run/udev
    mount --bind /tmp squashfs-root/tmp
    mount --bind /var/lib squashfs-root/var/lib 
    mount --bind /etc squashfs-root/etc
    chroot squashfs-root 

    # In chroot now:

    export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    export LC_ALL=C
    dhclient

Set up display, open up new terminal on host pc :

    Xephyr -ac -screen 1600x900 -br -reset -terminate 2> /dev/null :1 & 

Back to chroot terminal, start the xfce4 desktop environment:

    export DISPLAY=:1
    xclock
    # CNTRL+Z
    startxfce4 &  
    # If Xephyr is not starting look at the create-linux-pro-step-2.md file.

The chroot desktop environment will look like :
![root-environment](https://user-images.githubusercontent.com/44880102/113708243-fbecad00-96ae-11eb-99da-1c6622bcb8d7.png)

#### Install software

Ethercat-master:
    
    apt-get install linux-headers-5.10.0-5-rt-amd64
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.0/ethercat-master.deb
    dpkg -i ethercat-master.deb
    
    # Set up autoconfigure Mac at boot time.
    
    cat <<EOF > crontab -e
    @reboot echo MASTER0_DEVICE="$(cat /sys/class/net/enp0s25/address)" DEVICE_MODULES=generic > /etc/sysconfig/ethercat 
    # Slow down the process so above line is done before the restart. 
    @reboot /etc/init.d/ethercat start
    @reboot /etc/init.d/ethercat stop
    @reboot /etc/init.d/ethercat restart
    EOF
    
    # We test later the interaction with macchanger.
    
Linuxcnc:

    apt-get install autoconf
    git clone https://github.com/LinuxCNC/linuxcnc.git

    cd linuxcnc/debian
    ./configure uspace
    cd ..
    
    dpgk-checkbuilldeps
    
    # solved with bullseye repository :
    apt-get install debhelper libudev-dev tcl8.6-dev tk8.6-dev libtk-img bwidget tclx8.4 \
    asciidoc dblatex docbook-xsl dvipng ghostscript graphviz groff imagemagick inkscape  \
    source-highlight w3c-linkchecker xsltproc texlive-extra-utils texlive-font-utils texlive-fonts-recommended \
    texlive-lang-cyrillic texlive-lang-french texlive-lang-german texlive-lang-polish texlive-lang-spanish \
    texlive-latex-recommended python-is-python2 python-dev-is-python2 python-tk libxmu-dev libglu1-mesa-dev libgl1-mesa-dev \
    libgtk2.0-dev gettext intltool libboost-python-dev netcat libmodbus-dev libusb-1.0-0-dev yapps2

    # Download old package : libreadline-gplv2-dev 
    apt-get install libncurses-dev libtinfo-dev
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.1/libreadline-gplv2-dev_5.2+dfsg-3+b13_amd64.deb
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.1/libreadline5_5.2+dfsg-3+b13_amd64.deb
    dpkg -i libreadline5_5.2+dfsg-3+b13_amd64.deb
    dpkg -i libreadline-gplv2-dev_5.2+dfsg-3+b13_amd64.deb
    
    # This is the result, but no problem, error: Unmet build dependencies: dh-python python-lxml

    cd src
    ./autogen.sh
    ./configure --with-python=python3 --with-boost-python=boost_python39 --with-tclConfig=/lib/tclx8.4 --with-tkConfig=/lib/tk8.6
    make -j2
    
    # If succes, install the linuxcnc.deb package.
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.1/linuxcnc.deb
    dpkg -i linuxcnc.deb
    
Linuxcnc-ethercat


