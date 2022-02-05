#
# Build: docker build -t openscad/mxe-x86_64-gcc .
# Use: docker run --rm -it openscad/mxe-x86_64-gcc
#
FROM openscad/mxe-i686-gcc:latest

ARG JOBS=2
ARG BRANCH=openscad-snapshot-build
ARG GITHUB_USER=openscad
ARG GITHUB_REPO=mxe

WORKDIR /mxe

RUN \
  make "JOBS=${JOBS}" "-j${JOBS}" \
    MXE_TARGETS=x86_64-w64-mingw32.static.posix \
      cc && \
  make clean-junk
