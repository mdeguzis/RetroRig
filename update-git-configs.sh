#!/bin/bash

#small script to update configuration files for git repo
#Version 0.6.1
#This configuration file is based on Ubuntu 14.04 LTS
#absolute home paths replaced with $HOME

#Nestopia
#default path: /home/$USER/.nestopia
cp -Rv $HOME/.nestopia/nstcontrols $HOME/RetroRig/Nestopia/
cp -Rv $HOME/.nestopia/nstsettings $HOME/RetroRig/Nestopia/

#gens
#default path: /home/$USER/.gens
cp -v $HOME/.gens/gens.cfg $HOME/RetroRig/Gens-GS/

#ZSNES
#default path: /home/$USER/.zsnes
cp -v $HOME/.zsnes/zinput.cfg $HOME/RetroRig/ZSNES/
cp -v $HOME/.zsnes/zsnesl.cfg  $HOME/RetroRig/ZSNES/

#mame
#default path: /home/$USER/.mame
cp -v $HOME/.mame/mame.ini $HOME/RetroRig/MAME/
#inject over offline scapper files
cp -v $HOME/Games/Artwork/MAME/* $HOME/RetroRig/MAME/Artwork

#pcsx
#default path: /home/$USER/.pcsx
#Do NOT copy in a BIOS files
#main config
cp -v $HOME/.pcsx/pcsx.cfg $HOME/RetroRig/pcsx/
#patches and plugins
cp -Rv $HOME/.pcsx/plugins/ $HOME/RetroRig/pcsx/
cp -Rv $HOME/.pcsx/patches/ $HOME/RetroRig/pcsx/

#pcsx2
#default path: /home/$USER/.pcsx
#Do NOT copy in any BIOS files
cp -v $HOME/.config/pcsx2/inis/* $HOME/RetroRig/pcsx2/inis/
#copy other ini files, but bios
cp -v $HOME/.config/pcsx2/inisOnePAD.ini $HOME/RetroRig/pcsx2/
cp -v $HOME/.config/pcsx2/PCSX2-reg.ini $HOME/RetroRig/pcsx2/

#mupen64plus
#default path: /home/$USER/.config/mupen64plus
#Main config
cp -v $HOME/.config/mupen64plus/mupen64plus.cfg $HOME/RetroRig/mupen64plus/

#Stella
#default path: /home/$USER/.stella
#Main config
cp -v $HOME/.stella/stellarc $HOME/RetroRig/Stella/

#dolphin
#default path /home/$USER/.dolphin-emu/
#Dolphin.ini  GCPadNew.ini  gfx_opengl.ini
cp -v $HOME/.dolphin-emu/Config/Dolphin.ini /$HOME/RetroRig/Dolphin/
cp -v $HOME/.dolphin-emu/Config/GCPadNew.ini /$HOME/RetroRig/Dolphin/
cp -v $HOME/.dolphin-emu/Config/gfx_opengl.ini /$HOME/RetroRig/Dolphin/

#update configs for other utilities
#qjoypad
cp -v $HOME/Games/Configs/qjoypad_launch.sh $HOME/RetroRig/controller-cfg/
cp -v $HOME/.qjoypad3/retro-gaming.lyt $HOME/RetroRig/controller-cfg/
#xboxdrv cfg
cp -v $HOME/Games/Configs/xpad-wireless.xboxdrv $HOME/RetroRig/controller-cfg/
cp -v /etc/init.d/xboxdrv $HOME/RetroRig/init-scripts/
cp -v /etc/modprobe.d/blacklist.conf $HOME/RetroRig/init-scripts/

#RCB config files
#--workign with dev--

#XBMC
#add RCB addons from $HOME/.xbmc/addons
cp -Rv $HOME/.xbmc/addons/script.games.rom.collection.browser $HOME/RetroRig/XBMC/addons
cp -Rv $HOME/.xbmc/addons/service.rom.collection.browser $HOME/RetroRig/XBMC/addons

#update init-scripts
#xboxdrv service
cp -v /etc/init.d/xboxdrv $HOME/RetroRig/init-scripts/

#Note:
#Remember to run garbage collection script every once in a while

#commit data
git add *
git commit
git push origin master






