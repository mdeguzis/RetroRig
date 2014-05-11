#!/bin/bash

#small script to copy over configuration files for emulators
#Version 0.6
#Please report any errors via a pull request

#auto install dialog
echo "RetroRig requires dialog for installation tasks. Installing..."
sudo apt-get install dialog >> /dev/null
sleep 2s 

PS3='Please enter your choice: '
options=("Install Software" "Setup configuration files" "Reboot PC" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Install Software")
            echo "Installing required programs..."
	    sleep 2s
	    clear
	    sudo apt-get update
	    sudo apt-get install git xboxdrv zsnes nestopia pcsxr\
	    pcsx2 mame mupen64plus qjoypad xbmc dolphin-emu stella
	    sleep 5s
	    #clear and prompt
	    clear
	    echo "Please enter your choice:"	
            echo "1) Install Software	      3) Other"
	    echo "2) Setup configuration files  4) Quit"
            ;;
        "Setup configuration files")
            echo "Configuring..."
		sleep 2s
		clear
		#setup skelton folders for XBMC Rom Collection Browser
		mkdir -pv $HOME/Games/ROMs
		mkdir -pv $HOME/Games/Artwork
		mkdir -pv $HOME/Games/Emulators
		mkdir -pv $HOME/Games/Saves
		mkdir -pv $HOME/Games/Tools
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
		sleep 3s
		clear
	    	echo "Please enter your choice:"	
           	echo "1) Install Software	      3) Other"
	   	echo "2) Setup configuration files  4) Quit"
            ;;
        "Reboot PC")
            echo "Rebooting in 5 seconds, press CTRL+C to cancel"
            sleep 5s
            sudo reboot
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done


