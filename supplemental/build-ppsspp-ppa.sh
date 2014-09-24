#========================================================================
# Build Script for custom ppsspp RetroRig PPA
#======================================================================== 
#
# Author      : Michael T. DeGuzis
# Date        : 20140919
# Version     : 0.9.9.1-132
# Description : Version 0.9.9.1, unpatched, pl0
#               
# Notes: Base for pl0: 
#	 https://launchpad.net/~ppsspp/+archive/ubuntu/stable/+packages
#	
# ========================================================================

#define base version
PRE=0
BASE=0.9.9.1

# define patch level
PL=0

#define branch
BRANCH=unpatched

clear
echo "#################################################################"
echo "Building custom ppsspp Debian package (branch $BRANCH)"
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
  sudo apt-get update -y
  sudo apt-get install -y build-essential fakeroot devscripts autoconf autotools-dev binutils-dev \
  debhelper autotools-dev automake1.10 pkg-config libsdl1.2-dev qt4-qmake libqt4-dev libqt4-opengl-dev

else
  echo ""
  echo "skipping installation of build packages, use arbitrary second argument to get those packages"
  echo "e.g ./build-ppsspp-ppa.sh compile update"
  echo ""
fi

echo ""
echo "##########################################"
echo "Setup build directory"
echo "##########################################"
echo ""
echo "~/packaging/ppsspp"
# start in $HOME
cd

# remove old build directory
rm -rf ~/packaging/ppsspp

#create build directory
mkdir -p ~/packaging/ppsspp

#change to build directory
cd ~/packaging/ppsspp

echo ""
echo "##########################################"
echo "Setup package base files"
echo "##########################################"

echo "dsc file"
cp ~/RetroRig/supplemental/ppsspp/ppsspp.dsc ppsspp-$PRE:$BASE.$PL.dsc
sed -i "s|version_placeholder|$PRE:$BASE.$PL|g" "ppsspp-$PRE:$BASE.$PL.dsc"

SRC_FOLDER=ppsspp-$BASE.$PL

echo "original tarball"
git clone https://github.com/ProfessorKaos64/ppsspp
file ppsspp/

if [ $? -eq 0 ]; then  
    echo "successfully cloned"
else  
    echo "git clone failed, aborting"
    exit
fi 

mv ppsspp/ $SRC_FOLDER

#change to source folder
cd $SRC_FOLDER

git checkout $BRANCH
rm -rf .git .gitignore

echo "changelog"
cp ~/RetroRig/supplemental/ppsspp/changelog debian/
sed -i "s|version_placeholder|$PRE:$BASE.$PL|g" debian/changelog

echo "control"
cp ~/RetroRig/supplemental/ppsspp/control debian/

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
        ls -lah ~/packaging/ppsspp
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
        ls -lah ~/packaging/ppsspp
        echo ""
        echo ""
        echo "you can upload the package with dput ppa:beauman/retrorig ~/packaging/ppsspp/ppsspp_$BASE.$PL""_source.changes"
        echo "all good"
        echo ""
        echo ""

        while true; do
            read -p "Do you wish to upload the source package?    " yn
            case $yn in
                [Yy]* ) dput ppa:beauman/retrorig ~/packaging/ppsspp/ppsspp_*.$PL""_source.changes; break;;
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






