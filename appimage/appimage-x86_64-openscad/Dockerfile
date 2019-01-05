#
# Build: docker build -t appimage-x86_64-openscad .
# Use: docker run --rm -it -v appimage-x86_64-openscad
#
FROM openscad/appimage-x86_64-openscad:latest

ARG BRANCH=master
ARG OPENSCAD_VERSION=

WORKDIR /openscad

RUN \
        git clone https://github.com/openscad/openscad . && \
        git checkout "${BRANCH}" && \
        git rev-parse --abbrev-ref HEAD && \
        git log -n8 --pretty=tformat:"%h %ai (%aN) %s"

RUN \
	qmake CONFIG+=experimental CONFIG+=snapshot CONFIG-=debug PREFIX=/usr VERSION="$(OPENSCAD_VERSION)" && \
	make install INSTALL_ROOT=AppDir && \
	/appimage/linuxdeploy-x86_64.AppImage --plugin qt --output appimage --appdir AppDir && \
	mkdir -p out && \
	cp -iv OpenSCAD*.AppImage out/

ENTRYPOINT tar --create -C /openscad/out .
