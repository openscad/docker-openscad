#
# Build: docker build --progress=plain --load -t openscad/appimage-x86_64-base:latest .
#
FROM ubuntu:22.04

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
		libsqlite3-dev \
		lsb-release \
		liblzma-dev \
		libssl-dev \
		libbz2-dev \
		appstream \
		apt-utils \
		unzip \
		gnupg \
		file \
		ncat \
		wget \
		git

RUN \
	sed -ie 's/^#\s*\(.*universe\)$/\1/' /etc/apt/sources.list && \
	echo "deb https://download.opensuse.org/repositories/home:/t-paul:/lib3mf/xUbuntu_22.04/ ./" >> /etc/apt/sources.list && \
	echo "deb https://download.opensuse.org/repositories/home:/t-paul:/cgal/xUbuntu_22.04/ ./" >> /etc/apt/sources.list && \
	grep -v "^#" /etc/apt/sources.list && \
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
	(apt-get install -y lib3mf-dev python3-dev nettle-dev || /bin/true) && \
	apt-get clean

WORKDIR /appimage

RUN \
	rm -rf /openscad && \
	wget -q https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage && \
	wget -q https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage && \
	wget -q https://github.com/t-paul/linuxdeploy-plugin-python/archive/refs/heads/master.zip -O linuxdeploy-plugin-python.zip && \
	wget -q https://raw.githubusercontent.com/linuxdeploy/linuxdeploy-plugin-gtk/master/linuxdeploy-plugin-gtk.sh

RUN \
	chmod +x linuxdeploy*.AppImage *.sh && \
	./linuxdeploy-x86_64.AppImage --appimage-extract && \
	./linuxdeploy-plugin-qt-x86_64.AppImage --appimage-extract && \
	mkdir -p usr/bin/share && \
	mv -iv squashfs-root/usr/bin/* usr/bin && \
	mv -iv squashfs-root/plugins . && \
	rm -rf squashfs-root && \
	unzip -p linuxdeploy-plugin-python.zip linuxdeploy-plugin-python-master/linuxdeploy-plugin-python.sh > usr/bin/linuxdeploy-plugin-python.sh && \
	unzip -p linuxdeploy-plugin-python.zip linuxdeploy-plugin-python-master/share/sitecustomize.py > usr/bin/sitecustomize.py && \
        chmod 755 /appimage/usr/bin/linuxdeploy-plugin-python.sh && \
	rm -rf squashfs-root && \
	rm -rf *.AppImage && \
	find /appimage

RUN \
	dpkg --purge $(dpkg -l 'libqscintilla2-qt5*' | grep ^ii | awk '{ print $2 }') && \
	wget -q https://www.riverbankcomputing.com/static/Downloads/QScintilla/2.14.1/QScintilla_src-2.14.1.tar.gz && \
	tar xvf QScintilla_src-2.14.1.tar.gz && \
	cd QScintilla_src-2.14.1/src && \
	qmake && \
	make -j2 && make install
