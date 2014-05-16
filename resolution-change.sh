#!/bin/bash
#
#submenu script to change the resolution
#Version 0.6
#Please report any errors via a pull request
#
#
clear

#note: The shell is responsible for expanding variables. If you use single quotes 
#for strings, the contents will be treated literally, so sed now tries to replace
#every occurrence of the literal $var. use double quotes Use double quotes to 
#make the shell expand variables while keeping whitespace.

#insert new sub menu for resolution changes and other things


#testing only
#echo "old"
#echo $m_org_X
#echo $m_org_Y
#echo "new"
#echo $m_new_X
#echo $m_new_Y
#sleep 3s

#menu
while true; do
cmd=(dialog --backtitle "RetroRig Settings" --menu "Choose your option(s)" 16 76 16)
options=(1 "Current Resolution"
	 2 "1366x768 (720p)"
	 3 "Custom"
	 4 "Back to main menu"
	)
     
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
if [ "$choices" != "" ]; then
    case $choices in

	 1) 
	    clear
	    #report current resolution
	    echo "current resolutions are:"
	    echo ""
	    #mupen64plus
	    echo "mupen64plus:"
	    grep -i "ScreenWidth = " $HOME/.config/mupen64plus/mupen64plus.cfg
	    grep -i "ScreenHeight = " $HOME/.config/mupen64plus/mupen64plus.cfg
	    sleep 5s
            ;; 
      
	 2) 
	    clear
	    echo "Setting resolution to 1360x768 (720p)"
	    #mupen64plus
	    m_org_X=$(grep -i "ScreenWidth = " $HOME/.config/mupen64plus/mupen64plus.cfg)
	    m_org_Y=$(grep -i "ScreenHeight = " $HOME/.config/mupen64plus/mupen64plus.cfg)

            #set new resolution(s) from configs
	    m_new_X="ScreenWidth = 1366"
	    m_new_Y="ScreenHeight = 768"

	    #make the changes
	    #mupen64plus
	    echo "Changing mupen resolution to 720p"
	    sed -i "s|$m_org_X|$m_new_X|g" $HOME/.config/mupen64plus/mupen64plus.cfg
	    sed -i "s|$m_org_Y|$m_new_Y|g" $HOME/.config/mupen64plus/mupen64plus.cfg 
            ;; 

	 3) 
	    clear
	    echo "Setting resolution from user input"

	    #mupen64plus
	    m_org_X=$(grep -i "ScreenWidth = " $HOME/.config/mupen64plus/mupen64plus.cfg)
	    m_org_Y=$(grep -i "ScreenHeight = " $HOME/.config/mupen64plus/mupen64plus.cfg)

            #set new resolution(s) from user input
	    sleep 2s
	    echo -e "Set Width in X: \c"
	    read m_new_X
	    echo -e "Set Height in Y: \c"
	    read m_new_Y
	    #set new resolution(s) from configs
	    m_new_X="ScreenWidth = $m_new_X"
	    m_new_Y="ScreenHeight = $m_new_Y"

	    #make the changes
	    #mupen64plus
	    echo "Changing mupen resolution to 720p"
	    sed -i "s|$m_org_X|$m_new_X|g" $HOME/.config/mupen64plus/mupen64plus.cfg
	    sed -i "s|$m_org_Y|$m_new_Y|g" $HOME/.config/mupen64plus/mupen64plus.cfg 
            ;; 


	 4) 

	   return
	   ;;

	 esac
     else
	 break
fi
done
clear
