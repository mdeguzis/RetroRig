#!/bin/bash

	#create system directories
	mkdir -p /usr/share/RetroRig 
	mkdir -p /usr/share/RetroRig/Artwork/XBMC

	
	# copy base files
	cp -r scripts/ gamepad-cfgs/ emu-cfgs/ init-scripts/ scriptmodules/ common/ XBMC-cfgs/ retrorig-cfgs/ /usr/share/RetroRig
	
	#copy executables
	cp retrorig-setup.sh /usr/bin/retrorig-setup
	cp /usr/share/RetroRig/XBMC-cfgs/extra/xbmc-retrorig /usr/bin 
	
	#icons
	cp /usr/share/RetroRig/XBMC-cfgs/extra/retro-icon.png /usr/share/icons 
	cp Artwork/XBMC/RetroMain-0-9-7b.png /usr/share/RetroRig/Artwork/XBMC/
	cp Artwork/XBMC/gears.png /usr/share/RetroRig/Artwork/XBMC/
	
	
	#supplemental application files
	cp /usr/share/RetroRig/XBMC-cfgs/extra/startXBMC.sh /usr/share/applications
	cp /usr/share/RetroRig/XBMC-cfgs/extra/RetroRig.desktop /usr/share/applications
	cp /usr/share/RetroRig/XBMC-cfgs/extra/gp_autodetect_xbmc.sh /usr/share/applications
	
	#services
	#mv /usr/share/RetroRig/XBMC-cfgs/extra/rescan /etc/init.d/
