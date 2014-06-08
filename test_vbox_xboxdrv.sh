#!/bin/bash
#
# You can use this small script to test proper xboxdrv input under your
# host system. Some Linux distros use their own "defaults" of xboxdrv,
# so this script will stop that current implementation and load what
# I test with.
#
sudo killall xboxdrv
sudo xboxdrv -w 0 -l 2 --trigger-as-button --dpad-as-button &
#
# DONE
