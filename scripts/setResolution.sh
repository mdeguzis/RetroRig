#!/bin/bash

########################################################################
# file        :     setResolution.sh
# date        :     14/08/31
# author      :     jc
# description :     Take resoltuion arguments and display name from
#                   command line and configure emulators accordingly.
#
#                   This will only be executed, if parameter
#                   "auto resolution" is set in the configuration
#                   file.
#
#                   In general, a line in the configuration file looks
#                   like this:
#
#                   parameter name, parameter value
#
########################################################################

###############################################
#
# source function modules:
#
# Calculate path of script modules firstly,
# then load them.
#
###############################################

# name of this script
thisScript=$0

# test, if command line path to this script
# contains folder name "scripts"
if [[ $thisScript == *scripts/setResolution.sh* ]]
then

  # this script has been called 
  # outside of folder "scripts"
  
  # remove last 24 chars = "scripts/setResolution.sh"
  path=${thisScript:0:-24}  

  # configuration module path relative to RetoRigs base directory
  relativePath="scriptmodules/configuration.shinc"

  #set up configuration module path
  configurationModule=$path$relativePath
  
  # helpers module path relative to RetoRigs base directory
  relativePath="scriptmodules/helpers.shinc"
  
  #set up helpers module path
  helpersModule=$path$relativePath

else

  # this script has been called 
  # within folder "scripts"

  #set up configuration module path
  configurationModule="../scriptmodules/configuration.shinc"
  
  #set up helpers module path
  helpersModule="../scriptmodules/helpers.shinc"

fi

#load function modules
source $configurationModule
source $helpersModule

#HOME is set in /usr/share/applications/startXBMC.sh
config_home=$HOME

#define configuration file
configFile="$config_home/retrorig.cfg"

