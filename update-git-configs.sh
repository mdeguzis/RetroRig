#!/bin/bash

#small script to update configuration files for git repo
#Version 1.1
#This configuration file is based on Ubuntu 14.04 LTS

#Nestopia
#default path: /home/$USER/.nestopia
cp -Rv $HOME/.nestopia/nstcontrols $HOME/RetroRig/Nestopia/

#gens
#default path: /home/$USER/.gens
#Global config
cp -v $HOME/.gens/gens.cfg $HOME/RetroRig/Gens-GS/

#ZSNES
#default path: /home/$USER/.zsnes
#Controller config
cp -v $HOME/.zsnes/zinput.cfg $HOME/RetroRig/ZSNES/
#emulator config
cp -v $HOME/.zsnes/zsnesl.cfg $HOME/RetroRig/ZSNES/

#mame
#default path: /home/$USER/.mame
#Main config
cp -v $HOME/.mame/mame.ini $HOME/RetroRig/MAME/
#controller config
cp -v $HOME/.mame/cfg/default.cfg $HOME/RetroRig/MAME/

#pcsx
#default path: /home/$USER/.pcsx
#Main config
cp -v $HOME/.pcsx/pcsx.cfg $HOME/RetroRig/pcsx/

#mupen64plus
#default path: /home/$USER/.config/mupen64plus
#Main config
cp -v $HOME/.config/pcsx2/PCSX2-reg.ini $HOME/RetroRig/pcsx2/

#mupen64plus
#default path: /home/$USER/.config/mupen64plus
#Main config
cp -v $HOME/.config/mupen64plus/mupen64plus.cfg $HOME/RetroRig/mupen64plus/

#mupen64plus
#default path: /home/$USER/.config/mupen64plus
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
cp -v /etc/init.d/xboxdrv $HOME/RetroRig/init-scipts/

#update init-scripts
#xboxdrv service
cp -v /etc/init.d/xboxdrv $HOME/RetroRig/init-scripts/

git add *
git commit
git push origin master






