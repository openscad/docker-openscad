FROM debian:bookworm-slim AS builder

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
	build-essential devscripts apt-utils apt-transport-https ca-certificates git wget jq

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

FROM debian:bookworm-slim

RUN apt-get update

RUN apt-get -y full-upgrade

RUN apt-get install -y --no-install-recommends \
	libcairo2 libdouble-conversion3 libxml2 lib3mf1 libzip4 libharfbuzz0b \
	libboost-thread1.74.0 libboost-program-options1.74.0 libboost-filesystem1.74.0 \
	libboost-regex1.74.0 libmpfr6 libqscintilla2-qt5-15 \
	libqt5multimedia5 libqt5concurrent5 libtbb12 libglu1-mesa \
	libglew2.2 xvfb xauth

RUN apt-get clean

WORKDIR /usr/local

COPY --from=builder /usr/local/ .

WORKDIR /openscad
