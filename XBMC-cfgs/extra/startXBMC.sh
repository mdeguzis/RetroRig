#!/bin/bash
 
# Project RetroRig: https://github.com/ProfessorKaos64/RetroRig
 
# This script launches XBMC, puts it to a predefined position on the desktop, crops its title bar and full-screens it.
# The fullscreening part will only work, if XBMC is configured to run in windowed mode.
# You have to do this one time: Start XBMC, in XBMC go to System > Settings > Video output and configure it for windowed mode
 
# Author: Jens-Christiansen, aka beaumanvienna/JC
# Revision: 2014/06/21, initial version

export XBMC_HOME=/usr/share/xbmc/
echo starting xbmc
xbmc  &
 
# Wait for the XBMC window to appear
status=0
while [ $status -eq 0 ]
do
  sleep 1
  status=`wmctrl -x -l | grep "XBMC Media Center" | wc -l | awk '{print $1}'`
done
# Not sure if the below window positioning should be kept for all
# Need to discuss with JC (edit: pk)

#wmctrl -x -r XBMC Media Center.XBMC Media Center -b toggle,maximized_vert,maximized_horz
#wmctrl -x -r XBMC Media Center.XBMC Media Center -e 50,2000,50,1920,1080
 
# run XBMC window in fullscreen mode
#wmctrl -x -r XBMC Media Center.XBMC Media Center -b toggle,fullscreen
 
status=Running
while [ "$status" == "Running" ]
do
  status=`pgrep xbmc > /dev/null && echo Running`
  sleep 1
done
