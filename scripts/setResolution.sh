#!/bin/bash

########################################################################
# file        :     setResolution.sh
# date        :     14/10/18
# author      :     jc
# changelog   :     removed dependency from scriptmodules
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



########################################################################
#
# Functions to handle configuration file
#
# Description :   A line in the configuration file looks like this:
#
#                 parameter name, parameter value
#
########################################################################


########################################################################
#
#  parameterIsTrue()
#  
#  Arguments:    boolean parameter 
#  
#  Description:  Test if boolean parameter is true. 
#
#                A parameter is defined by a text string before the 
#                comma delimeter in the configuration file.
#
#                A boolean parameter can be "true" or "false".
#
########################################################################

function parameterIsTrue()
{
  VAR=`grep "$1" $configFile |cut -f 2 -d ','|grep true`

  if [ -n "$VAR" ]; then
    #VAR is not empty, return true
    return 0
  else
    #return false
    return 1
  fi
}

########################################################################
#
#  setParameter()
#  
#  Arguments:    parameter name, parameter value 
#  
#  Description:  Append new line at the end of the config file, 
#                if new parameter.
#
#                Exchange parameter value, if existing.
#
########################################################################


function setParameter()
{
  #echo "setParameter $1, $2"
  newLine="$1, $2"

  oldLine=`grep "$1" $configFile`
  if [ $? -eq 0 ]; then  
    sed -i "s|$oldLine|$newLine|g" $configFile
  else  
    echo "$newLine" >> $configFile
  fi

}

########################################################################
#
#  getParameter()
#  
#  Arguments:    parameter name
#  
#  Return:       parameter value
#
########################################################################


function getParameter()
{

  VAR=`grep "$1" $configFile |cut -f 2 -d ','`

  echo $VAR

}

###############################################
#
#						main function module
#
###############################################


#HOME is set in /usr/share/applications/startXBMC.sh
config_home=$HOME

#define configuration file
configFile="$config_home/retrorig.cfg"

