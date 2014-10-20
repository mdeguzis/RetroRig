#========================================================================
# Build Script for custom antimicro RetroRig PPA
#======================================================================== 
#
# Author:  Jens-Christian Lache
# Date:    20140905
# Version: Patch Level 0 
#          (unpatched version forked and baselined on Fri, 5 Sep 2014
#           as "github.com/beaumanvienna/antimicro/tree/retrorig-pl0")
# ========================================================================

# date of github baseline
BASELINE_DATE=20140905

#define base version
BASE=2.5.$BASELINE_DATE

# define patch level
PL=0

#define branch
BRANCH=retrorig-pl$PL

clear
echo "#####################################################################"
echo "Building custom antimicro Debian package (patch level $PL)"
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

# Fetch build pkgs
if [[ -n "$2" ]]; then

  echo ""
  echo "##########################################"
  echo "Fetching necessary packages for build"
  echo "##########################################"
  echo ""

  #apt-get install packages
  sudo apt-get install -y build-essential fakeroot devscripts automake autoconf autotools-dev

  #get build dependencies
  sudo apt-get -y install cmake debhelper dpkg-dev \
	libsdl2-dev \
	qt4-qmake \
	libqt4-dev \
	libxtst-dev \
	libX11-dev
else
  echo ""
  echo "skipping installation of build packages, use arbitrary second argument to get those packages"
  echo "e.g ./build-antimicro-ppa.sh compile update"
  echo ""
fi

echo ""
echo "##########################################"
echo "Setup build directory"
echo "##########################################"
echo ""
echo "~/packaging/antimicro"
# start in $HOME
cd

# remove old build directory
rm -rf ~/packaging/antimicro

#create build directory
mkdir -p ~/packaging/antimicro

#change to build directory
cd ~/packaging/antimicro

echo ""
echo "##########################################"
echo "Setup package base files"
echo "##########################################"

echo "dsc file"
cp ~/RetroRig/supplemental/Antimicro/antimicro.dsc antimicro_$BASE.$PL.dsc
sed -i "s|version_placeholder|$BASE.$PL|g" "antimicro_$BASE.$PL.dsc"

echo "original tarball"
git clone https://github.com/beaumanvienna/antimicro

file antimicro/

if [ $? -eq 0 ]; then  
    echo "successfully cloned"
else  
    echo "git clone failed, aborting"
    exit
fi 

cd antimicro
git checkout $BRANCH
rm -rf .git .gitignore .hgeol .hgignore
cd ..

tar cfj antimicro.orig.tar.bz2 antimicro
mv antimicro.orig.tar.bz2 antimicro_$BASE.$PL.orig.tar.bz2

echo "debian files"
cp -r ~/RetroRig/supplemental/Antimicro/debian antimicro/

echo ""
echo "##########################################"
echo "Unpacking debian files"
echo "##########################################"
echo ""

#change to source folder
cd antimicro/

echo "changelog"
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
        ls -lah ~/packaging/antimicro
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
        ls -lah ~/packaging/antimicro
        echo ""
        echo ""
        echo "you can upload the package with dput ppa:beauman/retrorig ~/packaging/antimicro/antimicro_$BASE.$PL""_source.changes"
        echo "all good"
        echo ""
        echo ""

        while true; do
            read -p "Do you wish to upload the source package?    " yn
            case $yn in
                [Yy]* ) dput ppa:beauman/retrorig ~/packaging/antimicro/antimicro_*.$PL""_source.changes; break;;
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





