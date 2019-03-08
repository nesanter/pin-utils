#!/bin/bash

rm -rfv build.ignore
mkdir build.ignore
cd build.ignore
cp -v ../PKGBUILD .

[ "$1" ] && sed -i 's/pkgver=.*/pkgver='"$1"'/' PKGBUILD

updpkgsums PKGBUILD && \
    makepkg -Ccf && \
    bsdtar -tvf *.pkg.* && \
    cp *.pkg.* ..

