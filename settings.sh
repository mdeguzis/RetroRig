#!/bin/bash
#
#submenu script to change settings
#Version 0.6
#Please report any errors via a pull request
#
#
clear

#menu
while true; do
cmd=(dialog --backtitle "RetroRig Settings" --menu "Choose your option(s)" 16 76 16)
options=(1 "Change Resolution for emulators"
	 2 "Back to main menu"
	)
     
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
if [ "$choices" != "" ]; then
    case $choices in

	 1) 
	   bash resolution-change.sh
	   ;;
	 2) 

	   return
	   ;;

	 esac
     else
	 break
fi
done
clear
