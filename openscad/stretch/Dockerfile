FROM debian:stretch-slim AS builder

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

# Base setup
RUN \
        apt-get update && \
        apt-get upgrade -y && \
        apt-get install -y --no-install-recommends apt-utils apt-transport-https ca-certificates git wget gnupg jq

# Add OBS repo as Debian/stretch did not ship lib3mf-dev and libopencsg-dev had some issues
# that are fixed in version 1.4.2.
RUN \
	wget -qO - https://files.openscad.org/OBS-Repository-Key.pub | apt-key add - && \
	echo "deb https://download.opensuse.org/repositories/home:/t-paul:/lib3mf/Debian_9.0/ ./" >> /etc/apt/sources.list && \
	echo "deb https://download.opensuse.org/repositories/home:/t-paul:/opencsg-1.4.2/Debian_9.0/ ./" >> /etc/apt/sources.list

RUN \
        apt-get update && \
        apt-get upgrade -y

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

COPY patches/ patches/

RUN patch -p1 < patches/fix-qt-translation-call.patch

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

FROM debian:stretch-slim

RUN apt-get update

RUN apt-get -y full-upgrade

RUN apt-get install -y --no-install-recommends \
	libcairo2 libdouble-conversion1 libxml2 libzip4 libharfbuzz0b \
	libboost-thread1.62.0 libboost-program-options1.62.0 libboost-filesystem1.62.0 \
	libboost-regex1.62.0 libglew2.0 libmpfr4 libqt5scintilla2-12v5 libcgal12 \
	libqt5opengl5 libqt5multimedia5 libqt5concurrent5 libglu1-mesa libgl1-mesa-dri \
	xvfb xauth apt-transport-https ca-certificates wget gnupg

RUN \
	wget -qO - https://files.openscad.org/OBS-Repository-Key.pub | apt-key add - && \
	echo "deb https://download.opensuse.org/repositories/home:/t-paul:/lib3mf/Debian_9.0/ ./" >> /etc/apt/sources.list && \
	echo "deb https://download.opensuse.org/repositories/home:/t-paul:/opencsg-1.4.2/Debian_9.0/ ./" >> /etc/apt/sources.list && \
	apt-get update

RUN apt-get install -y --no-install-recommends \
	lib3mf1 libopencsg1

RUN apt-get clean

WORKDIR /usr/local

COPY --from=builder /usr/local/ .

# Prevent warning when running OpenSCAD
RUN mkdir -p /root/.local/share

WORKDIR /openscad
