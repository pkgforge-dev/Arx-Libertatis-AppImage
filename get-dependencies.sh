#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
# pacman -Syu --noconfirm PACKAGESHERE

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# If the application needs to be manually built that has to be done down here
if [ "${DEVEL_RELEASE-}" = 1 ]; then
	package=arx-libertatis-git
else
	package=arx-libertatis
fi
make-aur-package "$package"
pacman -Q "$package" | awk '{print $2; exit}' > ~/version
