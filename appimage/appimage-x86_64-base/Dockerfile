#
# Build: docker build -t appimage-x86_64-base .
# Use: docker run --rm -it -v appimage-x86_64-base
#
FROM ubuntu:16.04

ARG GITHUB_USER=openscad
ARG GITHUB_REPO=openscad
ARG BRANCH=master

RUN \
	apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y --no-install-recommends apt-utils apt-transport-https ca-certificates git wget gnupg && \
	sed -ie 's/^#\s*\(.*universe\)$/\1/' /etc/apt/sources.list && \
	echo "deb http://ppa.launchpad.net/beineri/opt-qt-5.14.2-xenial/ubuntu xenial main" >> /etc/apt/sources.list && \
	echo "deb http://download.opensuse.org/repositories/home:/t-paul:/lib3mf/xUbuntu_16.04/ ./" >> /etc/apt/sources.list && \
	echo "deb http://download.opensuse.org/repositories/home:/t-paul:/appimage-support/xUbuntu_16.04/ ./" >> /etc/apt/sources.list && \
	grep -v "^#" /etc/apt/sources.list && \
	apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys C65D51784EDC19A871DBDBB710C56D0DE9977759 && \
	wget -qO - https://files.openscad.org/OBS-Repository-Key.pub | apt-key add - && \
	apt-get update && \
	apt-get upgrade -y

WORKDIR /openscad

# Invalidate docker cache if the branch changes
ADD https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/git/refs/heads/${BRANCH} version.json

RUN \
	cat version.json && rm -f version.json && \
	git clone "https://github.com/${GITHUB_USER}/${GITHUB_REPO}" . && \
	git checkout "${BRANCH}" && \
	git rev-parse --abbrev-ref HEAD && \
	git log -n8 --pretty=tformat:"%h %ai (%aN) %s"

RUN \
	bash ./scripts/uni-get-dependencies.sh && \
	bash ./scripts/check-dependencies.sh && \
	(apt-get install -y lib3mf-dev || /bin/true) && \
	apt-get clean

WORKDIR /qt5-update

RUN \
	apt-get install -y --no-install-recommends build-essential fakeroot devscripts qt514-meta-minimal qt514gamepad qt514multimedia && \
	cd /opt/qt5*/include/ && ln -s /usr/include/x86_64-linux-gnu/qt5/Qsci && \
	cd /opt/qt5*/mkspecs/features && ln -s /usr/lib/x86_64-linux-gnu/qt5/mkspecs/features/qscintilla2.prf

WORKDIR /appimage

RUN \
	rm -rf /openscad && \
	wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage && \
	wget https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage && \
	chmod +x linuxdeploy*.AppImage && \
	./linuxdeploy-x86_64.AppImage --appimage-extract && \
	./linuxdeploy-plugin-qt-x86_64.AppImage --appimage-extract && \
	mv -iv $(find squashfs-root -mindepth 1 -maxdepth 1 -type d) . && \
	rm -rf *.AppImage squashfs-root && \
	find /appimage
