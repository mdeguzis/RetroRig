#!/bin/bash
# ==========================================================================
# Build script for custom mednafen Debian Package with dual head support
# ==========================================================================
#
#
# ==========================================================================
# Author:  Jens-Christian, aka "beaumanvienna"
# Date:    2014/07/24
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


echo ""
echo "##########################################"
echo "Removing old build files and directories"
echo "##########################################"

# create previous build directory for saving old build files
mkdir -p ~/mednafen-git-beforeBuild

# remove mednafen
sudo apt-get remove -y mednafen

# backup old build dir
mv -v ~/mednafen-git ~/mednafen-git-beforeBuild

# remove old files and directories
rm -rfv /tmp/mednafen_build
rm -rfv /tmp/mednafen
rm -rfv "~/mednafen-patched-for-retrorig-patchlevel-*-0trusty.deb"

# Fetch build pkgs
echo ""
echo "##########################################"
echo "Fetching necessary packages for build"
echo "##########################################"

#apt-get build-deps
sudo apt-get -y build-dep xbmc
#apt-get install packages
sudo apt-get install -y automake autopoint bison build-essential ccache cmake curl cvs default-jre fp-compiler gawk gdc gettext git-core gperf libasound2-dev libass-dev libavcodec-dev libavfilter-dev libavformat-dev libavutil-dev libbluetooth-dev libbluray-dev libbluray1 libboost-dev libboost-thread-dev libbz2-dev libcap-dev libcdio-dev libcec-dev libcec1 libcrystalhd-dev libcrystalhd3 libcurl3 libcurl4-gnutls-dev libcwiid-dev libcwiid1 libdbus-1-dev libenca-dev libflac-dev libfontconfig-dev libfreetype6-dev libfribidi-dev libglew-dev libiso9660-dev libjasper-dev libjpeg-dev libltdl-dev liblzo2-dev libmad0-dev libmicrohttpd-dev libmodplug-dev libmp3lame-dev libmpeg2-4-dev libmpeg3-dev libmysqlclient-dev libnfs-dev libogg-dev libpcre3-dev libplist-dev libpng-dev libpostproc-dev libpulse-dev libsamplerate-dev libsdl-dev libsdl-gfx1.2-dev libsdl-image1.2-dev libsdl-mixer1.2-dev libshairport-dev libsmbclient-dev libsqlite3-dev libssh-dev libssl-dev libswscale-dev libtiff-dev libtinyxml-dev libtool libudev-dev libusb-dev libva-dev libva-egl1 libva-tpi1 libvdpau-dev libvorbisenc2 libxml2-dev libxmu-dev libxrandr-dev libxrender-dev libxslt1-dev libxt-dev libyajl-dev mesa-utils nasm pmount python-dev python-imaging python-sqlite swig unzip yasm zip zlib1g-dev libafpclient-dev libshairplay-dev libsndfile1-dev autoconf autotools-dev libsdl2-dev


echo ""
echo "##############################################"
echo "Fetching beaumanviennas mednafen repository"
echo "##############################################"

cd
git clone https://github.com/beaumanvienna/mednafen-git
cd mednafen-git
git checkout mednafen-0.9.36.2-SDL2-dual-head
autoreconf -fi
./configure
make -j8

sudo make install
sudo strip /usr/local/bin/mednafen


echo ""
echo "##########################################"
echo "Extracting original Debian package"
echo "##########################################"

mkdir /tmp/mednafen
mkdir /tmp/mednafen_build

# download original mednafen as template
cd /tmp/mednafen
wget --tries=50 "http://www.libregeek.org/RetroRig/old_pkgs/mednafen_original.deb"
cp ~/mednafen_original.deb /tmp/mednafen

# unpack mednafen template
dpkg-deb -x mednafen_original.deb .
dpkg-deb -e mednafen_original.deb
# clean packed debs
sudo rm -f *.deb

#remove original bin file
rm usr/games/mednafen

#copy mednafen
cp /usr/local/bin/mednafen /tmp/mednafen/usr/games/

#remove Debian original files
rm /tmp/mednafen/DEBIAN/control
rm /tmp/mednafen/DEBIAN/md5sums

#copy/create Debian customized files
cp ~/RetroRig/supplemental/control.mednafen /tmp/mednafen/DEBIAN/control
find /tmp/mednafen/usr -type f -exec md5sum {} \; > /tmp/mednafen/DEBIAN/md5sums

# create package
dpkg-deb -b . "mednafen-patched-for-retrorig-patchlevel-$PL-0trusty.deb"
# copy new deb to home dir
cp "mednafen-patched-for-retrorig-patchlevel-$PL-0trusty.deb" /tmp/mednafen_build











