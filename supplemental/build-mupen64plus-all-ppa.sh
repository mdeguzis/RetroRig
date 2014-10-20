#========================================================================
# Build Script for *ALL* mupen64plus packages
#======================================================================== 
#
# Author      : Jens-Christian Lache
# Date        : 20140906
# Version     : 1
# ========================================================================

echo "building all mupen64plus packages"

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

if [[ -n "$2" ]]; then

  ./build-mupen64plus-video-glide64mk2-ppa.sh      $target $2
  if [ $? -eq 0 ]; then  
      echo "successfully build"
  else  
      echo "build failed, aborting"
      exit
  fi
  sleep 2

  ./build-mupen64plus-input-sdl-ppa.sh             $target $2
  if [ $? -eq 0 ]; then  
      echo "successfully build"
  else  
      echo "build failed, aborting"
      exit
  fi
  sleep 2

  ./build-mupen64plus-rsp-hle-ppa.sh               $target $2
  if [ $? -eq 0 ]; then  
      echo "successfully build"
  else  
      echo "build failed, aborting"
      exit
  fi
  sleep 2

  ./build-mupen64plus-rsp-z64-ppa.sh               $target $2
  if [ $? -eq 0 ]; then  
      echo "successfully build"
  else  
      echo "build failed, aborting"
      exit
  fi
  sleep 2

  ./build-mupen64plus-video-rice-ppa.sh            $target $2
  if [ $? -eq 0 ]; then  
      echo "successfully build"
  else  
      echo "build failed, aborting"
      exit
  fi
  sleep 2

  ./build-mupen64plus-video-glide64-ppa.sh         $target $2
  if [ $? -eq 0 ]; then  
      echo "successfully build"
  else  
      echo "build failed, aborting"
      exit
  fi
  sleep 2

  ./build-mupen64plus-audio-sdl-ppa.sh             $target $2
  if [ $? -eq 0 ]; then  
      echo "successfully build"
  else  
      echo "build failed, aborting"
      exit
  fi
  sleep 2

  ./build-mupen64plus-video-z64-ppa.sh             $target $2
  if [ $? -eq 0 ]; then  
      echo "successfully build"
  else  
      echo "build failed, aborting"
      exit
  fi
  sleep 2

  ./build-mupen64plus-video-arachnoid-ppa.sh       $target $2
  if [ $? -eq 0 ]; then  
      echo "successfully build"
  else  
      echo "build failed, aborting"
      exit
  fi
  sleep 2

  ./build-mupen64plus-ui-console-ppa.sh            $target $2
  if [ $? -eq 0 ]; then  
      echo "successfully build"
  else  
      echo "build failed, aborting"
      exit
  fi
  sleep 2

  ./build-mupen64plus-core-ppa.sh                  $target $2
  if [ $? -eq 0 ]; then  
      echo "successfully build"
  else  
      echo "build failed, aborting"
      exit
  fi
  sleep 2

else

  ./build-mupen64plus-video-glide64mk2-ppa.sh      $target
  if [ $? -eq 0 ]; then  
      echo "successfully build"
  else  
      echo "build failed, aborting"
      exit
  fi
  sleep 2

  ./build-mupen64plus-input-sdl-ppa.sh             $target
  if [ $? -eq 0 ]; then  
      echo "successfully build"
  else  
      echo "build failed, aborting"
      exit
  fi
  sleep 2

  ./build-mupen64plus-rsp-hle-ppa.sh               $target
  if [ $? -eq 0 ]; then  
      echo "successfully build"
  else  
      echo "build failed, aborting"
      exit
  fi
  sleep 2

  ./build-mupen64plus-rsp-z64-ppa.sh               $target
  if [ $? -eq 0 ]; then  
      echo "successfully build"
  else  
      echo "build failed, aborting"
      exit
  fi
  sleep 2

  ./build-mupen64plus-video-rice-ppa.sh            $target
  if [ $? -eq 0 ]; then  
      echo "successfully build"
  else  
      echo "build failed, aborting"
      exit
  fi
  sleep 2

  ./build-mupen64plus-video-glide64-ppa.sh         $target
  if [ $? -eq 0 ]; then  
      echo "successfully build"
  else  
      echo "build failed, aborting"
      exit
  fi
  sleep 2

  ./build-mupen64plus-audio-sdl-ppa.sh             $target
  if [ $? -eq 0 ]; then  
      echo "successfully build"
  else  
      echo "build failed, aborting"
      exit
  fi
  sleep 2

  ./build-mupen64plus-video-z64-ppa.sh             $target
  if [ $? -eq 0 ]; then  
      echo "successfully build"
  else  
      echo "build failed, aborting"
      exit
  fi
  sleep 2

  ./build-mupen64plus-video-arachnoid-ppa.sh       $target
  if [ $? -eq 0 ]; then  
      echo "successfully build"
  else  
      echo "build failed, aborting"
      exit
  fi
  sleep 2

  ./build-mupen64plus-ui-console-ppa.sh            $target
  if [ $? -eq 0 ]; then  
      echo "successfully build"
  else  
      echo "build failed, aborting"
      exit
  fi
  sleep 2

  ./build-mupen64plus-core-ppa.sh                  $target
  if [ $? -eq 0 ]; then  
      echo "successfully build"
  else  
      echo "build failed, aborting"
      exit
  fi  
  sleep 2

fi

find /home/yo/packaging/mupen64plus-* -name "*.deb"
find /home/yo/packaging/mupen64plus-* -name "*changes"

