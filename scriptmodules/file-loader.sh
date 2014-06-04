#!/bin/bash
#
# RetroRig file-loader module
# This is a small script to copy over configuration files for emulators
# append a "-x" on the end above for debugging if need be
# Please report any errors via a pull request
# You can also reach me on twitter: @N3RD42
#

function _file-loader (){

folder=$(dialog --stdout --title "Please choose a file (spacebar to select)" --fselect $HOME/ 14 48)
echo "${folder} file chosen."
}


#Load ROMs at will-call, or yes/no on configuration run
function _rom-loader (){

cmd=(dialog --backtitle "LibreGeek.org RetroRig Installer" --menu "Load ROMs for which system?" 19 32 24)
options=(1 "Atari 2600" 
	 2 "NES" 
	 3 "SNES" 
	 4 "Nintendo 64"
	 5 "MAME"
	 6 "Sega Master System"
	 7 "Sega Game Gear"
	 8 "GBC"
	 9 "GBC"
	 10 "TurboGraphix 16"
	 11 "Exit ROM Loader")

	#make menu choice
	selection=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	#functions

	for choice in $selection
	do
		case $choice in
		1)
		#call file loader  	
		_file-loader
		#copy Atari ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading Atari ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv "$folder"/* $HOME/Games/ROMs/Atari\ 2600/ | tee -a install_log.txt
		#return back to menu
		_rom-loader
		;;

		2)  
		#call file loader  	
		_file-loader
		#copy NES ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading NES ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv "$folder"/* $HOME/Games/ROMs/NES/ | tee -a install_log.txt
		#return back to menu
		_rom-loader
		;;

		3)
		#call file loader  	
		_file-loader
		#copy SNES ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading SNES ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv "$folder"/* $HOME/Games/ROMs/SNES/ | tee -a install_log.txt
		#return back to menu
		_rom-loader
		;;

		4)
		#call file loader  	
		_file-loader
		#copy N64 ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading N64 ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv "$folder"/* $HOME/Games/ROMs/N64/ | tee -a install_log.txt
		#return back to menu
		_rom-loader
		;;

		5)
		#call file loader  	
		_file-loader
		#copy MAME ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading MAME ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv "$folder"/* $HOME/Games/ROMs/MAME/ | tee -a install_log.txt
		#return back to menu
		_rom-loader
		;;

		6)
		#call file loader  	
		_file-loader
		#copy Sega Master System ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading Sega Master System ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv "$folder"/* $HOME/Games/ROMs/Sega\ Master\ System/ | tee -a install_log.txt
		#return back to menu
		_rom-loader
		;;

		7)
		#call file loader  	
		_file-loader
		#copy Sega Game Gear ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading Sega Game Gear ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv "$folder"/* $HOME/Games/ROMs/Sega\ Game\ Gear/ | tee -a install_log.txt
		#return back to menu
		_rom-loader
		;;

		8)
		#call file loader  	
		_file-loader
		#copy GBC ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading GBC ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv "$folder"/* $HOME/Games/ROMs/GBC/ | tee -a install_log.txt
		#return back to menu
		_rom-loader
		;;

		9)
		#call file loader  	
		_file-loader
		#copy GBA ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading GBA ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv "$folder"/* $HOME/Games/ROMs/GBA/ | tee -a install_log.txt
		#return back to menu
		_rom-loader
		;;

		10)
		#call file loader  	
		_file-loader
		#copy Turbographx 16 ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading Turbographx 16 ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv "$folder"/* $HOME/Games/ROMs/TurboGraphx\ 16/ | tee -a install_log.txt
		#return back to menu
		_rom-loader
		;;

		11)  
		return
		;;
		esac
	done
}

