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
cp -Rvi $HOME/.gens/gens.cfg $HOME/RetroRig/Gens-GS/

#ZSNES
#default path: /home/$USER/.zsnes
#Controller config
cp -Rv $HOME/.zsnes/zinput.cfg $HOME/RetroRig/ZSNES/
#emulator config
cp -Rv $HOME/.zsnes/zsnesl.cfg $HOME/RetroRig/ZSNES/

#mame
#default path: /home/$USER/.mame
#Main config
cp -Rv $HOME/.mame/mame.ini $HOME/RetroRig/MAME/
#controller config
cp -Rv $HOME/.mame/cfg/default.cfg $HOME/RetroRig/MAME/

#pcsx
#default path: /home/$USER/.pcsx
#Main config
cp -Rv $HOME/.pcsx/pcsx.cfg $HOME/RetroRig/PS1/

#mupen64plus
#default path: /home/$USER/.config/mupen64plus
#Main config
cp -Rv $HOME/.config/mupen64plus/mupen64plus.cfg $HOME/RetroRig/mupen64plus/

#update configs for other utilities
cp -Rv $HOME/Games/Configs/qjoypad_launch.sh $HOME/RetroRig/controller-cfg/
cp -Rv $HOME/Games/Configs/xpad-wireless.xboxdrv $HOME/RetroRig/controller-cfg/

git add *
git commit -m 'date'+"(Auto)update-git-config"
git push origin master






