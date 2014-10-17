#========================================================================
# Build Script for custom retrorig-setup RetroRig PPA
#======================================================================== 
#
# Author      : Michael T. DeGuzis, Jens-Christian Lache
# Date        : 201401017
# Version     : 0.9.5
# Description : Install RetroRig via Debian package
#		Please see changelog for latest alterations and fixes
# ========================================================================

#define base version
PRE=0
BASE=0.9.5

# define patch level
# In this case, this level will be used to denote incremental changes
# instead of a specific branch for now (beta/master only exist at the
# momement).
PL=3.0

#define branch
#BRANCH=beta
BRANCH=draft

#define upload target
#LAUNCHPAD_PPA="ppa:mdeguzis/retrorig"
LAUNCHPAD_PPA="ppa:beauman/retrorig-testing"

#define uploader for changelog
#uploader="Michael DeGuzis <mdeguzis@gmail.com>"
uploader="Jens-Christian Lache <jc.lache@gmail.com>"

#define package maintainer for dsc and control file 
pkgmaintainer="RetroRig Development Team <mdeguzis@gmail.com>"

#define github repository
#source_reprository=https://github.com/ProfessorKaos64/RetroRig
source_reprository="https://github.com/beaumanvienna/RetroRig"

clear
echo "#################################################################"
echo "Building custom retrorig-setup Debian package (branch $BRANCH)"
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

# apt-get install packages
# sudo apt-get update -y
  sudo apt-get install -y build-essential fakeroot devscripts autoconf autotools-dev binutils-dev \
  debhelper dput

else
  echo ""
  echo "skipping installation of build packages, use arbitrary second argument to get those packages"
  echo "e.g ./build-retrorig-setup-ppa.sh compile update"
  echo ""
fi

echo ""
echo "##########################################"
echo "Setup build directory"
echo "##########################################"
echo ""
echo "~/packaging/retrorig-setup"
# start in $HOME
cd

# remove old build directory
rm -rf ~/packaging/retrorig-setup

#create build directory
mkdir -p ~/packaging/retrorig-setup

#change to build directory
cd ~/packaging/retrorig-setup

echo ""
echo "##########################################"
echo "Setup package base files"
echo "##########################################"

echo "dsc file"
cp ~/RetroRig/supplemental/retrorig-setup/retrorig-setup.dsc retrorig-setup-$PRE:$BASE.$PL.dsc
sed -i "s|version_placeholder|$PRE:$BASE.$PL|g" "retrorig-setup-$PRE:$BASE.$PL.dsc"
sed -i "s|pkgmaintainer|$pkgmaintainer|g" "retrorig-setup-$PRE:$BASE.$PL.dsc"

SRC_FOLDER=retrorig-setup-$BASE.$PL

echo "cloning repository"
git clone $source_reprository  
file RetroRig/

if [ $? -eq 0 ]; then  
    echo "successfully cloned"
else  
    echo "git clone failed, aborting"
    exit
fi 

mv RetroRig/ $SRC_FOLDER

#change to source folder
cd $SRC_FOLDER

git checkout $BRANCH

mkdir -p debian/source

echo "changelog"
cp ~/RetroRig/supplemental/retrorig-setup/changelog debian/
sed -i "s|version_placeholder|$PRE:$BASE.$PL|g" debian/changelog
sed -i "s|uploader|$uploader|g" debian/changelog

echo "control"
cp ~/RetroRig/supplemental/retrorig-setup/control debian/
sed -i "s|pkgmaintainer|$pkgmaintainer|g" debian/control

echo "rules"
cp ~/RetroRig/supplemental/retrorig-setup/rules debian/

echo "format"
cp ~/RetroRig/supplemental/retrorig-setup/format debian/source/

echo "Makefile"
cp ~/RetroRig/supplemental/retrorig-setup/Makefile .

echo "removing internal files"
rm -rf supplemental/ .git/

echo "installation script"
if [ -f retrorig-setup.sh ]; then  
   mv retrorig-setup.sh retrorig-setup
fi

#installation script (deprecated notation)
if [ -f retrorig_setup.sh ]; then  
   mv retrorig_setup.sh retrorig-setup
fi

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
        ls -lah ~/packaging/retrorig-setup
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
        ls -lah ~/packaging/retrorig-setup
        echo ""
        echo ""
        echo "you can upload the package with dput $LAUNCHPAD_PPA ~/packaging/retrorig-setup/retrorig-setup_$BASE.$PL""_source.changes"
        echo "all good"
        echo ""
        echo ""

        while true; do
            read -p "Do you wish to upload the source package?    " yn
            case $yn in
                [Yy]* ) dput $LAUNCHPAD_PPA ~/packaging/retrorig-setup/retrorig-setup_*.$PL""_source.changes; break;;
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






