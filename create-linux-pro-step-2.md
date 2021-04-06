#### It's preferred that the host system has the same kernel as the target os.

    sudo su
    apt-get install linux-image-5.10.0-5-rt-amd64
    apt-get install linux-headers-$(uname -r)
    update-initramfs -u

    apt install gobject-introspection python3-gi python3-cairo-dev python3-gi-cairo # github issue 820 linuxcnc fix rene-dev
    apt-get install locales
    dpkg-reconfigure locales

    apt-get install dpkg geany wget git build-essential libusb-1.0-0-dev psmisc \
    debhelper libudev-dev tcl8.6-dev tk8.6-dev tclx8.4 libtk-img bwidget \
    asciidoc dblatex docbook-xsl dvipng ghostscript graphviz groff imagemagick inkscape \
    source-highlight w3c-linkchecker xsltproc texlive-extra-utils texlive-font-utils texlive-fonts-recommended \
    texlive-lang-cyrillic texlive-lang-french texlive-lang-german texlive-lang-polish texlive-lang-spanish \
    texlive-latex-recommended python-tk libxmu-dev libglu1-mesa-dev libgl1-mesa-dev \
    libgtk2.0-dev gettext intltool libboost-python-dev netcat libmodbus-dev yapps2 python-yapps \
    python3-tk python-is-python2 python-dev-is-python2 \
    python2-dev python-gtk2 python-lxml lib32readline-dev libedit-dev libreadline-gplv2-dev cairo-perf-utils --no-install-recommends

    cd /home
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.0/ethercat-master.deb
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.1/linuxcnc.deb
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.3/linuxcnc-ethercat.deb
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.2/qt-creator.deb
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.5/librecad.deb
    wget https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/releases/download/1.0.4/freecad.deb

    apt-get install linux-headers-5.10.0-5-rt-amd64 

    dpkg -i linuxcnc.deb 
    chmod 777 /opt/linuxcnc/bin/rtapi_app 
    chmod 777 /opt/linuxcnc/bin/linuxcnc_module_helper

    dpkg -i ethercat-master.deb 
    dpkg -i linuxcnc-ethercat.deb 
    dpkg -i qt-creator.deb # Edit launcher, remove the -
    apt-get install librecad-data libmuparser2v5 libqt5core5a 
    dpkg -i librecad.deb 
    dpkg -i freecad.deb 
    apt-get install qttools5-dev-tools qttools5.dev qalculate 

#### Remove sources in /home/software
    rm -rfv /home/*

#### Edit crontab -e
#### Add lines :
    @reboot echo MASTER0_DEVICE="$(cat /sys/class/net/enp0s25/address)" DEVICE_MODULES=generic > /etc/sysconfig/ethercat 
    # Slow down the process so above line is done before the restart. 
    @reboot /etc/init.d/ethercat start
    @reboot /etc/init.d/ethercat stop
    @reboot /etc/init.d/ethercat restart

#### Install Macchanger:

	# Download kali's keyring :

	wget http://http.kali.org/kali/pool/main/k/kali-archive-keyring/kali-archive-keyring_2020.2_all.deb

	# Install kali's keyring :

	dpkg -i kali-archive-keyring_2020.2_all.deb

	# Add kali's repository:

	echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list 
	echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list 
	apt-get update

	apt-get install macchanger

#### Install Tor:

	wget https://www.torproject.org/dist/torbrowser/10.0.15/tor-browser-linux64-10.0.15_en-US.tar.xz
        tar -xJvf tor-browser-linux64-10.0.15_en-US.tar.xz
	mkdir /opt/tor-browser/
	cp -rf /home/tor-browser_en-US/Browser/* /opt/tor-browser/
	chmod 777 /opt/tor-browser/start-tor-browser.desktop
	
	# Create desktop.launcher into system menu:

        cat <<EOF > /usr/share/applications/tor-browser.desktop
	#!/bin/bash
	[Desktop Entry]
	Name=Tor-browser
	Comment=Launcher to /opt/ dir
	GenericName=Tor Browser
	Exec=./start-tor-browser.desktop
	Icon=/opt/tor-browser/browser/chrome/icons/default/default48.png
	Terminal=false
	StartupNotify=true
	Type=Application
	Categories=Network;WebBrowser;
	MimeType=text/plain;
	Path=/opt/tor-browser/
	EOF

	# Remove a backdoor:
	apt-get remove ssh

	




	




