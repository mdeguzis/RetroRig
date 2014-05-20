#!/bin/bash
#
#small script to copy over configuration files for emulators
#Version 0.6.6
#Please report any errors via a pull request
#You can also reach me on twitter: @N3RD42
#
#Pre-requisite checks:
#check for dialog and prompt to install if it is not present



function _main () {

_prereq

cmd=(dialog --backtitle "LibreGeek.org RetroRig Installer" --menu "Choose your option(s). Any required BIOS files are NOT provided!" 16 70 16)
options=(1 "Install Software" 
	 2 "Set up default configuration files" 
	 3 "Retro Rig Settings" 
	 4 "Pull latest files from git" 
	 5 "Update emulator binaries" 
	 6 "Upgrade System (use with caution!)" 
	 7 "Start RetroRig" 
	 8 "Reboot PC" 
	 9 "Exit")

	#make menu choice
	selection=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	#functions

	for choice in $selection
	do
		case $choice in
		1)  	
		_software
		_main
		;;

		2)  
		_configuration
		_main 
		;;

		3)
		_settings
		_main
		;;

		4)
		_update-git
		#reload script with changes
		bash config-setup.sh
		;;

		5)
		_update-binaries
		_main
		;;

		6)
		_upgrade-system
		_main
		;;

		7)
		_start-xbmc
		_main
		;;

		8)
		_reboot
		_main
		;;

		9)  
		clear
		exit
		;;
esac
done
}

function _prereq (){

if ! which dialog > /dev/null; then
   echo -e "dialog command not found! Install? (y/n) \c"
   read DIALOG
   if [ $DIALOG = "y" ]; then
      sudo apt-get install dialog >> /dev/null
   elif  [ $DIALOG = "n" ]; then
	echo "exiting!"
	sleep 2s
	exit
   fi
fi

if ! which git > /dev/null; then
   echo -e "git command not found! Install? (y/n) \c"
   read GIT
   if [ $GIT = "y" ]; then
      sudo apt-get install git >> /dev/null
   elif  [ $GIT = "n" ]; then
        echo "exiting!"
        sleep 2s
        exit
   fi
fi
}

function _file-loader (){

dialog --title "text" --fselect /path/to/dir height width
FOLDER=$(dialog --stdout --title "Please choose a folder" --fselect $HOME/ 14 48)
echo "${FOLDER} file chosen." 
sleep 1s

_rom-loader

}

