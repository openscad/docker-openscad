#
# Build: docker build -t mxe-i686-gcc .
# Use: docker run --rm -it mxe-i686-gcc
#
FROM openscad/mxe-requirements:latest

ARG JOBS=2
ARG BRANCH=openscad-snapshot-build
ARG URL=https://github.com/openscad/mxe

WORKDIR /mxe

RUN \
	git clone "${URL}" . && \
	git checkout "${BRANCH}" && \
	git rev-parse --abbrev-ref HEAD && \
	git log -n8 --pretty=tformat:"%h %ai (%aN) %s"
RUN \
	make "JOBS=${JOBS}" "-j${JOBS}" MXE_PLUGIN_DIRS=plugins/gcc7 MXE_TARGETS=i686-w64-mingw32.static.posix gcc
