#!/bin/bash

	#create system directories
	mkdir -p /usr/lib/RetroRig 
	mkdir -p /usr/lib/RetroRig/Artwork/XBMC

	
	# copy base files
	cp -r scripts/ gamepad-cfgs/ emu-cfgs/ init-scripts/ scriptmodules/ common/ XBMC-cfgs/ retrorig-cfgs/ /usr/lib/RetroRig
	
	#copy executables
	cp retrorig-setup.sh /usr/bin/retrorig-setup
	cp /usr/lib/RetroRig/XBMC-cfgs/extra/xbmc-retrorig /usr/bin 
	
	#icons
	cp /usr/lib/RetroRig/XBMC-cfgs/extra/retro-icon.png /usr/share/icons 
	cp Artwork/XBMC/XBMC-logo-Ace-Skin.png /usr/lib/RetroRig/Artwork/XBMC/
	cp Artwork/XBMC/gears.png /usr/lib/RetroRig/Artwork/XBMC/
	
	
	#supplemental application files
	cp /usr/lib/RetroRig/XBMC-cfgs/extra/startXBMC.sh /usr/share/applications
	cp /usr/lib/RetroRig/XBMC-cfgs/extra/RetroRig.desktop /usr/share/applications
	cp /usr/lib/RetroRig/XBMC-cfgs/extra/gp_autodetect_xbmc.sh /usr/share/applications
	
	#services
	#mv /usr/lib/RetroRig/XBMC-cfgs/extra/rescan /etc/init.d/