#Load ROMs at will-call, or yes/no on configuration run
function _rom-loader (){

cmd=(dialog --backtitle "LibreGeek.org RetroRig Installer" --menu "Load ROMs for which system?" 16 70 16)
options=(1 "Atari 2600" 
	 2 "NES" 
	 3 "SNES" 
	 4 "Nintendo 64"
	 5 "MAME"
	 6 "Sega Genesis"
	 7 "Playstation 1"
	 8 "Playstation 2"
	 9 "Exit to main menu")

	#make menu choice
	selection=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	#functions

	for choice in $selection
	do
		case $choice in
		1)  	
		_file-loader
		cp -Rv $FOLDER/* $HOME/Games/ROMs/Atari\ 2600
		_rom-loader
		;;

		2)  

		;;

		3)

		;;

		4)

		;;

		5)

		;;

		6)

		;;

		7)

		;;

		8)

		;;

		9)  
		_main
		;;
esac
done

}


#settings function
function _settings (){

cmd=(dialog --backtitle "LibreGeek.org RetroRig Installer" --menu "Settings Menu" 16 46 16)
options=(1 "Change resolution for emulators"  
	 2 "Load ROMs (coming soon)"
	 3 "Back to main menu")

	#make menu choice
	selection=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	#functions

	for choice in $selection
	do
		case $choice in
		1)  	
		_resolution
		_settings
		;;

		2)  	
		#_rom-loader
		_settings
		;;

		3)  
		clear
		_main
		;;
esac
done
}

function _resolution () {

#menu
while true; do
cmd=(dialog --backtitle "RetroRig Settings" --menu "Choose your resolution" 16 32 16)
options=(1 "Current Resolution"
	 2 "1360x768 (720p)"
	 3 "1920x1080 (1080p)"
	 4 "Custom"
	 5 "Back to settings menu"
	 6 "Back to main menu"
	)
     
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
if [ "$choices" != "" ]; then
    case $choices in

	 1) 
		#mupen64plus
		echo "mupen64plus:" >> res.txt
		grep -i "ScreenWidth = " $HOME/.config/mupen64plus/mupen64plus.cfg 
		grep -i "ScreenHeight = " $HOME/.config/mupen64plus/mupen64plus.cfg 
		echo "" >> res.txt
		#ZSNES
		echo "ZSNES:" >> res.txt
		grep -i "CustomResX=" $HOME/.zsnes/zsnesl.cfg
		grep -i "CustomResY=" $HOME/.zsnes/zsnesl.cfg
		echo "" >> res.txt
		#Gens/GS
		echo "Gens/GS:" >> res.txt
		grep -i "OpenGL Width=" $HOME/.gens/gens.cfg
		grep -i "OpenGL Height=" $HOME/.gens/gens.cfg
		echo "" >> res.txt
		#Nestopia
		#Nestopia's settings is in a binary file, so echo current manually
		echo "Nestopia:" >> res.txt
		echo "Current Scaling: hq?x 3x" >> res.txt
		echo "" >> res.txt
		#Stella
		echo "Stella:" >> res.txt
		grep -i "tia_filter" $HOME/.stella/stellarc >> res.txt
		echo "" >> res.txt
		#report current resolution
		dialog --textbox res.txt 33 40
		#remove text file
		rm res.txt
		;;

	 2) 
		clear
		dialog --infobox "Setting resolution to 1920x768 (720p)" 3 48

		########################		
		#mupen64plus
		########################

		m_org_X=$(grep -i "ScreenWidth = " $HOME/.config/mupen64plus/mupen64plus.cfg)
		m_org_Y=$(grep -i "ScreenHeight = " $HOME/.config/mupen64plus/mupen64plus.cfg)
		#set new resolution(s) from configs
		m_new_X="1920"
		m_new_Y="1080"
		#make the changes, prefix new_X in case NULL was entered previousey
		#mupen64plus
		sed -i "s|$m_org_X|ScreenWidth = $m_new_X|g" $HOME/.config/mupen64plus/mupen64plus.cfg
		sed -i "s|$m_org_Y|ScreenHeight = $m_new_Y|g" $HOME/.config/mupen64plus/mupen64plus.cfg

		########################		
		#ZSNES
		######################## 

		#zsnes will not open properly if an improper resolution is set
		z_org_X=$(grep -i "CustomResX=" $HOME/.zsnes/zsnesl.cfg)
		z_org_Y=$(grep -i "CustomResY=" $HOME/.zsnes/zsnesl.cfg)
		#set new resolution(s) from configs
		z_new_X="1920"
		z_new_Y="1080"
		#make the changes, prefix new_X in case NULL was entered previously
		#ZSNES
		sed -i "s|$z_org_X|CustomResX="$z_new_X"|g" $HOME/.zsnes/zsnesl.cfg
		sed -i "s|$z_org_Y|CustomResY="$z_new_Y"|g" $HOME/.zsnes/zsnesl.cfg

		########################		
		#Gens/GS
		######################## 

		#Gens/GS will not open properly if an improper resolution is set
		g_org_X=$(grep -i "OpenGL Width=" $HOME/.gens/gens.cfg)
		g_org_Y=$(grep -i "OpenGL Height=" $HOME/.gens/gens.cfg)
		#set new resolution(s) from configs
		g_new_X="1920"
		g_new_Y="1080"
		#make the changes, prefix new_X in case NULL was entered previously
		#Gens/GS
		sed -i "s|$g_org_X|OpenGL Width="$g_new_X"|g" $HOME/.gens/gens.cfg
		sed -i "s|$g_org_Y|OpenGL Height="$g_new_Y"|g" $HOME/.gens/gens.cfg

		########################		
		#Stella
		######################## 
		#Stella does not support resolution changes (except the GUI), only scaling
		#Scaling testing and configuration will be put in at some point
		#This emulator does support OpenGL
		#Current Scaling is reported in RetroRig, but not yet configurable

		########################		
		#Nestopia
		######################## 
		#Nestopia does not support resolution changes, only scaling and filtering
		#Scaling testing and configuration will be put in at some point
		#This emulator does support OpenGL
		#Current Scaling is reported in RetroRig, but not yet configurable
		;;  
      
	 3) 
		clear
		dialog --infobox "Setting resolution to 1360x768 (720p)" 3 48

		########################		
		#mupen64plus
		########################

		m_org_X=$(grep -i "ScreenWidth = " $HOME/.config/mupen64plus/mupen64plus.cfg)
		m_org_Y=$(grep -i "ScreenHeight = " $HOME/.config/mupen64plus/mupen64plus.cfg)
		#set new resolution(s) from configs
		m_new_X="1360"
		m_new_Y="768"
		#make the changes, prefix new_X in case NULL was entered previousey
		#mupen64plus
		sed -i "s|$m_org_X|ScreenWidth = $m_new_X|g" $HOME/.config/mupen64plus/mupen64plus.cfg
		sed -i "s|$m_org_Y|ScreenHeight = $m_new_Y|g" $HOME/.config/mupen64plus/mupen64plus.cfg

		########################		
		#ZSNES
		######################## 

		#zsnes will not open properly if an improper resolution is set
		z_org_X=$(grep -i "CustomResX=" $HOME/.zsnes/zsnesl.cfg)
		z_org_Y=$(grep -i "CustomResY=" $HOME/.zsnes/zsnesl.cfg)
		#set new resolution(s) from configs
		z_new_X="1360"
		z_new_Y="768"
		#make the changes, prefix new_X in case NULL was entered previously
		#ZSNES
		sed -i "s|$z_org_X|CustomResX="$z_new_X"|g" $HOME/.zsnes/zsnesl.cfg
		sed -i "s|$z_org_Y|CustomResY="$z_new_Y"|g" $HOME/.zsnes/zsnesl.cfg

		########################		
		#Gens/GS
		######################## 

		#Gens/GS will not open properly if an improper resolution is set
		g_org_X=$(grep -i "OpenGL Width=" $HOME/.gens/gens.cfg)
		g_org_Y=$(grep -i "OpenGL Height=" $HOME/.gens/gens.cfg)
		#set new resolution(s) from configs
		g_new_X="1360"
		g_new_Y="768"
		#make the changes, prefix new_X in case NULL was entered previously
		#Gens/GS
		sed -i "s|$g_org_X|OpenGL Width="$g_new_X"|g" $HOME/.gens/gens.cfg
		sed -i "s|$g_org_Y|OpenGL Height="$g_new_Y"|g" $HOME/.gens/gens.cfg

		########################		
		#Stella
		######################## 
		#Stella does not support resolution changes (except the GUI), only scaling
		#Scaling testing and configuration will be put in at some point
		#This emulator does support OpenGL
		#Current Scaling is reported in RetroRig, but not yet configurable

		########################		
		#Nestopia
		######################## 
		#Nestopia does not support resolution changes, only scaling and filtering
		#Scaling testing and configuration will be put in at some point
		#This emulator does support OpenGL
		#Current Scaling is reported in RetroRig, but not yet configurable
		;; 

	 4) 
		dialog --infobox  "Setting resolution from user input" 3 40

		#set new resolution(s) from user input
		dialog --title "Set Custom Resolution" --inputbox "Enter Width (X)" 10 4 2> /tmp/new_X
		dialog --title "Set Custom Resolution" --inputbox "Enter Length (Y)" 10 4 2> /tmp/new_Y

		########################		
		#mupen64plus
		########################

		#grab current resolutions
		m_org_X=$(grep -i "ScreenWidth = " $HOME/.config/mupen64plus/mupen64plus.cfg)
		m_org_Y=$(grep -i "ScreenHeight = " $HOME/.config/mupen64plus/mupen64plus.cfg)
		#set new resolution(s) from configs
		m_new_X=$(cat '/tmp/new_X')
		m_new_Y=$(cat '/tmp/new_Y')
		#make the changes, prefix new_X in case NULL was entered previously
		#mupen64plus
		sed -i "s|$m_org_X|ScreenWidth = "$m_new_X"|g" $HOME/.config/mupen64plus/mupen64plus.cfg
		sed -i "s|$m_org_Y|ScreenHeight = "$m_new_Y"|g" $HOME/.config/mupen64plus/mupen64plus.cfg 

		########################		
		#ZSNES
		######################## 

		#zsnes will not open properly if an improper resolution is set
		z_org_X=$(grep -i "CustomResX=" $HOME/.zsnes/zsnesl.cfg)
		z_org_Y=$(grep -i "CustomResY=" $HOME/.zsnes/zsnesl.cfg)
		#set new resolution(s) from configs
		z_new_X=$(cat '/tmp/new_X')
		z_new_Y=$(cat '/tmp/new_Y')
		#make the changes, prefix new_X in case NULL was entered previously
		#ZSNES
		sed -i "s|$z_org_X|CustomResX="$z_new_X"|g" $HOME/.zsnes/zsnesl.cfg
		sed -i "s|$z_org_Y|CustomResY="$z_new_Y"|g" $HOME/.zsnes/zsnesl.cfg

		
		########################		
		#Gens/GS
		######################## 

		#Gens/GS will not open properly if an improper resolution is set
		g_org_X=$(grep -i "OpenGL Width=" $HOME/.gens/gens.cfg)
		g_org_Y=$(grep -i "OpenGL Height=" $HOME/.gens/gens.cfg)
		#set new resolution(s) from configs
		g_new_X=$(cat '/tmp/new_X')
		g_new_Y=$(cat '/tmp/new_Y')
		#make the changes, prefix new_X in case NULL was entered previously
		#ZSNES
		sed -i "s|$g_org_X|OpenGL Width="$g_new_X"|g" $HOME/.gens/gens.cfg
		sed -i "s|$g_org_Y|OpenGL Height="$g_new_Y"|g" $HOME/.gens/gens.cfg

		########################		
		#Stella
		######################## 
		#Stella does not support resolution changes, only scaling
		#Scaling testing and configuration will be put in at some point
		#This emulator does support OpenGL
		#Current Scaling is reported in RetroRig, but not yet configurable

		########################		
		#Nestopia
		######################## 
		#Nestopia does not support resolution changes, only scaling
		#Scaling testing and configuration will be put in at some point
		#This emulator does support OpenGL
		#Current Scaling is reported in RetroRig, but not yet configurable

		########################		
		#Cleanup
		######################## 

		rm -f /tmp/new_X
		rm -f /tmp/new_Y

		_resolution
		;; 
	 5) 
		_settings
		return
		;;
	 6) 
		_main
		return
		;;

	 esac
     else
	 break
fi
done
}

#software function
function _software () {

	#progress bar while loop
	(
	c=10
	while [ $c -ne 110 ]
	do

	#add multi-arch support
	echo "-----------------------------------------------------------" > install_log.txt
	echo "Adding multi-arch support..." >> install_log.txt
	echo "-----------------------------------------------------------" > install_log.txt
	sudo dpkg --add-architecture i386 &>> install_log.txt
	#update progres bar
        echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=10))
	sleep 1

	#add repository for pcsx2 (PS2 emulator)
	echo "-----------------------------------------------------------" > install_log.txt
	echo "Adding pcsx2 repository support..." >> install_log.txt
	echo "-----------------------------------------------------------" >> install_log.txt
	sudo add-apt-repository -y ppa:gregory-hainaut/pcsx2.official.ppa &> install_log.txt
	#update progres bar
        echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=10))
	sleep 1

	#add repository for official team XBMC "stable"
	echo "-----------------------------------------------------------" > install_log.txt
	echo "Adding XBMC Ubuntu (stable) repository..." >> install_log.txt
	echo "-----------------------------------------------------------" >> install_log.txt
	sudo add-apt-repository -y ppa:team-xbmc/ppa &>> install_log.txt
	#update progres bar
        echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=10))
	sleep 1

	#add repository for dolphin-emu
	echo "-----------------------------------------------------------" > install_log.txt
	echo "Adding Dolphin-Emu repository..." >> install_log.txt
	echo "-----------------------------------------------------------" >> install_log.txt
	sudo add-apt-repository -y ppa:glennric/dolphin-emu &>> install_log.txt
	#update progres bar
        echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=10))
	sleep 1

	#install Gens/GS via deb pkg (only way I  can currently find it)
	echo "-----------------------------------------------------------" > install_log.txt
	echo "Installing Gens/GS..." >> install_log.txt
	echo "-----------------------------------------------------------" >> install_log.txt
	sudo dpkg -i $HOME/RetroRig/emulators/Gens-GS/Gens_2.16.7_i386.deb &>> install_log.txt
	#update progres bar
        echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=20))
	sleep 1

	#update repository listings
	echo "-----------------------------------------------------------" > install_log.txt
	echo "Updating packages..." >> install_log.txt
	echo "-----------------------------------------------------------" >> install_log.txt
	sudo apt-get update &>> install_log.txt
	#update progres bar
        echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=30))
	sleep 1

	#install software from repositories
	echo "-----------------------------------------------------------" > install_log.txt
	echo "Installing required packages..." >> install_log.txt
	echo "-----------------------------------------------------------" >> install_log.txt
	sudo apt-get install -y xboxdrv curl zsnes nestopia pcsxr pcsx2:i386 \
	python-software-properties pkg-config software-properties-common \
	mame mupen64plus dconf-tools qjoypad xbmc dolphin-emu-master stella \
	build-essential &>> install_log.txt
	#update progres bar
        echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=10))
	sleep 3s
done
) |
dialog --title "Installing Required Programs..." --gauge "Please wait" 7 70 0

}

#configuration function
function _configuration () {

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
	   dialog --infobox "Continuing..." 3 17
	   sleep 2s
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

	#show progress bar
	(
	c=10
	while [ $c -ne 110 ]
	do


	dialog --infobox "Setting up configuration files" 3 35 ; sleep 3s
	clear
	#disable screensaver, XBMC will manage this
	#export display to allow gsettings running in terminal window
	echo "-----------------------------------------------------------" >> install_log.txt
	echo "Configuring required packages..." >> install_log.txt
	echo "-----------------------------------------------------------" >> install_log.txt
	export DISPLAY=:0.0
	gsettings set org.gnome.settings-daemon.plugins.power active 'false' &>> install_log.txt
	gsettings set org.gnome.desktop.screensaver idle-activation-enabled 'false' &>> install_log.txt
	gsettings set org.gnome.desktop.lockdown disable-lock-screen 'true' &>> install_log.txt
	#update progress bar
    	echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=4))
	sleep 0

	#setup skelton folders for XBMC Rom Collection Browser
	#ROMs
	mkdir -pv $HOME/Games/ROMs/Atari\ 2600/ &>> install_log.txt
	mkdir -pv $HOME/Games/ROMs/Gamecube/ &>> install_log.txt
	mkdir -pv $HOME/Games/ROMs/Mame4All/ &>> install_log.txt
	mkdir -pv $HOME/Games/ROMs/N64/ &>> install_log.txt
	mkdir -pv $HOME/Games/ROMs/NES/ &>> install_log.txt
	mkdir -pv $HOME/Games/ROMs/SNES/ &>> install_log.txt
	mkdir -pv $HOME/Games/ROMs/PS2/ &>> install_log.txt
	mkdir -pv $HOME/Games/ROMs/PS1/ &>> install_log.txt
	mkdir -pv $HOME/Games/ROMs/sgenroms/ &>> install_log.txt
	mkdir -pv $HOME/Games/ROMs/SNK\ Neo\ Geo/ &>> install_log.txt
	#update progress bar
    	echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=4))
	sleep 0

	#Artwork 
	mkdir -pv $HOME/Games/Artwork/Atari\ 2600 &>> install_log.txt
	mkdir -pv $HOME/Games/Artwork/Gamecube &>> install_log.txt
	mkdir -pv $HOME/Games/Artwork/MAME &>> install_log.txt
	mkdir -pv $HOME/Games/Artwork/N64 &>> install_log.txt
	mkdir -pv $HOME/Games/Artwork/NES &>> install_log.txt
	mkdir -pv $HOME/Games/Artwork/SNES &>> install_log.txt
	mkdir -pv $HOME/Games/Artwork/PS2 &>> install_log.txt
	mkdir -pv $HOME/Games/Artwork/PS1 &>> install_log.txt
	mkdir -pv $HOME/Games/Artwork/Genesis &>> install_log.txt
	mkdir -pv $HOME/Games/Artwork/SNK\ Neo\ Geo &>> install_log.txt
	#update progress bar
    	echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=4))
	sleep 0

	#Saves (if any)
	mkdir -pv $HOME/Games/Saves/Atari\ 2600/ &>> install_log.txt
	mkdir -pv $HOME/Games/Saves/Gamecube/ &>> install_log.txt
	mkdir -pv $HOME/Games/Saves/Mame4All/ &>> install_log.txt
	mkdir -pv $HOME/Games/Saves/N64/ &>> install_log.txt
	mkdir -pv $HOME/Games/Saves/NES/ &>> install_log.txt
	mkdir -pv $HOME/Games/Saves/SNES/ &>> install_log.txt
	mkdir -pv $HOME/Games/Saves/PS2/ &>> install_log.txt
	mkdir -pv $HOME/Games/Saves/PS1/ &>> install_log.txt
	mkdir -pv $HOME/Games/Saves/genroms/ &>> install_log.txt
	mkdir -pv $HOME/Games/Saves/SNK\ Neo\ Geo/ &>> install_log.txt
	#update progress bar
    	echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=4))
	sleep 0

	#create dotfiles
	mkdir -pv $HOME/.qjoypad3/ &>> install_log.txt
	mkdir -pv $HOME/.dolphin-emu/Config/ &>> install_log.txt
	mkdir -pv $HOME/.config/mupen64plus/ &>> install_log.txt
	mkdir -pv $HOME/.nestopia/ &>> install_log.txt
	mkdir -pv $HOME/.gens/ &>> install_log.txt
	mkdir -pv $HOME/.zsnes/ &>> install_log.txt
	mkdir -pv $HOME/.mame/cfg/ &>> install_log.txt
	mkdir -pv $HOME/.pcsx/plugins/ &>> install_log.txt
	mkdir -pv $HOME/.pcsx/patches/ &>> install_log.txt
	mkdir -pv $HOME/.config/pcsx2/inis/ &>> install_log.txt
	mkdir -pv $HOME/.stella/ &>> install_log.txt
	mkdir -pv $HOME/.xbmc/ &>> install_log.txt
	#update progress bar
    	echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=4))
	sleep 0

	#xbmc does not (at least for Ubuntu's repo pkg) load the
	#dot files without loading XBMC at least once
	#copy in default folder base from first run:	
	cp -Rv $HOME/RetroRig/XBMC-configs/* $HOME/.xbmc &>> install_log.txt
	#update progress bar
    	echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=4))
	sleep 0

	#xboxdrv director located in common area for startup
	echo "sudo needed to create common xboxdrv share!"
	sudo mkdir -pv /usr/share/xboxdrv/ &>> install_log.txt
	#update progress bar
    	echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=4))
	sleep 0

	#Tools
	mkdir -pv $HOME/Games/Tools/ &>> install_log.txt
	#update progress bar
    	echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=4))
	sleep 0

	#configs
	mkdir -pv $HOME/Games/Configs/ &>> install_log.txt
	#update progress bar
    	echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=4))
	sleep 0

	#Nestopia
	#default path: /home/$USER/.nestopia
	cp -v $HOME/RetroRig/emu-configs/Nestopia/nstcontrols $HOME/.nestopia/ &>> install_log.txt
	cp -v $HOME/RetroRig/emu-configs/Nestopia/nstsettings $HOME/.nestopia/ &>> install_log.txt
	#update progress bar
    	echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=4))
	sleep 0

	#gens
	#default path: /home/$USER/.gens
	#Global config
	cp -v $HOME/RetroRig/emu-configs/Gens-GS/gens.cfg $HOME/.gens/ &>> install_log.txt
	#update progress bar
    	echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=4))
	sleep 0

	#ZSNES
	#default path: /home/$USER/.zsnes
	#Controller config
	cp -v $HOME/RetroRig/emu-configs/ZSNES/zinput.cfg $HOME/.zsnes/ &>> install_log.txt
	cp -v $HOME/RetroRig/emu-configs/ZSNES/zsnesl.cfg $HOME/.zsnes/ &>> install_log.txt
	#update progress bar
    	echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=4))
	sleep 0

	#mame
	#default path: /home/$USER/.mame
	#Main config
	cp -v $HOME/RetroRig/emu-configs/MAME/default.cfg $HOME/.mame/cfg &>> install_log.txt
	cp -v $HOME/RetroRig/emu-configs/MAME/mame.ini $HOME/.mame &>> install_log.txt
	#offline artwork scrapper
	cp -v $HOME/RetroRig/emu-configs/MAME/Artwork/* $HOME/Games/Artwork/MAME &>> install_log.txt
	#update progress bar
    	echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=4))
	sleep 0	
	
	#pcsx
	#default path: /home/$USER/.pcsx
	#Main config
	cp -v $HOME/RetroRig/emu-configs/pcsx/pcsx.cfg $HOME/.pcsx/ &>> install_log.txt
	cp -Rv $HOME/RetroRig/emu-configs/pcsx/plugins $HOME/.pcsx/ &>> install_log.txt
	cp -Rv $HOME/RetroRig/emu-configs/pcsx/patches $HOME/.pcsx/ &>> install_log.txt
	#update progress bar
    	echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=4))
	sleep 0

	#pcsx2
	#default path: /home/$USER/.config/pcsx2
	#Main config
	cp -v $HOME/RetroRig/emu-configs/pcsx2/PCSX2-reg.ini $HOME/.config/pcsx2/ &>> install_log.txt
	cp -v $HOME/RetroRig/emu-configs/pcsx2/inisOnePAD.ini $HOME/.config/pcsx2/ &>> install_log.txt
	cp -v $HOME/RetroRig/emu-configs/pcsx2/inis/* $HOME/.config/pcsx2/inis/ &>> install_log.txt
	#update progress bar
    	echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=4))
	sleep 0

	#mupen64pluspwd
	#default path: /home/$USER/.config/mupen64plus
	#Main config
	cp -v $HOME/RetroRig/emu-configs/mupen64plus/mupen64plus.cfg $HOME/.config/mupen64plus/ &>> install_log.txt
	#update progress bar
    	echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=4))
	sleep 0

	#Stella
	#default path: /home/$USER/.config/mupen64plus
	#Main config
	cp -v $HOME/RetroRig/emu-configs/Stella/stellarc $HOME/.stella/ &>> install_log.txt
	#update progress bar
    	echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=4))
	sleep 0

	#dolphin
	#default path /home/$USER/.dolphin-emu/
	#emulator config
	cp -Rv /$HOME/RetroRig/emu-configs/Dolphin/Dolphin.ini $HOME/.dolphin-emu/Config/ &>> install_log.txt
	#Gamecube controller config
	cp -Rv /$HOME/RetroRig/emu-configs/Dolphin/GCPadNew.ini $HOME/.dolphin-emu/Config/ &>> install_log.txt
	#Wii controller config
	#OpenGL graphics config
	cp -Rv /$HOME/RetroRig/emu-configs/Dolphin/gfx_opengl.ini $HOME/.dolphin-emu/Config/ &>> install_log.txt
	#update progress bar
    	echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=4))
	sleep 0

	#copy config for qjoypad setup
	cp -v $HOME/RetroRig/controller-cfgs/retro-gaming.lyt $HOME/.qjoypad3/ &>> install_log.txt
	#update progress bar
    	echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=4))
	sleep 0

	#add xbox controller init script
	echo "sudo needed to create init scripts for xboxdrv!"
	sudo cp -v $HOME/RetroRig/controller-cfgs/xpad-wireless.xboxdrv /usr/share/xboxdrv/ &>> install_log.txt
	sudo cp -v $HOME/RetroRig/init-scripts/xboxdrv /etc/init.d/ &>> install_log.txt
	sudo update-rc.d xboxdrv defaults &>> install_log.txt
	#update progress bar
    	echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=4))
	sleep 0

	#copyautoexec.py in the userdata folder for autostarting RCB
	#cp -v $HOME/RetroRig/RCB/autoexec.py $HOME/.xbmc/userdata/

	#blacklist xpad
	echo "sudo needed to blacklist xpad!"
	sudo cp -v $HOME/RetroRig/init-scripts/blacklist.conf /etc/modprobe.d/ &>> install_log.txt
	#update progress bar
    	echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=4))
	sleep 0

	#create autostart for XBMC and qjoypad
	echo "sudo needed to create auto-start entries!"
	sudo cp -v /usr/share/applications/xbmc.desktop /etc/xdg/autostart/ &>> install_log.txt
	sudo cp -v $HOME/RetroRig/controller-cfgs/qjoypad.desktop /etc/xdg/autostart/ &>> install_log.txt
	#If xboxdrv config file does not pick up on reboot,
	#be sure to resync the wireless receiver!
	#update progress bar
    	echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=6))
	sleep 0

	#set the system user to an absolute value.
	#RCB and some config files don't like using $HOME, rather /home/test/
	#Let's change the config files to reflect the current username
	new_U=$($USER)
	#change default user from config files to target user. 'first run only!!!' 
	sed -i "s|/home/test/|/home/$USER/|g" $HOME/.config/pcsx2/PCSX2-reg.ini  &>> install_log.txt
	sed -i "s|/home/test/|/home/$USER/|g" $HOME/.gens/gens.cfg &>> install_log.txt
	sed -i "s|/home/test/|/home/$USER/|g" $HOME/.zsnes/zsnesl.cfg &>> install_log.txt
	sed -i "s|/home/test/|/home/$USER/|g" $HOME/.pcsx/pcsx.cfg  &>> install_log.txt
	sed -i "s|/home/test/|/home/$USER/|g" $HOME/.dolphin-emu/Config/Dolphin.ini  &>> install_log.txt
	sed -i "s|/home/test/|/home/$USER/|g" $HOME/.xbmc/userdata/addon_data/script.games.rom.collection.browser/config.xml &>> install_log.txt
	#update progress bar
    	echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=10))
	sleep 5s

done
) |
dialog --title "Configuring Programs..." --gauge "Please wait" 7 70 0
	
	#remind user about default resolution
	#If the default is not supported on the monitor, emulators like zsnes will fail to start!
	dialog --msgbox "Default Resolution is 1360x768 (720p)! Please ensure your \
                          display supports this resolution, or change it in the settings menu! \
                          Main Menu > Option 3 > Option 1" 12 31

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
	   dialog --infobox "ROM Loader Coming Soon!" 3 28 ; sleep 5s
	   disable rom-loader until ready
	   #_rom-loader
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

function _update-git () {
	dialog --infobox "updating git repo" 3 22
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
	echo "updating binaries"
	sudo apt-get install -y xboxdrv zsnes nestopia pcsxr pcsx2:i386\
	mame mupen64plus qjoypad xbmc dolphin-emu-master stella	
	sleep 3s
	#clear
	clear
}

function _upgrade-system () {
	dialog --infobox "updating system" 3 11
	sudo apt-get update
	sudo apt-get upgrade
	sleep 3s
	#clear
	clear
}

function _start-xbmc () {
	dialog --infobox "starting RetroRig" 3 24
	sleep 1s
	xbmc
	#clear
	clear
}

function _reboot () {
	#need to add reboot command to sudo to avoid pw prompt
        dialog --infobox "Rebooting in 5 seconds, press CTRL+C to cancel" 3 51 ; sleep 5s
        sleep 5s
        sudo reboot 
}
#call main
_main
