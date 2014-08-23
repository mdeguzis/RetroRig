#========================================================================
# Build Script for custom dolphin-emu RetroRig PPA
#======================================================================== 
#
# Author      : Jens-Christian Lache
# Date        : 20140818
# Version     : 4.0.2
# Descrition  : version 4.0.2 from Github, unpatched and unchanged
#               
# ========================================================================

#define base version
BASE=0:4.0.2.1

# define patch level
PL=0

#define branch
BRANCH=4.0.2

clear
echo "#################################################################"
echo "Building custom dolphin-emu Debian package (branch $BRANCH)"
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
  sudo apt-get install -y build-essential fakeroot devscripts automake autoconf autotools-dev binutils-dev \
			  debhelper, cmake, libao-dev, libasound2-dev, libavcodec-dev, libavformat-dev, \
			  libbluetooth-dev, libglew-dev, libgtk2.0-dev, liblzo2-dev, libopenal-dev, libpolarssl-dev \
			  libpulse-dev, libreadline6-dev, libsdl1.2-dev, libsfml-dev, libsoil-dev, libsoundtouch-dev \
			  libswscale-dev, libminiupnpc-dev, libwxbase3.0-dev, libwxgtk3.0-dev, libxext-dev \
			  libxrandr-dev, lsb-release, pkg-config, portaudio19-dev, wx3.0-headers, zlib1g-dev

else
  echo ""
  echo "skipping installation of build packages, use arbitrary second argument to get those packages"
  echo "e.g ./build-dolphin-emu-ppa.sh compile update"
  echo ""
fi

echo ""
echo "##########################################"
echo "Setup build directory"
echo "##########################################"
echo ""
echo "~/packaging/dolphin-emu"
# start in $HOME
cd

# remove old build directory
rm -rf ~/packaging/dolphin-emu

#create build directory
mkdir -p ~/packaging/dolphin-emu

#change to build directory
cd ~/packaging/dolphin-emu

echo ""
echo "##########################################"
echo "Setup package base files"
echo "##########################################"

echo "dsc file"
cp ~/RetroRig/supplimental/dolphin-emu/dolphin-emu.dsc dolphin-emu_$BASE.$PL.dsc
sed -i "s|version_placeholder|$BASE.$PL|g" "dolphin-emu_$BASE.$PL.dsc"

echo "original tarball"
git clone https://github.com/beaumanvienna/dolphin
mv dolphin dolphin-emu

file dolphin-emu/

if [ $? -eq 0 ]; then  
    echo "successfully cloned"
else  
    echo "git clone failed, aborting"
    exit
fi

cd dolphin-emu/
git checkout $BRANCH
rm -rf .git .gitignore .hgeol .hgignore
cd ..

tar cfj dolphin-emu_orig.tar.bz2 dolphin-emu
mv dolphin-emu_orig.tar.bz2 dolphin-emu_$BASE.$PL.orig.tar.bz2

echo "debian files"
wget --tries=50 "https://launchpad.net/~glennric/+archive/ubuntu/dolphin-emu/+files/dolphin-emu_4.0-0ubuntu1~saucy.debian.tar.bz2"

echo ""
echo "##########################################"
echo "Unpacking debian files"
echo "##########################################"
echo ""

#unpack
echo "unpacking template dolphin-emu_4.0-0ubuntu1~saucy.debian.tar.bz2"
tar xfj dolphin-emu_4.0-0ubuntu1~saucy.debian.tar.bz2
#remove template
rm dolphin-emu_4.0-0ubuntu1~saucy.debian.tar.bz2

#move debian folder into source folder
mv debian/ dolphin-emu/

#change to source folder
cd dolphin-emu/

echo "control"
cp ~/RetroRig/supplimental/dolphin-emu/control debian/

echo "format"
rm -rf debian/source 
mkdir debian/source
cp ~/RetroRig/supplimental/dolphin-emu/format debian/source/

echo "changelog"
cp ~/RetroRig/supplimental/dolphin-emu/changelog debian/
sed -i "s|version_placeholder|$BASE.$PL|g" debian/changelog
#dch -i

echo "patches"
rm -rf debian/patches

echo "clean up"
rm -f debian/watch

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
        ls -lah ~/packaging/dolphin-emu
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
        ls -lah ~/packaging/dolphin-emu
        echo ""
        echo ""
        echo "you can upload the package with dput ppa:beauman/retrorig ~/packaging/dolphin-emu/dolphin-emu_$BASE.$PL""_source.changes"
        echo "all good"
        echo ""
        echo ""

        while true; do
            read -p "Do you wish to upload the source package?    " yn
            case $yn in
                [Yy]* ) dput ppa:beauman/retrorig ~/packaging/dolphin-emu/dolphin-emu_*.$PL""_source.changes; break;;
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