if parameterIsTrue "auto resolution"; then

  #echo "auto resolution is enabled, setting emulator configurations to" $1 "by" "$2" ". Display name is $3."
  
  #set new resolution for emulators
  
  # mupen64plus
  m_new_X=$1
  m_new_Y=$2
  
  # mednafen (GBC)
  gb_new_X=$1
  gb_new_Y=$2
  
  # mednafen (GBA)
  gba_new_X=$1
  gba_new_Y=$2
  
  # mednafen (NES)
  nes_new_X=$1
  nes_new_Y=$2
  
  # mednafen (SNES)
  snes_new_X=$1
  snes_new_Y=$2
  
  # mednafen (Sega Master System)
  sms_new_X=$1
  sms_new_Y=$2
  
  # mednafen (Sega Game Gear)
  gg_new_X=$1
  gg_new_Y=$2
  
  # mednafen (Turbographx 16)
  pce_new_X=$1
  pce_new_Y=$2
  
  # mednafen (PSX)
  psx_new_X=$1
  psx_new_Y=$2
  
  # pcsx (PS2)
  ps2_new_X=$1
  ps2_new_Y=$2

  # dolphin
  dolphin_new_X=$1
  dolphin_new_Y=$2
  dolphin_monitor=$3

  # Gens/GS (Sega CD/32X)
  gens_new_X=$1
  gens_new_X=$2
  
  ########################		
  #mupen64plus
  ########################
  m_org_X=$(grep -Ee "\bScreenWidth = \b" "$config_home/.config/mupen64plus/mupen64plus.cfg")
  m_org_Y=$(grep -Ee "\bScreenHeight = \b" "$config_home/.config/mupen64plus/mupen64plus.cfg")
  #make the changes, prefix new_X in case NULL was entered previousey
  sed -i "s|$m_org_X|ScreenWidth = $m_new_X|g" "$config_home/.config/mupen64plus/mupen64plus.cfg"
  sed -i "s|$m_org_Y|ScreenHeight = $m_new_Y|g" "$config_home/.config/mupen64plus/mupen64plus.cfg"

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

  #Note: it should be noted that all emulators are set to aspect ratios
  #the screen (EMU_CODE.aspect. See the wiki for more

  #Mednafen (GBC)
  gb_org_X=$(grep -Ee "\bgb.xres\b " "$config_home/.mednafen/mednafen-09x.cfg")
  gb_org_Y=$(grep -Ee "\bgb.yres\b " "$config_home/.mednafen/mednafen-09x.cfg")
  #make the changes, prefix new_X in case NULL was entered previously
  sed -i "s|$gb_org_X|gb.xres $gb_new_X|g" "$config_home/.mednafen/mednafen-09x.cfg"
  sed -i "s|$gb_org_Y|gb.yres $gb_new_Y|g" "$config_home/.mednafen/mednafen-09x.cfg"

  #Mednafen (NES)
  nes_org_X=$(grep -Ee "\bnes.xres\b " "$config_home/.mednafen/mednafen-09x.cfg")
  nes_org_Y=$(grep -Ee "\bnes.yres\b " "$config_home/.mednafen/mednafen-09x.cfg")
  #make the changes, prefix new_X in case NULL was entered previously
  sed -i "s|$nes_org_X|nes.xres $nes_new_X|g" "$config_home/.mednafen/mednafen-09x.cfg"
  sed -i "s|$nes_org_Y|nes.yres $nes_new_Y|g" "$config_home/.mednafen/mednafen-09x.cfg"

  #Mednafen (GameBoy Advance)
  gba_org_X=$(grep -Ee "\bgba.xres\b " "$config_home/.mednafen/mednafen-09x.cfg")
  gba_org_Y=$(grep -Ee "\bgba.yres\b " "$config_home/.mednafen/mednafen-09x.cfg")
  #make the changes, prefix new_X in case NULL was entered previously
  sed -i "s|$gba_org_X|gba.xres $gba_new_X|g" "$config_home/.mednafen/mednafen-09x.cfg"
  sed -i "s|$gba_org_Y|gba.yres $gba_new_Y|g" "$config_home/.mednafen/mednafen-09x.cfg"

  #Mednafen (SNES)
  snes_org_X=$(grep -Ee "\bsnes.xres\b " "$config_home/.mednafen/mednafen-09x.cfg")
  snes_org_Y=$(grep -Ee "\bsnes.yres\b " "$config_home/.mednafen/mednafen-09x.cfg")
  #make the changes, prefix new_X in case NULL was entered previously
  sed -i "s|$snes_org_X|snes.xres $snes_new_X|g" "$config_home/.mednafen/mednafen-09x.cfg"
  sed -i "s|$snes_org_Y|snes.yres $snes_new_Y|g" "$config_home/.mednafen/mednafen-09x.cfg"

  #Mednafen (Sega Master System, aka Sega Sega Master)
  sms_org_X=$(grep -Ee "\bsms.xres\b " "$config_home/.mednafen/mednafen-09x.cfg")
  sms_org_Y=$(grep -Ee "\bsms.yres\b " "$config_home/.mednafen/mednafen-09x.cfg")
  #make the changes, prefix new_X in case NULL was entered previously
  sed -i "s|$sms_org_X|sms.xres $sms_new_X|g" "$config_home/.mednafen/mednafen-09x.cfg"
  sed -i "s|$sms_org_Y|sms.yres $sms_new_Y|g" "$config_home/.mednafen/mednafen-09x.cfg"

  #Mednafen (Sega Game Gear)
  gg_org_X=$(grep -Ee "\bgg.xres\b " "$config_home/.mednafen/mednafen-09x.cfg")
  gg_org_Y=$(grep -Ee "\bgg.yres\b " "$config_home/.mednafen/mednafen-09x.cfg")
  #make the changes, prefix new_X in case NULL was entered previously
  sed -i "s|$gg_org_X|gg.xres $gg_new_X|g" "$config_home/.mednafen/mednafen-09x.cfg"
  sed -i "s|$gg_org_Y|gg.yres $gg_new_Y|g" "$config_home/.mednafen/mednafen-09x.cfg"

  #Mednafen (Turbographx 16)
  pce_org_X=$(grep -Ee "\bpce.xres\b " "$config_home/.mednafen/mednafen-09x.cfg")
  pce_org_Y=$(grep -Ee "\bpce.yres\b " "$config_home/.mednafen/mednafen-09x.cfg")
  #make the changes, prefix new_X in case NULL was entered previously
  sed -i "s|$pce_org_X|pce.xres $pce_new_X|g" "$config_home/.mednafen/mednafen-09x.cfg"
  sed -i "s|$pce_org_Y|pce.yres $pce_new_Y|g" "$config_home/.mednafen/mednafen-09x.cfg"

  #Mednafen (PSX)
  psx_org_X=$(grep -Ee "\bpsx.xres\b " "$config_home/.mednafen/mednafen-09x.cfg")
  psx_org_Y=$(grep -Ee "\bpsx.yres\b " "$config_home/.mednafen/mednafen-09x.cfg")
  #make the changes, prefix new_X in case NULL was entered previously
  sed -i "s|$psx_org_X|psx.xres $psx_new_X|g" "$config_home/.mednafen/mednafen-09x.cfg"
  sed -i "s|$psx_org_Y|psx.yres $psx_new_Y|g" "$config_home/.mednafen/mednafen-09x.cfg"

  # Gens GS (Sega CD)
  gens_org_X=$(grep -Ee "\bOpenGL Width=\b" "/home/test/.retrorig/.gens/gens.cfg")
  gens_org_Y=$(grep -Ee "\bOpenGL Height=\b" "/home/test/.retrorig/.gens/gens.cfg")
  #make the changes, prefix new_X in case NULL was entered previously
  sed -i "s|$gens_org_X|OpenGL Width= $gens_new_X|g" "$config_home/.mednafen/mednafen-09x.cfg"
  sed -i "s|$gens_org_Y|OpenGL Height= $gens_new_Y|g" "$config_home/.mednafen/mednafen-09x.cfg"

  ########################    
  # pcsx2
  ########################
  ps2_org_X=$(grep -Ee "\bresx = \b" "$config_home/.config/pcsx2/inis/GSdx.ini")
  ps2_org_Y=$(grep -Ee "\bresy = \b" "$config_home/.config/pcsx2/inis/GSdx.ini")
  #make the changes, prefix new_X in case NULL was entered previously

  if [ -n "$ps2_org_X" ]; then
    sed -i "s|$ps2_org_X|resx = $ps2_new_X|g" "$config_home/.config/pcsx2/inis/GSdx.ini"  
  fi
  
  if [ -n "$ps2_org_Y" ]; then
    sed -i "s|$ps2_org_Y|resy = $ps2_new_Y|g" "$config_home/.config/pcsx2/inis/GSdx.ini"
  fi

  #dolphin (gamecube)
  #old resolution
  dolphin_org_Res=$(grep -Ee "FullscreenResolution = " "$config_home/.dolphin-emu/Config/Dolphin.ini")
  #new resolution
  dolphin_new_Res="FullscreenResolution = $dolphin_monitor"": ""$dolphin_new_X""x""$dolphin_new_Y"
  #apply changes
  sed -i "s|$dolphin_org_Res|$dolphin_new_Res|g" "$config_home/.dolphin-emu/Config/Dolphin.ini"  
  
else
  echo "auto resolution is disabled, exiting"
fi
