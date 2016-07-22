#!/bin/bash

set -e
set -x

WORKING_DIR=$(pwd)

echo "updating yum"
time sudo yum -y update

echo "installing build tools"
time sudo yum -y groupinstall 'Development Tools'

echo "installing utilities"
time sudo yum -y install wget

echo "configuring rpmbuild"
echo "%_topdir    $WORKING_DIR/rpmbuild" > $HOME/.rpmmacros

echo "scaffolding rpmbuild tree"
mkdir -p rpmbuild
(cd rpmbuild && mkdir -p SPECS SOURCES BUILD BUILDROOT RPMS SRPMS)
