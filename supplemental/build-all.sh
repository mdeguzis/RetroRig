#========================================================================
# Build Script for *ALL* packages
#======================================================================== 
#
# Author      : Jens-Christian Lache
# Date        : 20140928
# Version     : 0.0.0.0.0.0.1
# ========================================================================

TARGET_OS=utopic


ppsspp=yes
dolphin_emu=no

echo "building all packages"

cd ~/RetroRig/supplemental

if [[ -n "$1" ]]; then

  echo ""
  echo "build target is $1"
  echo ""
  target=$1

else
  echo ""
  echo "build target is source"
  echo ""
  target=source
fi

# =====================================================
# ppsspp
# =====================================================

if [ "$ppsspp" == "yes" ]; then
  
  #restore default
  git checkout "./ppsspp/changelog"
  
  #replace target operating system
  sed -i "s|trusty|$TARGET_OS|g" "./ppsspp/changelog"
  
  #run build script
  ./build-ppsspp-ppa.sh      $target $2
  returnValue=$?
  
  #restore default
  git checkout "./ppsspp/changelog"
	
  if [ $returnValue -eq 0 ]; then  
      echo "successfully build"
      ppsspp_build=success
  else  
      echo "build failed, aborting"
      ppsspp_build=failed
  fi

fi


# =====================================================
# dolphin-emu
# =====================================================

if [ "$dolphin_emu" == "yes" ]; then
  
  #restore default
  git checkout "./dolphin-emu/changelog"
  
  #replace target operating system
  sed -i "s|trusty|$TARGET_OS|g" "./dolphin-emu/changelog"
  
  #run build script
  ./build-dolphin-emu-ppa.sh      $target $2
  returnValue=$?
  
  #restore default
  git checkout "./dolphin-emu/changelog"
	
  if [ $returnValue -eq 0 ]; then  
      echo "successfully build"
      dolphin_emu_build=success
  else  
      echo "build failed, aborting"
      dolphin_emu_build=failed
  fi

fi
 

find /home/yo/packaging/ -name "*.deb"
find /home/yo/packaging/ -name "*changes"

