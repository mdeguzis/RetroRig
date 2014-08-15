Format: 3.0 (native)
Source: mupen64plus-core
Binary: libmupen64plus2, libmupen64plus2-dbg, libmupen64plus-dev, mupen64plus-data
Architecture: any-i386 any-amd64 all
Version: version_placeholder
Maintainer: RetroRig Development Team <jc.lache@gmail.com>
Uploaders: RetroRig Development Team <jc.lache@gmail.com>
Homepage: https://github.com/beaumanvienna/mupen64plus-core
Standards-Version: 3.9.5
Build-Depends: debhelper (>= 9.20130604), dpkg-dev (>= 1.16.1.1), libfreetype6-dev, libgl1-mesa-dev | libgl-dev, libglu1-mesa-dev | libglu-dev, libminizip-dev, libpng-dev, libsdl2-dev, pkg-config, zlib1g-dev | libz-dev, binutils-dev
Package-List:
 libmupen64plus-dev deb libdevel optional arch=all
 libmupen64plus2 deb libs optional arch=any-i386,any-amd64
 libmupen64plus2-dbg deb debug extra arch=any-i386,any-amd64
 mupen64plus-data deb games optional arch=all
