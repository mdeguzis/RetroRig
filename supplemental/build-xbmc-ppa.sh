#========================================================================
# Build Script for custom XBMC RetroRig PPA
#======================================================================== 
#
# Author:  Michael DeGuzis and Jens-Christian Lache, 
# Date:    20141025
# Version: Patch Level 12
# Changed: 
#
#          Disabled GUI dialog 
#          "Add-on is incompatible due to unmet dependencies."
#
#          Disabled dbus messages for UDev
#
#          Recreate main window after game exit (for Gnome Desktop)
#
# ========================================================================

#define base version
BASE=3:14.0

# define patch level
PL=12

#define xbmc branch to checkout
BRANCH=retrorig-pl$PL

UPLOAD_TRY=2

PPA="ppa:beauman/retrorig"

clear
echo "#########################################################"
echo "Building custom xbmc Debian package (patch level $PL)"
echo "#########################################################"
echo ""
if [[ -n "$1" ]]; then

  echo ""
  echo "build target is $1"
  echo ""

else
  echo ""
  echo "build target is source"
  echo ""
fi

#set build target
if [[ -n "$1" ]]; then
  arg0=$1
else
  # set up default
  arg0=source
fi

sleep 2s

# Fetch build pkgs
if [[ -n "$2" ]]; then

  echo ""
  echo "##########################################"
  echo "Fetching necessary packages for build"
  echo "##########################################"
  echo ""

  # needed for ffmpeg-xbmc-dev
  sudo add-apt-repository -y ppa:wsnipex/xbmc-fernetmenta-master
  sudo add-apt-repository -y ppa:wsnipex/xbmc-next
  sudo apt-get update

  #apt-get build-deps
  sudo apt-get -y build-dep xbmc
  #apt-get install packages
  sudo apt-get install -y build-essential fakeroot devscripts automake autoconf autotools-dev fpc ffmpeg-xbmc-dev

else
  echo ""
  echo "skipping installation of build packages, use arbitrary second argument to get those packages"
  echo "e.g ./build-xbmc-ppa.sh compile update"
  echo ""
fi

echo ""
echo "##########################################"
echo "Setup build directory"
echo "##########################################"
echo ""
echo "~/packaging/xbmc"
# start in $HOME
cd

# remove old build directory
rm -rf ~/packaging/xbmc

#create build directory
mkdir -p ~/packaging/xbmc

#change to build directory
cd ~/packaging/xbmc

echo ""
echo "##########################################"
echo "Setup package base files"
echo "##########################################"

echo "dsc file"
cp ~/RetroRig/supplemental/xbmc/xbmc.dsc xbmc_$BASE.$PL.$UPLOAD_TRY.dsc
sed -i "s|version_placeholder|$BASE.$PL.$UPLOAD_TRY|g" "xbmc_$BASE.$PL.$UPLOAD_TRY.dsc"

echo "original tarball"
git clone https://github.com/beaumanvienna/xbmc 
#cp -r ~/xbmc .

file xbmc/

if [ $? -eq 0 ]; then  
    echo "successfully cloned"
else  
    echo "git clone failed, aborting"
    exit
fi 

cd xbmc
git checkout $BRANCH

if [ "$arg0" == "source" ]; then
  echo "removing .git folder"
  rm -rf .git 
else
  echo "keeping .git folder"
fi

cp ~/RetroRig/Artwork/XBMC/Splash_retrorig.png ~/RetroRig/Artwork/XBMC/Splash.png media/
cd ..

echo "debian files"
wget --tries=50 "http://www.libregeek.org/RetroRig/Ubuntu-Trusty/templates/xbmc.debian.tar.bz2"
echo ""
echo "##########################################"
echo "Unpacking debian files"
echo "##########################################"
echo ""

#unpack
echo "unpacking template xbmc.debian.tar.bz2"
tar xfj xbmc.debian.tar.bz2
#remove template
rm xbmc.debian.tar.bz2

#move debian folder into source folder
mv debian/ xbmc/

echo ""
echo "##########################################"
echo "Setting up debian files"
echo "##########################################"
echo ""

#change to source folder
cd xbmc/

echo "compat"
cp ~/RetroRig/supplemental/xbmc/compat debian/

echo "control"
cp ~/RetroRig/supplemental/xbmc/control debian/

echo "rules"
cp ~/RetroRig/supplemental/xbmc/rules debian/

echo "setting up patches"
rm -rf debian/patches/*
rm -rf .pc/
rm debian/source/options debian/source/include-binaries

echo "format"
cp ~/RetroRig/supplemental/xbmc/format debian/source/

echo "changelog"
cp ~/RetroRig/supplemental/xbmc/changelog debian/
sed -i "s|version_placeholder|$BASE.$PL.$UPLOAD_TRY|g" debian/changelog
#dch -i


cd debian
rm xbmc-addon-dev.install xbmc-eventclients-common.install xbmc-eventclients-dev.examples xbmc-eventclients-dev.install xbmc-eventclients-j2me.install xbmc-eventclients-j2me.manpages xbmc-eventclients-ps3.install xbmc-eventclients-ps3.manpages xbmc-eventclients-wiiremote.install  xbmc-eventclients-wiiremote.manpages xbmc-eventclients-xbmc-send.install xbmc-eventclients-xbmc-send.manpages xbmc-pvr-dev.install xbmc-screensaver-dev.install xbmc-visualization-dev.install
cd ..

#disable google test suite
sed -i "s|configure_gtest=yes|configure_gtest=no|g" configure.in

wget --tries=50 -P /tmp "http://www.libregeek.org/RetroRig/libs/ffmpeg-2.4-Helix-alpha4.tar.gz"
cp /tmp/ffmpeg-2.4-Helix-alpha4.tar.gz ~/packaging/xbmc/xbmc/tools/depends/target/ffmpeg/ffmpeg-2.4-Helix-alpha4.tar.gz

case "$arg0" in
  compile)
    echo ""
    echo "##########################################"
    echo "Building binary package now"
    echo "##########################################"
    echo ""

    #build binary package
    debuild -us -uc

    if [ $? -eq 0 ]; then  
        echo ""
        echo "##########################################"
        echo "Building finished"
        echo "##########################################"
        echo ""
        ls -lah ~/packaging/xbmc
         exit 0
    else  
        echo "debuild failed to generate the binary package, aborting"
        exit 1
    fi 
    ;;
  source)
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
      echo "****** please copy your gpg passphrase into the clipboard ******"
      echo ""
      sleep 10

      debuild -S -sa -k$gpgkey

      if [ $? -eq 0 ]; then
        echo ""
        echo ""
        ls -lah ~/packaging/xbmc
        echo ""
        echo ""
        echo "you can upload the package with dput $PPA ~/packaging/xbmc/xbmc_*_source.changes"
        echo "all good"
        echo ""
        echo ""

        while true; do
            read -p "Do you wish to upload the source package?    " yn
            case $yn in
                [Yy]* ) dput $PPA ~/packaging/xbmc/xbmc_*_source.changes; break;;
                [Nn]* ) break;;
                * ) echo "Please answer yes or no.";;
            esac
        done

        exit 0
      else
        echo "debuild failed to generate the source package, aborting"
        exit 1
      fi
    else
      echo "secret key not found, aborting"
      exit 1
    fi
    ;;
esac









