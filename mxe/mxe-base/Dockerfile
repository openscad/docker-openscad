# syntax=docker/dockerfile:1.2
#
# Build: docker build -t openscad/mxe-base .
# Use: docker run --rm -it openscad/mxe-base
#
FROM openscad/mxe-requirements:latest

ARG JOBS=2
ARG MXE_REF=tags
ARG MXE_BRANCH=openscad-snapshot-build
ARG MXE_CLONE_DEPTH=5
ARG MXE_GITHUB_USER=openscad
ARG MXE_GITHUB_REPO=mxe
ARG CLEAN=clean-junk

COPY packages.lst /tmp
COPY settings.mk /tmp

WORKDIR /mxe

# Invalidate docker cache if the branch changes
ADD https://api.github.com/repos/${MXE_GITHUB_USER}/${MXE_GITHUB_REPO}/git/refs/${MXE_REF}/${MXE_BRANCH} version.json

RUN \
	cat version.json && rm -f version.json && \
	git clone --recursive --depth "${MXE_CLONE_DEPTH} --single-branch --branch "${MXE_BRANCH}" "https://github.com/${MXE_GITHUB_USER}/${MXE_GITHUB_REPO}" . && \
	git rev-parse --abbrev-ref HEAD && \
	git log -n"${MXE_CLONE_DEPTH}" --pretty=tformat:"%h %ai (%aN) %s"

RUN \
	--mount=type=cache,id=pkg,target=/mxe/pkg \
	eval `bash /tmp/packages.lst` && \
	make "JOBS=${JOBS}" "-j${JOBS}"  \
		MXE_SETTINGS_FILE=/tmp/settings.mk \
		MXE_PLUGIN_DIRS="${PLUGIN_DIRS}" \
		${PKG_DOWNLOAD_ALL} \
	&& \
	make "JOBS=${JOBS}" "-j${JOBS}"  \
		MXE_SETTINGS_FILE=/tmp/settings.mk \
		MXE_PLUGIN_DIRS="${PLUGIN_DIRS}" \
		MXE_TARGETS="${TARGET_32} ${TARGET_64}" \
		${PKG_MXE_GCC} \
	&& \
	make ${CLEAN}
