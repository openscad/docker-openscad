#
# Build: docker build -t openscad/appimage-x86_64-openscad .
# Use: docker run --rm -it -v openscad/appimage-x86_64-openscad
#
FROM openscad/appimage-x86_64-base:latest

ARG GITHUB_USER=openscad
ARG GITHUB_REPO=openscad
ARG BRANCH=master
ARG REFS=heads
ARG OPENSCAD_VERSION=
ARG BUILD_TYPE=Release
ARG SNAPSHOT=ON
ARG JOBS=2
ARG COMMIT=true

WORKDIR /openscad

# Invalidate docker cache if the branch changes
ADD https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/git/refs/${REFS}/${BRANCH} version.json

RUN \
	cat version.json && rm -f version.json && \
	git clone --recursive --single-branch --branch "${BRANCH}" --shallow-submodules "https://github.com/${GITHUB_USER}/${GITHUB_REPO}" . && \
	git rev-parse --abbrev-ref HEAD && \
	git log -n8 --pretty=tformat:"%h %ai (%aN) %s"

RUN \
	. /opt/qt*/bin/qt*-env.sh && \
	export OPENSCAD_COMMIT=$(/bin/"$COMMIT" && git log -1 --pretty=format:%h || echo "") && \
	mkdir build && \
	cd build && \
	cmake .. \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
		-DEXPERIMENTAL=${SNAPSHOT} \
		-DSNAPSHOT=${SNAPSHOT} \
		-DOPENSCAD_VERSION="$OPENSCAD_VERSION" \
		-DOPENSCAD_COMMIT="$OPENSCAD_COMMIT" \
		-DENABLE_TESTS=OFF \
		&& \
	make -j"$JOBS" && \
	make install DESTDIR=../AppDir

RUN \
	. /opt/qt*/bin/qt*-env.sh && \
	export PATH=/appimage/usr/bin:"$PATH" && \
	mv -iv AppDir/usr/share/applications/openscad.desktop AppDir/usr/share/applications/org.openscad.OpenSCAD.desktop && \
	sed -i -e 's/openscad.desktop/org.openscad.OpenSCAD.desktop/' AppDir/usr/share/metainfo/org.openscad.OpenSCAD.appdata.xml && \
	sed -i -e '/<content_rating/d' AppDir/usr/share/metainfo/org.openscad.OpenSCAD.appdata.xml && \
	VERSION="${OPENSCAD_VERSION:-$(date +%Y.%m.%d).ai}" linuxdeploy --plugin qt --output appimage --appdir AppDir && \
	mkdir -p out && \
	cp -iv OpenSCAD*.AppImage out/

ENTRYPOINT tar --create -C /openscad/out .
