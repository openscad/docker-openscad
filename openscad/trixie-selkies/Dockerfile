# syntax=docker/dockerfile:1

FROM debian:trixie-slim AS builder

ARG GITHUB_USER=openscad
ARG GITHUB_REPO=openscad
ARG BRANCH=master
ARG REFS=heads
ARG OPENSCAD_VERSION=
ARG BUILD_TYPE=Release
ARG SNAPSHOT=ON
ARG JOBS=1
ARG COMMIT=true

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y full-upgrade

# Base setup
RUN \
	apt-get install -y --no-install-recommends \
	build-essential binutils devscripts apt-utils apt-transport-https ca-certificates git wget jq

RUN \
	wget -qO- https://files.openscad.org/OBS-Repository-Key.pub \
	| tee /etc/apt/trusted.gpg.d/obs-openscad-nightly.asc

RUN \
	for line in \
		"X-Repolib-Name: obs-openscad-nightly" \
		"Types: deb" \
		"Suites: ./" \
		"URIs: https://download.opensuse.org/repositories/home:/t-paul:/docker-support/Debian_13/" \
		"Signed-By: /etc/apt/trusted.gpg.d/obs-openscad-nightly.asc" \
	; \
	do echo "$line" | tee -a /etc/apt/sources.list.d/obs-openscad-nightly.sources ; done

RUN \
	apt-get update

# Dev dependencies
RUN \
	apt-get -y install --no-install-recommends \
	build-essential curl libffi-dev libxmu-dev cmake bison flex \
	git-core libboost-all-dev libmpfr-dev libboost-dev \
	libcairo2-dev libeigen3-dev libcgal-dev libgmp3-dev \
	libgmp-dev imagemagick libfreetype6-dev libdouble-conversion-dev \
	gtk-doc-tools libglib2.0-dev gettext pkg-config ragel libxi-dev \
	libfontconfig-dev libzip-dev lib3mf-dev libharfbuzz-dev libxml2-dev \
	qtbase5-dev libqt5scintilla2-dev libqt5opengl5-dev libqt5svg5-dev \
	qtmultimedia5-dev libqt5multimedia5-plugins libtbb-dev \
	python3-pip python3-venv \
	libglew-dev

WORKDIR /openscad

# Invalidate docker cache if the branch changes
ADD https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/git/refs/${REFS}/${BRANCH} version.json

RUN \
	cat version.json | jq . && rm -f version.json && \
	git clone --recurse-submodules "https://github.com/${GITHUB_USER}/${GITHUB_REPO}" . && \
	git checkout "${BRANCH}" && \
	git rev-parse --abbrev-ref HEAD && \
	git log -n8 --pretty=tformat:"%h %ai (%aN) %s"

RUN \
	export OPENSCAD_COMMIT=$(/bin/"$COMMIT" && git log -1 --pretty=format:%h || echo "") && \
	mkdir build && \
	cd build && \
	cmake .. \
		-DCMAKE_INSTALL_PREFIX=/usr/local \
		-DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
		-DEXPERIMENTAL=${SNAPSHOT} \
		-DSNAPSHOT=${SNAPSHOT} \
		-DUSE_BUILTIN_OPENCSG=ON \
		-DOPENSCAD_VERSION="$OPENSCAD_VERSION" \
		-DOPENSCAD_COMMIT="$OPENSCAD_COMMIT" \
		&& \
	make -j"$JOBS" && \
	make install

# runtime stage
FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="OpenSCAD version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="docker-openscad"

# title
ENV TITLE=OpenSCAD \
    NO_FULL=true

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /usr/local

COPY --from=builder /usr/local/ .

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/openscad/openscad/master/icons/openscad-256.png && \
  echo "**** install runtime dependencies ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    libcairo2 libdouble-conversion3 libxml2 lib3mf1 libzip5 libharfbuzz0b \
    libboost-thread1.83.0 libboost-program-options1.83.0 libboost-filesystem1.83.0 \
    libboost-regex1.83.0 libmpfr6 libqscintilla2-qt5-15 \
    libqt5multimedia5 libqt5concurrent5 libtbb12 libglu1-mesa && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

WORKDIR /openscad

# ports and volumes
EXPOSE 3000

VOLUME /config
