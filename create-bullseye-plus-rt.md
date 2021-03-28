    
Problem with debian bullseye is the size of the dvd. 3.7Gb
There is almost no space left to pre-install additional software.

We downloaded the debian bullseye alpha-3 dvd, and unpack it, see other tutorials.
We now focus on the squashfs-root dir to keep it under 4.0Gb.

apt-get <name> --no-install-recommends, helps also with reducing the total size.
    
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
    apt-get install sudo # important
    apt-get install task-xfce-desktop # desktop environment
    
    apt install gobject-introspection python3-gi python3-cairo-dev python3-gi-cairo # github issue 820 linuxcnc fix rene-dev
    apt-get install locales
    dpkg-reconfigure locales
    
    apt-get install task-xfce-desktop geany wget git build-essential libusb-1.0-0-dev psmisc --no-install-recommends
    # + 300Mb +241Mb +433Mb
    
    # This includes the bullseye main repository
    apt-get install debhelper libudev-dev tcl8.6-dev tk8.6-dev tclx8.4 libtk-img bwidget \
    asciidoc dblatex docbook-xsl dvipng ghostscript graphviz groff imagemagick inkscape \
    source-highlight w3c-linkchecker xsltproc texlive-extra-utils texlive-font-utils texlive-fonts-recommended \
    texlive-lang-cyrillic texlive-lang-french texlive-lang-german texlive-lang-polish texlive-lang-spanish \
    texlive-latex-recommended python-tk libxmu-dev libglu1-mesa-dev libgl1-mesa-dev \
    libgtk2.0-dev gettext intltool libboost-python-dev netcat libmodbus-dev yapps2 python-yapps 
    python3-tk python-is-python2 python-dev-is-python2 --no-install-recommends

    echo "deb http://deb.debian.org/debian buster main contrib non-free" > /etc/apt/sources.list
    echo "deb-src http://deb.debian.org/debian buster main contrib non-free" >> /etc/apt/sources.list
    echo "deb http://security.debian.org/debian-security buster/updates main contrib" >> /etc/apt/sources.list
    echo "deb-src http://security.debian.org/debian-security buster/updates main contrib" >> /etc/apt/sources.list

    echo "deb http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list
    echo "deb-src http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list
    echo "deb http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list
    echo "deb-src http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list
    apt-get update

    apt-get install python2-dev python-gtk2 python-lxml lib32readline-dev libedit-dev libreadline-gplv2-dev cairo-perf-utils --no-install-recommends

    # Clone linuxcnc and check linuxcnc dependencies.
    
    git clone https://github.com/LinuxCNC/linuxcnc.git /home/linuxcnc
    cd /home/linuxcnc/debian
    ./configure uspace
    cd ..
    
    cd scr
    ./autogen.sh
    # Keep on trying the next line until it's satisfied.
    ./configure --with-python=python3 --with-boost-python=boost_python39 
    make
    
    # If this run's oke. We can install the linuxcnc.deb package.
    # Remove git source.
    rm -rf /home/linuxcnc
    
    
    # Reset repository
    echo "deb http://ftp.de.debian.org/debian bullseye main contrib non-free" > /etc/apt/sources.list
    echo "deb-src http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list
    echo "deb http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list
    echo "deb-src http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list
    apt-get update
    
    mkdir /home/software && cd /home/software
    
    # Install linuxcnc in /opt/
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.1/linuxcnc.deb
    dpkg -i linuxcnc.deb
    
    chmod 777 /opt/linuxcnc/bin/rtapi_app
    chmod 777 /opt/linuxcnc/bin/linuxcnc_module_helper
    
    # Install ethercat-master, be sure you have the kernel headers, see above.
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.0/ethercat-master.deb
    dpkg -i ethercat-master.deb
    
    # Edit crontab -e
    # Add lines :
        @reboot echo MASTER0_DEVICE="$(cat /sys/class/net/enp0s25/address)" DEVICE_MODULES=generic > /etc/sysconfig/ethercat 
        # Slow down the process so above line is done before the restart. 
        @reboot /etc/init.d/ethercat start
        @reboot /etc/init.d/ethercat stop
        @reboot /etc/init.d/ethercat restart
        
        # Set screen power-saving, hibernate, etc. to off.
        @reboot xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/dpms-on-ac-off -s 0
        @reboot xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/blank-on-ac -s 0
        @reboot xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/dpms-on-ac-sleep -s 0
        @reboot xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/inactivity-sleep-mode-on-ac -s 0
    
    
    
    
    
    # Install linuxcnc-ethercat in /opt/
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.3/linuxcnc-ethercat.deb
    dpkg -i linuxcnc-ethercat.deb
    
    # Install qt-creator in /opt/
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.2/qt-creator.deb
    dpkg -i qt-creator.deb
    
    # Install librecat in /opt/
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.5/librecad.deb
    dpkg -i librecad.deb
    
    # Remove sources in /home/software
    rm -rfv /home/software
    
    # Install qt-creator for python and qtvcp sources.
    apt-get install qttools5-dev-tools qttools5.dev
    
    # Calculator
    apt-get install qalculate
    
    umount /dev /sys /proc 
    exit
    # reboot pc
    
    # Repack the iso.
    mksquashfs squashfs-root/ filesystem.squashfs -comp xz
    
    # Output squashed filesize :
    3.1Gb wich is nice.
    
    cp /dvd/filesystem.squashfs to your unpacked debian iso /live dir and replace existing filesystem.squashfs with the new one.
    
    # Copy the files from squashfs-root/boot/* to your dvd/live/ dir, if they are different then the orignal one's.
        intitrd..
        vmlinuz..
        config..
        system.map..
    
    # Edit the info file in /remastered/.disk/info
    Debian 11 Bullseye Rtos 5.10.0-4-rt-amd64
    
    # Create iso 
    xorriso -as mkisofs -V 'Debian 11 Bullseye Rtos 5.10.0-5' \
    -o Debian-11-Bullseye-Rtos-5.10.0-5.iso -J -J -joliet-long -cache-inodes \
    -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
    -b isolinux/isolinux.bin \
    -c isolinux/boot.cat -boot-load-size 4 -boot-info-table -no-emul-boot -eltorito-alt-boot \
    -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus .

    #Put the new iso file on your usb device in /remastered/
    sudo dd bs=4M if=Debian-11-Bullseye-Rtos-5.10.0-5.iso of=/dev/sdb conv=fdatasync status=progress

    # Runtest
    # Iso boots oke.
    
 
    
    
    
    
    
    
    
    
    
    
