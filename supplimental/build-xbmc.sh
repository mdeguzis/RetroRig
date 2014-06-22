
# ==========================================================================
# How to build the debian package for xbmc-retrorig plus miscellaneous stuff
# ==========================================================================
# Author:  Jens-Christiansen, aka "beaumanvienna"
# Date:    20140622
# Version: Beta

#Starting point is a plain ubuntu install.

#Get and install RetroRig (done via normal install script, posted for science)

sudo apt-get update
sudo apt-get install dialog git figlet
sudo rm /var/cache/apt/archives/*
cd
git clone https://github.com/ProfessorKaos64/RetroRig
cd RetroRig 
git checkout beta
sudo ./retrorig_setup.sh

# Run option 1. "RetroRig installation"
# Exit script from main screen to continue on

# After that you'll find two xbmc packages in /var/cache/apt/archives/:
# xbmc_2%3a13.1~git20140606.0917-gotham-0trusty_all.deb   and
# xbmc-bin_2%3a13.1~git20140606.0917-gotham-0trusty_amd64.deb

mkdir /tmp/RetroRig
cd /tmp/RetroRig
sudo cp -v /var/cache/apt/archives/xbmc-bin_*.deb xbmc-bin_original.deb

dpkg-deb -x xbmc-bin_original.deb .
dpkg-deb -e xbmc-bin_original.deb

#now compile xbmc
exit
cd

sudo apt-get build-dep xbmc
sudo apt-get install -y automake autopoint bison build-essential ccache cmake curl cvs default-jre fp-compiler gawk gdc gettext git-core gperf libasound2-dev libass-dev libavcodec-dev libavfilter-dev libavformat-dev libavutil-dev libbluetooth-dev libbluray-dev libbluray1 libboost-dev libboost-thread-dev libbz2-dev libcap-dev libcdio-dev libcec-dev libcec1 libcrystalhd-dev libcrystalhd3 libcurl3 libcurl4-gnutls-dev libcwiid-dev libcwiid1 libdbus-1-dev libenca-dev libflac-dev libfontconfig-dev libfreetype6-dev libfribidi-dev libglew-dev libiso9660-dev libjasper-dev libjpeg-dev libltdl-dev liblzo2-dev libmad0-dev libmicrohttpd-dev libmodplug-dev libmp3lame-dev libmpeg2-4-dev libmpeg3-dev libmysqlclient-dev libnfs-dev libogg-dev libpcre3-dev libplist-dev libpng-dev libpostproc-dev libpulse-dev libsamplerate-dev libsdl-dev libsdl-gfx1.2-dev libsdl-image1.2-dev libsdl-mixer1.2-dev libshairport-dev libsmbclient-dev libsqlite3-dev libssh-dev libssl-dev libswscale-dev libtiff-dev libtinyxml-dev libtool libudev-dev libusb-dev libva-dev libva-egl1 libva-tpi1 libvdpau-dev libvorbisenc2 libxml2-dev libxmu-dev libxrandr-dev libxrender-dev libxslt1-dev libxt-dev libyajl-dev mesa-utils nasm pmount python-dev python-imaging python-sqlite swig unzip yasm zip zlib1g-dev -y

git clone git://github.com/xbmc/xbmc
cd xbmc
git checkout 13.1-Gotham
./bootstrap
./configure
make

# copy the patch to from the RetroRig root DIR: 'XBMC-cfgs/extra/SDLJoystick.cpp' to '~/xbmc/xbmc/input/SDLJoystick.cpp' 
# Interactive mode to confirm action is valid

sudo cp -iv ~/RetroRig/XBMC-cfgs/extra/SDLJoystick.cpp
make
# strip out the bin executable
strip xbmc.bin

# replace old xbmc bin file with new one, repack, tidy up
# The first line here will go in the main script
sudo cp ./xbmc.bin /tmp/RetroRig/usr/lib/xbmc/xbmc.bin
cd /tmp/RetroRig
sudo dpkg-deb -b . xbmc-bin_Gotham_V13.1_patched_for_RetroRig.deb

# copy new deb to home dir
# Lines 1, 3, and 4 will get worked into script
cp xbmc-bin_Gotham_V13.1_patched_for_RetroRig.deb ~/
cd
sudo apt-get remove xbmc-bin
sudo dpkg -i xbmc-bin_Gotham_V13.1_patched_for_RetroRig.deb
sudo apt-get install xbmc

##############################
# miscelleaneous stuff
##############################

#get wmctrl
sudo apt-get install wmctrl

# Copy down these scripts during install 

# cp http://pastebin.com/LB6NNNaW to /etc/init.d/rescan
# cp http://pastebin.com/Xyz51edA to /usr/share/applications/ps3_autodetect_xbmc.sh
# cp http://pastebin.com/0Ripd3JW to /usr/share/applications/startXBMC.sh   (new version with XBMC_HOME)

sudo cp -v "~/RetroRig/init-scripts/ps3_blu_controller/ps3_autodetect_xbmc.sh" "/usr/share/applications"
sudo cp -v "~/RetroRig/RetroRig/XBMC-cfgs/extra/startXBMC.sh" "/usr/share/applications"
sudo cp -v "~/RetroRig/init-scripts/ps3_blu_controller/rescan" "/etc/init.d"

sudo chmod 755 /usr/share/applications/startXBMC.sh 
sudo chmod 755 /usr/share/applications/ps3_autodetect_xbmc.sh 
sudo chmod 755 /etc/init.d/rescan

#register rescan service at upstart
sudo update-rc.d rescan defaults

# Launch /usr/share/applications/startXBMC.sh and set windowed mode in System > Video Output
# Decision pending on window code

# Delete existing xbmc starter and create new one without terminal
gnome-session-properties
