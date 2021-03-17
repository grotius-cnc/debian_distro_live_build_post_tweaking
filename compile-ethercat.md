For info only, this code compiles on Linux debian 5.10.0-4-rt-amd64, is info only to make a future patch set :
[master.zip](https://github.com/grotius-cnc/debian_distro_live_build_post_tweaking/files/6154607/master.zip)

    $ sudo apt-get install mercurial
    
Edit the file : /etc/mercurial/hgrc
Add : 

    [extensions]
    mq =
    
Get the source : https://sourceforge.net/u/uecasm/etherlab-patches/ci/default/tree/
Follow the steps.

    $ hg clone -u 33b922ec1871 http://hg.code.sf.net/p/etherlabmaster/code etherlab
    $ hg clone http://hg.code.sf.net/u/uecasm/etherlab-patches etherlab/.hg/patches  # set invisible files to view.
    $ cd etherlab
    $ hg qpush -a
    $ ./bootstrap
    $ ./configure --enable-generic --disable-8139too 
    $ make
    $ make all modules
    $ sudo make modules_install install
    $ sudo depmod

copy the /etc/init.d/ethercat to system dir.
copy the /etc/sysconfig/ethercat to system dir.

Add mac adres + generic driver to the etc/sysconfig/ethercat file.
    
    $ cat /sys/class/net/enp0s25/address     # retrieve mac adres.


    $ chmod go+rwx /etc/udev/rules.d/99-ethercat.rules
    $ echo "KERNEL=="\"EtherCAT[0-9]*\"", MODE="\"777\"", GROUP=""\"ethercat\"" > /etc/udev/rules.d/99-ethercat.rules
    
System command to restart some things:

    $ systemctl restart systemd-modules-load.service	    
    
Now you can start the EtherCAT master:

    $ sudo /etc/init.d/ethercat start  # Make this file executable first.

Additional commands : 

    $ sudo /etc/init.d/ethercat stop
    $ sudo /etc/init.d/ethercat restart
 

