#!/bin/bash

SHADOW_VERSION="4.2.1"

echo "installing build deps"
time sudo yum -y install libselinux-devel audit-libs-devel libsemanage-devel libacl-devel libattr-devel bison flex gnome-doc-utils

echo "gathering sources"
cp shadow-utils/* rpmbuild/SOURCES/
cp shadow-utils.spec rpmbuild/SPECS/

if [ ! -f rpmbuild/SOURCES/shadow-$SHADOW_VERSION.tar.xz ]; then
  (cd rpmbuild/SOURCES && wget http://pkg-shadow.alioth.debian.org/releases/shadow-$SHADOW_VERSION.tar.xz)
fi

if [ ! -f rpmbuild/SOURCES/shadow-$SHADOW_VERSION.tar.xz.sig ]; then
  (cd rpmbuild/SOURCES && wget http://pkg-shadow.alioth.debian.org/releases/shadow-$SHADOW_VERSION.tar.xz.sig)
fi

echo "building"
time rpmbuild -bb rpmbuild/SPECS/shadow-utils.spec
