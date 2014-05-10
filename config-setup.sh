#!/bin/bash

#small script to copy over configuration files for emulators
#Version 1.1
#cp has interactive mode enabled to prompt for changes

PS3='Please enter your choice: '
options=("Option 1" "Option 2" "Option 3" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Option 1")
            echo "you chose choice 1"
            ;;
        "Option 2")
            echo "you chose choice 2"
            ;;
        "Option 3")
            echo "you chose choice 3"
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done

#setup skelton folders for XBMC Rom Collection Browser
mkdir -pv $HOME/Games/ROMs
mkdir -pv $HOME/Games/Artwork
mkdir -pv $HOME/Games/Emulators
mkdir -pv $HOME/Games/Saves
mkdir -pv $HOME/Games/Tools
mkdir -pv $HOME/Games/Configs

#Nestopia
#default path: /home/$USER/.nestopia
cp -Rvi nestopia/nstcontrols $HOME/.nestopia/nstcontrols

#gens
#default path: /home/$USER/.gens
#Global config
cp -Rvi $HOME/RetroRig/Gens-GS/ $HOME/.gens/gens.cfg 

#ZSNES
#default path: /home/$USER/.zsnes
#Controller config
cp -Rvi $HOME/RetroRig/ZSNES/ $HOME/.zsnes/zinput.cfg
#emulator config
cp -Rvi $HOME/RetroRig/ZSNES/ $HOME/.zsnes/zsnesl.cfg

#mame
#default path: /home/$USER/.mame
#Main config
cp -Rvi $HOME/RetroRig/MAME/ $HOME/.mame/mame.ini
#controller config
cp -Rvi $HOME/RetroRig/MAME/ $HOME/.mame/cfg/default.cfg

#pcsx
#default path: /home/$USER/.pcsx
#Main config
cp -Rvi $HOME/RetroRig/PS1/ $HOME/.pcsx/pcsx.cfg

#mupen64plus
#default path: /home/$USER/.config/mupen64plus
#Main config
cp -Rvi $HOME/RetroRig/mupen64plus/ $HOME/.config/mupen64plus/mupen64plus.cfg

#copy configs for other utilities
cp -Rvi $HOME/RetroRig/controller-cfg/ $HOME/Games/Configs/qjoypad_launch.sh
cp -Rvi $HOME/RetroRig/controller-cfg/ $HOME/Games/Configs/xpad-wireless.xboxdrv
