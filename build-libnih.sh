#!/bin/bash

LIBNIH_VERSION="1.0.3"

echo "installing build deps"
time sudo yum -y install dbus-devel expat-devel

echo "gathering sources"
cp libnih/* rpmbuild/SOURCES/
mv rpmbuild/SOURCES/libnih.spec rpmbuild/SPECS/

if [ ! -f rpmbuild/SOURCES/libnih-$LIBNIH_VERSION.tar.gz ]; then
  (cd rpmbuild/SOURCES && wget http://launchpad.net/libnih/1.0/$LIBNIH_VERSION/+download/libnih-$LIBNIH_VERSION.tar.gz)
fi

echo "building"
time rpmbuild -bb rpmbuild/SPECS/libnih.spec
