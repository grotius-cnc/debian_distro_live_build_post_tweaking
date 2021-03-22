
# Compile test linuxcnc on kernel :
# Linux debian 5.10.0-4-rt-amd64 #1 SMP PREEMPT_RT Debian 5.10.19-1 (2021-03-02) x86_64 GNU/Linux

# Install and compile linuxcnc from source :

	git clone https://github.com/LinuxCNC/linuxcnc
	cd linuxcnc

	# optional :
	# $ git checkout 2.8

	cd debian
	./configure uspace
	cd..
	cd src
	./autogen.sh
	# optional : $ ./configure --help
	./configure --with-python=python3
	make 
	sudo make setuid

Runtest :

	$ cd linuxcnc/sctipts/. ./rip-environment
	$ linuxcnc
	
Cleanup :
	remove the dpkg directory, we don't need it : 

	$ cd linuxcnc && rm -rf debian

Todo : 

1. Make a linuxcnc.deb archive that unpack's into the /opt/ system directory.
2. Create and install a desktop launcher into the system menu with command :

		$ cd /opt/linuxcnc/scripts/ && . ./rip-environment && linuxcnc


[how-to-create-deb-package.zip](https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/files/6154727/how-to-create-deb-package.zip)


Package: linuxcnc
Version: 2.8.1
Section: custom
Priority: optional
Architecture: amd64
Essential: no
Installed-Size: 
Maintainer: skynet
Depends: 
Suggests: 
Breaks:
Provides: 
Section: devel
Priority: optional
Homepage: http://www.linuxcnc.org
Description: 
Programmer-Info: 

# To build package:
$ dpkg-deb --build linuxcnc

# Compile linuxcnc from source :

echo "deb http://deb.debian.org/debian buster main contrib non-free" >> /etc/apt/sources.list 
echo "deb-src http://deb.debian.org/debian buster main contrib non-free" >> /etc/apt/sources.list
echo "deb http://security.debian.org/debian-security buster/updates main contrib" >> /etc/apt/sources.list 
echo "deb-src http://security.debian.org/debian-security buster/updates main contrib" >> /etc/apt/sources.list 
apt-get update

apt-get install dctrl-tools dkms \
mercurial mercurial-common quilt live-build autoconf cmake make gcc geany build-essential \
debhelper libudev-dev tcl8.6-dev tk8.6-dev libtk-img bwidget tclx8.4 \
asciidoc dblatex docbook-xsl dvipng ghostscript graphviz groff imagemagick inkscape \
source-highlight w3c-linkchecker xsltproc texlive-extra-utils texlive-font-utils texlive-fonts-recommended \
texlive-lang-cyrillic texlive-lang-french texlive-lang-german texlive-lang-polish texlive-lang-spanish \
python-tk libxmu-dev libgtk2.0-dev gettext intltool libboost-python-dev libmodbus-dev libusb-1.0-0-dev psmisc \
source-highlight w3c-linkchecker texlive-font-utils texlive-lang-cyrillic \
texlive-lang-french texlive-lang-german texlive-lang-polish texlive-lang-spanish libglu1-mesa-dev \
libgl1-mesa-dev libgtk2.0-dev intltool libboost-python-dev libmodbus-dev libusb-1.0-0-dev psmisc \
python-is-python2 python-dev-is-python2 python3-yapps libncurses-dev ncurses-doc \
libboost-all-dev python3-tk libeigen3-dev deepin-calculator \
librecad git pciutils yapps2 

./configure --with-python=python3 
make -j2
sudo make setuid
