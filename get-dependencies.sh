#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	boost 		\
	cmake 		\
	cppunit 	\
	glew 		\
	glm 		\
	inkscape    \
	libepoxy 	\
	openal 		\
	qt6-base 	\
	sdl2-compat

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# If the application needs to be manually built that has to be done down here
#if [ "${DEVEL_RELEASE-}" = 1 ]; then
#	package=arx-libertatis-git
#else
#	package=arx-libertatis
#fi
#make-aur-package "$package"
#pacman -Q "$package" | awk '{print $2; exit}' > ~/version
echo "Building Arx Libertatis..."
echo "---------------------------------------------------------------"
REPO="https://github.com/arx/ArxLibertatis"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --depth 1 "$REPO" ./ArxLibertatis
echo "$VERSION" > ~/version

cmake -S ArxLibertatis -B build \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DCMAKE_INSTALL_LIBEXECDIR=lib/arx \
	-DRUNTIME_DATADIR="" \
	-DCMAKE_BUILD_TYPE=Release \
	-DUNITY_BUILD=ON \
	-DINSTALL_SCRIPTS=ON \
	-DBUILD_TOOLS=ON \
	-DBUILD_TESTS=OFF \
	-DUSE_NATIVE_FS=ON \
	-DUSE_OPENAL=ON \
	-DUSE_OPENGL=ON \
	-DWITH_SDL=2 \
	-DWITH_OPENGL=epoxy
cmake --build build -j$(nproc)
cmake --install build
