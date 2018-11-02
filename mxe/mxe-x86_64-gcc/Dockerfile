#
# Build: docker build -t mxe-x86_64-gcc .
# Use: docker run --rm -it mxe-x86_64-gcc
#
FROM openscad/mxe-requirements:latest

ARG JOBS=2
ARG BRANCH=openscad-snapshot-build
ARG URL=https://github.com/openscad/mxe

WORKDIR /mxe

RUN git clone "${URL}" . || git pull origin "${BRANCH}"
RUN make "JOBS=${JOBS}" "-j${JOBS}" MXE_PLUGIN_DIRS=plugins/gcc7 MXE_TARGETS=x86_64-w64-mingw32.static.posix gcc
