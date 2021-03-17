
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

Todo : 

1. Make a linuxcnc.deb archive that unpack's into the /opt/ system directory.

[how-to-create-deb-package.zip](https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/files/6154727/how-to-create-deb-package.zip)