#clear configuration folder
rm -f $config_home/xbmc_crashlog-*.log

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
  ps2_monitor=$3
  ps2_new_xpos=`getpos 2>/dev/null|grep xpos|cut -f 2 -d ' '`
  ps2_new_ypos=`getpos 2>/dev/null|grep ypos|cut -f 2 -d ' '`

  # dolphin
  dolphin_new_X=$1
  dolphin_new_Y=$2
  dolphin_monitor=$3
  dolphin_new_xpos=`getpos 2>/dev/null|grep xpos|cut -f 2 -d ' '`
  dolphin_new_ypos=`getpos 2>/dev/null|grep ypos|cut -f 2 -d ' '`

  # Gens/GS (Sega CD/32X)
  gens_new_X=$1
  gens_new_X=$2
  
  ########################		
  #mupen64plus
  ########################
  m_org_X=$(grep -Ee "\bScreenWidth = \b" "$config_home/.config/mupen64plus/mupen64plus.cfg")
  m_org_Y=$(grep -Ee "\bScreenHeight = \b" "$config_home/.config/mupen64plus/mupen64plus.cfg")
  #make the changes, prefix new_X in case NULL was entered previousey

  if [ -n "$m_org_X" ];then
    sed -i "s|$m_org_X|ScreenWidth = $m_new_X|g" "$config_home/.config/mupen64plus/mupen64plus.cfg"
  fi

  if [ -n "$m_org_Y" ];then  
    sed -i "s|$m_org_Y|ScreenHeight = $m_new_Y|g" "$config_home/.config/mupen64plus/mupen64plus.cfg"
  fi

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
  if [ -e "$config_home/.gens/gens.cfg" ]; then

    gens_org_X=$(grep -Ee "\bOpenGL Width=\b" "$config_home/.gens/gens.cfg")
    gens_org_Y=$(grep -Ee "\bOpenGL Height=\b" "$config_home/.gens/gens.cfg")
    #make the changes, prefix new_X in case NULL was entered previously
    if [ -n "$gens_org_X" ]; then
      sed -i "s|$gens_org_X|OpenGL Width= $gens_new_X|g" "$config_home/.gens/gens.cfg"
    fi
  
    if [ -n "$gens_org_Y" ]; then
      sed -i "s|$gens_org_Y|OpenGL Height= $gens_new_Y|g" "$config_home/.gens/gens.cfg"
    fi

  fi

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
  
  #pcsx2 ui settings
  ps2_ui_org_X=$(grep -Ee "FullscreenX=" "$config_home/.config/pcsx2/inis/PCSX2_ui.ini")
  ps2_ui_org_Y=$(grep -Ee "FullscreenY=" "$config_home/.config/pcsx2/inis/PCSX2_ui.ini")

  WindowPos_org=$(grep -Ee "WindowPos=" "$config_home/.config/pcsx2/inis/PCSX2_ui.ini")
  WindowPos_new="$ps2_new_xpos,$ps2_new_ypos"
  #apply the changes
  if [ -n "$ps2_ui_org_X" ]; then
    sed -i "s|$ps2_ui_org_X|FullscreenX=$ps2_new_X|g" "$config_home/.config/pcsx2/inis/PCSX2_ui.ini"  
  fi
  
  if [ -n "$ps2_ui_org_Y" ]; then
    sed -i "s|$ps2_ui_org_Y|FullscreenY=$ps2_new_Y|g" "$config_home/.config/pcsx2/inis/PCSX2_ui.ini"
  fi

  if [ -n "$WindowPos_org" ]; then
    sed -i "s|$WindowPos_org|WindowPos=$WindowPos_new|g" "$config_home/.config/pcsx2/inis/PCSX2_ui.ini"
  fi
  #set pcsx2 to fullscreen
  ps2_ui_org_fs=$(grep -Ee "DefaultToFullscreen=" "$config_home/.config/pcsx2/inis/PCSX2_ui.ini")
  if [ -n "$ps2_ui_org_fs" ]; then
    sed -i "s|$ps2_ui_org_fs|DefaultToFullscreen=enabled|g" "$config_home/.config/pcsx2/inis/PCSX2_ui.ini"
  fi

  #dolphin (Wii)
  #old resolution
  dolphin_org_Res=$(grep -Ee "FullscreenResolution = " "$config_home/.dolphin-emu/Wii/Config/Dolphin.ini")
  #new resolution
  dolphin_new_Res="FullscreenResolution = $dolphin_monitor"": ""$dolphin_new_X""x""$dolphin_new_Y"
  #apply changes
  sed -i "s|$dolphin_org_Res|$dolphin_new_Res|g" "$config_home/.dolphin-emu/Wii/Config/Dolphin.ini"  
  #enable vsync
  if [ -f $config_home/.dolphin-emu/Wii/Config/gfx_opengl.ini ];then

    dolphin_org_vsync=$(grep -Ee "VSync = " "$config_home/.dolphin-emu/Wii/Config/gfx_opengl.ini")
    if [ -n "$dolphin_org_vsync" ]; then
      sed -i "s|$dolphin_org_vsync|VSync = True|g" "$config_home/.dolphin-emu/Wii/Config/gfx_opengl.ini"  
    fi 
  fi
  
  #old render position
  dolphin_old_xpos=$(grep -Ee "RenderWindowXPos = " "$config_home/.dolphin-emu/Wii/Config/Dolphin.ini")
  dolphin_old_ypos=$(grep -Ee "RenderWindowYPos = " "$config_home/.dolphin-emu/Wii/Config/Dolphin.ini")
  #apply changes
  sed -i "s|$dolphin_old_xpos|RenderWindowXPos = $dolphin_new_xpos|g" "$config_home/.dolphin-emu/Wii/Config/Dolphin.ini"  
  sed -i "s|$dolphin_old_ypos|RenderWindowYPos = $dolphin_new_ypos|g" "$config_home/.dolphin-emu/Wii/Config/Dolphin.ini"  
  
  #dolphin (Gamecube)
  #old resolution
  dolphin_org_Res=$(grep -Ee "FullscreenResolution = " "$config_home/.dolphin-emu/GC/Config/Dolphin.ini")
  #new resolution
  dolphin_new_Res="FullscreenResolution = $dolphin_monitor"": ""$dolphin_new_X""x""$dolphin_new_Y"
  #apply changes
  sed -i "s|$dolphin_org_Res|$dolphin_new_Res|g" "$config_home/.dolphin-emu/GC/Config/Dolphin.ini"  
  #enable vsync
  if [ -f $config_home/.dolphin-emu/GC/Config/gfx_opengl.ini ];then

    dolphin_org_vsync=$(grep -Ee "VSync = " "$config_home/.dolphin-emu/GC/Config/gfx_opengl.ini")
    if [ -n "$dolphin_org_vsync" ]; then
      sed -i "s|$dolphin_org_vsync|VSync = True|g" "$config_home/.dolphin-emu/GC/Config/gfx_opengl.ini"  
    fi 
  fi
  
  #old render position
  dolphin_old_xpos=$(grep -Ee "RenderWindowXPos = " "$config_home/.dolphin-emu/GC/Config/Dolphin.ini")
  dolphin_old_ypos=$(grep -Ee "RenderWindowYPos = " "$config_home/.dolphin-emu/GC/Config/Dolphin.ini")
  #apply changes
  sed -i "s|$dolphin_old_xpos|RenderWindowXPos = $dolphin_new_xpos|g" "$config_home/.dolphin-emu/GC/Config/Dolphin.ini"  
  sed -i "s|$dolphin_old_ypos|RenderWindowYPos = $dolphin_new_ypos|g" "$config_home/.dolphin-emu/GC/Config/Dolphin.ini"  
  
else
  echo "auto resolution is disabled, exiting"
fi
