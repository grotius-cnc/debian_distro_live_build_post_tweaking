Here we go and try to get ec-debianize fixed for kernels > 5.0.0

I suspect that we have to change the source to git, and checkout as 1.5.
Then see what happens.


Notes :

#### This is how to install linuxcnc-ethercat. Linuxcnc-ethercat is responsible for the lcec.so driver and lcec_conf for linuxcnc.

    git clone https://github.com/grotius-cnc/linuxcnc-ethercat.git

#### In /linuxcnc-ethercat/src/user.mk, repaired typo line 1 :

    "include ../configure.mk"
    
#### In /linuxcnc-ethercat/Makefile, line 8, don't remove configure.mk. This is not clever to do so.

    #rm -f configure.mk configure.mk.tmp

#### In /linuxcnc-ethercat/configure.mk, line 1, add :

    COMP=/opt/linuxcnc/bin/halcompile # This is the new path to linuxcnc as it is installed in the /opt/linuxcnc directory.

#### Compile output is ok :

    $ make

    make[1]: Entering directory '/home/user/linuxcnc-ethercat/src'
    make[2]: Entering directory '/home/user/linuxcnc-ethercat/src'
    user.mk:15: warning: overriding recipe for target 'install'
    /opt/linuxcnc/src/Makefile.modinc:106: warning: ignoring old recipe for target 'install'
    gcc -o lcec_conf.o -Os -g -I. -I/opt/linuxcnc/src/include -DUSPACE -fno-fast-math -mieee-fp -fno-unsafe-math-optimizations -DRTAPI -D_GNU_SOURCE -Drealtime -D__MODULE__ -I/opt/linuxcnc/include -DSIM -fPIC -URTAPI -U__MODULE__ -DULAPI -Os -c lcec_conf.c
    gcc -o lcec_conf_util.o -Os -g -I. -I/opt/linuxcnc/src/include -DUSPACE -fno-fast-math -mieee-fp -fno-unsafe-math-optimizations -DRTAPI -D_GNU_SOURCE -Drealtime -D__MODULE__ -I/opt/linuxcnc/include -DSIM -fPIC -URTAPI -U__MODULE__ -DULAPI -Os -c lcec_conf_util.c
    gcc -o lcec_conf_icmds.o -Os -g -I. -I/opt/linuxcnc/src/include -DUSPACE -fno-fast-math -mieee-fp -fno-unsafe-math-optimizations -DRTAPI -D_GNU_SOURCE -Drealtime -D__MODULE__ -I/opt/linuxcnc/include -DSIM -fPIC -URTAPI -U__MODULE__ -DULAPI -Os -c lcec_conf_icmds.c
    gcc -o lcec_conf lcec_conf.o lcec_conf_util.o lcec_conf_icmds.o  -Wl,-rpath,/opt/linuxcnc/lib -L/opt/linuxcnc/lib -llinuxcnchal -lexpat
    make[2]: Leaving directory '/home/user/linuxcnc-ethercat/src'
    make[2]: Entering directory '/home/user/linuxcnc-ethercat/src'
    /opt/linuxcnc/src/Makefile.modinc:106: warning: overriding recipe for target 'install'
    /opt/linuxcnc/src/Makefile.modinc:106: warning: ignoring old recipe for target 'install'
    Compiling realtime lcec_main.c
    Compiling realtime lcec_class_enc.c
    Compiling realtime lcec_generic.c
    Compiling realtime lcec_ax5200.c
    Compiling realtime lcec_el1xxx.c
    Compiling realtime lcec_el1252.c
    Compiling realtime lcec_el1859.c
    Compiling realtime lcec_el2521.c
    Compiling realtime lcec_el2xxx.c
    Compiling realtime lcec_el2202.c
    Compiling realtime lcec_el31x2.c
    Compiling realtime lcec_el31x4.c
    Compiling realtime lcec_el3255.c
    Compiling realtime lcec_el40x1.c
    Compiling realtime lcec_el40x2.c
    Compiling realtime lcec_el40x8.c
    Compiling realtime lcec_el41x2.c
    Compiling realtime lcec_el41x4.c
    Compiling realtime lcec_el5101.c
    Compiling realtime lcec_el5151.c
    Compiling realtime lcec_el5152.c
    Compiling realtime lcec_el6900.c
    Compiling realtime lcec_el1904.c
    Compiling realtime lcec_el2904.c
    Compiling realtime lcec_el7041_1000.c
    Compiling realtime lcec_el7211.c
    Compiling realtime lcec_el7342.c
    Compiling realtime lcec_el95xx.c
    Compiling realtime lcec_em7004.c
    Compiling realtime lcec_stmds5k.c
    Compiling realtime lcec_deasda.c
    Compiling realtime lcec_omrg5.c
    Compiling realtime lcec_ph3lm2rm.c
    Linking lcec.so
    make[2]: Leaving directory '/home/user/linuxcnc-ethercat/src'
    make[1]: Leaving directory '/home/user/linuxcnc-ethercat/src'
    
#### In /linuxcnc-ethercat/src/Makefile, line 10, repaired typo :    

    install: ../configure.mk
    
#### In /linuxcnc-ethercat/examples/Makefile, line 1, repaired typo :    

    install: ../configure.mk  
    
#### Compile output is ok :

    $ make install
    
    make[1]: Entering directory '/home/user/linuxcnc-ethercat/src'
    Makefile:10: warning: overriding recipe for target 'install'
    /opt/linuxcnc/src/Makefile.modinc:106: warning: ignoring old recipe for target 'install'
    mkdir -p /opt/linuxcnc/rtlib
    make[2]: Entering directory '/home/user/linuxcnc-ethercat/src'
    user.mk:15: warning: overriding recipe for target 'install'
    /opt/linuxcnc/src/Makefile.modinc:106: warning: ignoring old recipe for target 'install'
    mkdir -p /opt/linuxcnc/bin
    cp lcec_conf /opt/linuxcnc/bin/
    make[2]: Leaving directory '/home/user/linuxcnc-ethercat/src'
    make[2]: Entering directory '/home/user/linuxcnc-ethercat/src'
    /opt/linuxcnc/src/Makefile.modinc:106: warning: overriding recipe for target 'install'
    /opt/linuxcnc/src/Makefile.modinc:106: warning: ignoring old recipe for target 'install'
    cp lcec.so /opt/linuxcnc/rtlib/
    make[2]: Leaving directory '/home/user/linuxcnc-ethercat/src'
    make[1]: Leaving directory '/home/user/linuxcnc-ethercat/src'
    make[1]: Entering directory '/home/user/linuxcnc-ethercat/examples'
    mkdir -p /opt/linuxcnc/share/linuxcnc-ethercat/examples
    cp -R generic-complex swm-fm45a /opt/linuxcnc/share/linuxcnc-ethercat/examples
    make[1]: Leaving directory '/home/user/linuxcnc-ethercat/examples'
    
    

    
    
    
    

