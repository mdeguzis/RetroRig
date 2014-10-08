#========================================================================
# Build Script for custom pcsx2 RetroRig PPA
#======================================================================== 
#
# Author:  Jens-Christian Lache
# Date:    20141003
# Version: Patch Level 2, reverted to unpatched version from github 
#          upstream, tagged 1.2.2 (multi monitor support from settings)
# ========================================================================

#define base version
BASE=2:1.2.2

# define patch level
PL=2

#define branch
BRANCH=retrorig-pl$PL

clear
echo "#####################################################################"
echo "Building custom pcsx2 Debian package (patch level $PL)"
echo "#####################################################################"
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

echo "This script needs to run on a 32bit environment."
echo ""

#check 32bit environment
isKernel32bit=`uname -a |grep i686`
if [[ -n "$isKernel32bit" ]]; then
  echo "32bit environment found, good"
else
  echo "32bit environment not found, aborting. Are you running a 64bit system? This script must run on a i686 system."
  exit 1
fi

# Fetch build pkgs
if [[ -n "$2" ]]; then

  echo ""
  echo "##########################################"
  echo "Fetching necessary packages for build"
  echo "##########################################"
  echo ""

  # pcsx2 emulator PPA
  sudo add-apt-repository -y ppa:gregory-hainaut/pcsx2.official.ppa
  sudo apt-get update

  #apt-get install packages
  sudo apt-get install -y build-essential fakeroot devscripts automake autoconf autotools-dev

  #get build dependencies
  sudo apt-get -y install cmake debhelper dpkg-dev \
	libaio-dev \
	libasound2-dev \
	libbz2-dev \
	libegl1-mesa-dev \
	libgl1-mesa-dev \
	libglew-dev \
	libglu1-mesa-dev \
	libgtk2.0-dev \
	libjpeg-dev \
	libsdl1.2-dev \
	libsoundtouch-dev \
	libsparsehash-dev \
	libwxbase2.8-dev \
	libwxgtk2.8-dev \
	libx11-dev \
	locales \
	libcg \
	nvidia-cg-toolkit \
	portaudio19-dev \
	zlib1g-dev \
	libxrandr-dev

else
  echo ""
  echo "skipping installation of build packages, use arbitrary second argument to get those packages"
  echo "e.g ./build-pcsx2-ppa.sh compile update"
  echo ""
fi

echo ""
echo "##########################################"
echo "Setup build directory"
echo "##########################################"
echo ""
echo "~/packaging/pcsx2"
# start in $HOME
cd

# remove old build directory
rm -rf ~/packaging/pcsx2

#create build directory
mkdir -p ~/packaging/pcsx2

#change to build directory
cd ~/packaging/pcsx2

echo ""
echo "##########################################"
echo "Setup package base files"
echo "##########################################"

echo "dsc file"
cp ~/RetroRig/supplemental/pcsx2/pcsx2.dsc pcsx2_$BASE.$PL.dsc
sed -i "s|version_placeholder|$BASE.$PL|g" "pcsx2_$BASE.$PL.dsc"

echo "original tarball"
git clone https://github.com/beaumanvienna/pcsx2

file pcsx2/

if [ $? -eq 0 ]; then  
    echo "successfully cloned"
else  
    echo "git clone failed, aborting"
    exit
fi 

cd pcsx2
git checkout $BRANCH
rm -rf .git .gitignore .hgeol .hgignore
cd ..

tar cfj pcsx2.orig.tar.bz2 pcsx2
mv pcsx2.orig.tar.bz2 pcsx2_$BASE.$PL.orig.tar.bz2

echo "debian files"
wget --tries=50 "http://www.libregeek.org/RetroRig/Ubuntu-Trusty/templates/pcsx2.debian.tar.xz"

echo ""
echo "##########################################"
echo "Unpacking debian files"
echo "##########################################"
echo ""

#unpack
echo "unpacking template pcsx2.debian.tar.xz"
tar xfJ pcsx2.debian.tar.xz
#remove template
rm pcsx2.debian.tar.xz

#move debian folder into source folder
mv debian/ pcsx2/

#change to source folder
cd pcsx2/

echo "compat"
cp ~/RetroRig/supplemental/pcsx2/compat debian/

echo "control"
cp ~/RetroRig/supplemental/pcsx2/control debian/

echo "rules"
cp ~/RetroRig/supplemental/pcsx2/rules debian/

echo "setting up patches"
rm -rf debian/patches/*
rm -rf .pc/
rm -f debian/source/options

echo "format"
mkdir -p debian/source
cp ~/RetroRig/supplemental/pcsx2/format debian/source/

echo "changelog"
cp ~/RetroRig/supplemental/pcsx2/changelog debian/
sed -i "s|version_placeholder|$BASE.$PL|g" debian/changelog
#dch -i

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
        ls -lah ~/packaging/pcsx2
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
        ls -lah ~/packaging/pcsx2
        echo ""
        echo ""
        echo "you can upload the package with dput ppa:beauman/retrorig ~/packaging/pcsx2/pcsx2_$BASE.$PL""_source.changes"
        echo "all good"
        echo ""
        echo ""

        while true; do
            read -p "Do you wish to upload the source package?    " yn
            case $yn in
                [Yy]* ) dput ppa:beauman/retrorig ~/packaging/pcsx2/pcsx2_*.$PL""_source.changes; break;;
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









