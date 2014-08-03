#========================================================================
# Build Script for custom XBMC RetroRig PPA
#======================================================================== 
#
# Author:  Michael DeGuzis and Jens-Christian, 
# Date:    20140801
# Version: Patch Level 6
# ========================================================================

#define base version
BASE=13.1

# define patch level
PL=5

#define xbmc branch to checkout
BRANCH=gotham-retrorig-pl$PL


clear
echo "#########################################################"
echo "Building custom xbmc Debian package (patch level $PL)"
echo "#########################################################"
echo ""
sleep 2s

# Fetch build pkgs
echo ""
echo "##########################################"
echo "Fetching necessary packages for build"
echo "##########################################"

#apt-get build-deps
sudo apt-get -y build-dep xbmc
#apt-get install packages
sudo apt-get install -y build-essential fakeroot devscripts automake autoconf autotools-dev fpc


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
cp ~/RetroRig/supplimental/xbmc/xbmc.dsc xbmc_$BASE.$PL.dsc
sed -i "s|version_placeholder|$BASE.$PL|g" "xbmc_$BASE.$PL.dsc"

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
rm -rf .git 
cd ..
tar cfj xbmc_$BASE.$PL.orig.tar.bz2 xbmc

echo "debian files"
wget --tries=50 "https://launchpad.net/~aap/+archive/ubuntu/xbmc-release-fernetmenta/+files/xbmc_13.1-27182~e41281c-ppa1~trusty.debian.tar.bz2"
#cp ~/temp/xbmc_13.1-27182~e41281c-ppa1~trusty.debian.tar.bz2 .

echo ""
echo "##########################################"
echo "Unpacking debian files"
echo "##########################################"
echo ""

#unpack
echo "unpacking template xbmc_13.1-27182~e41281c-ppa1~trusty.debian.tar.bz2"
tar xfj xbmc_13.1-27182~e41281c-ppa1~trusty.debian.tar.bz2
#remove template
rm xbmc_13.1-27182~e41281c-ppa1~trusty.debian.tar.bz2

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
cp ~/RetroRig/supplimental/xbmc/compat debian/

echo "control"
cp ~/RetroRig/supplimental/xbmc/control debian/

echo "rules"
cp ~/RetroRig/supplimental/xbmc/rules debian/

echo "setting up patches"
rm -rf debian/patches/*
rm -rf .pc/
rm debian/source/options debian/source/include-binaries

echo "format"
cp ~/RetroRig/supplimental/xbmc/format debian/source/

echo "changelog"
cp ~/RetroRig/supplimental/xbmc/changelog debian/
#dch -i


cd debian
rm xbmc-addon-dev.install xbmc-eventclients-common.install xbmc-eventclients-dev.examples xbmc-eventclients-dev.install xbmc-eventclients-j2me.install xbmc-eventclients-j2me.manpages xbmc-eventclients-ps3.install xbmc-eventclients-ps3.manpages xbmc-eventclients-wiiremote.install  xbmc-eventclients-wiiremote.manpages xbmc-eventclients-xbmc-send.install xbmc-eventclients-xbmc-send.manpages xbmc-pvr-dev.install xbmc-screensaver-dev.install xbmc-visualization-dev.install
cd ..

echo ""
echo "##########################################"
echo "Building binary package now"
echo "##########################################"



#build package from source, to check if it compiles
debuild -us -uc

if [ $? -eq 0 ]; then  
    echo ""
    echo "##########################################"
    echo "Building finished"
    echo "##########################################"
    echo ""
    ls -lah ~/packaging/xbmc
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
    echo "you can upload the package with dput ppa:beauman/retrorig ~/packaging/xbmc/xbmc_$BASE.$PL""_source.changes"
    echo "all good"
  else
    echo "debuild failed to generate the source package, aborting"
  fi
else
  echo "secret key not found, aborting"
fi







