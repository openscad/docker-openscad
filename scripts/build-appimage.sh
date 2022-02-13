#!/bin/bash -e

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

COUNT=0

. "${SCRIPT_DIR}/build.sh"

clean

build appimage openscad/appimage-x86_64-base
build appimage openscad/appimage-x86_64-openscad

list 'openscad/appimage-*'
