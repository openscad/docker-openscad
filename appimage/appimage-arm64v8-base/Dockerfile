#
# Build: docker build -t appimage-arm64v8-base .
# Use: docker run --rm -it -v appimage-arm64v8-base
#
FROM arm64v8/debian:buster-slim

ARG GITHUB_USER=openscad
ARG GITHUB_REPO=openscad
ARG BRANCH=master
ARG JOBS=2

ENV DEBIAN_FRONTEND noninteractive

RUN \
	apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y --no-install-recommends \
		apt-utils apt-transport-https ca-certificates git wget \
		patchelf gnupg ccache appstream xxd desktop-file-utils \
		libjpeg-dev cimg-dev libcairo-dev libfuse-dev libssl-dev \
		&& \
	apt-get clean

WORKDIR /openscad

# Invalidate docker cache if the branch changes
ADD https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/git/refs/heads/${BRANCH} version.json

RUN \
	cat version.json && rm -f version.json && \
	git clone "https://github.com/${GITHUB_USER}/${GITHUB_REPO}" . && \
	git checkout "${BRANCH}" && \
	git rev-parse --abbrev-ref HEAD && \
	git log -n8 --pretty=tformat:"%h %ai (%aN) %s" && \
	bash ./scripts/uni-get-dependencies.sh && \
	bash ./scripts/check-dependencies.sh && \
	(apt-get install -y lib3mf-dev || /bin/true) && \
	cd / && apt-get clean && rm -rf /openscad

WORKDIR /appimage

RUN \
	git clone --single-branch --recursive https://github.com/linuxdeploy/linuxdeploy.git && \
	git clone --single-branch --recursive https://github.com/linuxdeploy/linuxdeploy-plugin-qt.git && \
	git clone --single-branch --recursive https://github.com/linuxdeploy/linuxdeploy-plugin-appimage.git && \
	git clone --single-branch --recursive https://github.com/AppImage/AppImageKit.git

RUN \
	cd /appimage/linuxdeploy/ && mkdir build && cd build/ && cmake -DCMAKE_INSTALL_PREFIX=/appimage/usr -DCMAKE_BUILD_TYPE=RelWithDebInfo .. && make -j"$JOBS" && make install && \
        cd /appimage && mkdir -p usr/bin/ && cp linuxdeploy/build/bin/linuxdeploy usr/bin/

RUN \
	cd /appimage/linuxdeploy-plugin-qt/ && mkdir build && cd build/ && cmake -DCMAKE_INSTALL_PREFIX=/appimage/usr -DCMAKE_BUILD_TYPE=RelWithDebInfo .. && make -j"$JOBS" && make install

RUN \
	cd /appimage/linuxdeploy-plugin-appimage && mkdir build && cd build/ && cmake -DCMAKE_INSTALL_PREFIX=/appimage/usr -DCMAKE_BUILD_TYPE=RelWithDebInfo .. && make -j"$JOBS" && make install

RUN \
	cd /appimage/AppImageKit && mkdir build && cd build/ && cmake -DCMAKE_INSTALL_PREFIX=/appimage/usr -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_TESTING=OFF -DAPPIMAGEKIT_PACKAGE_DEBS=OFF .. && make -j"$JOBS" && make install

RUN \
	rm -rf linuxdeploy linuxdeploy-plugin-qt linuxdeploy-plugin-appimage AppImageKit && \
	find /appimage
