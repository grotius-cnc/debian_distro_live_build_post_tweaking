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

#### host terminal

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

##### now switches to chroot terminal
    
    apt-get install xserver-xephyr ssh ufw dbus-x11 xterm # possible deps
    export DISPLAY=:1
    xclock # without this step it won't work.
    startxfce4 &

![chrooted-desktop-environment](https://user-images.githubusercontent.com/44880102/113175620-9feed800-9219-11eb-95be-f5d019f09afe.png)

#### cleanup
    apt-get remove nmap maltego sqlmap aircrack-ng autopsy binwalk hydra hasdeep hashcat cadaver burpsuite cherrytree
    apt-get remove wireshark whatweb wfuzz weevely nikto ncrack ophcrack netmask gparter iodine john istat wireshark sqlitebrowser
    apt-get remove wafw00f voiphopper wpscan masscan mimikatz miredo mitmproxy pipal pixiewps proxytunnel proxychains4 patator onesixtyone
    apt-get remove arping cewl chntpw dirbuster fierce enum4linux lbd laudanum kismet masscan nbtscan netdiscover ophcrack-cli 
    apt-get remove crunch cutycapt davtest wireshark unix-privesc-check udptunnel dmitry dirb dnschef dnsenum dnsrecon
    apt-get remove catfish skipfish recon-ng exploitdb spiderfoot zenity webshells zaproxy radare2 sakis3g strongswan blueman
    apt-get remove magicrescue pwnat clang chromium
    apt-autoremove
    
    # Remove desktop launchers in /etc/applications/kali*
    # Change desktop panel menu icon.
    # If desktop panel is accidentaly removed, restart, $ xfce4-panel 
    
#### apt sources list
    echo "deb http://deb.debian.org/debian buster main contrib non-free" > /etc/apt/sources.list
    echo "deb-src http://deb.debian.org/debian buster main contrib non-free" >> /etc/apt/sources.list
    echo "deb http://security.debian.org/debian-security buster/updates main contrib" >> /etc/apt/sources.list
    echo "deb-src http://security.debian.org/debian-security buster/updates main contrib" >> /etc/apt/sources.list
    echo "deb http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list
    echo "deb-src http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list
    echo "deb http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list
    echo "deb-src http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list 
    echo "deb http://ftp.de.debian.org/debian sid main" >> /etc/apt/sources.list 
    apt-get update
    
#### install deps
    apt-get install geany debhelper libudev-dev tcl8.6-dev tk8.6-dev tclx8.4 libtk-img bwidget wget git build-essential \
    libusb-1.0-0-dev psmisc asciidoc dblatex docbook-xsl dvipng ghostscript graphviz groff imagemagick inkscape \
    source-highlight w3c-linkchecker xsltproc texlive-extra-utils texlive-font-utils texlive-fonts-recommended \
    texlive-lang-cyrillic texlive-lang-french texlive-lang-german texlive-lang-polish texlive-lang-spanish \
    texlive-latex-recommended python-tk libxmu-dev libglu1-mesa-dev libgl1-mesa-dev \
    libgtk2.0-dev gettext intltool libboost-python-dev netcat libmodbus-dev yapps2 python-yapps \
    python3-tk python-is-python2 python-dev-is-python2 gobject-introspection python3-gi python3-cairo-dev python3-gi-cairo \
    python2-dev python-gtk2 python-lxml lib32readline-dev libedit-dev libreadline-gplv2-dev cairo-perf-utils \
    libmuparser2v5 librecad-data --no-install-recommends
    
    # kernel headers. linux-headers-$(uname -r)

#### Clone linuxcnc and check linuxcnc dependencies
    git clone https://github.com/LinuxCNC/linuxcnc.git /home/linuxcnc
    cd /home/linuxcnc/debian
    ./configure uspace
    cd ..

    cd scr
    ./autogen.sh
    # Keep on trying the next line until it's satisfied.
    ./configure --with-python=python3 --with-boost-python=boost_python39 
    make

#### Install programs, then remove sources 
    mkdir software && cd software
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.0/ethercat-deb-package.zip
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.1/linuxcnc.deb
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.3/linuxcnc-ethercat.deb
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.2/qt-creator.deb
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.5/librecad.deb
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.4/freecad.deb
    dpkg -i *.deb
    cd .. && rm -rfv software
    
    # For sure we set ethercat-master startup permissons:
    chmod 777 /opt/ethercat/script/init.d/ethercat

    # For sure we set linuxcnc startup permissions:
    chmod 777 /opt/linuxcnc/bin/rtapi_app
    chmod 777 /opt/linuxcnc/bin/linuxcnc_module_helper

#### Edit startup Apps
    crontab -e
    
    # Add lines :
    @reboot echo MASTER0_DEVICE="$(cat /sys/class/net/enp0s25/address)" DEVICE_MODULES=generic > /etc/sysconfig/ethercat 
    # Slow down the process so above line is done before the restart. 
    @reboot /etc/init.d/ethercat start
    @reboot /etc/init.d/ethercat stop
    @reboot /etc/init.d/ethercat restart
    
#### Edit /usr/lib/os-release 
    PRETTY_NAME="Linux Pro Rtos 5.10.0-5-rt-amd64"
    NAME="Linux Pro"
    ID=sid
    VERSION="2021.4"
    VERSION_ID="2021.4"
    VERSION_CODENAME="linux-pro"
    ID_LIKE=debian
    ANSI_COLOR="1;31"
    HOME_URL="https://github.com/grotius-cnc/"
    SUPPORT_URL="https://github.com/grotius-cnc/"
    BUG_REPORT_URL="https://github.com/grotius-cnc/"
    
#### Edit /etc/issue
    Linux Pro \n \l
    
#### Edit /etc/motd
    The programs included with the Linux Pro system are free software;
    the exact distribution terms for each program are described in the
    individual files in /usr/share/doc/*/copyright.

    Linus Pro comes with ABSOLUTELY NO WARRANTY, to the extent
    permitted by applicable law.
    
#### Edit /etc/issue.net
    Linux Pro

#### Edit /boot/themes/grub.d
    Edit backgrounds.
       
#### Edit /etc/default/grub.d/pro-themes.cfg
    # Try to force a 16x9 mode first, then 16x10, then default
    GRUB_GFXMODE="1280x720,1280x800,auto"
    GRUB_THEME="/boot/grub/themes/pro/theme.txt"
    # Add splash option to enable plymouth
    if ! echo "$GRUB_CMDLINE_LINUX_DEFAULT" | grep -q splash; then
        GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT splash"
    fi

#### Edit /boot/grub/live-theme/theme.txt
    line 28
    
#### Edit /boot/grub/x86_64-efi/splash.png
    
#### Edit /boot/grub/grub.cfg 
    Edit kernel names.
    
    
#### Umount chroot environment
    umount /dev /dev/pts /sys /proc /run /run/udev /tmp
    exit
    
    # check:
    mount
    # force umount:
    umount -l ......

#### Repack the filesystem
    sudo su
    squashfs squashfs-root

#### Edit the info file in /remastered/.disk/info
    Linux Pro Rtos 5.10.0-5-rt-amd64

#### Create iso in top level dir 
    xorriso -as mkisofs -V 'Linux Pro Rtos 5.10.0-5-rt-amd64' \
    -o Linux-Pro-Rtos-5.10.0-5-rt-amd64.iso -J -J -joliet-long -cache-inodes \
    -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
    -b isolinux/isolinux.bin \
    -c isolinux/boot.cat -boot-load-size 4 -boot-info-table -no-emul-boot -eltorito-alt-boot \
    -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus .

    #Put the new iso file on your usb device in /remastered/
    sudo dd bs=4M if=Linux-Pro-Rtos-5.10.0-5-rt-amd64.iso of=/dev/sdb conv=fdatasync status=progress

#### Todo
    dpkg set distro name into the remove menu

#### Runtest





