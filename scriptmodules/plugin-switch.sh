#!/bin/bash
#
# RetroRig plugin switcher module
# This is a small script to copy over configuration files for emulators
# append a "-x" on the end above for debugging if need be
# Please report any errors via a pull request
# You can also reach me on twitter: @N3RD42
#



#plugin/scaling/filter switch function
function _plugin-switcher (){

cmd=(dialog --backtitle "LibreGeek.org RetroRig Installer" --menu "Plugin Configuration Menu" 16 0 16)
options=(1 "Current configuration"
	 2 "Mupen64plus"
	 3 "Back to settings menu"  
	 4 "Back to main menu")

	#make menu choice
	selection=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	#functions

	for choice in $selection
	do
		case $choice in

		1)
		#echo curent plugin settings
		#mupen64plus
		echo "Mupen64plus:" > res.txt
		grep -i "VideoPlugin = " $HOME/.config/mupen64plus/mupen64plus.cfg >> res.txt
		echo "" >> res.txt
		#Stella
		echo "Stella:" >> res.txt
		grep -i "tia_filter" $HOME/.stella/stellarc >> res.txt
		echo "" >> res.txt
		#report current resolution
		dialog --textbox res.txt 33 0
		#remove text file
		rm res.txt	
		;;

		2)
		_config-mupen 	  	 	
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


#mupen64plus plugin changer
function _config-mupen (){

#set fstart to start at specified folder directory, local var only
local fstart

cmd=(dialog --backtitle "LibreGeek.org RetroRig Installer" --menu "Default directory: ~/.config/mupen64plus" 16 0 16)
options=(1 "Change Video Plugin"
	 2 "Back to settings menu"  
	 3 "Back to main menu")

	#make menu choice
	selection=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	#functions

	for choice in $selection
	do
		case $choice in

		1)
		#present a different file loader here, since we want to start in a diff DIR.
		fstart=/usr/lib/x86_64-linux-gnu/mupen64plus
		#Maybe I can find a way to swap the dir on the fly later on
		folder=$(dialog --stdout --title "Please choose a file (spacebar to select)" --fselect $fstart/ 10 68)
		#change plugin
		m_plug_orig=$(grep -i "VideoPlugin = " $HOME/.config/mupen64plus/mupen64plus.cfg)
		sed -i "s|$m_plug_orig|VideoPlugin = $folder|g" $HOME/.config/mupen64plus/mupen64plus.cfg	
		;;

		2)
		return 	 	
		;;

		1)
		_main 	 	
		;;
	esac
	done
grep -i "VideoPlugin = " $HOME/.config/mupen64plus/mupen64plus.cfg >> res.txt

}
