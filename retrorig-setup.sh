#!/bin/bash
############################################################################
# RetroRig Main Setup Script
# This is a small script to copy over configuration files for emulators
# append a "-x" on the end above for debugging if need be
# Version 0.9.7
#
# Note: Syscalls are now abstracted!
# Please see syscalls-<pkg_mgr>.shinc for more.
#
# Please report any errors via a pull request
# You can also reach me on twitter: @N3RD42
#
############################################################################

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

    if [ -f $module.shinc ]; then
      source $module.shinc
      echo "Loaded module $(basename $module.shinc)"
      return
    fi

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
    echo "$script_name : Unable to find module $module"
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

########################################################################
#
#  setDesktopEnvironment()
#  
#  Arguments:    Desktop folder identifier used in 
#                Unity/Gnome/Cinnamonin/Deepin Desktop ~/.config/user-dirs.dirs. 
#  
#  Description:  The command to set a folder variable is already 
#                contained in ~/.config/user-dirs.dirs. For example:
#
#                XDG_DOWNLOAD_DIR="$HOME/Downloads"
#
#                This script filters the related line and
#                sets the corresponding variable with lower 
#                case letters:
#
#                xdg_download_dir=/home/username/Downloads
#
########################################################################

function setDesktopEnvironment()
{

  arg_upper_case=$1
  arg_lower_case=`echo $1|tr '[:upper:]' '[:lower:]'`
  XDG_DIR="XDG_"$arg_upper_case"_DIR"
  xdg_dir="xdg_"$arg_lower_case"_dir"

  setDir=`cat $home/.config/user-dirs.dirs | grep $XDG_DIR| sed s/$XDG_DIR/$xdg_dir/|sed s/HOME/home/`
  target=`echo $setDir| cut -f 2 -d "="| sed s,'$home',$home,`

  checkValid=`echo $setDir|grep $xdg_dir=\"|grep home/`
 
  if [ -n "$checkValid" ]; then
    eval "$setDir"

  else

    echo "local desktop setting" $XDG_DIR "not found"
 
  fi
}

script_invoke_path="$0"
script_name=$(basename "$0")
getScriptAbsoluteDir "$script_invoke_path"
script_absolute_dir=$RESULT

if [ "$script_invoke_path" == "/usr/bin/retrorig-setup" ]; then

	#install method via system folder
	
	scriptdir=/usr/share/RetroRig
	
else

	#install method from local git clone
	
	scriptdir=`dirname "$script_absolute_dir"`
	
fi

# load script modules
echo "#####################################################"
echo "Loading script modules"
echo "#####################################################"

import "$scriptdir/scriptmodules/helpers"
import "$scriptdir/scriptmodules/configuration"
import "$scriptdir/scriptmodules/settings"
import "$scriptdir/scriptmodules/setup"
import "$scriptdir/scriptmodules/gamepads"
import "$scriptdir/scriptmodules/emulators"

# DEBUG ONLY!
# Remove the below comment to double check all modules load
# sleep 10s

echo "#####################################################"
echo "Checking compatibility"
echo "#####################################################"

# Discover platform
rrs_discover_distro

# Source the correct distro/plaform for syscalls
rrs_source_syscalls

######################################
# Start main script
######################################

if [[ "$1" == "--help" ]]; then
    rrs_showHelp
    exit 0
fi

if [ "$(id -u)" -ne 0 ]; then
    printf "Script must be run as root! Try:"
    echo ""
    echo ""
    printf "'sudo retrorig-setup'" 
    echo ""
    echo "OR (for a git cloned version of RetroRig in its base directory)"
    printf "'sudo ./retrorig-setup.sh'" 
    echo ""
    echo "OR "
    printf "'retrorig-setup --help'"
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
# 2. This path is needs to copy the dotfile configuration to the "real" home folder.
    
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

home=$(eval echo ~$user)

#################################################################
#
# *** Setting up local desktop folder structure ***
#
# Example for German Desktop:
#
# setup $xdg_desktop_dir to "/home/username/Schreibtisch"
# setup $xdg_download_dir to "/home/username/Downloads"
# setup $xdg_templates_dir to "/home/username/Vorlagen"
# setup $xdg_publicshare_dir to "/home/username/Öffentlich"
# setup $xdg_documents_dir to "/home/username/Dokumente"
# setup $xdg_music_dir to "/home/username/Musik"
# setup $xdg_pictures_dir to "/home/username/Bilder"
# setup $xdg_videos_dir to "/home/username/Videos"
#
#################################################################

