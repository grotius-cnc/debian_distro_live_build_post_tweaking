## Debian Distro Rebranding "DDR" 

This document is for rebranding, modifying a standard Debian distro, based on a live-build procedure.
I made this document for making a Debian 11 Bulsseye Distro with RealTime kernel.
This kind of software manipulation is time consuming. This process can take up to several hours.

After this live-build, tweaking the source code of the Debian distro is done by adding or remove software to your needs.
This adding or removing of software can normally be done by the live-build procedure, but i found some problems with
the live-build procedure : Building a Debian 11 Bullseye with realtime kernel is somehow not succesfull at the moment.
So this tweak is a solution. 

After the adding or removing of software, we create a new iso and we are done !


## Step 1 : Live-build.

The live-build is a linux software that does a lot of work for you. It's really a nice program that does good work !
It has a few commands like : *lb clean, lb build, etc.*
The live-build procedure outputs a standard debian iso file containing a distro like Debian 10 Buster.
The script can we tweaked to add or remove .deb files.
We stay at disto buster in this script to be sure the iso is made succesfully.

		$ sudo chmod 777 create-live-build-buster.sh  # This only after a fresh git clone
		$ sudo ./create-live-build-buster.sh

- Creates a directory */iso/* containing the live-build source code and the *live-image-amd64.hybrid.iso*
- Recommendends : Make a temponairy copy of the whole /iso dir to stay safe when you accidentaly messed things up in next step.

Create archive : 	

		$ tar -czvf iso_archive.tar.gz iso

Unpack archive : 

		$ tar -xf iso_archive.tar.gz
	
	
## Step 2 : Tweaking. Customize the live-build, also called *remastering*.

Pre-Recommendends : When you are new to this, you could go to Step 3 now. When Step 3 is succesfull you can repeat the process from here.

1. We add the Debian Bullseye reprository to our /etc/apt/sources.list and we add the latest realtime kernel .deb packages
2. We add or remove software in this stage, like .deb files. We can add programs like geany or xfburn etc with are .deb packages.
3. In this stage we have to log into our live-build source dir. We log into the live-build directory by a mount procedure.

		$ sudo chmod 777 chroot-start.sh  # This only after a fresh git clone
		$ sudo ./chroot-start.sh

- Now your terminal is in live-mode, check your terminal username. In fact you are now in a virtual os environment. 
- You are now in a virtual environment at : /iso/chroot/ This is the source directory of your new os.

		$ (live)root@user: dhclient -v 				# Activate internet connection
		$ (live)root@user: sudo apt-get install qtcreator  	# Tweak your distro.
		$ (live)root@user:
		$ (live)root@user:
		$ (live)root@user: - Consider to add the tweaklist.txt over here.  
		$ (live)root@user:
		$ (live)root@user: exit
		$ sudo ./chroot-end.sh					# Unmount command.
	
## Step 3 : Repack the Iso with the updated files.	
	
This was the hard part to investegate.

		$ sudo chmod 777 create-iso.sh  # This only after a fresh git clone
		$ sudo ./create-iso.sh

1. This will replace a SquashFS file in */iso/binary/live/*.
2. This will extract a template file in */iso/isohdpfx.bin* from the existing live-build iso file.
3. This will create a new iso with the program Xorriso. The Xorriso build commands can be copied from the existing live-build iso in : */.disk/mkisofs*

*** Notes : When the output in terminal is fast and " cannot read ... ", then do a reboot, and Step 3 again.
		
## Step 4 : Burn the ISO to cd, dvd or usb drive.

Option 1 : Use Xfburn to burn your new Distro on a CD or Dvd
Option 2 : Create a bootable usb device with the iso on it.

		$ lsblk 	
			# sdb is your usb.					
			
		$ sudo dd bs=4M if=/yourpath/live-image-amd64.hybrid.iso of=/dev/sdb conv=fdatasync status=progress
			
			# "dd" is a linux command that copies the iso onto the usb drive.

## Summary build commands :

		$ sudo chmod 777 create-live-build-buster.sh  && sudo chmod 777 chroot-start.sh  && sudo chmod 777 create-iso.sh
		$ sudo ./create-live-build-buster.sh
		$ sudo ./chroot-start.sh
		$ sudo ./create-iso.sh
		$ echo "I mean what could go wrong?"

## References :
- https://wiki.debian.org/RepackBootableISO
- https://packages.debian.org/stable/
- https://manpages.debian.org/stretch/live-build/lb_config.1.en.html
- https://docs.github.com/en/github/writing-on-github/basic-writing-and-formatting-syntax








