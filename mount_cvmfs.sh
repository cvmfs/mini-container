#!/bin/sh

set -e

REPOSITORY=$1
MOUNTPOINT=$2

usage() {
  echo "$0 <repository name> <mount point>"
  exit 1
}

[ "x$REPOSITORY" != "x" ] || usage
[ "x$MOUNTPOINT" != "x" ] || usage

portable_dirname() {
  if [ "x$(uname -s)" = "xDarwin" ]; then
    echo "$(dirname $(/usr/local/bin/greadlink --canonicalize $1))"
  else
    echo "$(dirname $(readlink --canonicalize $1))"
  fi
}

script_location="$(portable_dirname $0)"

[ -d "$MOUNTPOINT" ] || mkdir -p "$MOUNTPOINT"

export CVMFS_BASE_DIR="$script_location"
LD_LIBRARY_PATH="${script_location}/lib" CVMFS_LIBRARY_PATH="${script_location}/bin" \
  ${script_location}/bin/cvmfs2 \
  -o "config=${script_location}/default.conf:${script_location}/default.local,libfuse=2" \
  "$REPOSITORY" \
  "$MOUNTPOINT"
