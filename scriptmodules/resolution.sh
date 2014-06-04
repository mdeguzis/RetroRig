#!/bin/bash
#
# RetroRig main resolution module
# This is a small script to copy over configuration files for emulators
# append a "-x" on the end above for debugging if need be
# Please report any errors via a pull request
# You can also reach me on twitter: @N3RD42
#

function _resolution () {

#menu
#add res-switcher function to make new presets more modular to add
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
		#Need to use extended regexp's here because of nes being within nes
		#grep -Ee '\bnes\b' [list of files]

		#echo curent resolution
		#mupen64plus
		echo "mupen64plus:" > res.txt
		grep -Ee "\bScreenWidth = \b" $HOME/.config/mupen64plus/mupen64plus.cfg >> res.txt
		grep -Ee "\bScreenHeight = \b" $HOME/.config/mupen64plus/mupen64plus.cfg >> res.txt
		echo "" >> res.txt
		#Stella
		echo "Stella" >> res.txt
		grep -Ee "\bfullres = \b" $HOME/.stella/stellarc >> res.txt
		echo "" >> res.txt
		#mednafen GBC
		echo "Mednafen (GBC)" >> res.txt
		grep -Ee "\bgb.xres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		grep -Ee "\bgb.yres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		echo "" >> res.txt
		#mednafen GBA
		echo "Mednafen (GBA)" >> res.txt
		grep -Ee "\bgba.xres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		grep -Ee "\bgba.yres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		echo "" >> res.txt
		#mednafen Sega Sega Master System
		echo "Mednafen (Sega Master System)" >> res.txt
		grep -Ee "\bsms.xres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		grep -Ee "\bsms.yres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		echo "" >> res.txt
		#mednafen Sega Game Gear
		echo "Mednafen (Sega Game Gear)" >> res.txt
		grep -Ee "\bgg.xres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		grep -Ee "\bgg.yres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		echo "" >> res.txt
		#mednafen SNES
		echo "Mednafen (SNES)" >> res.txt
		grep -Ee "\bsnes.xres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		grep -Ee "\bsnes.yres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		echo "" >> res.txt
		#mednafen NES
		echo "Mednafen (NES)" >> res.txt
		grep -Ee "\bnes.xres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		grep -Ee "\bnes.yres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		echo "" >> res.txt
		#mednafen Turbographx 16
		echo "Mednafen (Turbographx 16)" >> res.txt
		grep -Ee "\bpce.xres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		grep -Ee "\bpce.yres\b" $HOME/.mednafen/mednafen-09x.cfg >> res.txt
		echo "" >> res.txt
		#report current resolution
		dialog --textbox res.txt 33 0
		#remove text file
		rm res.txt
		;;

	 2) 
		#setting chosen: "1280x720  (720p)  (5:4)"
		#set mupen64plus value
		m_new_X="1280"
		m_new_Y="720"
		#set mednafen (GBC) value
		gb_new_X="1280"
		gb_new_Y="720"
		#set mednafen (GBA) value
		gba_new_X="1280"
		gba_new_Y="1024"
		#set mednafen (NES) value
		nes_new_X="1280"
		nes_new_Y="720"
		#set mednafen (SNES) value
		snes_new_X="1280"
		snes_new_Y="720"
		#set mednafen (Sega Master System) value
		sms_new_X="1280"
		sms_new_Y="720"
		#set mednafen (Sega Game Gear) value
		gg_new_X="1280"
		gg_new_Y="720"
		#set mednafen (Turbographx 16) value
		pce_new_X="1280"
		pce_new_Y="720"
		#set stella (Atari 2600)
		st_new="1280x720"
		#call _res-swticher
		_res-swticher
		#return to menu
		return
		;;  
	 3) 
		#setting chosen: "1280x1024 (SXGA)  (5:4)"
		#set mupen64plus value
		m_new_X="1280"
		m_new_Y="1024"
		#set mednafen (GBC) value
		gb_new_X="1280"
		gb_new_Y="1024"
		#set mednafen (GBA) value
		gba_new_X="1280"
		gba_new_Y="1024"
		#set mednafen (NES) value
		nes_new_X="1280"
		nes_new_Y="1024"
		#set mednafen (SNES) value
		snes_new_X="1280"
		snes_new_Y="1024"
		#set mednafen (Sega Master System) value
		sms_new_X="1280"
		sms_new_Y="1024"
		#set mednafen (Sega Game Gear) value
		gg_new_X="1280"
		gg_new_Y="1024"
		#set mednafen (Turbographx 16) value
		pce_new_X="1280"
		pce_new_Y="1024"
		#set stella (Atari 2600)
		st_new="1280x1024"
		#call _res-swticher
		_res-swticher
		#return to menu
		return
		;;
	 4) 
		#setting chosen: "1366x768  (720p)  (16:9)"
		#set mupen64plus value
		m_new_X="1366"
		m_new_Y="768"
		#set mednafen (GBC) value
		gb_new_X="1366"
		gb_new_Y="768"
		#set mednafen (GBA) value
		gba_new_X="1366"
		gba_new_Y="768"
		#set mednafen (NES) value
		nes_new_X="1366"
		nes_new_Y="768"
		#set mednafen (SNES) value
		snes_new_X="1366"
		snes_new_Y="768"
		#set mednafen (Sega Master System) value
		sms_new_X="1366"
		sms_new_Y="768"
		#set mednafen (Sega Game Gear) value
		gg_new_X="1366"
		gg_new_Y="768"
		#set mednafen (Turbographx 16) value
		pce_new_X="1366"
		pce_new_Y="768"
		#set stella (Atari 2600)
		st_new="1366x768"
		#call _res-swticher
		_res-swticher
		#return to menu
		return
		;;
	 5) 
		#setting chosen: "1600x900  (900p)  (16:9)"
		#set mupen64plus value
		m_new_X="1600"
		m_new_Y="900"
		#set mednafen (GBC) value
		gb_new_X="1600"
		gb_new_Y="900"
		#set mednafen (GBA) value
		gba_new_X="1600"
		gba_new_Y="900"
		#set mednafen (NES) value
		nes_new_X="1600"
		nes_new_Y="900"
		#set mednafen (SNES) value
		snes_new_X="1600"
		snes_new_Y="900"
		#set mednafen (Sega Master System) value
		sms_new_X="1600"
		sms_new_Y="900"
		#set mednafen (Sega Game Gear) value
		gg_new_X="1600"
		gg_new_Y="900"
		#set mednafen (Turbographx 16) value
		pce_new_X="1600"
		pce_new_Y="900"
		#set stella (Atari 2600)
		st_new="1600x900"
		#call _res-swticher
		_res-swticher
		#return to menu
		return
		;;
	 6) 
		#setting chosen: "1920x1080 (1080p) (16:9)"
		#set mupen64plus value
		m_new_X="1920"
		m_new_Y="1080"
		#set mednafen (GBC) value
		gb_new_X="1920"
		gb_new_Y="1080"
		#set mednafen (GBA) value
		gba_new_X="1920"
		gba_new_Y="1080"
		#set mednafen (NES) value
		nes_new_X="1920"
		nes_new_Y="1080"
		#set mednafen (SNES) value
		snes_new_X="1920"
		snes_new_Y="1080"
		#set mednafen (Sega Master System) value
		sms_new_X="1920"
		sms_new_Y="1080"
		#set mednafen (Sega Game Gear) value
		gg_new_X="1920"
		gg_new_Y="1080"
		#set mednafen (Turbographx 16) value
		pce_new_X="1920"
		pce_new_Y="1080"
		#set stella (Atari 2600)
		st_new="1920x1080"
		#call _res-swticher
		_res-swticher
		#return to menu
		return
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
		#mednafen (GBC)
		gb_new_X=$(cat '/tmp/new_X')
		gb_new_Y=$(cat '/tmp/new_Y')
		#mednafen (GBA)
		gba_new_X=$(cat '/tmp/new_X')
		gba_new_Y=$(cat '/tmp/new_Y')
		#mednafen (NES)
		nes_new_X=$(cat '/tmp/new_X')
		nes_new_Y=$(cat '/tmp/new_Y')
		#mednafen (SNES)
		snes_new_X=$(cat '/tmp/new_X')
		snes_new_Y=$(cat '/tmp/new_Y')
		#mednafen (Sega Master System)
		sms_new_X=$(cat '/tmp/new_X')
		sms_new_Y=$(cat '/tmp/new_Y')
		#mednafen (Sega Game Gear)
		gg_new_X=$(cat '/tmp/new_X')
		gg_new_Y=$(cat '/tmp/new_Y')
		#mednafen (Turbographx 16)
		pce_new_X=$(cat '/tmp/new_X')
		pce_new_Y=$(cat '/tmp/new_Y')
		#set stella (Atari 2600)
		st1=$(cat '/tmp/new_X')
		stdelim=$('x')
		st2=$(cat '/tmp/new_Y')
		st_new=$($st1$stdelim$st2)

		#call _res-swticher
		_res-swticher
		#remove temp files
		rm -f /tmp/new_X
		rm -f /tmp/new_Y
		#return to menu
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

