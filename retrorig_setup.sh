#!/bin/bash
#
# RetroRig Main Setup Script
# This is a small script to copy over configuration files for emulators
# append a "-x" on the end above for debugging if need be
# Version 0.7.9
# Please report any errors via a pull request
# You can also reach me on twitter: @N3RD42
#

# TESTING IRC BOT WITH THIS MESSAGE!

clear
#set up errmsgs and postmsgs
__ERRMSGS=""
__postMSGs=""

######################################
# Start Helper Functions
######################################

#set -o nounset

function getScriptAbsoluteDir() {
    # @description used to get the script path
    # @param $1 the script $0 parameter
    local script_invoke_path="$1"
    local cwd=$(pwd)

    # absolute path ? if so, the first character is a /
    if test "x${script_invoke_path:0:1}" = 'x/'
    then
	RESULT=$(dirname "$script_invoke_path")
    else
	RESULT=$(dirname "$cwd/$script_invoke_path")
    fi
}

function import() {
    
    # @description importer routine to get external functionality.
    # @description the first location searched is the script directory.
    # @description if not found, search the module in the paths contained in $SHELL_LIBRARY_PATH environment variable
    # @param $1 the .shinc file to import, without .shinc extension
    module=$1

    if test "x$module" == "x"
    then
	echo "$script_name : Unable to import unspecified module. Dying."
        exit 1
    fi

	if test "x${script_absolute_dir:-notset}" == "xnotset"
    then
	echo "$script_name : Undefined script absolute dir. Did you remove getScriptAbsoluteDir? Dying."
        exit 1
    fi

	if test "x$script_absolute_dir" == "x"
    then
	echo "$script_name : empty script path. Dying."
        exit 1
    fi

    if test -e "$script_absolute_dir/$module.shinc"
    then
        # import from script directory
        . "$script_absolute_dir/$module.shinc"
        echo "Loaded module $script_absolute_dir/$module.shinc"
        return
    elif test "x${SHELL_LIBRARY_PATH:-notset}" != "xnotset"
    then
        # import from the shell script library path
        # save the separator and use the ':' instead
        local saved_IFS="$IFS"
        IFS=':'
        for path in $SHELL_LIBRARY_PATH
        do
    if test -e "$path/$module.shinc"
            then
                . "$path/$module.shinc"
                return
    fi
done
        # restore the standard separator
        IFS="$saved_IFS"
    fi
    echo "$script_name : Unable to find module $module."
    exit 1
}


function loadConfig()
{
    # @description Routine for loading configuration files that contain key-value pairs in the format KEY="VALUE"
    # param $1 Path to the configuration file relate to this file.
    local configfile=$1
    if test -e "$script_absolute_dir/$configfile"
    then
        . "$script_absolute_dir/$configfile"
        echo "Loaded configuration file $script_absolute_dir/$configfile"
        return
    else
	echo "Unable to find configuration file $script_absolute_dir/$configfile"
        exit 1
    fi
}

script_invoke_path="$0"
script_name=$(basename "$0")
getScriptAbsoluteDir "$script_invoke_path"
script_absolute_dir=$RESULT

# load script modules

import "scriptmodules/helpers"
import "scriptmodules/configuration"
import "scriptmodules/settings"
import "scriptmodules/setup"
import "scriptmodules/gamepads"
import "scriptmodules/emulators"           	

######################################
# Start main script
######################################

scriptdir=$(dirname "$0")
scriptdir=$(cd "$scriptdir" && pwd)

if [[ "$1" == "--help" ]]; then
    rrs_showHelp
    exit 0
fi

if [ "$(id -u)" -ne 0 ]; then
    printf "Script must be run as root! Try:"
    echo ""
    echo ""
    printf "'sudo ./retrorig_setup'" 
    echo ""
    echo "OR"
    printf "'./retrorig_setup --help'"
    echo ""
    echo ""
    printf "for further information\n"
    exit 1
fi

# if called with sudo ./retrorig_setup.sh, the installation directory is /$HOME/CURRENTUSER/RetroRig for the current user
# if called with sudo ./retrorig_setup.sh USERNAME, the installation directory is /$HOME/USERNAME/RetroRig for user USERNAME
# if called with sudo ./retrorig_setup.sh USERNAME ABSPATH, the installation directory is ABSPATH for user USERNAME

# We need to set "$home" for two reasons:
# 1. $HOME is a system reserved var
# 2. This path is needed to copy the dotfile configuration to the "real" home folder.
    
