
# ==========================================================================
# Build Script for custom XBMC deb package with PS3 Hotplugging
# ==========================================================================
#
# If sucessful, this will be tested against the Xbox 360 controller as well.
# If it can co-exist (the new build), will be used as normal. If it cannot,
# It will be only installed as part of the PS3 gamepad selection
# It may be useful to tee the output to a log file: 
# './build-xbmc | tee log.txt'
#
# ==========================================================================
# Author:  Jens-Christian, aka "beaumanvienna"
# Contribitions: Michael DeGuzis, aka "ProfessorKaos64"
# Date:    20140622
# Version: Beta
# ==========================================================================

# Starting point is a plain ubuntu install.
# Get and install RetroRig (done via normal install script, posted for science)

###############################################################
# sudo apt-get update
# sudo apt-get install dialog git figlet
# sudo rm /var/cache/apt/archives/*
# cd
# git clone https://github.com/ProfessorKaos64/RetroRig
# cd RetroRig 
# git checkout beta
# sudo ./retrorig_setup.sh
###############################################################

# Instead, add the xbmc PPA manually and do it here so we don't 
# Necessarily need to install a lot of extra stuff to do a new package.

clear
echo "##########################################"
echo "Building new custom xbmc pkg for PPA"
echo "##########################################"
echo ""
sleep 2s

echo ""
echo "##########################################"
echo "Removing old build files and directories"
echo "##########################################"
cd
rm -rf XBMC_BUILD/xbmc
sudo apt-get autoremove xbmc

# Fetch build pkgs
echo ""
echo "##########################################"
echo "Fetching necessary packages for build"
echo "##########################################"

sudo add-apt-repository -y ppa:team-xbmc/ppa
sudo apt-get update
sudo apt-get install -y dialog git figlet \
build-dep xbmc dh-make build-essential packaging-dev

#################################################
# Missing packages from build-dep, xbmc packages 
# should be listed below
#################################################

# This library was missing during a first attempt 
# build:
sudo apt-get install -y libxlst-dev

################################################


#####################################################################
# The line above this will build all the packages listed below...
#####################################################################

#sudo apt-get install -y automake autopoint bison build-essential ccache cmake curl cvs default-jre fp-compiler gawk gdc gettext git-core gperf libasound2-dev libass-dev libavcodec-dev libavfilter-dev libavformat-dev libavutil-dev libbluetooth-dev libbluray-dev libbluray1 libboost-dev libboost-thread-dev libbz2-dev libcap-dev libcdio-dev libcec-dev libcec1 libcrystalhd-dev libcrystalhd3 libcurl3 libcurl4-gnutls-dev libcwiid-dev libcwiid1 libdbus-1-dev libenca-dev libflac-dev libfontconfig-dev libfreetype6-dev libfribidi-dev libglew-dev libiso9660-dev libjasper-dev libjpeg-dev libltdl-dev liblzo2-dev libmad0-dev libmicrohttpd-dev libmodplug-dev libmp3lame-dev libmpeg2-4-dev libmpeg3-dev libmysqlclient-dev libnfs-dev libogg-dev libpcre3-dev libplist-dev libpng-dev libpostproc-dev libpulse-dev libsamplerate-dev libsdl-dev libsdl-gfx1.2-dev libsdl-image1.2-dev libsdl-mixer1.2-dev libshairport-dev libsmbclient-dev libsqlite3-dev libssh-dev libssl-dev libswscale-dev libtiff-dev libtinyxml-dev libtool libudev-dev libusb-dev libva-dev libva-egl1 libva-tpi1 libvdpau-dev libvorbisenc2 libxml2-dev libxmu-dev libxrandr-dev libxrender-dev libxslt1-dev libxt-dev libyajl-dev mesa-utils nasm pmount python-dev python-imaging python-sqlite swig unzip yasm zip zlib1g-dev libafpclient-dev libshairplay-dev

#####################################################################

echo ""
echo "##########################################"
echo "Fetching latest stable XBMC Gotham release"
echo "##########################################"

# clone the xbmc source based on fernetMenta/xbmc and checkout the stable 13.1 Gotham release
# This XBMC version is used in project OpenElec.

git clone https://github.com/beaumanvienna/xbmc
cd xbmc
git checkout gotham-retrorig
git pull

echo ""
echo "##########################################"
echo "Creating original archive..."
echo "##########################################"

# The Ubuntu package guide notes:
# The first stage in packaging is to get the released tar from upstream
# (we call the authors of applications “upstream”) and check that it
# compiles and runs.

# Note from pk: I am not sure how strict having a tar ball is
# These actions are subject to change

cd ..
# rename origin directory
mv "xbmc/" "xbmc-retrorig/"
# Create archive
tar -zcvf "xbmc-retrorig.tar.gz" "xbmc-retrorig/"
# jump back to build directory
cd xbmc-retrorig
clear

echo ""
echo "##########################################"
echo "Bootstrapping..."
echo "##########################################"
./bootstrap

echo ""
echo "##########################################"
echo "Configuring..."
echo "##########################################"
./configure --disable-debug --prefix=/usr


echo ""
echo "##########################################"
echo "Making package..."
echo "##########################################"
sleep 3s
clear
# Tip: by adding -j<number> to the make command, you describe how many
# concurrent jobs will be used. So for dualcore the command is: 
make -j2

echo ""
echo "##########################################"
echo "Installing from source..."
echo "##########################################"

# strip out the bin executable
strip xbmc.bin
#install
clear
echo "Installing built source files"
sleep 3s
sudo make install

echo ""
echo "##########################################"
echo ""
echo "##########################################"





