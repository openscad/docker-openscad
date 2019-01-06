#
# Build: docker build -t appimage-x86_64-base .
# Use: docker run --rm -it -v appimage-x86_64-base
#
FROM debian:jessie

ARG BRANCH=master

RUN \
	cat /etc/apt/sources.list && \
	apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y --no-install-recommends apt-utils ca-certificates git wget gpg

WORKDIR /openscad

RUN \
	git clone https://github.com/openscad/openscad . && \
	git checkout "${BRANCH}" && \
	git rev-parse --abbrev-ref HEAD && \
	git log -n8 --pretty=tformat:"%h %ai (%aN) %s"

RUN \
	bash ./scripts/uni-get-dependencies.sh && \
	bash ./scripts/check-dependencies.sh && \
	apt-get clean

WORKDIR /appimage

RUN \
	rm -rf /openscad && \
	wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage && \
	wget https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage && \
	chmod +x linuxdeploy*.AppImage && \
	./linuxdeploy-x86_64.AppImage --appimage-extract && \
	./linuxdeploy-plugin-qt-x86_64.AppImage --appimage-extract && \
	mv -iv $(find squashfs-root -mindepth 1 -maxdepth 1 -type d) . && \
	rm -rf squashfs-root && \
	find /appimage
