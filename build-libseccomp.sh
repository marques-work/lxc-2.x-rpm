#!/bin/bash

LIBSECCOMP_BUILD_VERSION="2.3.1"

echo "installing build deps"
time sudo yum -y install kernel-headers

echo "gathering sources"
cp libseccomp.spec rpmbuild/SPECS
if [ ! -f rpmbuild/SOURCES/libseccomp-$LIBSECCOMP_BUILD_VERSION.tar.gz ]; then
  (cd rpmbuild/SOURCES && wget https://github.com/seccomp/libseccomp/releases/download/v$LIBSECCOMP_BUILD_VERSION/libseccomp-$LIBSECCOMP_BUILD_VERSION.tar.gz)
fi

echo "building"
time rpmbuild -bb rpmbuild/SPECS/libseccomp.spec
