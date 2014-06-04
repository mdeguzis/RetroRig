# !/bin/bash
# 
#  append a "-x" on the end above for debugging if need be
# 
# small script to copy over configuration files for emulators
# Version 0.7.5
# Please report any errors via a pull request
# You can also reach me on twitter: @N3RD42
# 
# Pre-requisite checks:
# check for dialog and prompt to install if it is not present

# remove previous install log to start fresh
rm -f install_log.txt
# remove previous uninstall log, if any
rm -f uninstall_log.txt

# start logging
echo "-----------------------------------------------------------" >> install_log.txt
echo "Starting install log..." >> install_log.txt
echo "-----------------------------------------------------------" >> install_log.txt

function _gain-root (){

# prompt for sudo password for elevated operations.  We need this again, in case a user goes directly here
# The -S (stdin) option causes sudo to read the password from the standard input 
# instead of the terminal device. You can then use "echo <password> | sudo -S <command>" 
	
data=$(tempfile 2>/dev/null)
#  trap it
trap "rm -f $data" 0 1 2 5 15	 
#  get password with the --insecure option
dialog --title "Gaining elevated privledges" \
--clear \
--insecure \
--passwordbox "Enter your user password" 7 32 2> $data	 
ret=$?	 
#  make decison
case $ret in
  0)
    # variable to use later in other functions
     userpasswd=$(cat "$data")
    ;;
  1)
    echo "Cancel pressed.";;
  255)
    [ -s $data ] &&  cat $data || echo "ESC pressed.";;
esac

}

# gain elevated privledges for functions of install script
_gain-root 

function _main () {

cmd=(dialog --backtitle "LibreGeek.org RetroRig Installer" --menu "| Main Menu | \
			 Any required BIOS files are NOT provided!" 17 62 16)
options=(1 "Install Software" 
	 2 "Set up default configuration files" 
	 3 "Retro Rig Settings" 
	 4 "Pull latest files from git" 
	 5 "Update emulator binaries" 
	 6 "Upgrade System (use with caution!)" 
	 7 "Start RetroRig" 
	 8 "Reboot PC"
	 9 "Uninstall RetroRig"  
	 10 "Exit")

	# make menu choice
	selection=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	# functions

	for choice in $selection
	do
		case $choice in
		1)  	
		_software
		# call memu rather than return so user can choose again
		_main
		;;

		2)  
		_configuration
		# call memu rather than return so user can choose again
		_main 
		;;

		3)
		_settings
		# call memu rather than return so user can choose again
		_main
		;;

		4)
		_update-git
		# reload script with changes
		bash config-setup.sh
		;;

		5)
		_update-binaries
		# call memu rather than return so user can choose again
		_main
		;;

		6)
		_upgrade-system
		# call memu rather than return so user can choose again
		_main
		;;

		7)
		_start-xbmc
		# call memu rather than return so user can choose again
		_main
		;;

		8)
		_reboot
		# call memu rather than return so user can choose again
		_main
		;;

		9)
		# confirm uninstall is the intended action
		dialog --title "Confirm yes/no" \
		--backtitle "LibreGeek.org RetroRig Installer" \
		--yesno "Are you sure you want remove RetroRig?"  6 0

		#  Get exit status
		#  0 means user hit [yes] button.
		#  1 means user hit [no] button.
		#  255 means user hit [Esc] key.
		response=$?
		case $response in
			0)
			_uninstall
			;;

			1) 
			dialog --infobox "Exiting Uninstall"  3 11
			sleep 2s
			_main
			;;

			255)
			dialog --infobox "Exiting Uninstall" 3 0
			sleep 2s
			_main
			;;
		esac

		# call memu rather than return so user can choose again
		_main
		;;

		10)
		clear
		exit
		;;
		esac
	done
}


function _file-loader (){

folder=$(dialog --stdout --title "Please choose a file (spacebar to select)" --fselect $HOME/ 14 48)
echo "${folder} file chosen."
}


# Load ROMs at will-call, or yes/no on configuration run
function _bios-loader (){

cmd=(dialog --backtitle "LibreGeek.org RetroRig Installer" --menu "Load BIOS for which system?" 19 32 24)
options=(1 "Neo Geo BIOS files"
	 2 "Exit ROM Loader")

	# make menu choice
	selection=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	# functions

	for choice in $selection
	do
		case $choice in

		1)
		# call file loader  	
		_file-loader
		# copy NEO GEO BIOs file of choice ROMs. BIOS file *must* be a zip file that contains the
		# necessary files!!
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading Neo Geo BIOS files..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv "$folder" $HOME/Games/ROMs/Neo-Geo/BIOS/ | tee -a install_log.txt
		#  return back to menu
		_bios-loader
		;;

		2)  
		return
		;;
		esac
	done
}

function _file-loader (){

folder=$(dialog --stdout --title "Please choose a file (spacebar to select)" --fselect $HOME/ 14 48)
echo "${folder} file chosen."
}