setDesktopEnvironment DESKTOP
setDesktopEnvironment DOWNLOAD
setDesktopEnvironment TEMPLATES
setDesktopEnvironment PUBLICSHARE
setDesktopEnvironment DOCUMENTS
setDesktopEnvironment MUSIC
setDesktopEnvironment PICTURES
setDesktopEnvironment VIDEOS

#################################################################


#################################################################
# Pre-configuration
# 
# as show the banner. Pre-reqs are checked and ammened if 
# possible.
#
#################################################################


# make sure that RetroRig root directory exists
if [[ ! -d $rootdir ]]; then
    mkdir -p "$rootdir"
    chown $user:$user "$rootdir"
    chgrp "$user" "$rootdir"
    if [[ ! -d $rootdir ]]; then
      echo "Couldn't make directory $rootdir"
      exit 1
    fi
fi

# make sure that RetroRig-Setup log directory exists
if [[ ! -d $rootdir/logs ]]; then
    mkdir -p "$rootdir/logs"
    chown "$user" "$rootdir/logs"
    chgrp "$user" "$rootdir/logs"
    if [[ ! -d $rootdir/logs ]]; then
      echo "Couldn't make directory $rootdir/logs"
      exit 1
    fi
fi

# check for pre-requisites, output to log folder
rrs_prereq

# Show lame logo
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
sleep 2s

# set the directory '$home/.retrorig' as a variable for easy reading
xbmc_home="$home/.retrorig/.xbmc"

# set config_home for all the dotfiles that need copied down for emulators
# and other utilities
config_home="$home/.retrorig"

#set RetroRig configuration file
configFile=$config_home/retrorig.cfg

cd "$rootdir"

#################################################################

while true; do
    cmd=(dialog --backtitle "LibreGeek.org RetroRig 
Installer" --menu "| Main Menu (v.0.9.8) | \
 			 BIOS files are NOT provided!" 17 62 16)
    options=(1 "Install RetroRig" 
	     2 "Retro Rig Settings" 
	     3 "Pull latest files from git" 
	     4 "Update emulator binaries"
	     5 "Update XBMC" 
	     6 "Update System"
	     7 "Upgrade System (Use with caution)"  
	     8 "Reboot PC"
	     9 "Uninstall RetroRig"  
	     10 "Exit")

	#make menu choice
	# Expanding arrays involves [@] and {}
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)    
    if [ "$choices" != "" ]; then
	case $choices in

	    1) 
		now=$(date +'%d%m%Y_%H%M%S')
		h_autosave_configs | tee $rootdir/logs/install_$now.log.txt
		rrs_prepareFolders | tee $rootdir/logs/install_$now.log.txt
		rrs_software | tee $rootdir/logs/install_$now.log.txt
		rrs_emulators | tee $rootdir/logs/install_$now.log.txt
		rrs_retrorig_cfgs | tee $rootdir/logs/install_$now.log.txt
		rrs_xbmc_cfgs | tee $rootdir/logs/install_$now.log.txt
		rrs_gamepad | tee $rootdir/logs/install_$now.log.txt
		h_emu_user_fixes | tee $rootdir/logs/install_$now.log.txt
		set_resolution | tee $rootdir/logs/install_$now.log.txt
		rrs_post_install | tee $rootdir/logs/install_$now.log.txt
		rrs_debug | tee $rootdir/logs/install_$now.log.txt
		rrs_done | tee $rootdir/logs/install_$now.log.txt
		# clean and fixup log file
		tr -cd '\11\12\15\40-\176' < "$rootdir/logs/temp_log.txt" > "$rootdir/logs/install_$now.log.txt"              	
		chown -R "$user" "$rootdir/logs/install_$now.log.txt"
		chgrp -R "$user" "$rootdir/logs/install_$now.log.txt"

		kernelUpdate=`cat $rootdir/logs/kernelUpdate`
		rm -f "$rootdir/logs/kernelUpdate"
		if [ "$kernelUpdate" == "true" ]; then
		  rrs_reboot
		fi

		;;

	    2) 
		set_menu
		;;

	    3)
		h_update_git
		;;

	    4)
		rrs_emulators
		;;
	    5)
		rrs_xbmc_patched
		;;

	    6)
		h_update_system
		;;

	    7)
		h_upgrade_system
		;;

	    8) 
		rrs_reboot
		;;

	    9)
		cfg_uninstall
		;;

	    10) 
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


