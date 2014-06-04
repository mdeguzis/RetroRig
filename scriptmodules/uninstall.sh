#!/bin/bash
#
# RetroRig main uninstall module
# This is a small script to copy over configuration files for emulators
# append a "-x" on the end above for debugging if need be
# Please report any errors via a pull request
# You can also reach me on twitter: @N3RD42
#

function _uninstall () {

#clear screen
clear

echo "-----------------------------------------------------------" | tee -a uninstall_log.txt
echo "Removing RetroRig..." | tee -a install_log.txt
echo "-----------------------------------------------------------" | tee -a uninstall_log.txt

#remove installed binaries
#do not remove software-properties-common, necessary pkg!
apt-get autoremove -y xboxdrv curl  \
python-software-properties pkg-config mednafen \
mame mupen64plus dconf-tools qjoypad xbmc stella \
build-essential | tee -a uninstall_log.txt

#add apport, apport-gtk back
apt-get install -y apport apport-gtk | tee -a uninstall_log.txt

dpkg --remove-architecture i386 | tee -a uninstall_log.txt

echo "-----------------------------------------------------------" | tee -a uninstall_log.txt
echo "Cleaning up repositories..." | tee -a install_log.txt
echo "-----------------------------------------------------------" | tee -a uninstall_log.txt
#xbmc
echo $userpasswd | sudo add-apt-repository -ry ppa:team-xbmc/ppa | tee -a uninstall_log.txt

echo "-----------------------------------------------------------" | tee -a uninstall_log.txt
echo "Remove RetroRig config folders..." | tee -a install_log.txt
echo "-----------------------------------------------------------" | tee -a uninstall_log.txt

#ask to keep folders
#prompt user if they wish to keep folders from install
	dialog --title "Confirm yes/no" \
	--backtitle "LibreGeek.org RetroRig Installer" \
	--yesno "Do you wish to keep configuration folders?" 5 52
	 
	# Get exit status
	# 0 means user hit [yes] button.
	# 1 means user hit [no] button.
	# 255 means user hit [Esc] key.
	response=$?
	case $response in

	0) 
	#keep folders
	sleep 2s
	;;

   	1) 
	#remove dotfiles
	echo $userpasswd | sudo rm -rf $HOME/.qjoypad3/ | tee -a uninstall_log.txt
	echo $userpasswd | sudo rm -rf $HOME/.config/mupen64plus/ | tee -a uninstall_log.txt
	echo $userpasswd | sudo rm -rf $HOME/.mame/ | tee -a uninstall_log.txt
	echo $userpasswd | sudo rm -rf $HOME/.stella/ | tee -a uninstall_log.txt
	echo $userpasswd | sudo rm -rf $HOME/.xbmc/ | tee -a uninstall_log.txt
	echo $userpasswd | sudo rm -rf $HOME/.mednafen/ | tee -a uninstall_log.txt
	echo $userpasswd | sudo rm -rf $HOME/.mess/ | tee -a uninstall_log.txt

	echo "-----------------------------------------------------------" | tee -a uninstall_log.txt
	echo "Remove init scripts and post install files..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a uninstall_log.txt

	echo $userpasswd | sudo  rm -f /etc/xdg/autostart/qjoypad.desktop
	echo $userpasswd | sudo service xboxdrv stop | tee uninstall_log.txt
	echo $userpasswd | sudo update-rc.d -f xboxdrv remove
	echo $userpasswd | sudo rm -f /etc/init.d/xboxdrv
	echo $userpasswd | sudo rm -f /etc/default/xboxdrv
	sed -i 's|blacklist xpad||g' /etc/modprobe.d/blacklist.conf| tee -a install_log.txt
	   ;;

	255)
	#Keep folders"
	sleep 2s
	;;

	esac	

echo "-----------------------------------------------------------" | tee -a uninstall_log.txt
echo "Remove RetroRig ROM folders..." | tee -a install_log.txt
echo "-----------------------------------------------------------" | tee -a uninstall_log.txt

#ask to keep folders
#prompt user if they wish to keep ROMs they loaded
	dialog --title "Confirm yes/no" \
	--backtitle "LibreGeek.org RetroRig Installer" \
	--yesno "Do you wish to keep your ROMs?" 5 52
	 
	# Get exit status
	# 0 means user hit [yes] button.
	# 1 means user hit [no] button.
	# 255 means user hit [Esc] key.
	response=$?
	case $response in

	0) 
	#Keep ROMs
	sleep 2s
	;;

   	1) 
	echo $userpasswd | sudo rm -rf $HOME/Games/ROMs/ | tee -a uninstall_log.txt
	echo $userpasswd | sudo rm -rf $HOME/Games/Tools/ | tee -a uninstall_log.txt
	echo $userpasswd | sudo rm -rf $HOME/Games/Artwork/ | tee -a uninstall_log.txt
	echo $userpasswd | sudo rm -rf $HOME/Games/Saves/ | tee -a uninstall_log.txt
	echo $userpasswd | sudo rm -rf $HOME/Games/Configs/ | tee -a uninstall_log.txt
	;;

	255)
	#Keep ROMs
	sleep 2s
	;;

	esac	

echo "-----------------------------------------------------------" | tee -a uninstall_log.txt
echo "Finishing uninstall..." | tee -a install_log.txt
echo "-----------------------------------------------------------" | tee -a uninstall_log.txt

#update Ubuntu repository listings
echo $userpasswd | sudo apt-get update | tee -a uninstall_log.txt
sleep 2s

}
