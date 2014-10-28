#!/bin/bash
# ==========================================================================
# Build script for XBMC 
# ==========================================================================
#
# ==========================================================================
# Author:  Jens-Christian, aka "beaumanvienna"
# Contribitions: Michael DeGuzis, aka "ProfessorKaos64"
# Date:    20141004
# Version: Patch Level 9
# ==========================================================================

PL=9
BRANCH=retrorig-pl$PL

clear
echo "#######################################################"
echo "Building custom XBMC Debian packages (patch level $PL)"
echo "#######################################################"
echo ""
sleep 2s

echo ""
echo "##########################################"
echo "Removing old build files and directories"
echo "##########################################"


# create previous build directory for saving old build files
mkdir -p ~/XBMC-beforeBuild

#just in case it's not the first compile run
rm -rf ~/XBMC-beforeBuild/*

# backup old build dir
mv -v ~/xbmc ~/XBMC-beforeBuild

#compile xbmc
cd

# Fetch build pkgs
echo ""
echo "##########################################"
echo "Fetching necessary packages for build"
echo "##########################################"

#apt-get build-deps
sudo apt-get -y build-dep xbmc
#apt-get install packages
sudo apt-get install -y automake autopoint bison build-essential ccache cmake curl cvs default-jre fp-compiler gawk gdc gettext git-core gperf libasound2-dev libass-dev libavcodec-dev libavfilter-dev libavformat-dev libavutil-dev libbluetooth-dev libbluray-dev libbluray1 libboost-dev libboost-thread-dev libbz2-dev libcap-dev libcdio-dev libcec-dev libcec2 libcrystalhd-dev libcrystalhd3 libcurl3 libcurl4-gnutls-dev libcwiid-dev libcwiid1 libdbus-1-dev libenca-dev libflac-dev libfontconfig-dev libfreetype6-dev libfribidi-dev libglew-dev libiso9660-dev libjasper-dev libjpeg-dev libltdl-dev liblzo2-dev libmad0-dev libmicrohttpd-dev libmodplug-dev libmp3lame-dev libmpeg2-4-dev libmpeg3-dev libmysqlclient-dev libnfs-dev libogg-dev libpcre3-dev libplist-dev libpng-dev libpostproc-dev libpulse-dev libsamplerate-dev libsdl-dev libsdl-gfx1.2-dev libsdl-image1.2-dev libsdl-mixer1.2-dev libshairport-dev libsmbclient-dev libsqlite3-dev libssh-dev libssl-dev libswscale-dev libtiff-dev libtinyxml-dev libtool libudev-dev libusb-dev libva-dev libva-egl1 libva-tpi1 libvdpau-dev libvorbisenc2 libxml2-dev libxmu-dev libxrandr-dev libxrender-dev libxslt1-dev libxt-dev libyajl-dev mesa-utils nasm pmount python-dev python-imaging python-sqlite swig unzip yasm zip zlib1g-dev libafpclient-dev libshairplay-dev

echo ""
echo "##########################################"
echo "Fetching beaumanviennas XBMC repository"
echo "##########################################"

# clone the xbmc source based on fernetMenta/xbmc and checkout Gotham 13.1 based patch level 
# This XBMC version is used in project OpenElec.
git clone https://github.com/beaumanvienna/xbmc
cd xbmc
git checkout $BRANCH
git pull
./bootstrap
#./configure --disable-debug --prefix=/usr
./configure --prefix=/usr
echo "Making current pkg"
make -j8


