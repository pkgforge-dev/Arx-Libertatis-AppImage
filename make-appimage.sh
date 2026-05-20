#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/arx/ArxLibertatis/5b95e4c5ca9d583f1b11c085326979772645e0f3/data/icons/arx-libertatis.svg
export DESKTOP=https://raw.githubusercontent.com/arx/ArxLibertatis/refs/heads/master/data/icons/arx-libertatis.desktop
export STARTUPWMCLASS=arx-libertatis
export DEPLOY_OPENGL=1
export DEPLOY_PULSE=1

# Deploy dependencies
quick-sharun /usr/bin/arx* /usr/lib/libArxIO.so* /usr/share/games/arx /usr/lib/libopenal.so*
echo 'ANYLINUX_DO_NOT_LOAD_LIBS=libpipewire-0.3.so*:${ANYLINUX_DO_NOT_LOAD_LIBS}' >> ./AppDir/.env

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage
