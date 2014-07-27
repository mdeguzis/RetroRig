#!/bin/bash

# Project RetroRig: https://github.com/ProfessorKaos64/RetroRig
# This script detects a change on available PS controller. If detected, it notifies XBMC.
# Authors: Jens-Christiansen, Michael DeGuzis
# Revision: 2014/06/21, initial version
# Revision: 2014/07/26, by pk, added checks for all controllers

###################################################
# set controller type based on RetroRig Script
###################################################

controllertype="controller_temp"

###################################################

while [ 0 ]
do

# check for PS3 Bluetooth Controller
if [ "$controllertype" = "ps3_blu" ]; then

          oldControllerAvailable=$controllerAvailable
          controllerAvailable=`cat /proc/bus/input/devices | grep "PLAYSTATION(R)"`
          if [ "$controllerAvailable" != "$oldControllerAvailable" ]; then
            killall xbmc.bin -SIGUSR1
          fi
fi

# check for PS3 USB Controller

if [ "$controllertype" = "ps3_usb" ]; then
          # check for PS3 USB Controller
          oldControllerAvailableUSB=$controllerAvailableUSB
          controllerAvailableUSB=`lsusb | grep -E "PlayStation 3 Controller"`
          if [ "$controllerAvailableUSB" != "$oldControllerAvailableUSB" ]; then
            echo "Restarting xboxdrv services"
            sudo /usr/sbin/service xboxdrv restart
            killall xbmc.bin -SIGUSR1
          fi
 fi

# check for xbox 360 wirelesss Controller

if [ "$controllertype" = "xbox360_wireless" ]; then
          # check for Xbox360 USB Hub (wireless) Controller
          oldControllerAvailable=$controllerAvailable
          controllerAvailable=`lsusb | grep Xbox 360 Wireless`
          if [ "$controllerAvailable" != "$oldControllerAvailable" ]; then
            echo "Restarting xboxdrv services"
            sudo /usr/sbin/service xboxdrv restart
            killall xbmc.bin -SIGUSR1
          fi
 fi

### XBOX 360 WIRED HOTPLUGGING BELOW IS NOT CURRENTLY FUNCTIONING!!! ###

# check for xbox 360 wired Controller
if [ "$controllertype" = "x360_wired" ]; then

          # check for Xbox360 USB connected Controller
          oldControllerAvailableUSB=$controllerAvailableUSB
          controllerAvailableUSB=`lsusb | grep "Xbox360 Controller"`
          if [ "$controllerAvailableUSB" != "$oldControllerAvailableUSB" ]; then
            echo "Restarting xboxdrv services"
            killall xboxdrv
            sudo /usr/sbin/service xboxdrv restart
            killall xbmc.bin -SIGUSR1
          fi
fi

  sleep 1
done

