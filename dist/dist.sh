#!/bin/bash

[ -d build.ignore ] && rm -r build.ignore
mkdir -p build.ignore
cd build.ignore

[ -f LOG ] && cp LOG LOG.prev

cp ../PKGBUILD .

[ "$1" ] && sed -i 's/pkgver=.*/pkgver='"$1"'/' PKGBUILD

echo "Building version $(sed -n 's/pkgver=\(.*\)/\1/p' PKGBUILD)"

{ updpkgsums PKGBUILD && makepkg -Ccf ; } \
    &>LOG || \
    { echo 'Failed, check LOG' >&2 ; exit 1 ; }
bsdtar -tvf *.pkg.* | grep -v '\.[A-Z]\+' >FILES
[ -f ../FILES.prev.ignore ] && diff FILES ../FILES.prev.ignore
cp FILES ../FILES.prev.ignore
cp *.pkg.* ..
ls *.pkg.*

