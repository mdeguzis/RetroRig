#========================================================================
# Build Script for getpos RetroRig PPA
#======================================================================== 
#
# Author:  Jens-Christian Lache
# Date:    20141002
# Version: 1.1
#          first approach 
# ========================================================================


#define base version
BASE=1

# define patch level
PL=1

#define branch
BRANCH=retrorig-v$PL

clear
echo "#####################################################################"
echo "Building custom getpos Debian package (patch level $PL)"
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
  sudo apt-get -y install debhelper qt4-qmake libqt4-dev 

else
  echo ""
  echo "skipping installation of build packages, use arbitrary second argument to get those packages"
  echo "e.g ./build-getpos-ppa.sh compile update"
  echo ""
fi

echo ""
echo "##########################################"
echo "Setup build directory"
echo "##########################################"
echo ""
echo "~/packaging/getpos"
# start in $HOME
cd

# remove old build directory
rm -rf ~/packaging/getpos

#create build directory
mkdir -p ~/packaging/getpos

#change to build directory
cd ~/packaging/getpos

echo ""
echo "##########################################"
echo "Setup package base files"
echo "##########################################"

echo "dsc file"
cp ~/RetroRig/supplemental/getpos/getpos.dsc getpos_$BASE.$PL.dsc
sed -i "s|version_placeholder|$BASE.$PL|g" "getpos_$BASE.$PL.dsc"

echo "original tarball"
git clone https://github.com/beaumanvienna/getpos

file getpos/

if [ $? -eq 0 ]; then  
    echo "successfully cloned"
else  
    echo "git clone failed, aborting"
    exit
fi 

cd getpos
git checkout $BRANCH
rm -rf .git .gitignore .hgeol .hgignore
cd ..

tar cfj getpos.orig.tar.bz2 getpos
mv getpos.orig.tar.bz2 getpos_$BASE.$PL.orig.tar.bz2

echo "debian files"
cp -r ~/RetroRig/supplemental/getpos/debian getpos/

echo ""
echo "##########################################"
echo "Unpacking debian files"
echo "##########################################"
echo ""

#change to source folder
cd getpos/

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
        ls -lah ~/packaging/getpos
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
        ls -lah ~/packaging/getpos
        echo ""
        echo ""
        echo "you can upload the package with dput ppa:beauman/retrorig ~/packaging/getpos/getpos_$BASE.$PL""_source.changes"
        echo "all good"
        echo ""
        echo ""

        while true; do
            read -p "Do you wish to upload the source package?    " yn
            case $yn in
                [Yy]* ) dput ppa:beauman/retrorig ~/packaging/getpos/getpos_*.$PL""_source.changes; break;;
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





