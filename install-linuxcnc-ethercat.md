
At this moment ec-debianize is no longer required to connect ethercat with linuxcnc.


#### This is how to install linuxcnc-ethercat. Linuxcnc-ethercat is responsible for the lcec.so driver and lcec_conf for linuxcnc.
#### Install folder : /opt/linuxcnc/addons/linuxcnc-ethercat

I fixed some typo's in the source code and removed unused code. Linker problem solved thanks to Stormholds makefile example.
It now installs the lcec.so (in /opt/linuxcnc/rtlib) and lcec_conf (in /opt/linuxcnc/bin) 

    git clone https://github.com/grotius-cnc/linuxcnc-ethercat.git
    # edit configure.mk file, set your linuxcnc halcompile filepath.
    make
    make install
    
#### I now have linuxcnc and linuxcnc-ethercat installed. Let's test the lcec.so.

    /opt/linuxcnc/bin$ halshow
    > loadrt threads name1=base-thread fp1=0 period1=15000 name2=servo-thread period2=1000000
    > loadusr -W /opt/linuxcnc/bin/lcec_conf /path_to_yours/ethercat-conf.xml
    
    Contents of ethercat-conf.xml :
            <masters>
            <master idx="0" appTimePeriod="15000" refClockSyncCycles="1000000">
            <slave idx="0" type="EK1100" name="Terminal"/>
            <slave idx="1" type="EL2124" name="output_stepper_1"/>
            <slave idx="2" type="EL2124" name="output_stepper_2"/>
            </master>
            </masters>

    > loadrt lcec

#### Test ok. Everything works.
    


    
    



    
    
    
    

