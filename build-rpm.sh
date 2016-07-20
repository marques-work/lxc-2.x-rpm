#!/bin/bash
echo "updating yum"
time sudo yum -y update

echo "installing build tools"
time sudo yum -y groupinstall 'Development Tools'

echo "installing build deps"
time sudo yum -y install libselinux-devel libcap-devel docbook2X

echo "configuring rpmbuild"
echo '%_topdir    %{getenv:HOME}/rpmbuild' > $HOME/.rpmmacros

mkdir -p rpmbuild
(cd rpmbuild && mkdir -p SPECS SOURCES BUILD BUILDROOT RPMS SRPMS)

cp lxc.spec $HOME/rpmbuild/SPECS
cd $HOME/rpmbuild/SOURCES && wget https://linuxcontainers.org/downloads/lxc/lxc-2.0.3.tar.gz

cd $HOME
time rpmbuild -bb rpmbuild/SPECS/lxc.spec