if [[ $# -lt 1 ]]; then
    user=$SUDO_USER
    if [ -z "$user" ]
    then
        user=$(whoami)
    fi
    rootdir=/home/$user/RetroRig
elif [[ $# -lt 2 ]]; then
    user=$1
    rootdir=/home/$user/RetroRig
elif [[ $# -lt 3 ]]; then
    user=$1
    rootdir=$2
fi

if [[ $user == "root" ]]; then
echo "Please start the RetroRig Setup Script not as user 'root', but, e.g., as user 'pi'."
    exit
fi

esscrapimgw=275 # width in pixel for EmulationStation games scraper

home=$(eval echo ~$user)

# make sure that RetroRig root directory exists
if [[ ! -d $rootdir ]]; then
    mkdir -p "$rootdir"
    if [[ ! -d $rootdir ]]; then
      echo "Couldn't make directory $rootdir"
      exit 1
    fi
fi

# make sure that RetroRig-Setup log directory exists
if [[ ! -d $scriptdir/logs ]]; then
    mkdir -p "$scriptdir/logs"
    chown "$user" "$scriptdir/logs"
    chgrp "$user" "$scriptdir/logs"
    if [[ ! -d $scriptdir/logs ]]; then
      echo "Couldn't make directory $scriptdir/logs"
      exit 1
    fi
fi

# check for pre-requisites, output to log folder
rrs_prereq

# Show lame logo (take this out?)
# subtitle 1
clear
COLUMNS=$(tput cols) 
title1="Welcome To" 
printf "%*s\n" $(((${#title1}+$COLUMNS)/2)) "$title1"
figlet -c "_.= RetroRig=._"
echo ""
# subtitle 2
COLUMNS=$(tput cols) 
title2="www.libregeek.org" 
printf "%*s\n" $(((${#title2}+$COLUMNS)/2)) "$title2"
sleep 5s


while true; do
    cmd=(dialog --backtitle "LibreGeek.org RetroRig Installer" --menu "| Main Menu | \
 			 Any required BIOS files are NOT provided!" 17 62 16)
    options=(1 "Install RetroRig" 
	     2 "Retro Rig Settings" 
	     3 "Pull latest files from git" 
	     4 "Update emulator binaries" 
	     5 "Upgrade System (use with caution!)" 
	     6 "Reboot PC"
	     7 "Uninstall RetroRig"  
	     8 "Exit")

	#make menu choice
	# Expanding arrays involves [@] and {}
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)    
    if [ "$choices" != "" ]; then
	case $choices in

	    1) 
		now=$(date +'%d%m%Y_%H%M%S')
		{
		h_autosave_configs
		rrs_prepareFolders
		rrs_software
		rrs_emulators
		rrs_xbmc
		rrs_gamepad
		h_emu_user_fixes
		set_resolution
		rrs_unity
		rrs_done
		} 2>&1 | tee >(gzip --stdout > $scriptdir/logs/install_$now.log.gz)              	
		chown -R "$user" "$scriptdir/logs/install_$now.log.gz"
		chgrp -R "$user" "$scriptdir/logs/install_$now.log.gz"
		;;

	    2) 
		set_menu
		;;

	    3)
		h_update_git
		;;

	    4)
		now=$(date +'%d%m%Y_%H%M%S')
		{
		h_update_system
		} 2>&1 | tee >(gzip --stdout > $scriptdir/logs/update_$now.log.gz)              	
		chown -R "$user" "$scriptdir/logs/update_$now.log.gz"
		chgrp -R "$user" "$scriptdir/logs/update_$now.log.gz"
		;;

	    5)
		now=$(date +'%d%m%Y_%H%M%S')
		{
		h_upgrade_system
		} 2>&1 | tee >(gzip --stdout > "$scriptdir/logs/upgrade_$now.log.gz")	               	
		chown -R "$user" "$scriptdir/logs/upgrade_$now.log.gz"
		chgrp -R "$user" "$scriptdir/logs/upgrade_$now.log.gz"
		;;

	    6) 
		rrs_reboot
		;;

	    7)
		now=$(date +'%d%m%Y_%H%M%S')
		{
		cfg_uninstall
		} 2>&1 | tee >(gzip --stdout > "$scriptdir/logs/uninstall_$now.log.gz")               	
		chown -R "$user" "$scriptdir/logs/uninstall_$now.log.gz"
		chgrp -R "$user" "$scriptdir/logs/uninstall_$now.log.gz"
		;;

	    8) 
		clear
		exit
		;;

	    255)
		# Next two lines for debugging only	
	   	# dialog --infobox "Esc hit..." 3 14
	   	# sleep 1s
		;;

		esac
	else
		# Next two lines for debugging only	
		# dialog --infobox "cancel hit" 3 14
		# sleep 1s
		break
    fi
	done
clear

