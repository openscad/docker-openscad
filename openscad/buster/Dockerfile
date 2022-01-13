FROM debian:buster-slim AS builder

ARG GITHUB_USER=openscad
ARG GITHUB_REPO=openscad
ARG BRANCH=master
ARG REFS=heads
ARG OPENSCAD_VERSION=
ARG SNAPSHOT=+
ARG DEBUG=-
ARG JOBS=1
ARG COMMIT=true

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get -y full-upgrade

# Base setup
RUN apt-get install -y --no-install-recommends \
	apt-utils apt-transport-https ca-certificates git wget jq

# Dev dependencies
RUN apt-get -y install --no-install-recommends \
	build-essential curl libffi-dev  libxmu-dev cmake bison flex \
	git-core libboost-all-dev libmpfr-dev libboost-dev libglew-dev \
	libcairo2-dev  libeigen3-dev libcgal-dev libopencsg-dev libgmp3-dev \
	libgmp-dev imagemagick libfreetype6-dev libdouble-conversion-dev \
	gtk-doc-tools libglib2.0-dev gettext pkg-config ragel libxi-dev \
	libfontconfig-dev libzip-dev lib3mf-dev libharfbuzz-dev libxml2-dev \
	qtbase5-dev libqt5scintilla2-dev libqt5opengl5-dev libqt5svg5-dev \
	qtmultimedia5-dev libqt5multimedia5-plugins qt5-default

WORKDIR /openscad

# Invalidate docker cache if the branch changes
ADD https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/git/refs/${REFS}/${BRANCH} version.json

RUN \
        cat version.json | jq . && rm -f version.json && \
        git clone "https://github.com/${GITHUB_USER}/${GITHUB_REPO}" . && \
        git checkout "${BRANCH}" && \
        git rev-parse --abbrev-ref HEAD && \
        git log -n8 --pretty=tformat:"%h %ai (%aN) %s"

RUN \
	git submodule update --init && \
        export OPENSCAD_COMMIT=$(/bin/"$COMMIT" && git log -1 --pretty=format:%h || echo "") && \
	qmake -v && \
	qmake -d \
		PREFIX=/usr/local \
		VERSION="$OPENSCAD_VERSION" \
		OPENSCAD_COMMIT="$OPENSCAD_COMMIT" \
		CONFIG+=qopenglwidget \
		CONFIG${SNAPSHOT}=experimental \
		CONFIG${SNAPSHOT}=snapshot \
		CONFIG${DEBUG}=debug && \
        make -j"$JOBS"

RUN make install INSTALL_ROOT=/

FROM debian:buster-slim

RUN apt-get update

RUN apt-get -y full-upgrade

RUN apt-get install -y --no-install-recommends \
	libcairo2 libdouble-conversion1 libxml2 lib3mf1 libzip4 libharfbuzz0b \
	libboost-thread1.67.0 libboost-program-options1.67.0 libboost-filesystem1.67.0 \
	libboost-regex1.67.0 libglew2.1 libopencsg1 libmpfr6 libqscintilla2-qt5-13 \
	libqt5multimedia5 libqt5concurrent5 libcgal13 libglu1-mesa xvfb xauth

RUN apt-get clean

WORKDIR /usr/local

COPY --from=builder /usr/local/ .

WORKDIR /openscad