function _res-swticher (){
		clear
		dialog --infobox "Setting resolution to selection" 3 36
		#resolution is set via _resolution function		
		
		########################		
		#Stella
		########################
		st_org=$(grep -Ee "\bfullres = \b" $HOME/.stella/stellarc)
		#make the changes, prefix new_X in case NULL was entered previously
		sed -ie "s|$st_org|fullres = $st_new|g" $HOME/.stella/stellarc

		########################		
		#mupen64plus
		########################
		m_org_X=$(grep -Ee "\bScreenWidth = \b" $HOME/.config/mupen64plus/mupen64plus.cfg)
		m_org_Y=$(grep -Ee "\bScreenHeight = \b" $HOME/.config/mupen64plus/mupen64plus.cfg)
		#make the changes, prefix new_X in case NULL was entered previousey
		sed -ie "s|$m_org_X|ScreenWidth = $m_new_X|g" $HOME/.config/mupen64plus/mupen64plus.cfg
		sed -ie "s|$m_org_Y|ScreenHeight = $m_new_Y|g" $HOME/.config/mupen64plus/mupen64plus.cfg

		########################		
		#mednafen 
		######################## 

		#Emulator Codes:
		########################
		#Atari Lynx [lynx]
		#GameBoy (Color) [gb]
		#GameBoy Advance [gba]
		#Neo Geo Pocket (Color) [ngp]
		#Nintendo Entertainment System/Famicom [nes]
		#PC Engine (CD)/TurboGrafx 16 (CD)/SuperGrafx [pce]
		#PC Engine (CD)/TurboGrafx 16 (CD)/SuperGrafx [pce_fast]
		#PC-FX [pcfx]
		#Sega Game Gear [gg]
		#Sega Genesis/MegaDrive [md]
		#Sega Master System [sms]
		#Sony PlayStation [psx]
		#Super Nintendo Entertainment System/Super Famicom [snes]
		#Virtual Boy [vb]
		#WonderSwan [wswan]

		#Note: it should be noted that all emulators are set to stretch
		#the screen (EMU_CODE.stretch 1). The value is boolean.

		#Mednafen (GBC)
		gb_org_X=$(grep -Ee "\bgb.xres\b " $HOME/.mednafen/mednafen-09x.cfg)
		gb_org_Y=$(grep -Ee "\bgb.yres\b " $HOME/.mednafen/mednafen-09x.cfg)
		#make the changes, prefix new_X in case NULL was entered previously
		sed -ie "s|$gb_org_X|gb.xres $gb_new_X|g" $HOME/.mednafen/mednafen-09x.cfg
		sed -ie "s|$gb_org_Y|gb.yres $gb_new_Y|g" $HOME/.mednafen/mednafen-09x.cfg

		#Mednafen (NES)
		nes_org_X=$(grep -Ee "\bnes.xres\b " $HOME/.mednafen/mednafen-09x.cfg)
		nes_org_Y=$(grep -Ee "\bnes.yres\b " $HOME/.mednafen/mednafen-09x.cfg)
		#make the changes, prefix new_X in case NULL was entered previously
		sed -ie "s|$nes_org_X|nes.xres $nes_new_X|g" $HOME/.mednafen/mednafen-09x.cfg
		sed -ie "s|$nes_org_Y|nes.yres $nes_new_Y|g" $HOME/.mednafen/mednafen-09x.cfg

		#Mednafen (GameBoy Advance)
		gba_org_X=$(grep -Ee "\bgba.xres\b " $HOME/.mednafen/mednafen-09x.cfg)
		gba_org_Y=$(grep -Ee "\bgba.yres\b " $HOME/.mednafen/mednafen-09x.cfg)
		#make the changes, prefix new_X in case NULL was entered previously
		sed -ie "s|$gba_org_X|gba.xres $gba_new_X|g" $HOME/.mednafen/mednafen-09x.cfg
		sed -ie "s|$gba_org_Y|gba.yres $gba_new_Y|g" $HOME/.mednafen/mednafen-09x.cfg

		#Mednafen (SNES)
		snes_org_X=$(grep -Ee "\bsnes.xres\b " $HOME/.mednafen/mednafen-09x.cfg)
		snes_org_Y=$(grep -Ee "\bsnes.yres\b " $HOME/.mednafen/mednafen-09x.cfg)
		#make the changes, prefix new_X in case NULL was entered previously
		sed -ie "s|$snes_org_X|snes.xres $snes_new_X|g" $HOME/.mednafen/mednafen-09x.cfg
		sed -ie "s|$snes_org_Y|snes.yres $snes_new_Y|g" $HOME/.mednafen/mednafen-09x.cfg

		#Mednafen (Sega Master System, aka Sega Sega Master)
		sms_org_X=$(grep -Ee "\bsms.xres\b " $HOME/.mednafen/mednafen-09x.cfg)
		sms_org_Y=$(grep -Ee "\bsms.yres\b " $HOME/.mednafen/mednafen-09x.cfg)
		#make the changes, prefix new_X in case NULL was entered previously
		sed -ie "s|$sms_org_X|sms.xres $sms_new_X|g" $HOME/.mednafen/mednafen-09x.cfg
		sed -ie "s|$sms_org_Y|sms.yres $sms_new_Y|g" $HOME/.mednafen/mednafen-09x.cfg

		#Mednafen (Sega Gane Gear)
		sms_org_X=$(grep -Ee "\bsms.xres\b " $HOME/.mednafen/mednafen-09x.cfg)
		sms_org_Y=$(grep -Ee "\bsms.yres\b " $HOME/.mednafen/mednafen-09x.cfg)
		#make the changes, prefix new_X in case NULL was entered previously
		sed -ie "s|$sms_org_X|sms.xres $sms_new_X|g" $HOME/.mednafen/mednafen-09x.cfg
		sed -ie "s|$sms_org_Y|sms.yres $sms_new_Y|g" $HOME/.mednafen/mednafen-09x.cfg

		#Mednafen (Turbographx 16)
		gg_org_X=$(grep -Ee "\bgg.xres\b " $HOME/.mednafen/mednafen-09x.cfg)
		gg_org_Y=$(grep -Ee "\bgg.yres\b " $HOME/.mednafen/mednafen-09x.cfg)
		#make the changes, prefix new_X in case NULL was entered previously
		sed -ie "s|$gg_org_X|gg.xres $gg_new_X|g" $HOME/.mednafen/mednafen-09x.cfg
		sed -ie "s|$gg_org_Y|gg.yres $gg_new_Y|g" $HOME/.mednafen/mednafen-09x.cfg

		#For some reason, when I replace the resolutions, the config files are changed
		#They are appended with an "e" as in mednafen-09x.cfge. These "edited" files need
		#deleted. I will have to find out at some point why this occurs
		rm -f $HOME/.mednafen/mednafen-09x.cfge
		rm -f $HOME/.config/mupen64plus/mupen64plus.cfge
		rm -f $HOME/.pcsx/plugins/gpuPeopsMesaGL.cfge

}
