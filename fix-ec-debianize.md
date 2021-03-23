Here we go and try to get ec-debianize fixed for kernels > 5.0.0

I suspect that we have to change the source to git, and checkout as 1.5.
Then see what happens.


Notes :

In /linuxcnc-ethercat/src/user.mk, repaired typo line 1 :

    "include ../configure.mk"

In /linuxcnc-ethercat/configure.mk, line 1, add :

    COMP=/opt/linuxcnc/bin/halcompile


