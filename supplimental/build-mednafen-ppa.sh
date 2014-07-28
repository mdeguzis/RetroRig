#!/bin/bash
# ==========================================================================
# Build script for custom mednafen Debian Package with dual head support
# ==========================================================================
#
#
# ==========================================================================
# Author:  Jens-Christian, aka "beaumanvienna"
# Date:    2014/07/28
# Version: Patch Level 1
# ==========================================================================

# define patch level
PL=1

clear
echo "#########################################################"
echo "Building custom mednafen Debian package (patch level $PL)"
echo "#########################################################"
echo ""
sleep 2s

# Fetch build pkgs
echo ""
echo "##########################################"
echo "Fetching necessary packages for build"
echo "##########################################"

#apt-get build-deps
sudo apt-get -y build-dep mednafen
#apt-get install packages
sudo apt-get install -y build-essential fakeroot devscripts automake autoconf autotools-dev libsdl2-dev


echo ""
echo "##########################################"
echo "Setup build directory"
echo "##########################################"

# start in $HOME
cd

# remove old build directory
rm -rf ~/packaging/mednafen

#create build directory
mkdir -p ~/packaging/mednafen

#change to build directory
cd ~/packaging/mednafen

echo ""
echo "##########################################"
echo "Get template files"
echo "##########################################"

wget --tries=50 "http://archive.ubuntu.com/ubuntu/pool/universe/m/mednafen/mednafen_0.9.33.3-1.dsc" 
wget --tries=50 "http://archive.ubuntu.com/ubuntu/pool/universe/m/mednafen/mednafen_0.9.33.3.orig.tar.bz2"
wget --tries=50 "http://archive.ubuntu.com/ubuntu/pool/universe/m/mednafen/mednafen_0.9.33.3-1.debian.tar.xz"


echo ""
echo "##########################################"
echo "Unpacking template files"
echo "##########################################"
echo ""

#unpack
echo "mednafen_0.9.33.3.orig.tar.bz2"
tar xfj mednafen_0.9.33.3.orig.tar.bz2
echo "mednafen_0.9.33.3-1.debian.tar.xz"
tar xfJ mednafen_0.9.33.3-1.debian.tar.xz

#move debian folder into source folder
mv debian/ mednafen/

echo ""
echo "##########################################"
echo "Building package now"
echo "Prompt 'Continue' when asked"
echo "##########################################"

#change to source folder
cd mednafen/

#build the package from source
debuild -us -uc

echo ""
echo "##########################################"
echo "Building finished"
echo "##########################################"
echo ""

ls -lah ~/packaging/mednafen


