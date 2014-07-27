#!/bin/bash

# Project RetroRig: https://github.com/ProfessorKaos64/RetroRig
# This script detects a change on available PS controller. If detected, it notifies XBMC.
# Author: Jens-Christiansen, aka  beaumanvienna/JC
# Revision: 2014/06/21, initial version

# echo controllers
controllerAvailable_ps3_blu=`cat /proc/bus/input/devices | grep PLAYSTATION`
echo "Available PS3 Controllers (Bluetooth):"
echo $controllerAvailable_ps3_blu

controllerAvailable_ps3_usb=`cat /proc/bus/input/devices | grep PLAYSTATION`
echo "Available PS3 Controllers (USB):"
echo $controllerAvailable_ps3_usb

controllerAvailable_x360_wireless=`cat /proc/bus/input/devices | grep "Xbox Gamepad (userspace driver)"`
echo "Available Xbox 360 Controllers (Wireless):"
echo $controllerAvailable_x360_wireless
l
controllerAvailable_x360_usb=`cat /proc/bus/input/devices | grep "Xbox Gamepad (userspace driver)"`
echo "Available Xbox 360 Controllers (Wired):"
echo $controllerAvailable_x360_usb

while [ 0 ]
do

  # check for PS3 Bluetooth Controller
  oldControllerAvailable=$controllerAvailable
  controllerAvailable=`cat /proc/bus/input/devices | grep PLAYSTATION`
  if [ "$controllerAvailable" != "$oldControllerAvailable" ]; then
    killall xbmc.bin -SIGUSR1
  fi

  # check for PS3 USB Controller
  oldControllerAvailableUSB=$controllerAvailableUSB
  controllerAvailableUSB=`lsusb | grep PlayStation`
  if [ "$controllerAvailableUSB" != "$oldControllerAvailableUSB" ]; then
    killall xbmc.bin -SIGUSR1
  fi

  # check for Xbox360 USB Hub (wireless) Controller
  oldControllerAvailable=$controllerAvailable_x360_wireless
  controllerAvailableU=`lsusb | grep Xbox 360 Wireless`
  if [ "$controllerAvailable_x360_wireless" != "$oldControllerAvailable" ]; then
    killall xbmc.bin -SIGUSR1
  fi

  # check for Xbox360 USB connected Controller
  oldControllerAvailableUSB=$controllerAvailable_x360_usb
  controllerAvailableUSB=`lsusb | grep Xbox360 Controller`
  if [ "$controllerAvailableUSB" != "$oldControllerAvailableUSB" ]; then
    killall xbmc.bin -SIGUSR1
  fi

  sleep 1
done
