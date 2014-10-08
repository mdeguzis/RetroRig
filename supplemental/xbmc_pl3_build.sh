#!/bin/bash

echo "##########################################"
echo "Generating patch level 3 packages"
echo "##########################################"

echo ""
echo "##########################################"
echo "Removing old build files"
echo "##########################################"

rm -rfv /tmp/RetroRig
rm -rfv /tmp/RetroRig-bin
rm -rfv /tmp/XBMC_build

echo ""
echo "##########################################"
echo "Extracting old deb packages"
echo "##########################################"

# download original xbmc-bin file for build
mkdir /tmp/RetroRig-bin
cd /tmp/RetroRig-bin
wget "http://www.libregeek.org/RetroRig/xbmc/xbmc-bin_Gotham_V13.1_patched_for_RetroRig_patchlevel_2.deb"

# unpack xbmc-bin
sudo dpkg-deb -x xbmc-bin_Gotham_V13.1_patched_for_RetroRig_patchlevel_2.deb .
sudo dpkg-deb -e xbmc-bin_Gotham_V13.1_patched_for_RetroRig_patchlevel_2.deb

# download original xbmc file for build
mkdir /tmp/RetroRig
cd /tmp/RetroRig
wget "http://www.libregeek.org/RetroRig/xbmc/xbmc_Gotham_V13.1_patched_for_RetroRig_patchlevel_2.deb"

# unpack xbmc
sudo dpkg-deb -x xbmc_Gotham_V13.1_patched_for_RetroRig_patchlevel_2.deb .
sudo dpkg-deb -e xbmc_Gotham_V13.1_patched_for_RetroRig_patchlevel_2.deb

echo ""
echo "##########################################"
echo "Replacing / adding files"
echo "##########################################"

sudo cp -v /usr/bin/xbmc-retrorig /tmp/RetroRig/usr/bin/

echo "SHA1 of current debug version is 94de5b8b9b80cae1ca3b08480ef1b24417386d10"
file /usr/lib/xbmc/xbmc.bin
sudo cp -v /usr/lib/xbmc/xbmc.bin /tmp/RetroRig-bin/usr/lib/xbmc/

echo ""
echo "##########################################"
echo "Creating custom deb packages"
echo "##########################################"

# create xbmc-bin
cd /tmp/RetroRig-bin
sudo dpkg-deb -b . xbmc-bin_Gotham_V13.1_patched_for_RetroRig_patchlevel_3.deb
# copy new deb to '/tmp/XBMC_build' dir
mkdir -p /tmp/XBMC_build
cp -v xbmc-bin_Gotham_V13.1_patched_for_RetroRig_patchlevel_3.deb /tmp/XBMC_build

# create xbmc
cd /tmp/RetroRig
# create package
sudo dpkg-deb -b . xbmc_Gotham_V13.1_patched_for_RetroRig_patchlevel_3.deb
# copy new deb to '/tmp/XBMC_build' dir
cp -v xbmc_Gotham_V13.1_patched_for_RetroRig_patchlevel_3.deb /tmp/XBMC_build

echo "Please upload the files to libregeek and change 
RetroRig/scriptmodules/setup.shinc accordingly"
