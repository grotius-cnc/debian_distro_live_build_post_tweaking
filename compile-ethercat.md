Working install for :

        user@debian:~$ uname -a
        Linux debian 5.10.0-4-rt-amd64 #1 SMP PREEMPT_RT Debian 5.10.19-1 (2021-03-02) x86_64 GNU/Linux
        user@debian:~$ 

https://www.etherlab.org -> "report typo in INSTALL, =>./bootstrap"

#### Add sources to /etc/apt/sources.list

        echo "deb http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/source.list
        echo "deb-src http://ftp.de.debian.org/debian bullseye main contrib non-free" >> /etc/apt/source.list
        echo "deb http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/source.list
        echo "deb-src http://security.debian.org/debian-security/ bullseye-security main" >> /etc/apt/source.list
        echo "deb http://deb.debian.org/debian buster main contrib non-free" >> /etc/apt/source.list
        echo "deb-src http://deb.debian.org/debian buster main contrib non-free" >> /etc/apt/source.list
        echo "deb http://security.debian.org/debian-security buster/updates main contrib" >> /etc/apt/source.list
        echo "deb-src http://security.debian.org/debian-security buster/updates main contrib" >> /etc/apt/source.list
        apt-get update

        apt-get install git autoconf libtool linux-headers-$(uname -r)
        git clone https://gitlab.com/etherlab.org/ethercat.git
        cd ethercat
        git checkout stable-1.5 
        ./bootstrap
        ./configure --help
        ./configure --enable-generic --disable-8139too
        make
        make all modules
        make modules_install install
        depmod

#### Copy ethercat launcher :
        cp -f /opt/ethercat/script/init.d/ethercat /etc/init.d/

#### Make ethercat launcher executable :
        chmod +x /opt/ethercat/script/init.d/ethercat

#### copy ethercat mac and driver config sheet to system :
        mkdir -p /etc/sysconfig/
        cp -f /opt/ethercat/script/sysconfig/ethercat /etc/sysconfig/

#### Retrieve mac adres :
        echo MASTER0_DEVICE="$(cat /sys/class/net/enp0s25/address)" > /etc/sysconfig/ethercat

#### We choose the generic driver to activate :
        echo DEVICE_MODULES="generic" >> /etc/sysconfig/ethercat

#### From etherlab orginal :
        chmod go+rwx /etc/udev/rules.d/99-ethercat.rules
        echo "KERNEL=="\"EtherCAT[0-9]*\"", MODE="\"777\"", GROUP=""\"ethercat\"" > /etc/udev/rules.d/99-ethercat.rules

#### Start ethercat
        /etc/init.d/ethercat start

#### Or if previous start fails :
        systemctl restart systemd-modules-load.service
        /etc/init.d/ethercat start

