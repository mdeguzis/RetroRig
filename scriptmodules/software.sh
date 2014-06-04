#!/bin/bash
#
# RetroRig setup module
# This is a small script to copy over configuration files for emulators
# append a "-x" on the end above for debugging if need be
# Please report any errors via a pull request
# You can also reach me on twitter: @N3RD42
#

#software function
function _software () {

	#clear screen for output
	clear

	#add multi-arch support
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Adding multi-arch support..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	dpkg --add-architecture i386 | tee -a install_log.txt


	#add repository for official team XBMC "stable"
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Adding XBMC Ubuntu (stable) repository..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	add-apt-repository -y ppa:team-xbmc/ppa | tee -a install_log.txt

	#Add playdeb repo for later additions (very useful) 
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Add PlayDeb  Repository..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "deb http://archive.getdeb.net/ubuntu trusty-getdeb games" > /tmp/playdeb.list | tee -a install_log.txt
	mv /tmp/playdeb.list /etc/apt/sources.list.d/playdeb.list | tee -a install_log.txt
	wget -q -O- http://archive.getdeb.net/getdeb-archive.key > getdeb.key | tee -a install_log.txt
	sudo apt-key add getdeb.key | tee -a install_log.txt
	rm -f getdeb.key | tee -a install_log.txt

	#update repository listings
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Updating packages..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt	
	apt-get update | tee -a install_log.txt

	#install software from repositories
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Installing required packages..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	apt-get install -y xboxdrv curl \
	python-software-properties pkg-config software-properties-common mednafen \
	mame mupen64plus dconf-tools mess jstest-gtk qjoypad xbmc stella \
	build-essential | tee -a install_log.txt


	#Removal of software for related bugs
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Removing troublesome packages..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	apt-get remove -y apport apport-gtk | tee -a install_log.txt
	echo "" | tee -a install_log.txt
	echo "Remove apport to avoid constant gtk bug report instances until solved" | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Please reference the following bug report:" | tee -a install_log.txt
	echo "Reported by cecilpierce on 2012-06-05 on Launchpad" | tee -a install_log.txt
	echo "https://bugs.launchpad.net/ubuntu/+source/plymouth/+bug/1009238" | tee -a install_log.txt
	
	
	#clear screen
	clear
}
