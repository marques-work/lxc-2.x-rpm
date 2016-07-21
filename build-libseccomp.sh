#!/bin/bash

LIBSECCOMP_BUILD_VERSION="2.3.1"
WORKING_DIR=$(pwd)

echo "updating yum"
time sudo yum -y update

echo "installing build tools"
time sudo yum -y groupinstall 'Development Tools'

echo "installing build deps"
time sudo yum -y install wget kernel-headers

echo "configuring rpmbuild"
echo "%_topdir    $WORKING_DIR/rpmbuild" > $HOME/.rpmmacros

echo "scaffolding rpmbuild tree"
mkdir -p rpmbuild
(cd rpmbuild && mkdir -p SPECS SOURCES BUILD BUILDROOT RPMS SRPMS)

echo "gathering sources"
cp libseccomp.spec rpmbuild/SPECS
if [ ! -f rpmbuild/SOURCES/libseccomp-$LIBSECCOMP_BUILD_VERSION.tar.gz ]; then
  (cd rpmbuild/SOURCES && wget https://github.com/seccomp/libseccomp/releases/download/v$LIBSECCOMP_BUILD_VERSION/libseccomp-$LIBSECCOMP_BUILD_VERSION.tar.gz)
fi

echo "building"
time rpmbuild -bb rpmbuild/SPECS/libseccomp.spec
