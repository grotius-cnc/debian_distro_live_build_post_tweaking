Here we go and try to get ec-debianize fixed for kernels > 5.0.0

I suspect that we have to change the source to git, and checkout as 1.5.
Then see what happens.




#### This is how to install linuxcnc-ethercat. Linuxcnc-ethercat is responsible for the lcec.so driver and lcec_conf for linuxcnc.
#### I fixed some typo's in the source code and removed unused code.
#### It now installs the lcec.so and lcec_conf into the linuxcnc folders.

    git clone https://github.com/grotius-cnc/linuxcnc-ethercat.git
    # edit configure.mk file, set your linuxcnc halcompile filepath.
    make
    make install
    
    



    
    
    
    

