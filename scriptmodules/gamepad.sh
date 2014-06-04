#!/bin/bash
#
# RetroRig gamepad select module
# This is a small script to copy over configuration files for emulators
# append a "-x" on the end above for debugging if need be
# Please report any errors via a pull request
# You can also reach me on twitter: @N3RD42
#

function _gamepad (){

	#log change in install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Setting Controller Gamepad..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt

cmd=(dialog --backtitle "LibreGeek.org RetroRig Installer" --menu "| Gamepad Select | \
			 Request any new Gamepads via github!" 16 62 16)
options=(1 "Xbox 360 Controller (wireless) (4-player)" 
	 2 "Xbox 360 Controller (wired) (4-player)" 
	 3 "Exit gamepad selection"
	 4 "Back to main menu")

	#make menu choice
	selection=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	#functions

	for choice in $selection
	do
		case $choice in

		1)
		_config-x360ws
		return
		;;

		2)
		_config-x360wd
		return
		;;

		3)
		return
		;;

		4)
		_main
		;;
		esac
	done
}
