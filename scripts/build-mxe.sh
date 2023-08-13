#!/bin/bash -e

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

COUNT=0

. "${SCRIPT_DIR}/build.sh"

clean

build mxe openscad/mxe-requirements --no-cache "$@"

# Base build for both 32-bit and 64-bit gcc
build mxe openscad/mxe-base "$@"

build mxe openscad/mxe-x86_64-deps "$@"
build mxe openscad/mxe-x86_64-gui "$@"
build mxe openscad/mxe-x86_64-openscad "$@"

build mxe openscad/mxe-i686-deps "$@"
build mxe openscad/mxe-i686-gui "$@"
build mxe openscad/mxe-i686-openscad "$@"

list 'openscad/mxe-*'
