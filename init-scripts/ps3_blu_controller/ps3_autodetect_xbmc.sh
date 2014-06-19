#!/bin/bash

clear
echo "Recconecting PS3 Controller for XBMC.."
sleep 3s

count=0

while ! grep -q "PLAYSTATION(R)3" /proc/bus/input/devices
do
	# not set, echo below fore TESTING ONLY!!!
	# set ps3_blu_complete to 0 for false
	echo "Your controller is not turned on! please press the PS3 Button!"
	sleep 3s
done

# kill and restart xbmc if it is started
pkill xbmc
# give the controller about 3 seconds to start
sleep 3s
/usr/bin/xbmc
#exit script
exit
