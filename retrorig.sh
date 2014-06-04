#!/bin/bash
#
# RetroRig Main Setup Script
# This is a small script to copy over configuration files for emulators
# append a "-x" on the end above for debugging if need be
# Version 0.7.9
# Please report any errors via a pull request
# You can also reach me on twitter: @N3RD42
#

#remove previous install log to start fresh
rm -f install_log.txt
#remove previous uninstall log, if any
rm -f uninstall_log.txt

#start logging
echo "-----------------------------------------------------------" >> install_log.txt
echo "Starting install log..." >> install_log.txt
echo "-----------------------------------------------------------" >> install_log.txt

######################################
# Start main script
######################################


while true; do
cmd=(dialog --backtitle "LibreGeek.org RetroRig Installer" --menu "| Main Menu | \
			 Any required BIOS files are NOT provided!" 17 62 16)
options=(1 "Install Software" 
	 2 "Set up default configuration files" 
	 3 "Retro Rig Settings" 
	 4 "Pull latest files from git" 
	 5 "Update emulator binaries" 
	 6 "Upgrade System (use with caution!)" 
	 7 "Start RetroRig" 
	 8 "Reboot PC"
	 9 "Uninstall RetroRig"  
	 10 "Exit")

	#make menu choice
	choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	#functions

	if [ "$choices" != "10" ]; then
		case $choices in

		1)  	
		_software
		#call memu rather than return so user can choose again
		_main
		;;

		2)  
		bash scriptmodules/configuration.sh
		#call memu rather than return so user can choose again
		_main 
		;;

		3)
		bash scriptmodules/settings.sh
		#call memu rather than return so user can choose again
		_main
		;;

		4)
		_update-git
		#reload script with changes
		bash config-setup.sh
		;;

		5)
		_update-binaries
		#call memu rather than return so user can choose again
		_main
		;;

		6)
		_upgrade-system
		#call memu rather than return so user can choose again
		_main
		;;

		7)
		_start-xbmc
		#call memu rather than return so user can choose again
		_main
		;;

		8)
		_reboot
		#call memu rather than return so user can choose again
		_main
		;;

		9)
		#confirm uninstall is the intended action
		dialog --title "Confirm yes/no" \
		--backtitle "LibreGeek.org RetroRig Installer" \
		--yesno "Are you sure you want remove RetroRig?"  6 0

		# Get exit status
		# 0 means user hit [yes] button.
		# 1 means user hit [no] button.
		# 255 means user hit [Esc] key.
		response=$?
		case $response in
			0)
			_uninstall
			;;

			1) 
			dialog --infobox "Exiting Uninstall"  3 11
			sleep 2s
			_main
			;;

			255)
			dialog --infobox "Exiting Uninstall" 3 0
			sleep 2s
			_main
			;;
		esac

		#call memu rather than return so user can choose again
		_main
		;;

		10)
		clear
		exit
		;;

		esac
	else
		break
	fi
done
}

function _update-git () {
	clear
	echo "-----------------------------------------------------------" |tee -a install_log.txt
	echo "Updating git repo" | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	sleep 2s
	cd $HOME/RetroRig/
	git pull
	#pause for reviewing changes
	sleep 5s
	
	#clear
	clear

	bash config-setup.sh
}

function _update-binaries () {
	clear
	echo "-----------------------------------------------------------" |tee -a install_log.txt
	echo "Updating emulator binaries" | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	apt-get install -y xboxdrv curl zsnes nestopia pcsxr pcsx2:i386 \
	python-software-properties pkg-config software-properties-common mess \
	mame mupen64plus dconf-tools mednafen qjoypad xbmc dolphin-emu-master stella \
	build-essential | tee -a install_log.txt	
	sleep 3s
	#clear
	clear
}

function _upgrade-system () {
	clear
	echo "-----------------------------------------------------------" |tee -a install_log.txt
	echo "Upgrading system" | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	apt-get update
	apt-get upgrade
	sleep 3s
	#clear
	clear
}

function _start-xbmc () {
	dialog --infobox "starting RetroRig" 3 21
	sleep 1s
	xbmc
	#clear
	clear
}

function _reboot () {

	data=$(tempfile 2>/dev/null)
 
	# trap it
	trap "rm -f $data" 0 1 2 5 15
	 
	# get password with the --insecure option
	dialog --title "Enter password to confirm!" \
	--clear \
	--insecure \
	--passwordbox "Enter your user password" 7 28 2> $data
	 
	ret=$?
       #Exit status is subject to being overridden  by  environment  variables.
       #Normally they are:
       #0    if dialog is exited by pressing the Yes or OK button.
       #1    if the No or Cancel button is pressed.
       #2    if the Help button is pressed.
       #3    if the Extra button is pressed.
       #-1   if  errors occur inside dialog or dialog is exited by pressing the
       #     ESC key.

	case $ret in
	  0)
	    dialog --infobox "Rebooting PC" 3 0 ; sleep 2s
	    sleep 5s
	    /sbin/reboot
	    ;;
	  1)
	    dialog --infobox "Cancel Pressed" 3 18 ; sleep 2s
	    sleep 2s
	    ;;
	  255)
	    [ -s $data ] &&  cat $data || echo "ESC pressed.";;
	esac

}
