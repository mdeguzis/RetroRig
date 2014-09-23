#========================================================================
# Build Script for custom mame RetroRig PPA
#======================================================================== 
#
# Author      : Jens-Christian Lache
# Date        : 20140918
# Version     : 1:0.152
# Description : Version 0.152-0ubuntu1, patch level 0
#               
#
# ========================================================================

#define base version
PRE=1
BASE=0.152

# define patch level
PL=0

BRANCH=unpatched

clear
echo "#################################################################"
echo "Building custom mame Debian package (branch $BRANCH)"
echo "#################################################################"
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

sleep 2s

# Fetch build pkgs
if [[ -n "$2" ]]; then

  echo ""
  echo "##########################################"
  echo "Fetching necessary packages for build"
  echo "##########################################"
  echo ""



  #apt-get install packages
  sudo apt-get install -y build-essential fakeroot devscripts  autoconf autotools-dev binutils-dev \
                          debhelper libexpat1-dev libflac-dev libfontconfig1-dev libjpeg8-dev libportmidi-dev \
                          libqt4-dev libsdl-ttf2.0-dev libsdl1.2-dev libxinerama-dev subversion python-dev zlib1g-dev

else
  echo ""
  echo "skipping installation of build packages, use arbitrary second argument to get those packages"
  echo "e.g ./build-mame-ppa.sh compile update"
  echo ""
fi

echo ""
echo "##########################################"
echo "Setup build directory"
echo "##########################################"
echo ""
echo "~/packaging/mame"
# start in $HOME
cd

# remove old build directory
rm -rf ~/packaging/mame

#create build directory
mkdir -p ~/packaging/mame

#change to build directory
cd ~/packaging/mame

echo ""
echo "##########################################"
echo "Setup package base files"
echo "##########################################"

echo "dsc file"
cp ~/RetroRig/supplemental/mame/mame.dsc mame-$PRE:$BASE.$PL.dsc
sed -i "s|version_placeholder|$PRE:$BASE.$PL|g" "mame-$PRE:$BASE.$PL.dsc"

SRC_FOLDER=mame-$BASE.$PL

echo "original tarball"
wget http://archive.ubuntu.com/ubuntu/pool/multiverse/m/mame/mame_0.152.orig.tar.xz
tar xfJ mame_0.152.orig.tar.xz
rm mame_0.152.orig.tar.xz

file mame-0.152/

if [ $? -eq 0 ]; then  
    echo "successfully cloned"
else  
    echo "git clone failed, aborting"
    exit
fi 

mv mame-0.152/ $SRC_FOLDER

#change to source folder
cd $SRC_FOLDER

echo ""
echo "##########################################"
echo "Unpacking debian files"
echo "##########################################"
echo ""

#unpack
echo "unpacking template mupen64plus-video-glide64.debian.tar.xz"
tar xfz ~/RetroRig/supplemental/mame/mame.debian.tar.gz

echo "format"
rm -rf debian/source 
mkdir debian/source
cp ~/RetroRig/supplemental/mame/format debian/source/

echo "changelog"
cp ~/RetroRig/supplemental/mame/changelog debian/
sed -i "s|version_placeholder|$PRE:$BASE.$PL|g" debian/changelog

echo "control"
cp ~/RetroRig/supplemental/mame/control debian/

echo "patches"
rm -rf debian/patches

echo "clean up"
rm -rf debian/upstream/
rm -f debian/upstream-signing-key.pgp
rm -f debian/watch
rm -rf debian/backports

if [[ -n "$1" ]]; then
  arg0=$1
else
  # set up default
  arg0=source
fi

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
        ls -lah ~/packaging/mame
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
        ls -lah ~/packaging/mame
        echo ""
        echo ""
        echo "you can upload the package with dput ppa:beauman/retrorig ~/packaging/mame/mame_$BASE.$PL""_source.changes"
        echo "all good"
        echo ""
        echo ""

        while true; do
            read -p "Do you wish to upload the source package?    " yn
            case $yn in
                [Yy]* ) dput ppa:beauman/retrorig ~/packaging/mame/mame_*.$PL""_source.changes; break;;
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






