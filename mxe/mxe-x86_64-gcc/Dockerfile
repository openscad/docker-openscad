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

# Invalidate docker cache if the branch changes
ADD https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/git/refs/heads/${BRANCH} version.json

RUN \
	cat version.json && rm -f version.json && \
	git clone "https://github.com/${GITHUB_USER}/${GITHUB_REPO}" . && \
	git checkout "${BRANCH}" && \
	git rev-parse --abbrev-ref HEAD && \
	git log -n8 --pretty=tformat:"%h %ai (%aN) %s"

# use 32bit makensis from MXE. 64bit version not compatible
# for that we use the i686-gcc base image which provides the
# already built gcc
RUN \
	make "JOBS=${JOBS}" "-j${JOBS}" \
                MXE_PLUGIN_DIRS=plugins/gcc10 \
                MXE_TARGETS=x86_64-w64-mingw32.static.posix \
                cc && \
	make "JOBS=${JOBS}" "-j${JOBS}" \
		MXE_PLUGIN_DIRS=plugins/gcc10 \
		MXE_TARGETS=i686-w64-mingw32.static.posix \
		nsis && \
	make MXE_PLUGIN_DIRS=plugins/gcc10 clean-junk
