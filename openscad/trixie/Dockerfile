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
	./scripts/uni-get-dependencies.sh qt6

RUN \
	./scripts/check-dependencies.sh

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
		-DENABLE_TESTS=OFF \
		&& \
	make -j"$JOBS" && \
	make install

FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /usr/local

COPY --from=builder /usr/local/ .

RUN apt-get update

RUN apt-get -y full-upgrade

RUN apt-get install -y --no-install-recommends \
	libcairo2 libdouble-conversion3 libxml2 lib3mf1 libzip5 libharfbuzz0b \
	libboost-thread1.83.0 libboost-program-options1.83.0 libboost-filesystem1.83.0 \
	libboost-regex1.83.0 libmpfr6 libtbb12 libglu1-mesa libmimalloc3 \
	libqt6multimedia6 libqt6concurrent6 libqt6core5compat6 libqt6openglwidgets6 \
	libqscintilla2-qt6-15

RUN apt-get clean

WORKDIR /openscad
