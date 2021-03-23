
#### Compile test linuxcnc on kernel :
#### Linux debian 5.10.0-4-rt-amd64 #1 SMP PREEMPT_RT Debian 5.10.19-1 (2021-03-02) x86_64 GNU/Linux

#### For Linuxcnc we need the buster repository on top of the bullseye & sid repository :

	echo "deb http://deb.debian.org/debian buster main contrib non-free" >> /etc/apt/sources.list 
	echo "deb-src http://deb.debian.org/debian buster main contrib non-free" >> /etc/apt/sources.list
	echo "deb http://security.debian.org/debian-security buster/updates main contrib" >> /etc/apt/sources.list 
	echo "deb-src http://security.debian.org/debian-security buster/updates main contrib" >> /etc/apt/sources.list 
	apt-get update

#### Dependencies for Linuxcnc also a few extra.

	sudo apt-get install dctrl-tools dkms linux-headers-$(uname -r)\
	mercurial mercurial-common quilt live-build autoconf cmake make gcc geany build-essential \
	debhelper libudev-dev tcl8.6-dev tk8.6-dev libtk-img bwidget tclx8.4 \
	asciidoc dblatex docbook-xsl dvipng ghostscript graphviz groff imagemagick inkscape \
	source-highlight w3c-linkchecker xsltproc texlive-extra-utils texlive-font-utils texlive-fonts-recommended \
	texlive-lang-cyrillic texlive-lang-french texlive-lang-german texlive-lang-polish texlive-lang-spanish \
	python-tk libxmu-dev libgtk2.0-dev gettext intltool libboost-python-dev libmodbus-dev libusb-1.0-0-dev psmisc \
	source-highlight w3c-linkchecker texlive-font-utils texlive-lang-cyrillic \
	texlive-lang-french texlive-lang-german texlive-lang-polish texlive-lang-spanish libglu1-mesa-dev \
	libgl1-mesa-dev libgtk2.0-dev intltool libboost-python-dev libmodbus-dev libusb-1.0-0-dev psmisc \
	python-gtk2 python-is-python2 python-dev-is-python2 python-yapps python3-yapps libncurses-dev ncurses-doc \
	libboost-all-dev python3-tk libeigen3-dev deepin-calculator \
	librecad git pciutils yapps2 libreadline-gplv2-dev  
	
	/linuxcnc/dpkg-checkbuilddeps # Satisfy the existing dpkg package builder depend list.
	
#### Install and compile linuxcnc from source :

	git clone https://github.com/LinuxCNC/linuxcnc /opt/linuxcnc
	cd opt/linuxcnc
	
	# version 2.8 did not compile ok on kernels > 5.0.0
	# git checkout 2.8 # Go for the stable release.

	cd debian
	./configure uspace
	cd..
	cd src
	./autogen.sh
	# optional : $ ./configure --help
	./configure
	
	# Optional if boost::python is unknown :
	
		sudo ldconfig -p | grep boost_python
		# Gives me back :
		libboost_python39.so.1.74.0 (libc6,x86-64) => /lib/x86_64-linux-gnu/libboost_python39.so.1.74.0
		libboost_python39.so (libc6,x86-64) => /lib/x86_64-linux-gnu/libboost_python39.so

		./configure --with-boost-python=boost_python39 
	
	make -j2 # Build with 2 processors
	sudo make setuid # Allow to run on real hardware 

#### Runtest :

	$ cd linuxcnc/sctipts/. ./rip-environment
	$ linuxcnc
	
#### Todo : 

1. Make a linuxcnc.deb archive that unpack's linuxcnc into the /opt/linuxcnc system directory.
2. Install a linuxcnc desktop launcher into the system menu.
3. Install a documentation launcher to the system menu.
4. For test : create a Doxygen documentation web application with desktop launcher into the system menu.


	
