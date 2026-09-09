#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	boost \
	cmake \
	freetype2 \
	glew \
	libepoxy \
	openal \
	qt5-base qt6-base \
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
if [ "${DEVEL_RELEASE-}" = 1 ]; then
    echo "Making nightly build of Arx Libertatis..."
    echo "---------------------------------------------------------------"
    VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
    git clone --depth 1 "$REPO" ./ArxLibertatis
else
	echo "Making stable build of Arx Libertatis..."
	VERSION="$(git ls-remote --tags --sort="v:refname" "$REPO" | tail -n1 | sed 's/.*\///; s/\^{}//; s/^v//')"
	git clone --branch v"$VERSION" --single-branch --depth 1 "$REPO" ./ArxLibertatis
fi
echo "$VERSION" > ~/version

