#!/bin/bash

LXC_BUILD_VERSION="2.0.3"
WORKING_DIR=$(pwd)

echo "updating yum"
time sudo yum -y update

echo "installing build tools"
time sudo yum -y groupinstall 'Development Tools'

echo "installing build deps"
time sudo yum -y install wget libselinux-devel libcap-devel

echo "configuring rpmbuild"
echo "%_topdir    $WORKING_DIR/rpmbuild" > $HOME/.rpmmacros

echo "scaffolding rpmbuild tree"
mkdir -p rpmbuild
(cd rpmbuild && mkdir -p SPECS SOURCES BUILD BUILDROOT RPMS SRPMS)

echo "gathering sources"
cp lxc.spec rpmbuild/SPECS
if [ ! -f rpmbuild/SOURCES/lxc-$LXC_BUILD_VERSION.tar.gz ]; then
  (cd rpmbuild/SOURCES && wget https://linuxcontainers.org/downloads/lxc/lxc-$LXC_BUILD_VERSION.tar.gz)
fi

echo "building"
time rpmbuild -bb rpmbuild/SPECS/lxc.spec
