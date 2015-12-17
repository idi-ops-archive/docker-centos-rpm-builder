#!/bin/bash

set -x

PACKAGE_NAME=erlang-mochiweb
PACKAGE_REPO=https://github.com/gtirloni/rpm-centos-mochiweb
PACKAGE_SPEC="${PACKAGE_NAME}.spec"

OUTPUT_DIR="/pkgs"
RPM_DIR="$HOME/rpmbuild/RPMS/`uname -m`"
SOURCES_DIR="$HOME/rpmbuild/SOURCES"

echo "===> Fetching repository: $PACKAGE_REPO"
REPO_DIR=`mktemp -d`
cd $REPO_DIR
/usr/bin/git clone $PACKAGE_REPO .

echo "===> Installing build dependencies: $BUILD_REQUIRES"
BUILD_REQUIRES=`egrep '^BuildRequires' $PACKAGE_SPEC | awk '{ printf("%s ", $2); }'`
/usr/bin/yum install -y $BUILD_REQUIRES

if ! [ -d $SOURCES_DIR ]; then
  mkdir -p $SOURCES_DIR
  if [ $? -eq 0 ]; then
    echo "===> Created SOURCES directory: $SOURCES_DIR"
  fi
fi

mv *.patch $SOURCES_DIR
if [ $? -eq 0 ]; then
  echo "===> Moved patches to $SOURCES_DIR"
fi

spectool -g -A -R ${PACKAGE_NAME}.spec
if [ $? -eq 0 ]; then
  echo "===> Retrieved sources with spectool"
fi

rpmbuild -ba ${PACKAGE_NAME}.spec
if [ $? -eq 0 ]; then
  echo "===> Successfully built package(s)"
fi

# Copy packages to output area
mkdir -p $OUTPUT_DIR
if [ $? -eq 0 ]; then
  echo "===> Created output directory: $OUTPUT_DIR"
fi

mv -f $RPM_DIR/${PACKAGE_NAME}-*.rpm $OUTPUT_DIR
if [ $? -eq 0 ]; then
  echo "===> Moved packages to output directory"
fi

