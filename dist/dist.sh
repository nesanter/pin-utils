#!/bin/bash
# Copyright © 2019 Noah Santer <personal@mail.mossy-tech.com>
#
# This file is part of pin-utils.
#
# pin-utils is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# pin-utils is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with pin-utils.  If not, see <https://www.gnu.org/licenses/>.

VERSION=$1
PKGBUILD=PKGBUILD
BUILDDIR=build.ignore

[ -d $BUILDDIR ] && rm -r $BUILDDIR
mkdir -p $BUILDDIR
cd $BUILDDIR

cp ../$PKGBUILD PKGBUILD

[ "$VERSION" ] && sed -i 's/pkgver=.*/pkgver='"$VERSION"'/' PKGBUILD

echo -n "Building version $(sed -n 's/pkgver=\(.*\)/\1/p' PKGBUILD)... " >&2

{ updpkgsums PKGBUILD && makepkg ; } \
    &>LOG || \
    { echo -e '[31;1mfailed[0m.\nCheck $BUILDDIR/LOG.' >&2 ; exit 1 ; }
echo -e "[32mbuilt[0m.\nContents:"
bsdtar -tf *.pkg.* | sed -n '/\.[A-Z]/d;s/\(.*\)/\t\1/p'
#grep -v '\.[A-Z]\+'
PKG=$(ls *.pkg.*)
cp $PKG ../$PKG
echo -e "\nPackaged [34;1m$PKG[0m"
