#!/bin/bash
set -eu

export MXE_PREFIX=/mxe
export TARGET=x86_64-w64-mingw32.static.posix
export PATH="$MXE_PREFIX/usr/bin":"$MXE_PREFIX/usr/x86_64-pc-linux-gnu/bin":"$PATH"

URL="https://github.com/CGAL/cgal/releases/download"

function install() {
(
        V="CGAL-$1"
        rm -rf "$V"
        tar xf "$V-library.tar.xz"
        cd "$V"
        mkdir -p build
        cd build
        ${TARGET}-cmake .. \
                -DCMAKE_BUILD_TYPE=Release \
                -DCGAL_INSTALL_CMAKE_DIR:STRING="lib/CGAL" \
                -DCGAL_INSTALL_INC_DIR:STRING="include" \
                -DCGAL_INSTALL_DOC_DIR:STRING="share/doc/CGAL-$version" \
                -DCGAL_INSTALL_BIN_DIR:STRING="bin"
        make install >/dev/null
)
}

for version in $(ls -1 *.xz | sed -e 's/[^-]*-\([0-9.]*\)-.*/\1/') ; do
  install "${version}"

  echo "# Compiling w/ CGAL ${version}"
  "$TARGET"-g++ -std=c++14 -DCGAL_USE_GMPXX=1 -o bug.cc.obj -c bug.cc
  echo "# Compilation finished"
  echo
  echo "# Press enter to continue"

  read
done

