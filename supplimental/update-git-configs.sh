#!/bin/bash

#small script to update configuration files for git repo
#Version 0.6.4
#This configuration file is based on Ubuntu 14.04 LTS
#absolute home paths replaced with $HOME

#Nestopia
#default path: /home/$USER/.nestopia
cp -Rv $HOME/.nestopia/nstcontrols $HOME/RetroRig/emu-configs/Nestopia/
cp -Rv $HOME/.nestopia/nstsettings $HOME/RetroRig/emu-configs/Nestopia/

#gens
#default path: /home/$USER/.gens
cp -v $HOME/.gens/gens.cfg $HOME/RetroRig/emu-configs/Gens-GS/

#ZSNES
#default path: /home/$USER/.zsnes
cp -v $HOME/.zsnes/zinput.cfg $HOME/RetroRig/emu-configs/ZSNES/
cp -v $HOME/.zsnes/zsnesl.cfg  $HOME/RetroRig/emu-configs/ZSNES/

#mame
#default path: /home/$USER/.mame
cp -v $HOME/.mame/mame.ini $HOME/RetroRig/emu-configs/MAME/
#inject over offline scapper files
cp -v $HOME/Games/Artwork/MAME/* $HOME/RetroRig/emu-configs/MAME/Artwork

#pcsx
#default path: /home/$USER/.pcsx
#Do NOT copy in a BIOS files
#main config
cp -v $HOME/.pcsx/pcsx.cfg $HOME/RetroRig/emu-configs/pcsx/
#patches and plugins
cp -Rv $HOME/.pcsx/plugins/ $HOME/RetroRig/emu-configs/pcsx/
cp -Rv $HOME/.pcsx/patches/ $HOME/RetroRig/emu-configs/pcsx/

#pcsx2
#default path: /home/$USER/.pcsx
#Do NOT copy in any BIOS files
cp -v $HOME/.config/pcsx2/inis/* $HOME/RetroRig/pcsx2/inis/
#copy other ini files, but bios
cp -v $HOME/.config/pcsx2/inisOnePAD.ini $HOME/RetroRig/emu-configs/pcsx2/
cp -v $HOME/.config/pcsx2/PCSX2-reg.ini $HOME/RetroRig/emu-configs/pcsx2/

#mupen64plus
#default path: /home/$USER/.config/mupen64plus
#Main config
cp -v $HOME/.config/mupen64plus/mupen64plus.cfg $HOME/RetroRig/emu-configs/mupen64plus/

#Stella
#default path: /home/$USER/.stella
#Main config
cp -v $HOME/.stella/stellarc $HOME/RetroRig/Stella/

#dolphin
#default path /home/$USER/.dolphin-emu/
#Dolphin.ini  GCPadNew.ini  gfx_opengl.ini
cp -v $HOME/.dolphin-emu/Config/Dolphin.ini /$HOME/RetroRig/emu-configs/Dolphin/
cp -v $HOME/.dolphin-emu/Config/GCPadNew.ini /$HOME/RetroRig/emu-configs/Dolphin/
cp -v $HOME/.dolphin-emu/Config/gfx_opengl.ini /$HOME/RetroRig/emu-configs/Dolphin/

#update configs for other utilities
#qjoypad
cp -v $HOME/Games/Configs/qjoypad_launch.sh $HOME/RetroRig/controller-cfgs/
cp -v $HOME/.qjoypad3/retro-gaming.lyt $HOME/RetroRig/controller-cfgs/
#xboxdrv cfg
cp -v $HOME/Games/Configs/xpad-wireless.xboxdrv $HOME/RetroRig/controller-cfgs/
cp -v /etc/init.d/xboxdrv $HOME/RetroRig/init-scripts/
cp -v /etc/modprobe.d/blacklist.conf $HOME/RetroRig/init-scripts/

#XBMC
#add RCB addons from $HOME/.xbmc/addons
#Don't* add RCB addon or userdata anymore, default shell established for RCB in git repo!

#cp -Rv $HOME/.retrorig/addons/script.games.rom.collection.browser $HOME/RetroRig/XBMC/addons
#cp -Rv $HOME/.retrorig/addons/service.rom.collection.browser $HOME/RetroRig/XBMC/addons

#update init-scripts
#xboxdrv service
cp -v /etc/init.d/xboxdrv $HOME/RetroRig/init-scripts/

#Note:
#Remember to run garbage collection script every once in a while

#commit data
git add *
git commit
git push origin master






