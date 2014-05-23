#!/bin/bash
#
#small script to copy over configuration files for emulators
#Version 0.6.7
#Please report any errors via a pull request
#You can also reach me on twitter: @N3RD42
#
#Pre-requisite checks:
#check for dialog and prompt to install if it is not present

#remove previous install log
rm -f install_log.txt

#start logging
echo "-----------------------------------------------------------" | tee -a install_log.txt
echo "Starting install log..." | tee -a install_log.txt
echo "-----------------------------------------------------------" | tee -a install_log.txt

function _main () {

_prereq

cmd=(dialog --backtitle "LibreGeek.org RetroRig Installer" --menu "| Main Menu | \
			 Any required BIOS files are NOT provided!" 16 62 16)
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
      echo $userpasswd | sudo -S apt-get install dialog >> /dev/null
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
      echo $userpasswd | sudo -S apt-get install git >> /dev/null
   elif  [ $GIT = "n" ]; then
        echo "exiting!"
        sleep 2s
        exit
   fi
fi
}

function _file-loader (){

folder=$(dialog --stdout --title "Please choose a file (spacebar to select)" --fselect $HOME/ 14 48)
echo "${folder} file chosen."

}

#Load ROMs at will-call, or yes/no on configuration run
function _rom-loader (){

cmd=(dialog --backtitle "LibreGeek.org RetroRig Installer" --menu "Load ROMs for which system?" 18 32 16)
options=(1 "Atari 2600" 
	 2 "NES" 
	 3 "SNES" 
	 4 "Nintendo 64"
	 5 "Gamecube"
	 6 "MAME"
	 7 "Sega Genesis"
	 8 "Playstation 1"
	 9 "Playstation 2"
	 10 "Neo Geo"
	 11 "Exit to main menu")

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
		cp -Rv $folder/* $HOME/Games/ROMs/Atari\ 2600/ | tee -a install_log.txt
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
		cp -Rv $folder/* $HOME/Games/ROMs/NES/ | tee -a install_log.txt
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
		cp -Rv $folder/* $HOME/Games/ROMs/SNES/ | tee -a install_log.txt
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
		cp -Rv $folder/* $HOME/Games/ROMs/N64/ | tee -a install_log.txt
		#return back to menu
		_rom-loader
		;;

		5)
		#call file loader  	
		_file-loader
		#copy Gamecube ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading Gamecube ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv $folder/* $HOME/Games/ROMs/Gamecube/ | tee -a install_log.txt
		#return back to menu
		_rom-loader
		;;

		6)
		#call file loader  	
		_file-loader
		#copy MAME ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading MAME ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv $folder/* $HOME/Games/ROMs/MAME/ | tee -a install_log.txt
		#return back to menu
		_rom-loader
		;;

		7)
		#call file loader  	
		_file-loader
		#copy Sega Genesis ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading Sega Genesis ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv $folder/* $HOME/Games/ROMs/Sega\ Genesis/ | tee -a install_log.txt
		#return back to menu
		_rom-loader
		;;

		8)
		#call file loader  	
		_file-loader
		#copy Playstation 1 ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading Playstation 1 ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv $folder/* $HOME/Games/ROMs/PS1/ | tee -a install_log.txt
		#return back to menu
		_rom-loader
		;;

		9)
		#call file loader  	
		_file-loader
		#copy Playstation 2 ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading Playstation 2 ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv $folder/* $HOME/Games/ROMs/PS2/ | tee -a install_log.txt
		#return back to menu
		_rom-loader
		;;

		10)
		#call file loader  	
		_file-loader
		#copy Neo Geo ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading Neo Geo ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv $folder/* $HOME/Games/ROMs/SNK\ Neo\ Geo/ | tee -a install_log.txt
		#return back to menu
		_rom-loader
		;;

		11)  
		_main
		;;
		esac
	done
}

#settings function
function _remote-tools (){

clear
dialog --infobox "Setting resolution to 1920x768 (720p)" 3 48

}

#settings function
function _settings (){

cmd=(dialog --backtitle "LibreGeek.org RetroRig Installer" --menu "Settings Menu" 16 0 16)
options=(1 "Change resolution"  
	 2 "Load ROMs"
	 3 "Change Gamepad Type"
	 4 "Back to main menu")

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
		_rom-loader
		_settings
		;;

		3)  	
		_gamepad
		_settings
		;;

		4)  
		_main
		;;
	esac
	done
}

function _res-swticher (){
clear
		dialog --infobox "Setting resolution to selection" 3 48
		#resolution is set via _resolution function		
		
		########################		
		#mupen64plus
		########################
		m_org_X=$(grep -i "ScreenWidth = " $HOME/.config/mupen64plus/mupen64plus.cfg)
		m_org_Y=$(grep -i "ScreenHeight = " $HOME/.config/mupen64plus/mupen64plus.cfg)
		#make the changes, prefix new_X in case NULL was entered previousey
		sed -i "s|$m_org_X|ScreenWidth = $m_new_X|g" $HOME/.config/mupen64plus/mupen64plus.cfg
		sed -i "s|$m_org_Y|ScreenHeight = $m_new_Y|g" $HOME/.config/mupen64plus/mupen64plus.cfg

		########################		
		#ZSNES
		########################
		#zsnes will not open properly if an improper resolution is set
		z_org_X=$(grep -i "CustomResX=" $HOME/.zsnes/zsnesl.cfg)
		z_org_Y=$(grep -i "CustomResY=" $HOME/.zsnes/zsnesl.cfg)
		#make the changes, prefix new_X in case NULL was entered previously
		sed -i "s|$z_org_X|CustomResX="$z_new_X"|g" $HOME/.zsnes/zsnesl.cfg
		sed -i "s|$z_org_Y|CustomResY="$z_new_Y"|g" $HOME/.zsnes/zsnesl.cfg

		########################		
		#Gens/GS
		######################## 
		#Gens/GS will not open properly if an improper resolution is set
		g_org_X=$(grep -i "OpenGL Width=" $HOME/.gens/gens.cfg)
		g_org_Y=$(grep -i "OpenGL Height=" $HOME/.gens/gens.cfg)
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
}

function _resolution () {

#menu
#add res-switcher function to make new presets more modular to add
while true; do
cmd=(dialog --backtitle "RetroRig Settings" --menu "Choose your resolution" 16 34 16)
options=(1 "Current Resolution"
	 2 "1280x720  (720p)  (5:4)"
	 3 "1280x1024 (SXGA)  (5:4)"
	 4 "1366x768  (720p)  (16:9)"
	 5 "1600x900  (900p)  (16:9)"
	 6 "1920x1080 (1080p) (16:9)"
	 7 "Custom"
	 8 "Back to settings menu"
	 9 "Back to main menu"
	)
     
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
if [ "$choices" != "" ]; then
    case $choices in

	 1) 
		#echo curent resolution
		#mupen64plus
		echo "mupen64plus:" >> res.txt
		grep -i "ScreenWidth = " $HOME/.config/mupen64plus/mupen64plus.cfg >> res.txt
		grep -i "ScreenHeight = " $HOME/.config/mupen64plus/mupen64plus.cfg >> res.txt
		echo "" >> res.txt
		#ZSNES
		echo "ZSNES:" >> res.txt
		grep -i "CustomResX=" $HOME/.zsnes/zsnesl.cfg >> res.txt
		grep -i "CustomResY=" $HOME/.zsnes/zsnesl.cfg >> res.txt
		echo "" >> res.txt
		#Gens/GS
		echo "Gens/GS:" >> res.txt
		grep -i "OpenGL Width=" $HOME/.gens/gens.cfg >> res.txt
		grep -i "OpenGL Height=" $HOME/.gens/gens.cfg >> res.txt
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
		#setting chosen: "1280x720  (720p)  (5:4)"
		#set mupen64plus value
		m_new_X="1280"
		m_new_Y="720"
		#set zsnes value
		z_new_X="1280"
		z_new_Y="720"
		#set gens value
		g_new_X="1280"
		g_new_Y="720"
		#call _res-swticher
		_res-swticher
		#return to menu
		_resolution
		;;  
	 3) 
		#setting chosen: "1280x1024 (SXGA)  (5:4)"
		#set mupen64plus value
		m_new_X="1280"
		m_new_Y="1024"
		#set zsnes value
		z_new_X="1280"
		z_new_Y="1024"
		#set gens value
		g_new_X="1280"
		g_new_Y="1024"
		#call _res-swticher
		_res-swticher
		#return to menu
		_resolution
		;;
	 4) 
		#setting chosen: "1366x768  (720p)  (16:9)"
		#set mupen64plus value
		m_new_X="1366"
		m_new_Y="768"
		#set zsnes value
		z_new_X="1366"
		z_new_Y="768"
		#set gens value
		g_new_X="1366"
		g_new_Y="768"
		#call _res-swticher
		_res-swticher
		#return to menu
		_resolution
		;;
	 5) 
		#setting chosen: "1600x900  (900p)  (16:9)"
		#set mupen64plus value
		m_new_X="1600"
		m_new_Y="900"
		#set zsnes value
		z_new_X="1600"
		z_new_Y="900"
		#set gens value
		g_new_X="1600"
		g_new_Y="900"
		#call _res-swticher
		_res-swticher
		#return to menu
		_resolution
		;;
	 6) 
		#setting chosen: "1920x1080 (1080p) (16:9)"
		#set mupen64plus value
		m_new_X="1920"
		m_new_Y="1080"
		#set zsnes value
		z_new_X="1920"
		z_new_Y="1080"
		#set gens value
		g_new_X="1920"
		g_new_Y="1080"
		#call _res-swticher
		_res-swticher
		#return to menu
		_resolution
		;;    
	 7) 
		dialog --infobox  "Setting resolution from user input" 3 40
		#set new resolution(s) from user input
		dialog --title "Set Custom Resolution" --inputbox "Enter Width (X)" 10 4 2> /tmp/new_X
		dialog --title "Set Custom Resolution" --inputbox "Enter Length (Y)" 10 4 2> /tmp/new_Y

		#set new resolution(s) from configs
		#mupen64plus
		m_new_X=$(cat '/tmp/new_X')
		m_new_Y=$(cat '/tmp/new_Y')
		#zsnes
		z_new_X=$(cat '/tmp/new_X')
		z_new_Y=$(cat '/tmp/new_Y')
		#Gens
		g_new_X=$(cat '/tmp/new_X')
		g_new_Y=$(cat '/tmp/new_Y')

		#call _res-swticher
		_res-swticher
		#remove temp files
		rm -f /tmp/new_X
		rm -f /tmp/new_Y
		#return to menu
		_resolution
		;; 
	 8) 
		_settings
		;;
	 9) 
		_main
		;;
	esac
fi
done
}

#software function
function _software () {


	#prompt for sudo password for elevated operations
	#The -S (stdin) option causes sudo to read the password from the standard input 
	#instead of the terminal device. You can then use "echo <password> | sudo -S <command>" 
	data=$(tempfile 2>/dev/null)
 
	# trap it
	trap "rm -f $data" 0 1 2 5 15
	 
	# get password with the --insecure option
	dialog --title "Gaining elevated privledges" \
	--clear \
	--insecure \
	--passwordbox "Enter your user password" 7 32 2> $data
	 
	ret=$?
	 
	# make decison
	case $ret in
	  0)
	    #use local variable to use it later in other functions
	    userpasswd=$(cat "$data")
	    ;;
	  1)
	    echo "Cancel pressed.";;
	  255)
	    [ -s $data ] &&  cat $data || echo "ESC pressed.";;
	esac

	#clear screen for output
	clear

	#add multi-arch support
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Adding multi-arch support..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo $userpasswd | sudo -S dpkg --add-architecture i386 | tee -a install_log.txt

	#add repository for pcsx2 (PS2 emulator)
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Adding pcsx2 repository support..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	sudo add-apt-repository -y ppa:gregory-hainaut/pcsx2.official.ppa | tee -a install_log.txt

	#add repository for official team XBMC "stable"
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Adding XBMC Ubuntu (stable) repository..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo $userpasswd | sudo -S add-apt-repository -y ppa:team-xbmc/ppa | tee -a install_log.txt

	#add repository for dolphin-emu
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Adding Dolphin-Emu repository..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	sudo add-apt-repository -y ppa:glennric/dolphin-emu | tee -a install_log.txt

	#install Gens/GS via deb pkg (only way I  can currently find it)
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Installing Gens/GS...On first run this will take some time!" | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	#need to use gdebi here to autoresolve dependencies that Gens/GS requires for i386
	#install Gens/GS using gdebi
	echo $userpasswd | sudo -S gdebi --n $HOME/RetroRig/emulators/Gens-GS/Gens_2.16.7_i386.deb | tee -a install_log.txt
	
	#install software from repositories
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Installing required packages..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo $userpasswd | sudo -S apt-get install -y xboxdrv curl zsnes nestopia pcsxr pcsx2:i386 \
	python-software-properties pkg-config software-properties-common \
	mame mupen64plus dconf-tools qjoypad xbmc dolphin-emu-master stella \
	build-essential gdebi| tee -a install_log.txt

	#Removal of software for related bugs
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Removing troublesome packages..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo $userpasswd | sudo -S apt-get remove -y apport apport-gtk | tee -a install_log.txt
	echo "" | tee -a install_log.txt
	echo "Remove apport to avoid constant gtk bug report instances until solved" | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Please reference the following bug report:" | tee -a install_log.txt
	echo "Reported by cecilpierce on 2012-06-05 on Launchpad" | tee -a install_log.txt
	echo "https://bugs.launchpad.net/ubuntu/+source/plymouth/+bug/1009238" | tee -a install_log.txt
	
	#update repository listings
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Updating packages..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt	
	echo $userpasswd | sudo -S apt-get update | tee -a install_log.txt
	
	#clear screen
	clear
}


function _gamepad (){

	#log change in install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Setting Controller Gamepad..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt

	#prompt for sudo password for elevated operations.  We need this again, in case a user goes directly here
	#The -S (stdin) option causes sudo to read the password from the standard input 
	#instead of the terminal device. You can then use "echo <password> | sudo -S <command>" 
	data=$(tempfile 2>/dev/null)
	# trap it
	trap "rm -f $data" 0 1 2 5 15	 
	# get password with the --insecure option
	dialog --title "Gaining elevated privledges" \
	--clear \
	--insecure \
	--passwordbox "Enter your user password" 7 32 2> $data	 
	ret=$?	 
	# make decison
	case $ret in
	  0)
	    #use local variable to use it later in other functions
	    local userpasswd=$(cat "$data")
	    ;;
	  1)
	    echo "Cancel pressed.";;
	  255)
	    [ -s $data ] &&  cat $data || echo "ESC pressed.";;
	esac

cmd=(dialog --backtitle "LibreGeek.org RetroRig Installer" --menu "| Gamepad Select | \
			 Request any new Gamepads via github!" 16 62 16)
options=(1 "Xbox 360 Controller (wireless) (4-player)" 
	 2 "Back to settings menu" 
	 3 "Back to main menu")

	#make menu choice
	selection=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	#functions

	for choice in $selection
	do
		case $choice in

		1)
		#copy xbox configuration (default) to folder
		echo $userpasswd | sudo -S sed -v $HOME/RetroRig/controller-cfgs/xpad-wireless.xboxdrv /usr/share/xboxdrv/ | tee -a install_log.txt
		#Inject Xbox 360 configuration to init script. The default is xpad-wireless.xbodrv, so no need to inject below!
		#but.........commented anyway for science!!!
		#echo $userpasswd | sudo -S sed -i "s|xpad-wireless.xboxdrv|xpad-wireless.xboxdrv|g" /etc/init.d/xboxdrv

		#set qjoypad's profile to match Xbox 360 Wireless (4-player)
		cp -v $HOME/RetroRig/controller-cfgs/x360w.lyt $HOME/.qjoypad3/ | tee -a install_log.txt

		#back to settings menu
		_settings
		;;

		2)
		_settings
		;;

		3)
		_main
		;;
		esac
	done
}

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

	#prompt for sudo password for elevated operations
	#The -S (stdin) option causes sudo to read the password from the standard input 
	#instead of the terminal device. You can then use "echo <password> | sudo -S <command>" 
	data=$(tempfile 2>/dev/null)
	# trap it
	trap "rm -f $data" 0 1 2 5 15	 
	# get password with the --insecure option
	dialog --title "Gaining elevated privledges" \
	--clear \
	--insecure \
	--passwordbox "Enter your user password" 7 32 2> $data	 
	ret=$?	 
	# make decison
	case $ret in
	  0)
	    #use local variable to use it later in other functions
	    local userpasswd=$(cat "$data")
	    ;;
	  1)
	    echo "Cancel pressed.";;
	  255)
	    [ -s $data ] &&  cat $data || echo "ESC pressed.";;
	esac

	#clear screen for output
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
	mkdir -pv $HOME/Games/ROMs/Gamecube/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/ROMs/MAME/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/ROMs/N64/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/ROMs/NES/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/ROMs/SNES/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/ROMs/PS2/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/ROMs/PS1/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/ROMs/Sega\ Genesis/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/ROMs/SNK\ Neo\ Geo/ | tee -a install_log.txt

	#Artwork 
	mkdir -pv $HOME/Games/Artwork/Atari\ 2600/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Artwork/Gamecube/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Artwork/MAME/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Artwork/N64/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Artwork/NES/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Artwork/SNES/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Artwork/PS2/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Artwork/PS1/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Artwork/Sega\ Genesis/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Artwork/SNK\ Neo\ Geo/ | tee -a install_log.txt

	#Saves (if any)
	mkdir -pv $HOME/Games/Saves/Atari\ 2600/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Saves/Gamecube/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Saves/MAME/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Saves/N64/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Saves/NES/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Saves/SNES/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Saves/PS2/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Saves/PS1/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Saves/Sega\ Genesis/ | tee -a install_log.txt
	mkdir -pv $HOME/Games/Saves/SNK\ Neo\ Geo/ | tee -a install_log.txt

	#create dotfiles
	mkdir -pv $HOME/.qjoypad3/ | tee -a install_log.txt
	mkdir -pv $HOME/.dolphin-emu/Config/ | tee -a install_log.txt
	mkdir -pv $HOME/.config/mupen64plus/ | tee -a install_log.txt
	mkdir -pv $HOME/.nestopia/ | tee -a install_log.txt
	mkdir -pv $HOME/.gens/ | tee -a install_log.txt
	mkdir -pv $HOME/.zsnes/ | tee -a install_log.txt
	mkdir -pv $HOME/.mame/cfg/ | tee -a install_log.txt
	mkdir -pv $HOME/.pcsx/plugins/ | tee -a install_log.txt
	mkdir -pv $HOME/.pcsx/patches/ | tee -a install_log.txt
	mkdir -pv $HOME/.config/pcsx2/inis/ | tee -a install_log.txt
	mkdir -pv $HOME/.stella/ | tee -a install_log.txt
	mkdir -pv $HOME/.xbmc/ | tee -a install_log.txt

	#xbmc does not (at least for Ubuntu's repo pkg) load the
	#dot files without loading XBMC at least once
	#copy in default folder base from first run:	
	cp -Rv $HOME/RetroRig/XBMC-configs/* $HOME/.xbmc | tee -a install_log.txt

	#xboxdrv director located in common area for startup
	echo "echo $userpasswd | sudo -S needed to create common xboxdrv share!"
	echo $userpasswd | sudo -S mkdir -pv /usr/share/xboxdrv/ | tee -a install_log.txt

	#Tools
	mkdir -pv $HOME/Games/Tools/ | tee -a install_log.txt

	echo "-----------------------------------------------------------" |tee -a install_log.txt
	echo "Copy software configurations" tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	#configs
	mkdir -pv $HOME/Games/Configs/ | tee -a install_log.txt

	#Nestopia
	#default path: /home/$USER/.nestopia
	cp -v $HOME/RetroRig/emu-configs/Nestopia/nstcontrols $HOME/.nestopia/ | tee -a install_log.txt
	cp -v $HOME/RetroRig/emu-configs/Nestopia/nstsettings $HOME/.nestopia/ | tee -a install_log.txt

	#gens
	#default path: /home/$USER/.gens
	#Global config
	cp -v $HOME/RetroRig/emu-configs/Gens-GS/gens.cfg $HOME/.gens/ | tee -a install_log.txt

	#ZSNES
	#default path: /home/$USER/.zsnes
	#Controller config
	cp -v $HOME/RetroRig/emu-configs/ZSNES/zinput.cfg $HOME/.zsnes/ | tee -a install_log.txt
	cp -v $HOME/RetroRig/emu-configs/ZSNES/zsnesl.cfg $HOME/.zsnes/ | tee -a install_log.txt

	#mame
	#default path: /home/$USER/.mame
	#Main config
	cp -v $HOME/RetroRig/emu-configs/MAME/default.cfg $HOME/.mame/cfg | tee -a install_log.txt
	cp -v $HOME/RetroRig/emu-configs/MAME/mame.ini $HOME/.mame | tee -a install_log.txt
	#offline artwork scrapper configs
	cp -v $HOME/RetroRig/emu-configs/MAME/parserConfig.xml $HOME/Games/Artwork/MAME | tee -a install_log.txt
	
	#pcsx
	#default path: /home/$USER/.pcsx
	#Main config
	cp -v $HOME/RetroRig/emu-configs/pcsx/pcsx.cfg $HOME/.pcsx/ | tee -a install_log.txt
	cp -Rv $HOME/RetroRig/emu-configs/pcsx/plugins $HOME/.pcsx/ | tee -a install_log.txt
	cp -Rv $HOME/RetroRig/emu-configs/pcsx/patches $HOME/.pcsx/ | tee -a install_log.txt

	#pcsx2
	#default path: /home/$USER/.config/pcsx2
	#Main config
	cp -v $HOME/RetroRig/emu-configs/pcsx2/PCSX2-reg.ini $HOME/.config/pcsx2/ | tee -a install_log.txt
	cp -v $HOME/RetroRig/emu-configs/pcsx2/inisOnePAD.ini $HOME/.config/pcsx2/ | tee -a install_log.txt
	cp -v $HOME/RetroRig/emu-configs/pcsx2/inis/* $HOME/.config/pcsx2/inis/ | tee -a install_log.txt

	#mupen64pluspwd
	#default path: /home/$USER/.config/mupen64plus
	#Main config
	cp -v $HOME/RetroRig/emu-configs/mupen64plus/mupen64plus.cfg $HOME/.config/mupen64plus/ | tee -a install_log.txt

	#Stella
	#default path: /home/$USER/.config/mupen64plus
	#Main config
	cp -v $HOME/RetroRig/emu-configs/Stella/stellarc $HOME/.stella/ | tee -a install_log.txt

	#dolphin
	#default path /home/$USER/.dolphin-emu/
	#emulator config
	cp -Rv /$HOME/RetroRig/emu-configs/Dolphin/Dolphin.ini $HOME/.dolphin-emu/Config/ | tee -a install_log.txt
	#Gamecube controller config
	cp -Rv /$HOME/RetroRig/emu-configs/Dolphin/GCPadNew.ini $HOME/.dolphin-emu/Config/ | tee -a install_log.txt
	#Wii controller config
	#OpenGL graphics config
	cp -Rv /$HOME/RetroRig/emu-configs/Dolphin/gfx_opengl.ini $HOME/.dolphin-emu/Config/ | tee -a install_log.txt

	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "init scripts and post-configurations" | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt

	#add xbox controller init script
	echo "echo $userpasswd | sudo -S needed to create init scripts for xboxdrv!"
	#call function to select gamepad configuration
	_gamepad
	echo $userpasswd | sudo -S cp -v $HOME/RetroRig/init-scripts/xboxdrv /etc/init.d/ | tee -a install_log.txt
	echo $userpasswd | sudo -S update-rc.d xboxdrv defaults | tee -a install_log.txt

	#copyautoexec.py in the userdata folder for autostarting RCB
	#cp -v $HOME/RetroRig/RCB/autoexec.py $HOME/.xbmc/userdata/

	#blacklist xpad
	echo "sudo needed to blacklist xpad!"
	echo $userpasswd | sudo -S cp -v $HOME/RetroRig/init-scripts/blacklist.conf /etc/modprobe.d/ | tee -a install_log.txt

	#copy default gamepad setup for Xbox 360 Wireless (4-player)
	cp -v $HOME/RetroRig/controller-cfgs/x360w.lyt $HOME/.qjoypad3/ | tee -a install_log.txt

	#create autostart for XBMC and qjoypad
	echo "sudo needed to create auto-start entries!"
	echo $userpasswd | sudo -S cp -v /usr/share/applications/xbmc.desktop /etc/xdg/autostart/ | tee -a install_log.txt
	echo $userpasswd | sudo -S cp -v $HOME/RetroRig/controller-cfgs/qjoypad.desktop /etc/xdg/autostart/ | tee -a install_log.txt
	#If xboxdrv config file does not pick up on reboot,
	#be sure to resync the wireless receiver!

	#set the system user to an absolute value.
	#RCB and some config files don't like using $HOME, rather /home/test/
	#Let's change the config files to reflect the current username
	sed -i "s|/home/test/|/home/$USER/|g" $HOME/.config/pcsx2/PCSX2-reg.ini | tee -a install_log.txt
	sed -i "s|/home/test/|/home/$USER/|g" $HOME/.gens/gens.cfg | tee -a install_log.txt
	sed -i "s|/home/test/|/home/$USER/|g" $HOME/.zsnes/zsnesl.cfg | tee -a install_log.txt
	sed -i "s|/home/test/|/home/$USER/|g" $HOME/.pcsx/pcsx.cfg | tee -a install_log.txt
	sed -i "s|/home/test/|/home/$USER/|g" $HOME/.dolphin-emu/Config/Dolphin.ini | tee -a install_log.txt
	sed -i "s|/home/test/|/home/$USER/|g" $HOME/.xbmc/userdata/addon_data/script.games.rom.collection.browser/config.xml | tee -a install_log.txt	
	echo "The user applied to configuration files was: $USER" |  tee -a install_log
	sleep 7s
	
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
	echo $userpasswd | sudo -S apt-get install -y xboxdrv zsnes nestopia pcsxr pcsx2:i386\
	mame mupen64plus qjoypad xbmc dolphin-emu-master stella	
	sleep 3s
	#clear
	clear
}

function _upgrade-system () {
	dialog --infobox "updating system" 3 11
	echo $userpasswd | sudo -S apt-get update
	echo $userpasswd | sudo -S apt-get upgrade
	sleep 3s
	#clear
	clear
}

function _start-xbmc () {
	dialog --infobox "starting RetroRig" 3 21
	sleep 1s
	xbmc
	#clear
	clear
}

function _reboot () {
	#need to add reboot command to sudo to avoid pw prompt
	data=$(tempfile 2>/dev/null)
 
	# trap it
	trap "rm -f $data" 0 1 2 5 15
	 
	# get password with the --insecure option
	dialog --title "Gaining elevated privledges" \
	--clear \
	--insecure \
	--passwordbox "Enter your user password" 7 32 2> $data
	 
	ret=$?
	 
	# make decison
	case $ret in
	  0)
	    #use local variable to use it later in other functions
	    userpasswd=$(cat "$data")
	    ;;
	  1)
	    echo "Cancel pressed.";;
	  255)
	    [ -s $data ] &&  cat $data || echo "ESC pressed.";;
	esac

        dialog --infobox "Rebooting in 5 seconds, press CTRL+C to cancel" 3 51 ; sleep 5s
        sleep 5s
        echo $userpasswd | sudo -S /sbin/reboot
}
#call main
_main
