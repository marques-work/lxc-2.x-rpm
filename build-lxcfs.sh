#!/bin/bash

LXCFS_VERSION="2.0.2"

echo "installing build deps"
time sudo yum -y install fuse-devel pam-devel

echo "gathering sources"
cp lxcfs.spec rpmbuild/SPECS
if [ ! -f rpmbuild/SOURCES/lxcfs-$LXCFS_VERSION.tar.gz ]; then
  (cd rpmbuild/SOURCES && wget https://linuxcontainers.org/downloads/lxcfs/lxcfs-$LXCFS_VERSION.tar.gz)
fi

echo "building"
time rpmbuild -bb rpmbuild/SPECS/lxcfs.spec
