#!/bin/bash

# Project RetroRig: https://github.com/ProfessorKaos64/RetroRig
# This script detects a change on available PS controller. If detected, it notifies XBMC.
# Author: Jens-Christiansen, aka  beaumanvienna/JC
# Revision: 2014/10/28, initial version

controllerAvailable=`cat /proc/bus/input/devices | grep PLAYSTATION`

while [ 0 ]
do
  oldControllerAvailable=$controllerAvailable
  controllerAvailable=`cat /proc/bus/input/devices | grep PLAYSTATION`
  if [ "$controllerAvailable" != "$oldControllerAvailable" ]; then
  
    echo "sending gamepad reconfiguration request"
    killall xbmc.bin -SIGUSR1
  
    #auto start xbmc for first controller to be switched on
    autostarted=false
    if [ -z "$oldControllerAvailable" ]; then
      #first controller was switched on
      echo "first controller was switched on"
      
      if [ -z "$(ps ax|grep xbmc.bin|grep -v grep)" ]; then
        # xbmc not running yet
        echo "xbmc not running yet"
        
        # get user name
        user=`ps aux |grep "/bin/dbus-daemon --config-file"|grep -v grep|cut -f 1 -d " "`
        
        export export DISPLAY=:0.0
        echo "auto starting RetroRig for user $user"
        sudo -u $user -g $user -s /usr/share/applications/startXBMC.sh &
        autostarted=true
        
      fi
    fi
    
    #diagnostic message
    sleep 2
    if [ "$autostarted" == "true" ]; then
      if [ -n "$(ps ax|grep xbmc.bin|grep -v grep)" ]; then
        echo "RetroRig sucessfully started"
      else
        echo "attempt to start RetroRig failed"
      fi
    else
      echo "RetroRig *not* started automatically (either first controller not switched on or xbmc already running)"
    fi
    
  fi
  sleep 1
done

