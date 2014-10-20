#========================================================================
# Build Script for custom Stella RetroRig PPA
#======================================================================== 
#
# Author:  Jens-Christian Lache
# Date:    20140808
# Version: Patch Level 0 (unpatched)
# ========================================================================

#define base version
BASE=2:4.0

# define patch level
PL=0

clear
echo "#########################################################"
echo "Building custom Stella Debian package (patch level $PL)"
echo "#########################################################"
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

  sudo apt-get install -y subversion

  #apt-get build-deps
  sudo apt-get -y build-dep stella
  #apt-get install packages
  sudo apt-get install -y build-essential fakeroot devscripts automake autoconf autotools-dev

else
  echo ""
  echo "skipping installation of build packages, use arbitrary second argument to get those packages"
  echo "e.g ./build-stella-ppa.sh compile update"
  echo ""
fi

echo ""
echo "##########################################"
echo "Setup build directory"
echo "##########################################"
echo ""
echo "~/packaging/stella"
# start in $HOME
cd

# remove old build directory
rm -rf ~/packaging/stella

#create build directory
mkdir -p ~/packaging/stella

#change to build directory
cd ~/packaging/stella

echo ""
echo "##########################################"
echo "Setup package base files"
echo "##########################################"

echo "dsc file"
cp ~/RetroRig/supplemental/stella/stella.dsc stella_$BASE.$PL.dsc
sed -i "s|version_placeholder|$BASE.$PL|g" "stella_$BASE.$PL.dsc"

echo "original tarball"
svn co https://svn.code.sf.net/p/stella/code/trunk stella 

file stella/

if [ $? -eq 0 ]; then  
    echo "successfully cloned"
else  
    echo "git clone failed, aborting"
    exit
fi 

cd stella
rm -rf .svn
cd ..
tar cfj stella_$BASE.$PL.orig.tar.bz2 stella


echo ""
echo "##########################################"
echo "Setting up debian files"
echo "##########################################"
echo ""

#change to source folder
cd stella/

echo "compat"
cp ~/RetroRig/supplemental/stella/compat debian/

echo "control"
cp ~/RetroRig/supplemental/stella/control debian/

echo "format"
mkdir debian/source
cp ~/RetroRig/supplemental/stella/format debian/source/

echo "changelog"
cp ~/RetroRig/supplemental/stella/changelog debian/
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
        ls -lah ~/packaging/stella
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
        ls -lah ~/packaging/stella
        echo ""
        echo ""
        echo "you can upload the package with dput ppa:beauman/retrorig ~/packaging/stella/stella_$BASE.$PL""_source.changes"
        echo "all good"
        echo ""
        echo ""

        while true; do
            read -p "Do you wish to upload the source package?    " yn
            case $yn in
                [Yy]* ) dput ppa:beauman/retrorig ~/packaging/stella/stella_*.$PL""_source.changes; break;;
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









