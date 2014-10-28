#!/bin/bash

# Project RetroRig: https://github.com/ProfessorKaos64/RetroRig
# This script detects a change on available PS controller. If detected, it notifies XBMC.
# Author: Jens-Christiansen, aka  beaumanvienna/JC
# Revision: 2014/10/28, initial version


controllerAvailable=`cat /proc/bus/input/devices | grep PLAYSTATION`
echo $controllerAvailable

while [ 0 ]
do
  oldControllerAvailable=$controllerAvailable
  controllerAvailable=`cat /proc/bus/input/devices | grep PLAYSTATION`
  if [ "$controllerAvailable" != "$oldControllerAvailable" ]; then
  
    echo "sending gamepad reconfiguration request"
    killall xbmc.bin -SIGUSR1
  
    #auto start xbmc for first controller to be switched on
    if [ -z "$oldControllerAvailable" ]; then
      #a controller was switched on
      if [ -z "$(pidof xbmc.bin 2>/dev/null)" ]; then
        # xbmc not running yet
        /usr/share/applications/startXBMC.sh
        
        #make sure it knows of the controller just being switched on
        sleep 5
        killall xbmc.bin -SIGUSR1
      fi
    fi
  fi
  sleep 1
done

