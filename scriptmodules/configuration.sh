#!/bin/bash
#
# RetroRig Configuration module
# This is a small script to copy over configuration files for emulators
# append a "-x" on the end above for debugging if need be
# Please report any errors via a pull request
# You can also reach me on twitter: @N3RD42
#

#configuration function
function _configuration (){

	dialog --title "Confirm yes/no" \
	--backtitle "LibreGeek.org RetroRig Installer" \
	--yesno "Are you sure you want run the configuration setup? \
	This will* reset existing configurations!" 7 50
	 
	# Get exit status
	# 0 means user hit [yes] button.
	# 1 means user hit [no] button.
	# 255 means user hit [Esc] key.
	response=$?
	case $response in
	   0) 
	   #dialog --infobox "Continuing..." 3 17
	   #continue on below
	   ;;

	   1) 
	   dialog --infobox "Exiting Configuration Setup"  3 31
	   sleep 2s
	   _main
	   ;;

	   255)
	   dialog --infobox "Exiting Configuration Setup" 3 31
	   sleep 2s
	   _main
	   ;;

	esac

	dialog --infobox "Setting up configuration files" 3 34 ; sleep 3s
	#clear screen
	clear

	#Note for mkdir and some settings:
	#tee will only output/log if there is an error or the folder exists

	#disable screensaver, XBMC will manage this
	#export display to allow gsettings running in terminal window
	echo "Configuring required packages..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	export DISPLAY=:0.0
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Configuring Unity Settings..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	
	gsettings set org.gnome.desktop.screensaver lock-enabled false | tee -a install_log.txt
	gsettings set org.gnome.desktop.screensaver ubuntu-lock-on-suspend false | tee -a install_log.txt
	gsettings set org.gnome.desktop.session idle-delay 3600 | tee -a install_log.txt

	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Setup skelton folders for RetroRig, please wait..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	#setup skelton folders for XBMC Rom Collection Browser
	#ROMs
	mkdir -pv $HOME/Games/ROMs/Atari\ 2600/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/ROMs/MAME/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/ROMs/N64/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/ROMs/NES/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/ROMs/SNES/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/ROMs/Sega\ Master\ System/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/ROMs/Sega\ Game\ Gear/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/ROMs/GBC/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/ROMs/GBA/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/ROMs/TurboGraphx\ 16/ | tee -a install_log.txt

	#Artwork 
	mkdir -pv $HOME/Games/Artwork/Atari\ 2600/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Artwork/MAME/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Artwork/N64/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Artwork/NES/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Artwork/SNES/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Artwork/Sega\ Master\ System/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Artwork/Sega\ Game\ Gear/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Artwork/GBC/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Artwork/GBA/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Artwork/TurboGraphx\ 16/ | tee -a install_log.txt

	#Saves (if any)
	mkdir -pv $HOME/Games/Saves/Atari\ 2600/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Saves/MAME/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Saves/N64/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Saves/NES/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Saves/SNES/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Saves/Sega\ Master\ System/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Saves/Sega\ Game\ Gear/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Saves/GBC/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Saves/GBA/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Saves/TurboGraphx\ 16/ | tee -a install_log.txt

	#create dotfiles
	mkdir -pv $HOME/.qjoypad3/ | tee -a install_log.txt
	mkdir -pv $HOME/.config/mupen64plus/ | tee -a install_log.txt
	mkdir -pv $HOME/.mame/cfg/ | tee -a install_log.txt
	mkdir -pv $HOME/.stella/ | tee -a install_log.txt
	mkdir -pv $HOME/.xbmc/ | tee -a install_log.txt
	mkdir -pv $HOME/.mednafen/ | tee -a install_log.txt

	#xbmc does not (at least for Ubuntu's repo pkg) load the
	#dot files without loading XBMC at least once
	#copy in default folder base from first run:	
	cp -Rv $HOME/RetroRig/XBMC-cfgs/* $HOME/.xbmc | tee -a install_log.txt

	#xboxdrv director located in common area for startup
	echo "echo $userpasswd | sudo -S needed to create common xboxdrv share!"
	echo $userpasswd | sudo -S mkdir -pv /usr/share/xboxdrv/ | tee -a install_log.txt

	#Tools
	mkdir -pv $HOME/Games/Tools/ | tee -a install_log.txt

	echo "-----------------------------------------------------------" |tee -a install_log.txt
	echo "Copy software configurations" | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	#configs
	mkdir -pv $HOME/Games/Configs/ | tee -a install_log.txt

	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "init scripts and post-configurations" | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt

	#add xbox controller init script
	echo "echo $userpasswd | sudo -S needed to create init scripts for xboxdrv!"

	#call modular function to select specific gamepad configuration for all environments
	_gamepad

	#call function to set resolution
	_resolution

	#clear screen after functions are called
	clear

	#create autostart for XBMC (universal)
	echo "sudo needed to create auto-start entries!"
	echo $userpasswd | sudo -S cp -v /usr/share/applications/xbmc.desktop /etc/xdg/autostart/ | tee -a install_log.txt

	#If x360ws xboxdrv config file does not pick up on reboot,
	#be sure to resync the wireless receiver!

	#set the system user to an absolute value.
	#RCB and some config files don't like using $HOME, rather /home/test/
	#Let's change the config files to reflect the current username
	sed -i "s|/home/mikeyd/|/home/$USER/|g" $HOME/.mame/mame.ini | tee -a install_log.txt
	sed -i "s|/home/mikeyd/|/home/$USER/|g" $HOME/.xbmc/userdata/addon_data/script.games.rom.collection.browser/config.xml | tee -a install_log.txt	
	echo "The user applied to configuration files was: $USER" |  tee -a install_log.txt

	#prompt user if they wish to pre-load ROMs now
	dialog --title "Confirm yes/no" \
	--backtitle "LibreGeek.org RetroRig Installer" \
	--yesno "Do you wish to load your ROMs now? (reccomended)" 5 52
	 
	# Get exit status
	# 0 means user hit [yes] button.
	# 1 means user hit [no] button.
	# 255 means user hit [Esc] key.
	response=$?
	case $response in
	   0) 
	   _rom-loader
	   ;;

	   1) 
	   dialog --infobox "Finished"  3 12
	   sleep 2s
	   _main
	   ;;

	   255)
	   dialog --infobox "Exiting Configuration Setup" 3 31
	   sleep 2s
	   _main
	   ;;

	esac	
}
