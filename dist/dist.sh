#!/bin/bash

mkdir -p build.ignore
cd build.ignore

[ -f LOG ] && cp LOG LOG.prev
[ -f FILES ] && cp FILES FILES.prev

cp ../PKGBUILD .

[ "$1" ] && sed -i 's/pkgver=.*/pkgver='"$1"'/' PKGBUILD

echo "Building version $(sed -n 's/pkgver=\(.*\)/\1/p' PKGBUILD)"

{ updpkgsums PKGBUILD && makepkg -Ccf ; } \
    &>LOG || \
    { echo 'Failed, check LOG' >&2 ; exit 1 ; }
bsdtar -tvf *.pkg.* | grep -v '\.[A-Z]\+' >FILES
[ -f FILES.prev ] && diff FILES FILES.prev
ls *.pkg.*
cp *.pkg.* ..

