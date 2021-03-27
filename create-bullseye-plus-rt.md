    
Problem with debian bullseye is the size of the dvd. 3.7Gb
There is almost no space left to pre-install additional software.

We downloaded the debian bullseye alpha-3 dvd, and unpack it, see other tutorials.
We now focus on the squashfs-root dir.
    
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
    apt-get install task-xfce-desktop wget git build-essential libusb-1.0-0-dev psmisc --no-install-recommends
    # + 300Mb +241Mb +433Mb
    
    # This includes the bullseye main repository
    apt-get install debhelper libudev-dev tcl8.6-dev tk8.6-dev tclx8.4 libtk-img bwidget \
    asciidoc dblatex docbook-xsl dvipng ghostscript graphviz groff imagemagick inkscape \
    source-highlight w3c-linkchecker xsltproc texlive-extra-utils texlive-font-utils texlive-fonts-recommended \
    texlive-lang-cyrillic texlive-lang-french texlive-lang-german texlive-lang-polish texlive-lang-spanish \
    texlive-latex-recommended python-tk libxmu-dev libglu1-mesa-dev libgl1-mesa-dev \
    libgtk2.0-dev gettext intltool libboost-python-dev netcat libmodbus-dev yapps2  
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

    apt-get install python2-dev python-gtk2 python-lxml lib32readline-dev libedit-dev libreadline-gplv2-dev --no-install-recommends

    # Clone linuxcnc and check linuxcnc dependencies.
    cd debian
    ./configure uspace
    cd ..
    
    cd scr
    ./autogen.sh
    # Keep on trying the next line until it's satisfied.
    ./configure --with-python=python3 --with-boost-python=boost_python39 
    make
    
    # If this run's oke. We can isntall the linuxcnc.deb package.
    
    # Reset repository
    echo "deb http://ftp.de.debian.org/debian bullseye main contrib non-free" > /etc/apt/sources.list
    echo "deb-src http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list
    echo "deb http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list
    echo "deb-src http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/sources.list
    apt-get update
    
    # Install linuxcnc in /opt/
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.1/linuxcnc.deb
    dpkg -i linuxcnc.deb
    
    # Install ethercat-master
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.0/ethercat-master.deb
    dpkg -i ethercat-master.deb
    
    # Edit crontab -e
    
    
    # Install linuxcnc-ethercat in /opt/
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.3/linuxcnc-ethercat.deb
    dpkg -i linuxcnc-ethercat.deb
    
    # Install qt-creator in /opt/
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.2/qt-creator.deb
    dpkg -i qt-creator.deb
    
    
    # Remove sources.
    
    
    
    
    
    
    
    
    
    
    
    
