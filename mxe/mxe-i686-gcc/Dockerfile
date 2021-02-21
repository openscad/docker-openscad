#
# Build: docker build -t openscad/mxe-i686-gcc .
# Use: docker run --rm -it openscad/mxe-i686-gcc
#
FROM openscad/mxe-requirements:latest

ARG JOBS=2
ARG BRANCH=openscad-snapshot-build
ARG GITHUB_USER=openscad
ARG GITHUB_REPO=mxe

WORKDIR /mxe

# Invalidate docker cache if the branch changes
ADD https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/git/refs/heads/${BRANCH} version.json

RUN \
	cat version.json && rm -f version.json && \
	git clone "https://github.com/${GITHUB_USER}/${GITHUB_REPO}" . && \
	git checkout "${BRANCH}" && \
	git rev-parse --abbrev-ref HEAD && \
	git log -n8 --pretty=tformat:"%h %ai (%aN) %s"
RUN \
	make "JOBS=${JOBS}" "-j${JOBS}" MXE_PLUGIN_DIRS=plugins/gcc10 MXE_TARGETS=i686-w64-mingw32.static.posix cc
