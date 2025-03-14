#! /bin/sh

HHROOT="https://github.com/holzschu"
LUAVERSION=lua-5.4.4
IOS_SYSTEM_VER=3.0.3

curl https://www.lua.org/ftp/$LUAVERSION.tar.gz -O
tar xfz $LUAVERSION.tar.gz
rm $LUAVERSION.tar.gz
# get ios_system.framework
echo "Downloading header file:"
curl -OL $HHROOT/ios_system/releases/download/$IOS_SYSTEM_VER/lua_ios/ios_error.h 


# Patch sources:
patch $LUAVERSION/src/lua.c < patch_luac.txt
patch $LUAVERSION/src/luac.c < patch_luacc.txt
patch $LUAVERSION/src/luaconf.h < patch_luaconf.txt
patch $LUAVERSION/src/lauxlib.c < patch_lauxlibc.txt
patch $LUAVERSION/src/ldblib.c < patch_ldblibc.txt
patch $LUAVERSION/src/liolib.c < patch_liolibc.txt
patch $LUAVERSION/src/loslib.c < patch_loslibc.txt


