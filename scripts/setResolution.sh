#!/bin/bash

########################################################################
# file        :     setResolution.sh
# date        :     14/08/19
# author      :     jc
# description :     Take resoltuion arguments from command line 
#                   and configure emulators accordingly.
#
#                   This will only be executed, if parameter
#                   "auto resolution" is set in the configuration
#                   file.
#
#                   In general, a line in the configuration file looks
#                   like this:
#
#                   parameter name, parameter value
#
########################################################################

source "configuration.shinc"

#define configuration file
#HOME is set in /usr/share/applications/startXBMC.sh
configFile="$HOME/retrorig.cfg"


########################################################
# just for testing, can be deleted
#
    if parameterIsTrue "auto resolution"; then
      echo "before: true"
    else
      echo "before: false"
    fi

    echo "test #1: set parameter"
    setParameter "auto resolution" "true"
    if parameterIsTrue "auto resolution"; then
      echo "  test #1: true"
    else
      echo "  test #1: false"
    fi
    
    echo "test #2: set parameter"
    setParameter "auto resolution" "false"
    if parameterIsTrue "auto resolution"; then
      echo "  test #2: true"
    else
      echo "  test #2: false"
    fi

    echo "test #3: create new parameter at end of file"
    str=`date`
    setParameter "$str" "$str"
    output=$(getParameter "$str")
    echo $output
#
#
########################################################
