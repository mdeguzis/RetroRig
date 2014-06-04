#!/bin/bash
#
# RetroRig settings module
# This is a small script to copy over configuration files for emulators
# append a "-x" on the end above for debugging if need be
# Please report any errors via a pull request
# You can also reach me on twitter: @N3RD42
#

function _settings (){

cmd=(dialog --backtitle "LibreGeek.org RetroRig Installer" --menu "Settings Menu" 16 0 16)
options=(1 "Change resolution"  
	 2 "Load ROMs"
	 3 "Change plugins/filters/scaling"
	 4 "Change Gamepad Type"
	 5 "Enable SSH support"
	 6 "Back to main menu")

	#make menu choice
	selection=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	#functions
grep -i "VideoPlugin = " $HOME/.config/mupen64plus/mupen64plus.cfg >> res.txt
	for choice in $selection
	do
		case $choice in
		1)  	
		_resolution
		#call settings rather than return so user can choose again
		_settings
		;;

		2)  	
		bash scriptmodules/rom-loader.sh
		#call settings rather than return so user can choose again
		_settings
		;;

		3)
		dialog --msgbox "Option disabled for further testing" 5 40  	
		#_plugin-switcher
		#call settings rather than return so user can choose again
		_settings
		;;

		4)  	
		_gamepad
		#call settings rather than return so user can choose again
		_settings
		;;

		5)
		clear
		#install openssh-server  
		apt-get install -y openssh-server | tee -a install_log.txt
		#prompt user to change default port
		dialog --title "Set desired SSH port (typically 22)" --inputbox "Enter Port" 10 0 2> /tmp/set_ssh
		#cat input
		ssh_new=$(cat '/tmp/set_ssh')
		#set orig port 
		ssh_org=$(grep -i "Port " /etc/ssh/sshd_config)
		#set new port from user input
		sed -i "s|$ssh_org|Port $ssh_new|g" /etc/ssh/sshd_config
		#restart ssh service
		service ssh restart
		#remove temp file
		rm -f /tmp/set_ssh
		#return to menu
		_settings
		;;

		6)  
		return
		;;
	esac
	done
}
