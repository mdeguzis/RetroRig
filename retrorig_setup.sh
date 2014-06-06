#!/bin/bash
#
# RetroRig Main Setup Script
# This is a small script to copy over configuration files for emulators
# append a "-x" on the end above for debugging if need be
# Version 0.7.9
# Please report any errors via a pull request
# You can also reach me on twitter: @N3RD42
#


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
import "scriptmodules/menus"
import "scriptmodules/settings"
import "scriptmodules/setup"
import "scriptmodules/gamepads"           	

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

# if called with sudo ./retrorig_setup.sh, the installation directory is /home/CURRENTUSER/RetroRig for the current user
# if called with sudo ./retrorig_setup.sh USERNAME, the installation directory is /home/USERNAME/RetroRig for user USERNAME
# if called with sudo ./retrorig_setup.sh USERNAME ABSPATH, the installation directory is ABSPATH for user USERNAME
    
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
    chown $user "$scriptdir/logs"
    chgrp $user "$scriptdir/logs"
    if [[ ! -d $scriptdir/logs ]]; then
      echo "Couldn't make directory $scriptdir/logs"
      exit 1
    fi
fi

#check for pre-requisites, output to log folder
rrs_prereq

while true; do
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

	#make menu choice
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)    
    if [ "$choices" != "" ]; then
	case $choices in

	    1)  now=$(date +'%d%m%Y_%H%M%S')
		{
		rrs_software	
		} 2>&1 | tee >(gzip --stdout > $scriptdir/logs/install_$now.log.gz)	               	
		chown -R $user $scriptdir/logs/install_$now.log.gz
		chgrp -R $user $scriptdir/logs/install_$now.log.gz
		;;

	    2) 
		now=$(date +'%d%m%Y_%H%M%S')
		{
		cfg_confirm
		rrs_prepareFolders
		rrs_emu_configs
		m_gamepad
		set_resolution
		rrs_autostart
		} 2>&1 | tee >(gzip --stdout > $scriptdir/logs/install_$now.log.gz)	               	
		chown -R $user $scriptdir/logs/cfg_$now.log.gz
		chgrp -R $user $scriptdir/logs/cfg_$now.log.gz
		;;

	    3) 
		m_settings
		;;

	    4)
		h_update_git
		;;

	    5)
		now=$(date +'%d%m%Y_%H%M%S')
		{
		h_update_binaries
		} 2>&1 | tee >(gzip --stdout > $scriptdir/logs/update_$now.log.gz)	               	
		chown -R $user $scriptdir/logs/update_$now.log.gz
		chgrp -R $user $scriptdir/logs/update_$now.log.gz
		;;

	    6)
		now=$(date +'%d%m%Y_%H%M%S')
		{
		h_upgrade_system
		} 2>&1 | tee >(gzip --stdout > $scriptdir/logs/upgrade_$now.log.gz)	               	
		chown -R $user $scriptdir/logs/upgrade_$now.log.gz
		chgrp -R $user $scriptdir/logs/upgrade_$now.log.gz
		;;

	    7)
		h_start_xbmc
		;;

	    8) 
		rrs_reboot
		;;

	    9)
		now=$(date +'%d%m%Y_%H%M%S')
		{
		cfg_uninstall
		} 2>&1 | tee >(gzip --stdout > $scriptdir/logs/uninstall_$now.log.gz)	               	
		chown -R $user $scriptdir/logs/uninstall_$now.log.gz
		chgrp -R $user $scriptdir/logs/uninstall_$now.log.gz
		;;

	    10)
		;;

		esac
	else
		break
    fi
	done
clear
