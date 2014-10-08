#========================================================================
# Build Script for custom gens RetroRig PPA
#======================================================================== 
#
# Author      : Jens-Christian Lache
# Date        : 20140917
# Version     : 2.16.7.2
# Description : Version 2.16.7 from gerbilsoft, patch level 2
#               
#               Ported to SDL2.
#
# ========================================================================

#define base version
PRE=1
BASE=2.16.7

# define patch level
PL=2.2

#define branch
BRANCH=retrorig-pl2

clear
echo "#################################################################"
echo "Building custom gens Debian package (branch $BRANCH)"
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



  #apt-get install packages
  sudo apt-get install -y build-essential fakeroot devscripts  autoconf autotools-dev binutils-dev \
			  debhelper autotools-dev automake1.10 pkg-config nasm libsdl2-i386-dev \
                          libglib2.0-dev libgtk2.0-dev mesa-common-dev libgl1-mesa-dev zlib1g-dev libpng12-dev

else
  echo ""
  echo "skipping installation of build packages, use arbitrary second argument to get those packages"
  echo "e.g ./build-gens-ppa.sh compile update"
  echo ""
fi

echo ""
echo "##########################################"
echo "Setup build directory"
echo "##########################################"
echo ""
echo "~/packaging/gens"
# start in $HOME
cd

# remove old build directory
rm -rf ~/packaging/gens

#create build directory
mkdir -p ~/packaging/gens

#change to build directory
cd ~/packaging/gens

echo ""
echo "##########################################"
echo "Setup package base files"
echo "##########################################"

echo "dsc file"
cp ~/RetroRig/supplemental/gens/gens.dsc gens-$PRE:$BASE.$PL.dsc
sed -i "s|version_placeholder|$PRE:$BASE.$PL|g" "gens-$PRE:$BASE.$PL.dsc"

SRC_FOLDER=gens-$BASE.$PL

echo "original tarball"
git clone https://github.com/beaumanvienna/gens-gs
file gens-gs/

if [ $? -eq 0 ]; then  
    echo "successfully cloned"
else  
    echo "git clone failed, aborting"
    exit
fi 

mv gens-gs/ $SRC_FOLDER

#change to source folder
cd $SRC_FOLDER

git checkout $BRANCH
rm -rf .git .gitignore

echo "changelog"
cp ~/RetroRig/supplemental/gens/changelog debian/
sed -i "s|version_placeholder|$PRE:$BASE.$PL|g" debian/changelog

echo "control"
cp ~/RetroRig/supplemental/gens/control debian/

#get Makefiles straight
aclocal && autoconf && autoreconf -i && automake --add-missing

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
        ls -lah ~/packaging/gens
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
        ls -lah ~/packaging/gens
        echo ""
        echo ""
        echo "you can upload the package with dput ppa:beauman/retrorig ~/packaging/gens/gens_$BASE.$PL""_source.changes"
        echo "all good"
        echo ""
        echo ""

        while true; do
            read -p "Do you wish to upload the source package?    " yn
            case $yn in
                [Yy]* ) dput ppa:beauman/retrorig ~/packaging/gens/gens_*.$PL""_source.changes; break;;
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






