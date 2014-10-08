#!/bin/bash

########################################################################
# file        :     bringToFront.sh
# date        :     14/09/27
# author      :     jc
# description :     Move RetroRig window to front
#
########################################################################

WINTITLE=RetroRig

if [ `wmctrl -l | grep -c "$WINTITLE"` != 0 ]
then

  # If it exists, bring RetroRig window to front
  xdotool search --name $WINTITLE windowraise

fi
exit 0
