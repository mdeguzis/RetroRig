#!/bin/bash

# Project RetroRig: https://github.com/ProfessorKaos64/RetroRig
# This script detects a change on available PS controller. If detected, it notifies XBMC.
# Author: Jens-Christiansen, aka  beaumanvienna/JC
# Revision: 2014/06/21, initial version


controllerAvailable=`cat /proc/bus/input/devices | grep PLAYSTATION`
echo $controllerAvailable

while [ 0 ]
do
  oldControllerAvailable=$controllerAvailable
  controllerAvailable=`cat /proc/bus/input/devices | grep PLAYSTATION`
  if [ "$controllerAvailable" != "$oldControllerAvailable" ]; then
    killall xbmc.bin -SIGUSR1
  fi
  sleep 1
done
