## Debian Distro Rebranding "DDR" Usable for Debian 10.

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
	
	
## Step 2 : Tweaking. Customize the live-build, also called *"remastering"*.

Follow the steps of file :

		$ geany chroot-start.txt
		$ perform the chroot-start commands from directory : yourfilepath/iso/

When the chroot command is done, you are in a virtual environment at : /iso/chroot/ This is the source directory of your new debian os.

		# This is how it looks like to be live :
		#
		# (live):/ $ mount none -t proc /proc
		# (live):/ $ mount none -t sysfs /sys
		# (live):/ $ mount none -t devpts /dev/pts
		# (live):/ $ export HOME=/root
		# (live):/ $ export LC_ALL=C
		# (live):/ $ export PS1="\e[01;31m(live):\W \$ \e[00m"
		# (live):/ $
		# (live):/ $ dhclient -v 
		# (live):/ $ sudo apt-get install qtcreator etc. to tweak your debian installation to your needs.
		# (live):/ $
		# (live):/ $
		# (live):/ $ umount /proc /sys /dev/pts
		# $ exit
	
## Step 3 : Repack the Iso with the updated files.	
	
This was the hard part to investegate.

		$ sudo chmod 777 create-iso.sh  # This only after a fresh git clone
		$ sudo ./create-iso.sh

1. This will replace a SquashFS file in */iso/binary/live/*.
2. This will extract a template file in */iso/isohdpfx.bin* from the existing live-build iso file.
3. This will create a new iso with the program Xorriso. The Xorriso build commands can be copied from the existing live-build iso in : */.disk/mkisofs*

*** Notes : When the output in terminal is fast and " cannot read ... ", your unmounting in step 2 has failed.
*** Notes : During repacking the iso, Xorriso has some output message's about filmware. Don't worry about this.
		
## Step 4 : Burn the ISO to cd, dvd or usb drive.

Option 1 : Use Xfburn to burn your new Distro on a CD or Dvd
Option 2 : Create a bootable usb device with the iso on it.

		$ lsblk 	
			# sdb is your usb.					
			
		$ sudo dd bs=4M if=/yourpath/live-image-amd64.hybrid.iso of=/dev/sdb conv=fdatasync status=progress
			
			# "dd" is a linux command that copies the iso onto the usb drive.

## Summary build commands :

		$ sudo chmod 777 create-live-build-buster.sh  && sudo chmod 777 create-iso.sh
		$ sudo ./create-live-build-buster.sh
		$ echo "now open up the file : chroot-start.txt and follow the steps"
		$ sudo ./create-iso.sh
		$ echo "I mean what could go wrong?"

## Multiple Live Tests, to proof concept :

I did a *"create-live-build-buster.sh"*.
	This outputs live-image-amd64.hybrid.iso wich i installed trough usb storage device and worked ok.
	
I did a *"create-live-build-buster.sh"* + *"create-iso.sh"*.
	This outputs a live-image-amd64.hybrid-modified.iso wich i installed trough usb storage device and worked ok.
	This procedure is fact, creating a iso and repack it again. It's a proof the repacking process is oke.

I did a *"create-live-build-buster.sh"* + *"chroot-start.txt procedure"* + *"create-iso.sh"*.
	The only program i added was librecad during the chroot-start procedure.
	This outputs a live-image-amd64.hybrid-modified.iso wich i installed trough usb storage device and worked ok.


To get this far. It took me multiple day's with trail and error. 
A freightening error was after installing the new iso and opening a terminal in the new system i got :
	
	(live)user@user:$

It was caused by this example : https://github.com/RackunSec/debian-custom-iso-scripts
Glad i tried another example that solved it : https://github.com/Oros42/CustomDebian

But finding the cause of the error, took quite a while. It had to do with incorrect mount/umount i guess.
Normally a live-build would make a Debian 11 distro for you. But somehow the live-build was not working as expected.
I needed to learn the tweaking process and needed to learn to repack the iso with the updated files.
This document show's how i did the process. Thanks to the links below i was able to get good info !

## References :
- https://live-team.pages.debian.net/live-manual/html/live-manual/customizing-package-installation.en.html
- https://wiki.debian.org/RepackBootableISO
- https://packages.debian.org/stable/
- https://manpages.debian.org/stretch/live-build/lb_config.1.en.html
- https://docs.github.com/en/github/writing-on-github/basic-writing-and-formatting-syntax
- https://github.com/Oros42/CustomDebian Had the solution for my problem's with chroot and mount.
- https://github.com/RackunSec/debian-custom-iso-scripts My starting point for tweaking the distro and repack the iso.
- https://sourceforge.net/projects/eznixos This was my starting point for my first distro. 
Not used in this document, but a nice tip to look at :
- https://wiki.debian.org/Debootstrap Debootstrap is a tip to look at. A handy tool to setup a linux environment.
- https://willhaley.com/blog/custom-debian-live-environment/
- https://www.paranoids.at/create-custom-debian-buster-live/


