#!/bin/bash

VERSION=$1
PKGBUILD=PKGBUILD.w64
BUILDDIR=w64-build.ignore

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
cp $PKG ../w64-$PKG
echo -e "\nPackaged [34;1m$PKG[0m"
