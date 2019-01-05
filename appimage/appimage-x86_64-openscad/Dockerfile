#
# Build: docker build -t appimage-x86_64-openscad .
# Use: docker run --rm -it -v appimage-x86_64-openscad
#
FROM openscad/appimage-x86_64-base:latest

ARG BRANCH=master
ARG OPENSCAD_VERSION=
ARG JOBS=2

WORKDIR /openscad

RUN \
        git clone https://github.com/openscad/openscad . && \
        git checkout "${BRANCH}" && \
        git rev-parse --abbrev-ref HEAD && \
        git log -n8 --pretty=tformat:"%h %ai (%aN) %s"

RUN \
	export OPENSCAD_COMMIT=$(git log -1 --pretty=format:%h) && \
	qmake CONFIG+=experimental CONFIG+=snapshot CONFIG-=debug PREFIX=/usr VERSION="$OPENSCAD_VERSION" OPENSCAD_COMMIT="$OPENSCAD_COMMIT" && \
	make -j"$JOBS" && \
	make install INSTALL_ROOT=AppDir && \
	export PATH=/appimage/usr/bin:"$PATH" && \
	linuxdeploy --plugin qt --output appimage --appdir AppDir && \
	mkdir -p out && \
	cp -iv OpenSCAD*.AppImage out/

ENTRYPOINT tar --create -C /openscad/out .
