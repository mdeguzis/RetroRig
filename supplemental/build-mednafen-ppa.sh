#!/bin/bash
# ==========================================================================
# Build script for custom mednafen Debian Package with dual head support
# ==========================================================================
#
#
# ==========================================================================
# Author:  Jens-Christian, aka "beaumanvienna"
# Date:    2014/10/12
# Version: Patch Level 2 / upload try 2
#
#          update prefix of version to superseed getdeb repository
#
# ==========================================================================

#define prefix
PRE=1:

#define base version
BASE=0.9.36.2

# define patch level
PL=2.2

#define mednafen branch to checkout
BRANCH=mednafen-0.9.36.2-SDL2-dual-head

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
sudo apt-get install -y build-essential fakeroot devscripts automake autoconf \
                        autotools-dev libsdl2-dev libmpcdec-dev dh-autoreconf \
                        libjack-dev libsndfile1-dev libvorbisidec-dev libjack0 dput


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
echo "Setup package base files"
echo "##########################################"

echo "dsc file"
cp ~/RetroRig/supplemental/mednafen/mednafen.dsc mednafen_$PRE$BASE.$PL.dsc
sed -i "s|version_placeholder|$BASE.$PL|g" "mednafen_$PRE$BASE.$PL.dsc"

echo "original tarball"
git clone https://github.com/beaumanvienna/mednafen-git 
file mednafen-git/

if [ $? -eq 0 ]; then  
    echo "successfully cloned"
else  
    echo "git clone failed, aborting"
    exit
fi 

mv mednafen-git/ mednafen
cd mednafen
git checkout $BRANCH
rm -rf .git instructions.txt patch-from.0.9.36.2-to-SDL2.txt
cd ..
tar cfj mednafen.tar.bz2 mednafen
mv mednafen.tar.bz2 "mednafen_$BASE.$PL.orig.tar.bz2"

echo "debian files"
wget --tries=50 "http://www.libregeek.org/RetroRig/Ubuntu-Trusty/templates/mednafen.debian.tar.xz"

echo ""
echo "##########################################"
echo "Unpacking debian files"
echo "##########################################"
echo ""

#unpack
echo "unpacking template mednafen.debian.tar.xz"
tar xfJ mednafen.debian.tar.xz
#remove template
rm mednafen.debian.tar.xz

#move debian folder into source folder
mv debian/ mednafen/

echo ""
echo "##########################################"
echo "Setting up debian files"
echo "##########################################"
echo ""

#change to source folder
cd mednafen/

echo "control"
cp ~/RetroRig/supplemental/mednafen/control debian/

echo "rules"
cp ~/RetroRig/supplemental/mednafen/rules debian/


echo "changelog"
cp ~/RetroRig/supplemental/mednafen/changelog debian/
sed -i "s|version_placeholder|$PRE$BASE.$PL|g" debian/changelog

echo "setting up patches"
rm debian/patches/*
rm -rf .pc/


echo ""
echo "##########################################"
echo "Building binary package now"
echo "Prompt 'Continue' when asked"
echo "##########################################"



#build package from source, to check if it compiles
debuild -us -uc

if [ $? -eq 0 ]; then  
    echo ""
    echo "##########################################"
    echo "Building finished"
    echo "##########################################"
    echo ""
    ls -lah ~/packaging/mednafen
    sleep 10
else  
    echo "debuild failed to generate the binary package, aborting"
    exit
fi 


#get secret key
gpgkey=`gpg --list-secret-keys|grep "sec   "|cut -f 2 -d '/'|cut -f 1 -d ' '`

if [[ -n "$gpgkey" ]]; then

  echo ""
  echo "##########################################"
  echo "Building source package"
  echo "##########################################"
  echo ""
  echo ""
  echo ""
  echo "****** please copy your gpg passphrase into the clipboard now ******"
  sleep 20

  debuild -S -sa -k$gpgkey

  if [ $? -eq 0 ]; then
    echo "you can upload the package with dput ppa:beauman/retrorig ~/packaging/mednafen/mednafen_$BASE.$PL""_source.changes"
    echo "all good"
  else
    echo "debuild failed to generate the source package, aborting"
  fi
else
  echo "secret key not found, aborting"
fi




