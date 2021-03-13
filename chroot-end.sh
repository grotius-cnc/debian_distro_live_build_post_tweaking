#!/bin/bash

cd iso
umount {chroot/dev/pts,chroot/dev,chroot/sys,chroot/proc,chroot/run}
