#
# Build: docker build -t appimage-x86_64-base .
# Use: docker run --rm -it -v appimage-x86_64-base
#
FROM ubuntu:20.04

ARG GITHUB_USER=openscad
ARG GITHUB_REPO=openscad
ARG BRANCH=master

ENV DEBIAN_FRONTEND=noninteractive

RUN \
	apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y --no-install-recommends \
		software-properties-common \
		apt-transport-https \
		ca-certificates \
		openssh-client \
		lsb-release \
		appstream \
		apt-utils \
		gnupg \
		ncat \
		wget \
		git

RUN \
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C65D51784EDC19A871DBDBB710C56D0DE9977759 && \
	sed -ie 's/^#\s*\(.*universe\)$/\1/' /etc/apt/sources.list && \
	echo "deb http://ppa.launchpad.net/beineri/opt-qt-5.15.4-focal/ubuntu focal main" >> /etc/apt/sources.list && \
	echo "deb https://apt.kitware.com/ubuntu/ focal main" >> /etc/apt/sources.list && \
	echo "deb https://download.opensuse.org/repositories/home:/t-paul:/lib3mf/xUbuntu_20.04/ ./" >> /etc/apt/sources.list && \
	echo "deb https://download.opensuse.org/repositories/home:/t-paul:/cgal/xUbuntu_20.04/ ./" >> /etc/apt/sources.list && \
	echo "deb https://download.opensuse.org/repositories/home:/t-paul:/opencsg-1.5/xUbuntu_20.04/ ./" >> /etc/apt/sources.list && \
	grep -v "^#" /etc/apt/sources.list && \
	wget -qO - https://files.openscad.org/OBS-Repository-Key.pub | apt-key add - && \
	wget -qO - https://apt.kitware.com/keys/kitware-archive-latest.asc | apt-key add - && \
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
	apt-get install -y --no-install-recommends build-essential fakeroot devscripts qt515base qt515gamepad qt515multimedia qt515svg && \
	cd /opt/qt5*/include/ && ln -s /usr/include/x86_64-linux-gnu/qt5/Qsci && \
	cd /opt/qt5*/mkspecs/features && ln -s /usr/lib/x86_64-linux-gnu/qt5/mkspecs/features/qscintilla2.prf

WORKDIR /appimage

RUN \
	rm -rf /openscad && \
	wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage && \
	wget https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage && \
	wget https://raw.githubusercontent.com/linuxdeploy/linuxdeploy-plugin-gtk/master/linuxdeploy-plugin-gtk.sh && \
	chmod +x linuxdeploy*.AppImage *.sh && \
	./linuxdeploy-x86_64.AppImage --appimage-extract && \
	./linuxdeploy-plugin-qt-x86_64.AppImage --appimage-extract && \
	mv -iv $(find squashfs-root -mindepth 1 -maxdepth 1 -type d) . && \
	mv -iv linuxdeploy-plugin-gtk.sh usr/bin/ && \
	rm -rf *.AppImage squashfs-root && \
	find /appimage
