#!/bin/bash

LXC_BUILD_VERSION="2.0.3"

echo "installing build deps"
time sudo yum -y install libselinux-devel libcap-devel docbook2X

echo "gathering sources"
cp lxc.spec rpmbuild/SPECS
if [ ! -f rpmbuild/SOURCES/lxc-$LXC_BUILD_VERSION.tar.gz ]; then
  (cd rpmbuild/SOURCES && wget https://linuxcontainers.org/downloads/lxc/lxc-$LXC_BUILD_VERSION.tar.gz)
fi

echo "building"
time rpmbuild -bb rpmbuild/SPECS/lxc.spec