function _rom-loader (){

#  Load ROMs at will-call, or yes/no on configuration run

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
	 11 "Neo Geo CDZ (US)"
	 12 "Exit ROM Loader")

	# make menu choice
	selection=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	# functions

	for choice in $selection
	do
		case $choice in
		1)
		# call file loader  	
		_file-loader
		# copy Atari ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading Atari ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv "$folder"/* $HOME/Games/ROMs/Atari\ 2600/ | tee -a install_log.txt
		#  return back to menu
		_rom-loader
		;;

		2)  
		# call file loader  	
		_file-loader
		# copy NES ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading NES ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv "$folder"/* $HOME/Games/ROMs/NES/ | tee -a install_log.txt
		# return back to menu
		_rom-loader
		;;

		3)
		# call file loader  	
		_file-loader
		# copy SNES ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading SNES ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv "$folder"/* $HOME/Games/ROMs/SNES/ | tee -a install_log.txt
		# return back to menu
		_rom-loader
		;;

		4)
		#  call file loader  	
		_file-loader
		#  copy N64 ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading N64 ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv "$folder"/* $HOME/Games/ROMs/N64/ | tee -a install_log.txt
		#  return back to menu
		_rom-loader
		;;

		5)
		# call file loader  	
		_file-loader
		# copy MAME ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading MAME ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv "$folder"/* $HOME/Games/ROMs/MAME/ | tee -a install_log.txt
		# return back to menu
		_rom-loader
		;;

		6)
		# call file loader  	
		_file-loader
		# copy Sega Master System ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading Sega Master System ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv "$folder"/* $HOME/Games/ROMs/Sega\ Master\ System/ | tee -a install_log.txt
		# return back to menu
		_rom-loader
		;;

		7)
		# call file loader  	
		_file-loader
		# copy Sega Game Gear ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading Sega Game Gear ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv "$folder"/* $HOME/Games/ROMs/Sega\ Game\ Gear/ | tee -a install_log.txt
		# return back to menu
		_rom-loader
		;;

		8)
		# call file loader  	
		_file-loader
		# copy GBC ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading GBC ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv "$folder"/* $HOME/Games/ROMs/GBC/ | tee -a install_log.txt
		# return back to menu
		_rom-loader
		;;

		9)
		# call file loader  	
		_file-loader
		# copy GBA ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading GBA ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv "$folder"/* $HOME/Games/ROMs/GBA/ | tee -a install_log.txt
		# return back to menu
		_rom-loader
		;;

		10)
		# call file loader  	
		_file-loader
		# copy Turbographx 16 ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading Turbographx 16 ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv "$folder"/* $HOME/Games/ROMs/TurboGraphx\ 16/ | tee -a install_log.txt
		# return back to menu
		_rom-loader
		;;

		11)
		# call file loader  	
		_file-loader
		# copy NEO GEO CDZ ROMs
		clear
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		echo "Loading Neo Geo CDZ ROMs..." | tee -a install_log.txt
		echo "-----------------------------------------------------------" | tee -a install_log.txt
		cp -Rv "$folder"/* $HOME/Games/ROMs/Neo-Geo/AES/ | tee -a install_log.txt
		# return back to menu
		_rom-loader
		;;

		12)  
		return
		;;
		esac
	done
}

# mupen64plus plugin changer
function _config-mupen (){

# set fstart to start at specified folder directory, local var only
local fstart

cmd=(dialog --backtitle "LibreGeek.org RetroRig Installer" --menu "Default directory: ~/.config/mupen64plus" 16 0 16)
options=(1 "Change Video Plugin"
	 2 "Back to settings menu"  
	 3 "Back to main menu")

	# make menu choice
	selection=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	# functions

	for choice in $selection
	do
		case $choice in

		1)
		# present a different file loader here, since we want to start in a diff DIR.
		fstart=/usr/lib/x86_64-linux-gnu/mupen64plus
		# Maybe I can find a way to swap the dir on the fly later on
		folder=$(dialog --stdout --title "Please choose a file (spacebar to select)" --fselect $fstart/ 10 68)
		# change plugin
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

# plugin/scaling/filter switch function
function _plugin-switcher (){

cmd=(dialog --backtitle "LibreGeek.org RetroRig Installer" --menu "Plugin Configuration Menu" 16 0 16)
options=(1 "Current configuration"
	 2 "Mupen64plus" 
	 3 "Back to settings menu"  
	 4 "Back to main menu")

	# make menu choice
	selection=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	# functions

	for choice in $selection
	do
		case $choice in

		1)
		# echo curent plugin settings
		# mupen64plus
		echo "Mupen64plus:" > res.txt
		grep -i "VideoPlugin = " $HOME/.config/mupen64plus/mupen64plus.cfg >> res.txt
		echo "" >> res.txt
		# Stella
		echo "Stella:" >> res.txt
		grep -i "tia_filter" $HOME/.stella/stellarc >> res.txt
		echo "" >> res.txt
		# report current resolution
		dialog --textbox res.txt 33 0
		# remove text file
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

# settings function
function _settings (){

cmd=(dialog --backtitle "LibreGeek.org RetroRig Installer" --menu "Settings Menu" 16 0 16)
options=(1 "Change resolution"  
	 2 "Load BIOS files for systems"
	 3 "Load ROMs"
	 4 "Change plugins/filters/scaling"
	 5 "Change Gamepad Type"
	 6 "Enable SSH support"
	 7 "Back to main menu")

	# make menu choice
	selection=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	# functions
grep -i "VideoPlugin = " $HOME/.config/mupen64plus/mupen64plus.cfg >> res.txt
	for choice in $selection
	do
		case $choice in
		1)  	
		_resolution
		# call settings rather than return so user can choose again
		_settings
		;;

		2)  	
		_bios-loader
		# call settings rather than return so user can choose again
		_settings
		;;

		2)  	
		_rom-loader
		# call settings rather than return so user can choose again
		_settings
		;;

		4)
		dialog --msgbox "Option disabled for further testing" 5 40  	
		# _plugin-switcher
		# call settings rather than return so user can choose again
		_settings
		;;

		5)  	
		_gamepad
		# call settings rather than return so user can choose again
		_settings
		;;

		6)
		clear
		# install openssh-server  
		echo $userpasswd | sudo -S apt-get install -y openssh-server | tee -a install_log.txt
		# prompt user to change default port
		dialog --title "Set desired SSH port (typically 22)" --inputbox "Enter Port" 10 0 2> /tmp/set_ssh
		# cat input
		ssh_new=$(cat '/tmp/set_ssh')
		# set orig port 
		ssh_org=$(grep -i "Port " /etc/ssh/sshd_config)
		# set new port from user input
		echo $userpasswd | sudo -S sed -i "s|$ssh_org|Port $ssh_new|g" /etc/ssh/sshd_config
		# restart ssh service
		echo $userpasswd | sudo -S service ssh restart
		# remove temp file
		rm -f /tmp/set_ssh
		# return to menu
		_settings
		;;

		7)  
		return
		;;
	esac
	done
}

function _res-swticher (){
		clear
		dialog --infobox "Setting resolution to selection" 3 36
		# resolution is set via _resolution function		
		
		######################## 		
		# Stella
		######################## 
		st_org=$(grep -Ee "\bfullres = \b" $HOME/.stella/stellarc)
		# make the changes, prefix new_X in case NULL was entered previously
		sed -ie "s|$st_org|fullres = $st_new|g" $HOME/.stella/stellarc

		######################## 		
		# mupen64plus
		######################## 
		m_org_X=$(grep -Ee "\bScreenWidth = \b" $HOME/.config/mupen64plus/mupen64plus.cfg)
		m_org_Y=$(grep -Ee "\bScreenHeight = \b" $HOME/.config/mupen64plus/mupen64plus.cfg)
		# make the changes, prefix new_X in case NULL was entered previousey
		sed -ie "s|$m_org_X|ScreenWidth = $m_new_X|g" $HOME/.config/mupen64plus/mupen64plus.cfg
		sed -ie "s|$m_org_Y|ScreenHeight = $m_new_Y|g" $HOME/.config/mupen64plus/mupen64plus.cfg

		######################## 		
		# mednafen 
		########################  

		# Emulator Codes:
		######################## 
		# Atari Lynx [lynx]
		# GameBoy (Color) [gb]
		# GameBoy Advance [gba]
		# Neo Geo Pocket (Color) [ngp]
		# Nintendo Entertainment System/Famicom [nes]
		# PC Engine (CD)/TurboGrafx 16 (CD)/SuperGrafx [pce]
		# PC Engine (CD)/TurboGrafx 16 (CD)/SuperGrafx [pce_fast]
		# PC-FX [pcfx]
		# Sega Game Gear [gg]
		# Sega Genesis/MegaDrive [md]
		# Sega Master System [sms]
		# Sony PlayStation [psx]
		# Super Nintendo Entertainment System/Super Famicom [snes]
		# Virtual Boy [vb]
		# WonderSwan [wswan]

		# Note: it should be noted that all emulators are set to stretch
		# the screen (EMU_CODE.stretch 1). The value is boolean.

		# Mednafen (GBC)
		gb_org_X=$(grep -Ee "\bgb.xres\b " $HOME/.mednafen/mednafen-09x.cfg)
		gb_org_Y=$(grep -Ee "\bgb.yres\b " $HOME/.mednafen/mednafen-09x.cfg)
		# make the changes, prefix new_X in case NULL was entered previously
		sed -ie "s|$gb_org_X|gb.xres $gb_new_X|g" $HOME/.mednafen/mednafen-09x.cfg
		sed -ie "s|$gb_org_Y|gb.yres $gb_new_Y|g" $HOME/.mednafen/mednafen-09x.cfg

		# Mednafen (NES)
		nes_org_X=$(grep -Ee "\bnes.xres\b " $HOME/.mednafen/mednafen-09x.cfg)
		nes_org_Y=$(grep -Ee "\bnes.yres\b " $HOME/.mednafen/mednafen-09x.cfg)
		# make the changes, prefix new_X in case NULL was entered previously
		sed -ie "s|$nes_org_X|nes.xres $nes_new_X|g" $HOME/.mednafen/mednafen-09x.cfg
		sed -ie "s|$nes_org_Y|nes.yres $nes_new_Y|g" $HOME/.mednafen/mednafen-09x.cfg

		# Mednafen (GameBoy Advance)
		gba_org_X=$(grep -Ee "\bgba.xres\b " $HOME/.mednafen/mednafen-09x.cfg)
		gba_org_Y=$(grep -Ee "\bgba.yres\b " $HOME/.mednafen/mednafen-09x.cfg)
		# make the changes, prefix new_X in case NULL was entered previously
		sed -ie "s|$gba_org_X|gba.xres $gba_new_X|g" $HOME/.mednafen/mednafen-09x.cfg
		sed -ie "s|$gba_org_Y|gba.yres $gba_new_Y|g" $HOME/.mednafen/mednafen-09x.cfg

		# Mednafen (SNES)
		snes_org_X=$(grep -Ee "\bsnes.xres\b " $HOME/.mednafen/mednafen-09x.cfg)
		snes_org_Y=$(grep -Ee "\bsnes.yres\b " $HOME/.mednafen/mednafen-09x.cfg)
		# make the changes, prefix new_X in case NULL was entered previously
		sed -ie "s|$snes_org_X|snes.xres $snes_new_X|g" $HOME/.mednafen/mednafen-09x.cfg
		sed -ie "s|$snes_org_Y|snes.yres $snes_new_Y|g" $HOME/.mednafen/mednafen-09x.cfg

		# Mednafen (Sega Master System, aka Sega Sega Master)
		sms_org_X=$(grep -Ee "\bsms.xres\b " $HOME/.mednafen/mednafen-09x.cfg)
		sms_org_Y=$(grep -Ee "\bsms.yres\b " $HOME/.mednafen/mednafen-09x.cfg)
		# make the changes, prefix new_X in case NULL was entered previously
		sed -ie "s|$sms_org_X|sms.xres $sms_new_X|g" $HOME/.mednafen/mednafen-09x.cfg
		sed -ie "s|$sms_org_Y|sms.yres $sms_new_Y|g" $HOME/.mednafen/mednafen-09x.cfg

		# Mednafen (Sega Gane Gear)
		sms_org_X=$(grep -Ee "\bsms.xres\b " $HOME/.mednafen/mednafen-09x.cfg)
		sms_org_Y=$(grep -Ee "\bsms.yres\b " $HOME/.mednafen/mednafen-09x.cfg)
		# make the changes, prefix new_X in case NULL was entered previously
		sed -ie "s|$sms_org_X|sms.xres $sms_new_X|g" $HOME/.mednafen/mednafen-09x.cfg
		sed -ie "s|$sms_org_Y|sms.yres $sms_new_Y|g" $HOME/.mednafen/mednafen-09x.cfg

		# Mednafen (Turbographx 16)
		gg_org_X=$(grep -Ee "\bgg.xres\b " $HOME/.mednafen/mednafen-09x.cfg)
		gg_org_Y=$(grep -Ee "\bgg.yres\b " $HOME/.mednafen/mednafen-09x.cfg)
		# make the changes, prefix new_X in case NULL was entered previously
		sed -ie "s|$gg_org_X|gg.xres $gg_new_X|g" $HOME/.mednafen/mednafen-09x.cfg
		sed -ie "s|$gg_org_Y|gg.yres $gg_new_Y|g" $HOME/.mednafen/mednafen-09x.cfg

		# For some reason, when I replace the resolutions, the config files are changed
		# They are appended with an "e" as in mednafen-09x.cfge. These "edited" files need
		# deleted. I will have to find out at some point why this occurs
		rm -f $HOME/.mednafen/mednafen-09x.cfge
		rm -f $HOME/.config/mupen64plus/mupen64plus.cfge
		rm -f $HOME/.pcsx/plugins/gpuPeopsMesaGL.cfge

}

function _resolution () {

# menu
# add res-switcher function to make new presets more modular to add
while true; do
cmd=(dialog --backtitle "RetroRig Settings" --menu "Choose your resolution" 16 0 16)
options=(1 "Current Resolution"
	 2 "1280x720  (720p)  (5:4)"
	 3 "1280x1024 (SXGA)  (5:4)"
	 4 "1366x768  (720p)  (16:9)"
	 5 "1600x900  (900p)  (16:9)"
	 6 "1920x1080 (1080p) (16:9)"
	 7 "Custom"
	 8 "Exit resolution selection"
	 9 "Back to main menu"
	)
     
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
if [ "$choices" != "" ]; then
    case $choices in

	 1) 
		# Need to use extended regexp's here because of nes being within nes
		# grep -Ee '\bnes\b' [list of files]

		# echo curent resolution
		# mupen64plus
		echo "mupen64plus:" > res.txt
		grep -Ee "\bScreenWidth = \b" $HOME/.config/mupen64plus/mupen64plus.cfg >> res.txt
		grep -Ee "\bScreenHeight = \b" $HOME/.config/mupen64plus/mupen64plus.cfg >> res.txt
		echo "" >> res.txt
		# Stella
		echo "Stella" >> res.txt
		grep -Ee "\bfullres = \b" $HOME/.stella/stellarc >> res.txt
		echo "" >> res.txt
		# mednafen GBC
		echo "Mednafen (GBC)" >> res.txt
		grep -Ee "\bgb.xres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		grep -Ee "\bgb.yres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		echo "" >> res.txt
		# mednafen GBA
		echo "Mednafen (GBA)" >> res.txt
		grep -Ee "\bgba.xres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		grep -Ee "\bgba.yres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		echo "" >> res.txt
		# mednafen Sega Sega Master System
		echo "Mednafen (Sega Master System)" >> res.txt
		grep -Ee "\bsms.xres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		grep -Ee "\bsms.yres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		echo "" >> res.txt
		# mednafen Sega Game Gear
		echo "Mednafen (Sega Game Gear)" >> res.txt
		grep -Ee "\bgg.xres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		grep -Ee "\bgg.yres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		echo "" >> res.txt
		# mednafen SNES
		echo "Mednafen (SNES)" >> res.txt
		grep -Ee "\bsnes.xres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		grep -Ee "\bsnes.yres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		echo "" >> res.txt
		# mednafen NES
		echo "Mednafen (NES)" >> res.txt
		grep -Ee "\bnes.xres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		grep -Ee "\bnes.yres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		echo "" >> res.txt
		# mednafen Turbographx 16
		echo "Mednafen (Turbographx 16)" >> res.txt
		grep -Ee "\bpce.xres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		grep -Ee "\bpce.yres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		echo "" >> res.txt
		# report current resolution
		dialog --textbox res.txt 33 0
		# remove text file
		rm res.txt
		;;

	 2) 
		# setting chosen: "1280x720  (720p)  (5:4)"
		# set mupen64plus value
		m_new_X="1280"
		m_new_Y="720"
		# set mednafen (GBC) value
		gb_new_X="1280"
		gb_new_Y="720"
		# set mednafen (GBA) value
		gba_new_X="1280"
		gba_new_Y="1024"
		# set mednafen (NES) value
		nes_new_X="1280"
		nes_new_Y="720"
		# set mednafen (SNES) value
		snes_new_X="1280"
		snes_new_Y="720"
		# set mednafen (Sega Master System) value
		sms_new_X="1280"
		sms_new_Y="720"
		# set mednafen (Sega Game Gear) value
		gg_new_X="1280"
		gg_new_Y="720"
		# set mednafen (Turbographx 16) value
		pce_new_X="1280"
		pce_new_Y="720"
		# set stella (Atari 2600)
		st_new="1280x720"
		# call _res-swticher
		_res-swticher
		# return to menu
		return
		;;  
	 3) 
		# setting chosen: "1280x1024 (SXGA)  (5:4)"
		# set mupen64plus value
		m_new_X="1280"
		m_new_Y="1024"
		# set mednafen (GBC) value
		gb_new_X="1280"
		gb_new_Y="1024"
		# set mednafen (GBA) value
		gba_new_X="1280"
		gba_new_Y="1024"
		# set mednafen (NES) value
		nes_new_X="1280"
		nes_new_Y="1024"
		# set mednafen (SNES) value
		snes_new_X="1280"
		snes_new_Y="1024"
		# set mednafen (Sega Master System) value
		sms_new_X="1280"
		sms_new_Y="1024"
		# set mednafen (Sega Game Gear) value
		gg_new_X="1280"
		gg_new_Y="1024"
		# set mednafen (Turbographx 16) value
		pce_new_X="1280"
		pce_new_Y="1024"
		# set stella (Atari 2600)
		st_new="1280x1024"
		# call _res-swticher
		_res-swticher
		# return to menu
		return
		;;
	 4) 
		# setting chosen: "1366x768  (720p)  (16:9)"
		# set mupen64plus value
		m_new_X="1366"
		m_new_Y="768"
		# set mednafen (GBC) value
		gb_new_X="1366"
		gb_new_Y="768"
		# set mednafen (GBA) value
		gba_new_X="1366"
		gba_new_Y="768"
		# set mednafen (NES) value
		nes_new_X="1366"
		nes_new_Y="768"
		# set mednafen (SNES) value
		snes_new_X="1366"
		snes_new_Y="768"
		# set mednafen (Sega Master System) value
		sms_new_X="1366"
		sms_new_Y="768"
		# set mednafen (Sega Game Gear) value
		gg_new_X="1366"
		gg_new_Y="768"
		# set mednafen (Turbographx 16) value
		pce_new_X="1366"
		pce_new_Y="768"
		# set stella (Atari 2600)
		st_new="1366x768"
		# call _res-swticher
		_res-swticher
		# return to menu
		return
		;;
	 5) 
		# setting chosen: "1600x900  (900p)  (16:9)"
		# set mupen64plus value
		m_new_X="1600"
		m_new_Y="900"
		# set mednafen (GBC) value
		gb_new_X="1600"
		gb_new_Y="900"
		# set mednafen (GBA) value
		gba_new_X="1600"
		gba_new_Y="900"
		# set mednafen (NES) value
		nes_new_X="1600"
		nes_new_Y="900"
		# set mednafen (SNES) value
		snes_new_X="1600"
		snes_new_Y="900"
		# set mednafen (Sega Master System) value
		sms_new_X="1600"
		sms_new_Y="900"
		# set mednafen (Sega Game Gear) value
		gg_new_X="1600"
		gg_new_Y="900"
		# set mednafen (Turbographx 16) value
		pce_new_X="1600"
		pce_new_Y="900"
		# set stella (Atari 2600)
		st_new="1600x900"
		# call _res-swticher
		_res-swticher
		# return to menu
		return
		;;
	 6) 
		# setting chosen: "1920x1080 (1080p) (16:9)"
		# set mupen64plus value
		m_new_X="1920"
		m_new_Y="1080"
		# set mednafen (GBC) value
		gb_new_X="1920"
		gb_new_Y="1080"
		# set mednafen (GBA) value
		gba_new_X="1920"
		gba_new_Y="1080"
		# set mednafen (NES) value
		nes_new_X="1920"
		nes_new_Y="1080"
		# set mednafen (SNES) value
		snes_new_X="1920"
		snes_new_Y="1080"
		# set mednafen (Sega Master System) value
		sms_new_X="1920"
		sms_new_Y="1080"
		# set mednafen (Sega Game Gear) value
		gg_new_X="1920"
		gg_new_Y="1080"
		# set mednafen (Turbographx 16) value
		pce_new_X="1920"
		pce_new_Y="1080"
		# set stella (Atari 2600)
		st_new="1920x1080"
		# call _res-swticher
		_res-swticher
		# return to menu
		return
		;;    
	 7) 
		dialog --infobox  "Setting resolution from user input" 3 40
		# set new resolution(s) from user input
		dialog --title "Set Custom Resolution" --inputbox "Enter Width (X)" 10 4 2> /tmp/new_X
		dialog --title "Set Custom Resolution" --inputbox "Enter Length (Y)" 10 4 2> /tmp/new_Y

		# set new resolution(s) from configs
		# mupen64plus
		m_new_X=$(cat '/tmp/new_X')
		m_new_Y=$(cat '/tmp/new_Y')
		# mednafen (GBC)
		gb_new_X=$(cat '/tmp/new_X')
		gb_new_Y=$(cat '/tmp/new_Y')
		# mednafen (GBA)
		gba_new_X=$(cat '/tmp/new_X')
		gba_new_Y=$(cat '/tmp/new_Y')
		# mednafen (NES)
		nes_new_X=$(cat '/tmp/new_X')
		nes_new_Y=$(cat '/tmp/new_Y')
		# mednafen (SNES)
		snes_new_X=$(cat '/tmp/new_X')
		snes_new_Y=$(cat '/tmp/new_Y')
		# mednafen (Sega Master System)
		sms_new_X=$(cat '/tmp/new_X')
		sms_new_Y=$(cat '/tmp/new_Y')
		# mednafen (Sega Game Gear)
		gg_new_X=$(cat '/tmp/new_X')
		gg_new_Y=$(cat '/tmp/new_Y')
		# mednafen (Turbographx 16)
		pce_new_X=$(cat '/tmp/new_X')
		pce_new_Y=$(cat '/tmp/new_Y')
		# set stella (Atari 2600)
		st1=$(cat '/tmp/new_X')
		stdelim=$('x')
		st2=$(cat '/tmp/new_Y')
		st_new=$($st1$stdelim$st2)

		# call _res-swticher
		_res-swticher
		# remove temp files
		rm -f /tmp/new_X
		rm -f /tmp/new_Y
		# return to menu
		return
		;; 
	 8) 
		return
		;;
	 9) 
		_main
		;;
	esac
fi
done
}

# software function
function _software () {

	# clear screen for output
	clear

	# add multi-arch support
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Adding multi-arch support..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo $userpasswd | sudo -S dpkg --add-architecture i386 | tee -a install_log.txt


	# add repository for official team XBMC "stable"
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Adding XBMC Ubuntu (stable) repository..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo $userpasswd | sudo -S add-apt-repository -y ppa:team-xbmc/ppa | tee -a install_log.txt

	# Add playdeb repo for later additions (very useful) 
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Add PlayDeb  Repository..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "deb http://archive.getdeb.net/ubuntu trusty-getdeb games" > /tmp/playdeb.list | tee -a install_log.txt
	echo $userpasswd | sudo -S mv /tmp/playdeb.list /etc/apt/sources.list.d/playdeb.list | tee -a install_log.txt
	wget -q -O- http://archive.getdeb.net/getdeb-archive.key > getdeb.key | tee -a install_log.txt
	echo $userpasswd | sudo -S sudo apt-key add getdeb.key | tee -a install_log.txt
	rm -f getdeb.key | tee -a install_log.txt

	# update repository listings
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Updating packages..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt	
	echo $userpasswd | sudo -S apt-get update | tee -a install_log.txt

	# install software from repositories
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Installing required packages..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo $userpasswd | sudo -S apt-get install -y xboxdrv curl \
	python-software-properties pkg-config software-properties-common mednafen \
	mame mupen64plus dconf-tools jstest-gtk qjoypad xbmc stella \
	build-essential | tee -a install_log.txt


	# Removal of software for related bugs
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
	
	
	# clear screen
	clear
}


function _gamepad (){

	# log change in install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Setting Controller Gamepad..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt

cmd=(dialog --backtitle "LibreGeek.org RetroRig Installer" --menu "| Gamepad Select | \
			 Request any new Gamepads via github!" 16 62 16)
options=(1 "Xbox 360 Controller (wireless) (4-player)" 
	 2 "Xbox 360 Controller (wired) (4-player)" 
	 3 "Exit gamepad selection"
	 4 "Back to main menu")

	# make menu choice
	selection=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	# functions

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

function _config-x360ws () {

	# Wireless Xbox 360 Controller Config
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Configuring Xbox (Wireless) Gamepad..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt

	# copy xbox configuration (default) to folder
	echo $userpasswd | sudo -S cp -v $HOME/RetroRig/controller-cfgs/x360ws/xpad-wireless.xboxdrv /usr/share/xboxdrv/ | tee -a install_log.txt
	
	#  copy keyboard.xml file for XBMC 
	#  Button id numbers are totally diffferent, due to the use of the use-dpad-as-button, and use-trigger-as-button options used.
	mkdir -pv $HOME/.xbmc/userdata/keymaps/ | tee -a install_log.txt
	echo $userpasswd | sudo -S cp -v $HOME/RetroRig/controller-cfgs/x360ws/keyboard.xml $HOME/.xbmc/userdata/keymaps

	# set qjoypad's profile to match Xbox 360 Wireless (4-player)
	cp -v $HOME/RetroRig/controller-cfgs/x360ws.lyt $HOME/.qjoypad3/ | tee -a install_log.txt

	# mame
	# default path: /home/$USER/.mame
	# Main config
	cp -v $HOME/RetroRig/emu-cfgs/x360ws/MAME/default.cfg $HOME/.mame/cfg | tee -a install_log.txt
	cp -v $HOME/RetroRig/emu-cfgs/x360ws/MAME/mame.ini $HOME/.mame | tee -a install_log.txt
	# offline artwork scrapper configs
	cp -v $HOME/RetroRig/emu-cfgs/x360ws/MAME/parserConfig.xml $HOME/Games/Artwork/MAME | tee -a install_log.txt
	cp -v $HOME/RetroRig/emu-cfgs/x360ws/MAME/MAME.txt $HOME/Games/Artwork/MAME | tee -a install_log.txt
	cp -v $HOME/RetroRig/emu-cfgs/x360ws/MAME/MAME\ synopsis\ RCB\ 201202.zip/ $HOME/Games/Artwork/MAME | tee -a install_log.txt

	# MESS
	# default path: /home/$USER/.mess
	# Main config
	cp -v $HOME/RetroRig/emu-cfgs/x360ws/MESS/mess.ini $HOME/.mess/ | tee -a install_log.txt
	cp -v $HOME/RetroRig/emu-cfgs/x360ws/MESS/default.cfg $HOME/.mess/cfg | tee -a install_log.txt

	# mednafen
	# default path: /home/$USER/.mednafen/mednafen.cfg
	# Main config
	cp -v $HOME/RetroRig/emu-cfgs/x360ws/mednafen/mednafen-09x.cfg $HOME/.mednafen | tee -a install_log.txt

	# mupen64plus
	# default path: /home/$USER/.config/mupen64plus
	# Main config
	cp -v $HOME/RetroRig/emu-cfgs/x360ws/mupen64plus/mupen64plus.cfg $HOME/.config/mupen64plus/ | tee -a install_log.txt

	# Stella
	# default path: /home/$USER/.config/mupen64plus
	# Main config
	cp -v $HOME/RetroRig/emu-cfgs/x360ws/Stella/stellarc $HOME/.stella/ | tee -a install_log.txt

	# inject init script and default config
	echo $userpasswd | sudo -S cp -v $HOME/RetroRig/init-scripts/x360ws/xboxdrv /etc/init.d/ | tee -a install_log.txt
	echo $userpasswd | sudo -S cp -v $HOME/RetroRig/init-scripts/x360ws/default/xboxdrv /etc/default/xboxdrv | tee -a install_log.txt
	# update 
	echo $userpasswd | sudo -S update-rc.d xboxdrv defaults | tee -a install_log.txt

	# blacklist xpad
	echo "sudo needed to blacklist xpad!"
	echo $userpasswd | sudo -S cp -v $HOME/RetroRig/init-scripts/x360ws/blacklist.conf /etc/modprobe.d/ | tee -a install_log.txt

	# copy default gamepad setup for Xbox 360 Wireless (4-player)
	cp -v $HOME/RetroRig/controller-cfgs/x360ws/x360ws.lyt $HOME/.qjoypad3/ | tee -a install_log.txt

	# copy qjoypad autostart item for x360ws gamepad config
	echo $userpasswd | sudo -S cp -v $HOME/RetroRig/controller-cfgs/x360ws/qjoypad.desktop /etc/xdg/autostart/ | tee -a install_log.txt

}

function _config-x360wd () {

	# Wired Xbox 360 Controller Config
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Configuring Xbox (Wired) Gamepad..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt

	# copy xbox configuration (default) to folder
	echo $userpasswd | sudo -S cp -v $HOME/RetroRig/controller-cfgs/x360wd/xpad-wired.xboxdrv /usr/share/xboxdrv/ | tee -a install_log.txt

	#  copy keyboard.xml file for XBMC 
	#  Button id numbers are totally diffferent, due to the use of the use-dpad-as-button, and use-trigger-as-button options used.
	mkdir -pv $HOME/.xbmc/userdata/keymaps/ | tee -a install_log.txt
	echo $userpasswd | sudo -S cp -v $HOME/RetroRig/controller-cfgs/x360wd/keyboard.xml $HOME/.xbmc/userdata/keymaps

	# set qjoypad's profile to match Xbox 360 Wireless (4-player)
	cp -v $HOME/RetroRig/controller-cfgs/x360wd.lyt $HOME/.qjoypad3/ | tee -a install_log.txt

	# mame
	# default path: /home/$USER/.mame
	# Main config
	cp -v $HOME/RetroRig/emu-cfgs/x360wd/MAME/default.cfg $HOME/.mame/cfg | tee -a install_log.txt
	cp -v $HOME/RetroRig/emu-cfgs/x360wd/MAME/mame.ini $HOME/.mame | tee -a install_log.txt
	# offline artwork scrapper configs
	cp -v $HOME/RetroRig/emu-cfgs/x360wd/MAME/parserConfig.xml $HOME/Games/Artwork/MAME | tee -a install_log.txt
	cp -v $HOME/RetroRig/emu-cfgs/x360wd/MAME/MAME.txt $HOME/Games/Artwork/MAME | tee -a install_log.txt
	cp -v $HOME/RetroRig/emu-cfgs/x360wd/MAME/MAME\ synopsis\ RCB\ 201202.zip/ $HOME/Games/Artwork/MAME | tee -a install_log.txt

	# MESS
	# default path: /home/$USER/.mess
	# Main config
	cp -v $HOME/RetroRig/emu-cfgs/x360ws/MESS/mess.ini $HOME/.mess/ | tee -a install_log.txt
	cp -v $HOME/RetroRig/emu-cfgs/x360ws/MESS/default.cfg $HOME/.mess/cfg | tee -a install_log.txt

	# mednafen
	# default path: /home/$USER/.mednafen/mednafen.cfg
	# Main config
	cp -v $HOME/RetroRig/emu-cfgs/x360ws/mednafen/mednafen-09x.cfg $HOME/.mednafen | tee -a install_log.txt

	# mupen64plus
	# default path: /home/$USER/.config/mupen64plus
	# Main config
	cp -v $HOME/RetroRig/emu-cfgs/x360wd/mupen64plus/mupen64plus.cfg $HOME/.config/mupen64plus/ | tee -a install_log.txt

	# Stella
	# default path: /home/$USER/.config/mupen64plus
	# Main config
	cp -v $HOME/RetroRig/emu-cfgs/x360wd/Stella/stellarc $HOME/.stella/ | tee -a install_log.txt
	
	# inject init script
	echo $userpasswd | sudo -S cp -v $HOME/RetroRig/init-scripts/x360wd/xboxdrv /etc/init.d/ | tee -a install_log.txt
	# update 
	echo $userpasswd | sudo -S update-rc.d xboxdrv defaults | tee -a install_log.txt

	# blacklist xpad
	echo "sudo needed to blacklist xpad!"
	echo $userpasswd | sudo -S cp -v $HOME/RetroRig/init-scripts/x360wd/blacklist.conf /etc/modprobe.d/ | tee -a install_log.txt

	# copy default gamepad setup for Xbox 360 Wireless (4-player)
	cp -v $HOME/RetroRig/controller-cfgs/x360wd/x360wd.lyt $HOME/.qjoypad3/ | tee -a install_log.txt

	# copy qjoypad autostart item for x360ws gamepad config
	echo $userpasswd | sudo -S cp -v $HOME/RetroRig/controller-cfgs/x360wd/qjoypad.desktop /etc/xdg/autostart/ | tee -a install_log.txt

}

# configuration function
function _configuration (){

	dialog --title "Confirm yes/no" \
	--backtitle "LibreGeek.org RetroRig Installer" \
	--yesno "Are you sure you want run the configuration setup? \
	This will* reset existing configurations!" 7 50
	 
	#  Get exit status
	#  0 means user hit [yes] button.
	#  1 means user hit [no] button.
	#  255 means user hit [Esc] key.
	response=$?
	case $response in
	   0) 
	   # dialog --infobox "Continuing..." 3 17
	   # continue on below
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
	# clear screen
	clear

	# Note for mkdir and some settings:
	# tee will only output/log if there is an error or the folder exists

	# disable screensaver, XBMC will manage this
	# export display to allow gsettings running in terminal window
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
	# setup skelton folders for XBMC Rom Collection Browser
	# ROMs
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
	mkdir -pv $HOME/Games/ROMs/Neo-Geo/AES/ | tee -a install_log.txt


	# Artwork 
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
	mkdir -pv $HOME/Games/Artwork/Neo-Geo/AES/ | tee -a install_log.txt

	# Saves (if any)
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
	mkdir -pv $HOME/Games/Saves/Neo-Geo/AES/ | tee -a install_log.txt

	# create dotfiles
	mkdir -pv $HOME/.qjoypad3/ | tee -a install_log.txt
	mkdir -pv $HOME/.config/mupen64plus/ | tee -a install_log.txt
	mkdir -pv $HOME/.mame/cfg/ | tee -a install_log.txt
	mkdir -pv $HOME/.stella/ | tee -a install_log.txt
	mkdir -pv $HOME/.xbmc/ | tee -a install_log.txt
	mkdir -pv $HOME/.mednafen/ | tee -a install_log.txt
	mkdir -pv $HOME/.mess/cfg | tee -a install_log.txt

	# BIOS file directories for users to load:
	mkdir -pv $HOME/Games/Neo-Geo/BIOS/ | tee -a install_log.txt
	

	# xbmc does not (at least for Ubuntu's repo pkg) load the
	# dot files without loading XBMC at least once
	# copy in default folder base from first run:	
	cp -Rv $HOME/RetroRig/XBMC-cfgs/* $HOME/.xbmc | tee -a install_log.txt

	# xboxdrv director located in common area for startup
	echo "echo $userpasswd | sudo -S needed to create common xboxdrv share!"
	echo $userpasswd | sudo -S mkdir -pv /usr/share/xboxdrv/ | tee -a install_log.txt

	# Tools
	mkdir -pv $HOME/Games/Tools/ | tee -a install_log.txt

	echo "-----------------------------------------------------------" |tee -a install_log.txt
	echo "Copy software configurations" | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	# configs
	mkdir -pv $HOME/Games/Configs/ | tee -a install_log.txt

	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "init scripts and post-configurations" | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt

	# add xbox controller init script
	echo "echo $userpasswd | sudo -S needed to create init scripts for xboxdrv!"

	# call modular function to select specific gamepad configuration for all environments
	_gamepad

	# call function to set resolution
	_resolution

	# clear screen after functions are called
	clear

	# create autostart for XBMC (universal)
	echo "sudo needed to create auto-start entries!"
	echo $userpasswd | sudo -S cp -v /usr/share/applications/xbmc.desktop /etc/xdg/autostart/ | tee -a install_log.txt

	# If x360ws xboxdrv config file does not pick up on reboot,
	# be sure to resync the wireless receiver!

	# set the system user to an absolute value.
	# RCB and some config files don't like using $HOME, rather /home/test/
	# Let's change the config files to reflect the current username
	sed -i "s|/home/mikeyd/|/home/$USER/|g" $HOME/.mame/mame.ini | tee -a install_log.txt
	sed -i "s|/home/mikeyd/|/home/$USER/|g" $HOME/.xbmc/userdata/addon_data/script.games.rom.collection.browser/config.xml | tee -a install_log.txt	
	echo "The user applied to configuration files was: $USER" |  tee -a install_log.txt

	# prompt user if they wish to pre-load ROMs now
	dialog --title "Confirm yes/no" \
	--backtitle "LibreGeek.org RetroRig Installer" \
	--yesno "Do you wish to load your ROMs now? (reccomended)" 5 52
	 
	#  Get exit status
	#  0 means user hit [yes] button.
	#  1 means user hit [no] button.
	#  255 means user hit [Esc] key.
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
	clear
	echo "-----------------------------------------------------------" |tee -a install_log.txt
	echo "Updating git repo" | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	sleep 2s
	cd $HOME/RetroRig/
	git pull
	# pause for reviewing changes
	sleep 5s
	
	# clear
	clear

	bash config-setup.sh
}

function _update-binaries () {
	clear
	echo "-----------------------------------------------------------" |tee -a install_log.txt
	echo "Updating emulator binaries" | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo $userpasswd | sudo -S apt-get install -y xboxdrv curl zsnes nestopia pcsxr pcsx2:i386 \
	python-software-properties pkg-config software-properties-common \
	mame mupen64plus dconf-tools mednafen qjoypad xbmc dolphin-emu-master stella \
	build-essential | tee -a install_log.txt	
	sleep 3s
	# clear
	clear
}

function _upgrade-system () {
	clear
	echo "-----------------------------------------------------------" |tee -a install_log.txt
	echo "Upgrading system" | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo $userpasswd | sudo -S apt-get update
	echo $userpasswd | sudo -S apt-get upgrade
	sleep 3s
	# clear
	clear
}

function _start-xbmc () {
	dialog --infobox "starting RetroRig" 3 21
	sleep 1s
	xbmc
	# clear
	clear
}

function _reboot () {
	# need to add reboot command to sudo to avoid pw prompt
	data=$(tempfile 2>/dev/null)
 
	#  trap it
	trap "rm -f $data" 0 1 2 5 15
	 
	#  get password with the --insecure option
	dialog --title "Enter password to confirm!" \
	--clear \
	--insecure \
	--passwordbox "Enter your user password" 7 28 2> $data
	 
	ret=$?
       # Exit status is subject to being overridden  by  environment  variables.
       # Normally they are:
       # 0    if dialog is exited by pressing the Yes or OK button.
       # 1    if the No or Cancel button is pressed.
       # 2    if the Help button is pressed.
       # 3    if the Extra button is pressed.
       # -1   if  errors occur inside dialog or dialog is exited by pressing the
       #      ESC key.

	case $ret in
	  0)
	    dialog --infobox "Rebooting PC" 3 0 ; sleep 2s
	    sleep 5s
	    echo $userpasswd | sudo -S /sbin/reboot
	    ;;
	  1)
	    dialog --infobox "Cancel Pressed" 3 18 ; sleep 2s
	    sleep 2s
	    ;;
	  255)
	    [ -s $data ] &&  cat $data || echo "ESC pressed.";;
	esac

}

function _uninstall () {

# clear screen
clear

echo "-----------------------------------------------------------" | tee -a uninstall_log.txt
echo "Removing RetroRig..." | tee -a install_log.txt
echo "-----------------------------------------------------------" | tee -a uninstall_log.txt

# remove installed binaries
# do not remove software-properties-common, necessary pkg!
echo $userpasswd | sudo -S apt-get autoremove -y xboxdrv curl  \
python-software-properties pkg-config mednafen \
mame mupen64plus dconf-tools qjoypad xbmc stella \
build-essential | tee -a uninstall_log.txt

# add apport, apport-gtk back
echo $userpasswd | sudo -S apt-get install -y apport apport-gtk | tee -a uninstall_log.txt

echo $userpasswd | sudo -S dpkg --remove-architecture i386 | tee -a uninstall_log.txt

echo "-----------------------------------------------------------" | tee -a uninstall_log.txt
echo "Cleaning up repositories..." | tee -a install_log.txt
echo "-----------------------------------------------------------" | tee -a uninstall_log.txt
# xbmc
echo $userpasswd | sudo add-apt-repository -ry ppa:team-xbmc/ppa | tee -a uninstall_log.txt

echo "-----------------------------------------------------------" | tee -a uninstall_log.txt
echo "Remove RetroRig config folders..." | tee -a install_log.txt
echo "-----------------------------------------------------------" | tee -a uninstall_log.txt

# ask to keep folders
# prompt user if they wish to keep folders from install
	dialog --title "Confirm yes/no" \
	--backtitle "LibreGeek.org RetroRig Installer" \
	--yesno "Do you wish to keep configuration folders?" 5 52
	 
	#  Get exit status
	#  0 means user hit [yes] button.
	#  1 means user hit [no] button.
	#  255 means user hit [Esc] key.
	response=$?
	case $response in

	0) 
	# keep folders
	sleep 2s
	;;

   	1) 
	# remove dotfiles
	echo $userpasswd | sudo rm -rf $HOME/.qjoypad3/ | tee -a uninstall_log.txt
	echo $userpasswd | sudo rm -rf $HOME/.config/mupen64plus/ | tee -a uninstall_log.txt
	echo $userpasswd | sudo rm -rf $HOME/.mame/ | tee -a uninstall_log.txt
	echo $userpasswd | sudo rm -rf $HOME/.stella/ | tee -a uninstall_log.txt
	echo $userpasswd | sudo rm -rf $HOME/.xbmc/ | tee -a uninstall_log.txt
	echo $userpasswd | sudo rm -rf $HOME/.mednafen/ | tee -a uninstall_log.txt

	echo "-----------------------------------------------------------" | tee -a uninstall_log.txt
	echo "Remove init scripts and post install files..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a uninstall_log.txt

	echo $userpasswd | sudo  rm -f /etc/xdg/autostart/qjoypad.desktop
	echo $userpasswd | sudo service xboxdrv stop | tee uninstall_log.txt
	echo $userpasswd | sudo update-rc.d -f xboxdrv remove
	echo $userpasswd | sudo rm -f /etc/init.d/xboxdrv
	echo $userpasswd | sudo rm -f /etc/default/xboxdrv
	sed -i 's|blacklist xpad||g' /etc/modprobe.d/blacklist.conf| tee -a install_log.txt
	   ;;

	255)
	# Keep folders"
	sleep 2s
	;;

	esac	

echo "-----------------------------------------------------------" | tee -a uninstall_log.txt
echo "Remove RetroRig ROM folders..." | tee -a install_log.txt
echo "-----------------------------------------------------------" | tee -a uninstall_log.txt

# ask to keep folders
# prompt user if they wish to keep ROMs they loaded
	dialog --title "Confirm yes/no" \
	--backtitle "LibreGeek.org RetroRig Installer" \
	--yesno "Do you wish to keep your ROMs?" 5 52
	 
	#  Get exit status
	#  0 means user hit [yes] button.
	#  1 means user hit [no] button.
	#  255 means user hit [Esc] key.
	response=$?
	case $response in

	0) 
	# Keep ROMs
	sleep 2s
	;;

   	1) 
	echo $userpasswd | sudo rm -rf $HOME/Games/ROMs/ | tee -a uninstall_log.txt
	echo $userpasswd | sudo rm -rf $HOME/Games/Tools/ | tee -a uninstall_log.txt
	echo $userpasswd | sudo rm -rf $HOME/Games/Artwork/ | tee -a uninstall_log.txt
	echo $userpasswd | sudo rm -rf $HOME/Games/Saves/ | tee -a uninstall_log.txt
	echo $userpasswd | sudo rm -rf $HOME/Games/Configs/ | tee -a uninstall_log.txt
	;;

	255)
	# Keep ROMs
	sleep 2s
	;;

	esac	

echo "-----------------------------------------------------------" | tee -a uninstall_log.txt
echo "Finishing uninstall..." | tee -a install_log.txt
echo "-----------------------------------------------------------" | tee -a uninstall_log.txt

# update Ubuntu repository listings
echo $userpasswd | sudo apt-get update | tee -a uninstall_log.txt
sleep 2s

}
# call main
_main
