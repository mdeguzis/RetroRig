#!/bin/bash
 
# Project RetroRig: https://github.com/ProfessorKaos64/RetroRig
 
# This script launches XBMC, puts it to a predefined position on the desktop, crops its title bar and full-screens it.
# The fullscreening part will only work, if XBMC is configured to run in windowed mode.
# You have to do this one time: Start XBMC, in XBMC go to System > Settings > Video output and configure it for windowed mode
 
# Author: Jens-Christian, aka beaumanvienna/JC
# Revision: 2014/06/21, initial version

export HOME=$HOME/.retrorig
echo starting xbmc
xbmc-retrorig  &
 
 
status=Running
while [ "$status" == "Running" ]
do
  status=`pgrep xbmc-retrorig > /dev/null && echo Running`
  sleep 1
done

