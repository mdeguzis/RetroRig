#========================================================================
# Build Script for custom mupen64plus-rsp-hle RetroRig PPA
#======================================================================== 
#
# Author      : Jens-Christian Lache
# Date        : 20140906
# Version     : Patch Level 0
# Descrition  : unpatched
# ========================================================================

#define base version
BASE=2:2.0

# define patch level
PL=0.0

#define branch
BRANCH=patchlevel-0

clear
echo "##########################################################################"
echo "Building custom mupen64plus-rsp-hle Debian package (patch level $PL)"
echo "##########################################################################"
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

  #apt-get build-deps
  sudo apt-get -y build-dep mupen64plus-rsp-hle
  #apt-get install packages
  sudo apt-get install -y build-essential fakeroot devscripts automake autoconf autotools-dev binutils-dev debhelper pkg-config dpkg-dev \
                          libmupen64plus-dev 
else
  echo ""
  echo "skipping installation of build packages, use arbitrary second argument to get those packages"
  echo "e.g ./build-mupen64plus-rsp-hle-ppa.sh compile update"
  echo ""
fi

echo ""
echo "##########################################"
echo "Setup build directory"
echo "##########################################"
echo ""
echo "~/packaging/mupen64plus-rsp-hle"
# start in $HOME
cd

# remove old build directory
rm -rf ~/packaging/mupen64plus-rsp-hle

#create build directory
mkdir -p ~/packaging/mupen64plus-rsp-hle

#change to build directory
cd ~/packaging/mupen64plus-rsp-hle

echo ""
echo "##########################################"
echo "Setup package base files"
echo "##########################################"

echo "dsc file"
cp ~/RetroRig/supplemental/mupen64plus/mupen64plus-rsp-hle/mupen64plus-rsp-hle.dsc mupen64plus-rsp-hle_$BASE.$PL.dsc
sed -i "s|version_placeholder|$BASE.$PL|g" "mupen64plus-rsp-hle_$BASE.$PL.dsc"

echo "original tarball"
git clone https://github.com/beaumanvienna/mupen64plus-rsp-hle

file mupen64plus-rsp-hle/

if [ $? -eq 0 ]; then  
    echo "successfully cloned"
else  
    echo "git clone failed, aborting"
    exit
fi

cd mupen64plus-rsp-hle/
git checkout $BRANCH
rm -rf .git .gitattributes .gitignore .travis.yml
cd ..

tar cfj mupen64plus-rsp-hle_orig.tar.bz2 mupen64plus-rsp-hle
mv mupen64plus-rsp-hle_orig.tar.bz2 mupen64plus-rsp-hle_$BASE.$PL.orig.tar.bz2

echo "debian files"
cp ~/RetroRig/supplemental/mupen64plus/mupen64plus-rsp-hle/mupen64plus-rsp-hle.debian.tar.xz .

echo ""
echo "##########################################"
echo "Unpacking debian files"
echo "##########################################"
echo ""

#unpack
echo "unpacking template mupen64plus-rsp-hle.debian.tar.xz"
tar xfJ mupen64plus-rsp-hle.debian.tar.xz
#remove template
rm mupen64plus-rsp-hle.debian.tar.xz

#move debian folder into source folder
mv debian/ mupen64plus-rsp-hle/

#change to source folder
cd mupen64plus-rsp-hle/

echo "control"
cp ~/RetroRig/supplemental/mupen64plus/mupen64plus-rsp-hle/control debian/

echo "format"
rm -rf debian/source 
mkdir debian/source
cp ~/RetroRig/supplemental/mupen64plus/mupen64plus-rsp-hle/format debian/source/

echo "changelog"
cp ~/RetroRig/supplemental/mupen64plus/mupen64plus-rsp-hle/changelog debian/
sed -i "s|version_placeholder|$BASE.$PL|g" debian/changelog
#dch -i

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
        ls -lah ~/packaging/mupen64plus-rsp-hle
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
        ls -lah ~/packaging/mupen64plus-rsp-hle
        echo ""
        echo ""
        echo "you can upload the package with dput ppa:beauman/retrorig ~/packaging/mupen64plus-rsp-hle/mupen64plus-rsp-hle_$BASE.$PL""_source.changes"
        echo "all good"
        echo ""
        echo ""

        while true; do
            read -p "Do you wish to upload the source package?    " yn
            case $yn in
                [Yy]* ) dput ppa:beauman/retrorig ~/packaging/mupen64plus-rsp-hle/mupen64plus-rsp-hle_*.$PL""_source.changes; break;;
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






