#!/bin/bash

set -e  # Exit on error

usage() {
  cat <<- EOF

  Usage: $(basename $0) <pkg_name> <pkg_repo> <output_dir> [deps_dir]

    pkg_name    - Package name
    pkg_repo    - URL to Git repository
    output_dir  - Where packages should be stored when done
    deps_dir    - Directory with build dependencies [OPTIONAL]

  Every *.rpm package in deps_dir will be installed before the build
  is attempted. This is to work around the fact that dependencies 
  might not be available in a public repository.

EOF
}

log() {
  echo -e "\e[1;92m`date +"%Y-%m-%d %H:%M:%S%z"` -- $1\e[0m"
}

# Check if we've the right amount of parameters
if [ $# -ge 3 && $# -le 4 ]; then
  usage
  exit 1
fi

PACKAGE_NAME=$1
PACKAGE_REPO=$2
OUTPUT_DIR=$3
DEPS_DIR=$4

RPMS_DIR="$HOME/rpmbuild/RPMS/`uname -m`"
SOURCES_DIR="$HOME/rpmbuild/SOURCES"

log "Fetching Git repository"
REPO_DIR=`mktemp -d`
git clone $PACKAGE_REPO $REPO_DIR

log "Creating rpmbuild hierarchy"
mkdir -p $SOURCES_DIR

log "Moving repository contents to rpmbuild/SOURCES"
mv ${REPO_DIR}/* $SOURCES_DIR
cd $SOURCES_DIR

log "Installing build dependencies"
yum install -y `egrep '^BuildRequires' ${PACKAGE_NAME}.spec | awk '{ printf("%s ", $2); }'` `ls ${DEPS_DIR}/*.rpm`

log "Retrieving sources"
spectool -g -A -R ${PACKAGE_NAME}.spec

log "Build package(s)"
rpmbuild -ba ${PACKAGE_NAME}.spec

log "Copyring package(s) to output directory"
mkdir -p $OUTPUT_DIR
mv $RPMS_DIR/*.rpm $OUTPUT_DIR
