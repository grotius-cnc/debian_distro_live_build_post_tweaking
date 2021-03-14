
- Date 		:	13-03-2021
- Author 	: 	Grotius Skynet
- Licence 	: 	GPL2
- Comments	:	 

	This document is for rebranding, modifying a standard Debian distro, based on a live-build procedure.
	I made this document for making a Debian 11 Bulsseye Distro with RealTime kernel.
	This kind of software manipulation is time consuming. This process can take up to several hours.

	After this live-build, tweaking the source code of the Debian distro is done by adding or remove software to your needs.
	This adding or removing of software can normally be done by the live-build procedure, but i found some problems with
	the live-build procedure : Building a Debian 11 Bullseye with realtime kernel is somehow not succesfull at the moment.
	So this tweak is a solution. 

	After the adding or removing of software, we create a new iso and we are done !


- Step 1 : Live-build.

- The live-build is a linux software that does a lot of work for you. It's really a nice program that does good work !
	   - It has a few commands like : lb clean, lb build, etc.
- The live-build producere outputs a standard debian iso file containing a distro like Debian 10 Buster.
- The script can we tweaked to add or remove .deb files.
- We stay at disto buster in this script to be sure the iso is made succesfully.

$ sudo ./create-live-build.sh

- Creates a directory /iso/ containing the live-build source code and hybrid.iso dvd output.

Recommendends : Make a temponairy copy of the whole /iso dir to stay safe when you accidentaly messed things up in next step.
My copy was 7.4 gb.

Or make a archive with 	$ tar -czvf iso_archive.tar.gz iso
Unzip command 			$ tar -xf iso_archive.tar.gz
	
	
- Step 2 : Tweak the outputted live-build source code. (reboot required after this step, read..)

Pre-Recommendends : When you are new to this, you could go to Step 3 now. When Step 3 is succesfull you can repeat the process from here.

- We add or remove software in this stage, like .deb files. We can add programs like geany or xfburn etc with are .deb packages.
- We add the Debian Bullseye reprository to our /etc/apt/sources.list and we add the latest realtime kernel .deb packages

- In this stage we have to log into our live-build source dir. We log into the live-build directory by a mount procedure.

$ sudo ./chroot-start.sh

- Now your terminal is in live-mode, check your terminal username. In fact you are now in a virtual os environment. 
- You are now in a virtual environment at : /iso/chroot/ This is the source directory of your new os.

	 $ dhclient -v 						# Internet connection
	 $ sudo apt-get install qtcreator  	# Tweak your distro.
	 $ 
	 $   
	 $ - Consider to add the tweaklist.txt over here.  
	 $    
	 $ exit

	 *** Now do a reboot....
	 *** Or find a command to do a correct unmount...
	 *** Without a reboot i got repeating terminal message " cannot read ... ". 

	 If it shows : "Parallel mksquashfs: Using 2 processors", its oke, unmount is done !!

Edit. Fixed, no reboot required, unmounting : $ sudo ./chroot-end.sh
	
- Step 3 : Create a new iso dvd.	
	
This was the hard part to investegate.

$ sudo ./create-iso.sh

1. This will replace a SquashFS file in /iso/binary/live/
2. This will extract a template file in /iso/isohdpfx.bin from the existing live-build iso file.
3. This will create a new iso with the program Xorriso. The Xorriso build commands can be copied from the existing live-build iso in : /.disk/mkisofs


*** Notes : When the output in terminal is fast and " cannot read ... ", then do a reboot, and Step 3 again.


		
- Step 4 : Use Xfburn to burn your new Distro.
	

Summary user commands, you can stay in the same dir :

- $ sudo ./create-live-build.sh
- $ sudo ./chroot-start.sh
- $ sudo ./create-iso.sh


Reference :
- https://wiki.debian.org/RepackBootableISO








