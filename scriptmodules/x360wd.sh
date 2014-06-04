#!/bin/bash
#
# RetroRig xbox 360 wired module
# This is a small script to copy over configuration files for emulators
# append a "-x" on the end above for debugging if need be
# Please report any errors via a pull request
# You can also reach me on twitter: @N3RD42
#

function _config-x360wd () {

	#Wired Xbox 360 Controller Config
	echo "-----------------------------------------------------------" | tee -a install_log.txt
	echo "Configuring Xbox (Wired) Gamepad..." | tee -a install_log.txt
	echo "-----------------------------------------------------------" | tee -a install_log.txt

	#copy xbox configuration (default) to folder
	cp -v $HOME/RetroRig/controller-cfgs/x360wd/xpad-wired.xboxdrv /usr/share/xboxdrv/ | tee -a install_log.txt

	# copy keyboard.xml file for XBMC 
	# Button id numbers are totally diffferent, due to the use of the use-dpad-as-button, and use-trigger-as-button options used.
	mkdir -pv $HOME/.xbmc/userdata/keymaps/ | tee -a install_log.txt
	cp -v $HOME/RetroRig/controller-cfgs/x360wd/keyboard.xml $HOME/.xbmc/userdata/keymaps

	#set qjoypad's profile to match Xbox 360 Wireless (4-player)
	cp -v $HOME/RetroRig/controller-cfgs/x360wd.lyt $HOME/.qjoypad3/ | tee -a install_log.txt

	#mame
	#default path: /home/$USER/.mame
	#Main config
	cp -v $HOME/RetroRig/emu-cfgs/x360wd/MAME/default.cfg $HOME/.mame/cfg | tee -a install_log.txt
	cp -v $HOME/RetroRig/emu-cfgs/x360wd/MAME/mame.ini $HOME/.mame | tee -a install_log.txt
	#offline artwork scrapper configs
	cp -v $HOME/RetroRig/emu-cfgs/x360wd/MAME/parserConfig.xml $HOME/Games/Artwork/MAME | tee -a install_log.txt
	cp -v $HOME/RetroRig/emu-cfgs/x360wd/MAME/MAME.txt $HOME/Games/Artwork/MAME | tee -a install_log.txt
	cp -v $HOME/RetroRig/emu-cfgs/x360wd/MAME/MAME\ synopsis\ RCB\ 201202.zip/ $HOME/Games/Artwork/MAME | tee -a install_log.txt

	#mednafen
	#default path: /home/$USER/.mednafen/mednafen.cfg
	#Main config
	cp -v $HOME/RetroRig/emu-cfgs/x360ws/mednafen/mednafen-09x.cfg $HOME/.mednafen | tee -a install_log.txt

	#mupen64plus
	#default path: /home/$USER/.config/mupen64plus
	#Main config
	cp -v $HOME/RetroRig/emu-cfgs/x360wd/mupen64plus/mupen64plus.cfg $HOME/.config/mupen64plus/ | tee -a install_log.txt

	#Stella
	#default path: /home/$USER/.config/mupen64plus
	#Main config
	cp -v $HOME/RetroRig/emu-cfgs/x360wd/Stella/stellarc $HOME/.stella/ | tee -a install_log.txt
	
	#inject init script
	cp -v $HOME/RetroRig/init-scripts/x360wd/xboxdrv /etc/init.d/ | tee -a install_log.txt
	#update 
	update-rc.d xboxdrv defaults | tee -a install_log.txt

	#blacklist xpad
	echo "sudo needed to blacklist xpad!"
	cp -v $HOME/RetroRig/init-scripts/x360wd/blacklist.conf /etc/modprobe.d/ | tee -a install_log.txt

	#copy default gamepad setup for Xbox 360 Wireless (4-player)
	cp -v $HOME/RetroRig/controller-cfgs/x360wd/x360wd.lyt $HOME/.qjoypad3/ | tee -a install_log.txt

	#copy qjoypad autostart item for x360ws gamepad config
	cp -v $HOME/RetroRig/controller-cfgs/x360wd/qjoypad.desktop /etc/xdg/autostart/ | tee -a install_log.txt

}
