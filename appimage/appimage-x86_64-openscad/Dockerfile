#
# Build: docker build -t appimage-x86_64-openscad .
# Use: docker run --rm -it -v appimage-x86_64-openscad
#
FROM openscad/appimage-x86_64-base:latest

ARG GITHUB_USER=openscad
ARG GITHUB_REPO=openscad
ARG BRANCH=master
ARG OPENSCAD_VERSION=
ARG JOBS=2

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
	. /opt/qt511/bin/qt511-env.sh && \
	export OPENSCAD_COMMIT=$(git log -1 --pretty=format:%h) && \
	qmake -v && \
	qmake CONFIG+=experimental CONFIG+=snapshot CONFIG-=debug PREFIX=/usr VERSION="$OPENSCAD_VERSION" OPENSCAD_COMMIT="$OPENSCAD_COMMIT" && \
	make -j"$JOBS" && \
	make install INSTALL_ROOT=AppDir && \
	export PATH=/appimage/usr/bin:"$PATH" && \
	linuxdeploy --plugin qt --output appimage --appdir AppDir && \
	mkdir -p out && \
	cp -iv OpenSCAD*.AppImage out/

ENTRYPOINT tar --create -C /openscad/out .
