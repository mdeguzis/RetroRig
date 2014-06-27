
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
# Author:  Jens-Christiansen, aka "beaumanvienna"
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
echo "Building new custom xbmc-bin deb pkg"
echo "##########################################"
echo ""
sleep 2s

echo ""
echo "##########################################"
echo "Removing old build files and directories"
echo "##########################################"

# remove xbmc,build dirs, and old files
rm -f build_log.txt
sudo rm -v /var/cache/apt/archives/*
sudo apt-get remove -y xbmc xbmc-bin
sudo rm -rfv /tmp/RetroRig
# rm -rfv ~/RetroRig
# rm -rfv ~/xbmc
rm -rfv ~/xbmc-bin_Gotham_V13.1_patched_for_RetroRig.deb

sudo add-apt-repository -y ppa:team-xbmc/ppa
sudo apt-get update
sudo apt-get install -y dialog git figlet xbmc

# Run option 1. "RetroRig installation"
# For this build script, we only need to clone the RetroRig directory

echo ""
echo "##########################################"
echo "Gathering RetroRig files from beta brach"
echo "##########################################"

cd
git clone https://github.com/ProfessorKaos64/RetroRig
# Only use the beta branch to build new pkgs please
cd RetroRig
git checkout beta
git pull

# After that you'll find two xbmc packages in /var/cache/apt/archives/:
# xbmc_2%3a13.1~git20140606.0917-gotham-0trusty_all.deb   and
# xbmc-bin_2%3a13.1~git20140606.0917-gotham-0trusty_amd64.deb

echo ""
echo "##########################################"
echo "Extracting old deb package"
echo "##########################################"

# copy over deb files for build
mkdir /tmp/RetroRig
cd /tmp/RetroRig
sudo cp -v /var/cache/apt/archives/xbmc-bin_*.deb xbmc-bin_original.deb

sudo dpkg-deb -x xbmc-bin_original.deb .
sudo dpkg-deb -e xbmc-bin_original.deb

#now compile xbmc
cd

# Fetch build pkgs
echo ""
echo "##########################################"
echo "Fetching necessary packages for build"
echo "##########################################"

sudo apt-get -y build-dep xbmc
sudo apt-get install -y automake autopoint bison build-essential ccache cmake curl cvs default-jre fp-compiler gawk gdc gettext git-core gperf libasound2-dev libass-dev libavcodec-dev libavfilter-dev libavformat-dev libavutil-dev libbluetooth-dev libbluray-dev libbluray1 libboost-dev libboost-thread-dev libbz2-dev libcap-dev libcdio-dev libcec-dev libcec1 libcrystalhd-dev libcrystalhd3 libcurl3 libcurl4-gnutls-dev libcwiid-dev libcwiid1 libdbus-1-dev libenca-dev libflac-dev libfontconfig-dev libfreetype6-dev libfribidi-dev libglew-dev libiso9660-dev libjasper-dev libjpeg-dev libltdl-dev liblzo2-dev libmad0-dev libmicrohttpd-dev libmodplug-dev libmp3lame-dev libmpeg2-4-dev libmpeg3-dev libmysqlclient-dev libnfs-dev libogg-dev libpcre3-dev libplist-dev libpng-dev libpostproc-dev libpulse-dev libsamplerate-dev libsdl-dev libsdl-gfx1.2-dev libsdl-image1.2-dev libsdl-mixer1.2-dev libshairport-dev libsmbclient-dev libsqlite3-dev libssh-dev libssl-dev libswscale-dev libtiff-dev libtinyxml-dev libtool libudev-dev libusb-dev libva-dev libva-egl1 libva-tpi1 libvdpau-dev libvorbisenc2 libxml2-dev libxmu-dev libxrandr-dev libxrender-dev libxslt1-dev libxt-dev libyajl-dev mesa-utils nasm pmount python-dev python-imaging python-sqlite swig unzip yasm zip zlib1g-dev

echo ""
echo "##########################################"
echo "Fetching latest stable XBMC Gotham release"
echo "##########################################"

# clone the xbmc source and checkout the stable 13.1 Gotham release
git clone git://github.com/xbmc/xbmc
cd xbmc
git checkout 13.1-Gotham
git pull
./bootstrap
./configure --disable-debug --prefix=/usr
echo "Making current pkg"
make

echo ""
echo "##########################################"
echo "Applying patches to xbmc"
echo "##########################################"
 
#restore baselined versions
git checkout xbmc/input/SDLJoystick.cpp
git checkout xbmc/Application.cpp  
git checkout xbmc/AppParamParser.cpp
#patch
patch xbmc/Application.cpp < $HOME/RetroRig/XBMC-cfgs/extra/xbmc_Application.cpp_-13.1-Gotham-interrupt_handler_for_SIGUSR1.patch
patch xbmc/AppParamParser.cpp < $HOME/RetroRig/XBMC-cfgs/extra/xbmc_AppParamParser.cpp_-13.1-Gotham-version_disply_shows_RetroRig_patch.patch
make

# strip out the bin executable
strip xbmc.bin

echo ""
echo "##########################################"
echo "Creating custom deb pkg"
echo "##########################################"
# replace old xbmc bin file with new one, repack, tidy up
# Notes for dpkg: http://ubuntuforums.org/showthread.php?t=1687348
sudo cp ./xbmc.bin /tmp/RetroRig/usr/lib/xbmc/xbmc.bin
cd /tmp/RetroRig
sudo dpkg-deb -b . xbmc-bin_Gotham_V13.1_patched_for_RetroRig.deb

# copy new deb to home dir

echo ""
echo "##########################################"
echo "Finishing deb build tasks for custom pkg"
echo "##########################################"

cp xbmc-bin_Gotham_V13.1_patched_for_RetroRig.deb ~/
cd
# don't remove xbmc here, since it will be done via retro rig
# the below line is for debugging only!

#sudo apt-get remove -y xbmc-bin

sudo dpkg -i xbmc-bin_Gotham_V13.1_patched_for_RetroRig.deb

# don't isntall xbmc here, since it will be done via retro rig
# the below line is for debugging only!

#sudo apt-get install -y xbmc

##############################
# miscelleaneous stuff
##############################

#get wmctrl
sudo apt-get install -y wmctrl

# Copy down these scripts during install 
# The pastes below are only for historical purposes, these are contained in RetroRig under:

# init-scripts/ps3_blu_controller/ps3_autodetect_xbmc.sh
# XBMC-cfgs/extra/startXBMC.sh
# init-scripts/ps3_blu_controller/rescan

# cp http://pastebin.com/LB6NNNaW to /etc/init.d/rescan
# cp http://pastebin.com/Xyz51edA to /usr/share/applications/ps3_autodetect_xbmc.sh
# cp http://pastebin.com/0Ripd3JW to /usr/share/applications/startXBMC.sh   (new version with XBMC_HOME)

echo ""
echo "##########################################"
echo "copying post install files"
echo "##########################################"

sudo cp -v "$HOME/RetroRig/XBMC-cfgs/extra/gp_autodetect_xbmc.sh" "/usr/share/applications"
sudo cp -v "$HOME/RetroRig/XBMC-cfgs/extra/startXBMC.sh" "/usr/share/applications"
sudo cp -v "$HOME/RetroRig/XBMC-cfgs/extra/rescan" "/etc/init.d"

echo ""
echo "##########################################"
echo "Fixing permisisons"
echo "##########################################"

sudo chmod 755 /usr/share/applications/startXBMC.sh 
sudo chmod 755 /usr/share/applications/gp_autodetect_xbmc.sh 
sudo chmod 755 /etc/init.d/rescan

echo ""
echo "##########################################"
echo "Updating init system"
echo "##########################################"

#register rescan service at upstart
sudo update-rc.d rescan defaults

# Launch /usr/share/applications/startXBMC.sh and set windowed mode in System > Video Output
# Decision pending on window code

echo ""
echo "##########################################"
ehco "Creating autostart entries"
echo "##########################################"

# Delete existing xbmc starter and create new one without terminal
# "startXBMC.sh" move to /etc/xdg/autostart
cp -v $HOME/RetroRig/XBMC-cfgs/extra/RetroRig.desktop $HOME/.config/autostart


