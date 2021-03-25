Todo :

1. When pc starts up, start ethercat bus, do this by a script that also set's the mac adres in the /etc/sysconfig/ethercat file.
In this way, a hdd can be switched to different pc's, and reconfigure mac adres is automaticly done at boot time. 
If production machine's use cloned hdd's. This is the way to go.

crontab -e
@reboot echo MASTER0_DEVICE="$(cat /sys/class/net/enp0s25/address)" > /etc/sysconfig/ethercat
@reboot echo "DEVICE_MODULES=generic" >> /etc/sysconfig/ethercat
@reboot /etc/init.d/ethercat start

Runtest ok. To be adapted to source code.


3. Look if deb packages can do a apt-get install in the preinst file. This seems not possible. 
4. Think about program removal system menu items.
5. Do research about the ethercat patches related to ec-debianize
6. Try to get the halcompiler used by qt
7. 


## Interesting links :
- https://live-team.pages.debian.net/live-manual/html/live-manual/customizing-package-installation.en.html
- https://wiki.debian.org/RepackBootableISO
- https://packages.debian.org/stable/
- https://manpages.debian.org/stretch/live-build/lb_config.1.en.html
- https://docs.github.com/en/github/writing-on-github/basic-writing-and-formatting-syntax
- https://github.com/Oros42/CustomDebian 
- https://github.com/RackunSec/debian-custom-iso-scripts 
- https://sourceforge.net/projects/eznixos 
- https://wiki.debian.org/Debootstrap
- https://willhaley.com/blog/custom-debian-live-environment/
- https://www.paranoids.at/create-custom-debian-buster-live/
- https://askubuntu.com/questions/74345/how-do-i-bypass-ignore-the-gpg-signature-checks-of-apt

