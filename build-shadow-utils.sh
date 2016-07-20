#!/bin/bash

SHADOW_VERSION="4.2.1"
WORKING_DIR=$(pwd)

echo "updating yum"
time sudo yum -y update

echo "installing build tools"
time sudo yum -y groupinstall 'Development Tools'

echo "installing build deps"
time sudo yum -y install wget libselinux-devel audit-libs-devel libsemanage-devel libacl-devel libattr-devel bison flex gnome-doc-utils

echo "configuring rpmbuild"
echo "%_topdir    $WORKING_DIR/rpmbuild" > $HOME/.rpmmacros

echo "scaffolding rpmbuild tree"
mkdir -p rpmbuild
(cd rpmbuild && mkdir -p SPECS SOURCES BUILD BUILDROOT RPMS SRPMS)

echo "gathering sources"
cp shadow-utils/* rpmbuild/SOURCES/
mv rpmbuild/SOURCES/shadow-utils.spec rpmbuild/SPECS/

if [ ! -f rpmbuild/SOURCES/shadow-$SHADOW_VERSION.tar.xz ]; then
  (cd rpmbuild/SOURCES && wget http://pkg-shadow.alioth.debian.org/releases/shadow-$SHADOW_VERSION.tar.xz)
fi

if [ ! -f rpmbuild/SOURCES/shadow-$SHADOW_VERSION.tar.xz.sig ]; then
  (cd rpmbuild/SOURCES && wget http://pkg-shadow.alioth.debian.org/releases/shadow-$SHADOW_VERSION.tar.xz.sig)
fi

echo "building"
time rpmbuild -bb rpmbuild/SPECS/shadow-utils.spec
