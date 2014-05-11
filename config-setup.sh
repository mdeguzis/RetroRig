#!/bin/bash
#
#small script to copy over configuration files for emulators
#Version 0.6
#Please report any errors via a pull request
#
#
clear
echo "RetroRig requires dialog and git for installation tasks. Installing..."
sudo apt-get update >> /dev/null
sudo apt-get install git dialog >> /dev/null
sleep 2s

while true; do
    cmd=(dialog --backtitle "LibreGeek.org RetroRig Installer" --menu "Choose your option" 22 76 16)
    options=(1 "Install Software"
             2 "Set up configuration files and init scripts"
             3 "Pull latest files"
             4 ""
             5 ""
             6 "Reboot PC"
             7 "Exit" )
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    if [ "$choices" != "" ]; then
	case $choices in
            1) 	
		echo "Installing required programs..."
		sleep 2s
		clear
		sudo apt-get update
		sudo apt-get install git xboxdrv zsnes nestopia pcsxr\
		pcsx2 mame mupen64plus qjoypad xbmc dolphin-emu stella	
		echo ""
		echo "RetroRig files cloned into: $HOME/RetroRig"	 
		sleep 5s		
		#clear
		clear
		;;
	    2) 
		echo "Seting up configuration files"
		sleep 3s
		clear
		#setup skelton folders for XBMC Rom Collection Browser
		#ROMs		
		mkdir -pv $HOME/Games/ROMs/Atari\ 2600/
		mkdir -pv $HOME/Games/ROMs/Gamecube/
		mkdir -pv $HOME/Games/ROMs/Mame4All/
		mkdir -pv $HOME/Games/ROMs/N64/
		mkdir -pv $HOME/Games/ROMs/NES/
		mkdir -pv $HOME/Games/ROMs/SNES/
		mkdir -pv $HOME/Games/ROMs/PS2/
		mkdir -pv $HOME/Games/ROMs/PS1/
		mkdir -pv $HOME/Games/ROMs/sgenroms/
		mkdir -pv $HOME/Games/ROMs/SNK\ Neo\ Geo/
		#Artwork
		mkdir -pv $HOME/Games/Artwork/
		#Emulators (if any fall here)		
		mkdir -pv $HOME/Games/Emulators
		#Saves (if any)		
		mkdir -pv $HOME/Games/Saves
		#Tools		
		mkdir -pv $HOME/Games/Tools
		#configs		
		mkdir -pv $HOME/Games/Configs

		#Nestopia
		#default path: /home/$USER/.nestopia
		cp -v $HOME/RetroRig/Nestopia/nstcontrols $HOME/.nestopia/

		#gens
		#default path: /home/$USER/.gens
		#Global config
		cp -v $HOME/RetroRig/Gens-GS/gens.cfg $HOME/.gens/

		#ZSNES
		#default path: /home/$USER/.zsnes
		#Controller config
		cp -v $HOME/RetroRig/ZSNES/zinput.cfg $HOME/.zsnes/
		#emulator config
		cp -v $HOME/RetroRig/ZSNES/zsnesl.cfg $HOME/.zsnes/

		#mame
		#default path: /home/$USER/.mame
		#Main config
		cp -v $HOME/RetroRig/MAME/mame.ini $HOME/.mame/
		#controller config
		cp -Rv $HOME/RetroRig/MAME/default.cfg $HOME/.mame/cfg/

		#pcsx
		#default path: /home/$USER/.pcsx
		#Main config
		cp -v $HOME/RetroRig/pcsx/pcsx.cfg $HOME/.pcsx/

		#pcsx2
		#default path: /home/$USER/.config/pcsx2
		#Main config
		cp -v $HOME/RetroRig/pcsx2/PCSX2-reg.ini $HOME/.config/pcsx2/

		#mupen64pluspwd
		#default path: /home/$USER/.config/mupen64plus
		#Main config
		cp -v $HOME/RetroRig/mupen64plus/mupen64plus.cfg $HOME/.config/mupen64plus/

		#dolphin
		#default path /home/$USER/.dolphin-emu/
		#emulator config
		cp -Rv /$HOME/RetroRig/Dolphin/Dolphin.ini $HOME/.dolphin-emu/Config/
		#Gamecube controller config
		cp -Rv /$HOME/RetroRig/Dolphin/GCPadNew.ini $HOME/.dolphin-emu/Config/
		#Wii controller config
		#[PENDING]
		#opengl config
		cp -Rv /$HOME/RetroRig/Dolphin/gfx_opengl.ini $HOME/.dolphin-emu/Config/

		#copy configs for other utilities
		cp -v $HOME/RetroRig/controller-cfg/qjoypad_launch.sh $HOME/Games/Configs/
		cp -v $HOME/RetroRig/controller-cfg/xpad-wireless.xboxdrv $HOME/Games/Configs/

		#clear and prompt
	        ;;
            3)
		echo "updating git repo"
		sleep 2s
		cd $HOME/RetroRig/
		git pull 
		;;
            4)  ;;
            5)  ;;
            6)  ;;
            7)
	        echo "Rebooting in 5 seconds, press CTRL+C to cancel"
                sleep 5s
                sudo reboot 
	        ;;
            8) 
	        break
                ;;
         esac
     else
	 break
     fi
done     
clear



