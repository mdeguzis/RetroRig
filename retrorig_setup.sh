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
    local cwd=`pwd`

    # absolute path ? if so, the first character is a /
    if test "x${script_invoke_path:0:1}" = 'x/'
    then
	RESULT=`dirname "$script_invoke_path"`
    else
	RESULT=`dirname "$cwd/$script_invoke_path"`
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
script_name=`basename "$0"`
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

scriptdir=`dirname $0`
scriptdir=`cd $scriptdir && pwd`

#check for pre-requisites
rrs_prereq

if [[ "$1" == "--help" ]]; then
    rrs_showHelp
    exit 0
fi

if [ $(id -u) -ne 0 ]; then
    printf "Script must be run as root. Try 'sudo ./retropie_setup' or ./retropie_setup --help for further information\n"
    exit 1
fi

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
	#functions

	if [ "$choices" != "10" ]; then
		case $choices in

		1)  	
		_software
		#call memu rather than return so user can choose again
		_main
		;;

		2)  
		bash scriptmodules/configuration.sh
		#call memu rather than return so user can choose again
		_main 
		;;

		3)
		bash scriptmodules/settings.sh
		#call memu rather than return so user can choose again
		_main
		;;

		4)
		_update-git
		#reload script with changes
		bash config-setup.sh
		;;

		5)
		_update-binaries
		#call memu rather than return so user can choose again
		_main
		;;

		6)
		_upgrade-system
		#call memu rather than return so user can choose again
		_main
		;;

		7)
		_start-xbmc
		#call memu rather than return so user can choose again
		_main
		;;

		8)
		_reboot
		#call memu rather than return so user can choose again
		_main
		;;

		9)
		#confirm uninstall is the intended action
		dialog --title "Confirm yes/no" \
		--backtitle "LibreGeek.org RetroRig Installer" \
		--yesno "Are you sure you want remove RetroRig?"  6 0

		# Get exit status
		# 0 means user hit [yes] button.
		# 1 means user hit [no] button.
		# 255 means user hit [Esc] key.
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

		#call memu rather than return so user can choose again
		_main
		;;

		10)
		clear
		exit
		;;

		esac
	else
		break
	fi
done
}
