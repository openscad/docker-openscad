#
# Build: docker build -t openscad/appimage-arm64v8-openscad .
# Use: docker run --rm -it -v openscad/appimage-arm64v8-openscad
#
FROM openscad/appimage-arm64v8-base:latest

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
	export OPENSCAD_COMMIT=$(/bin/"$COMMIT" && git log -1 --pretty=format:%h || echo "") && \
	mkdir build && \
	cd build && \
	cmake .. \
		-GNinja \
		-DENABLE_TESTS=OFF \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
		-DOpenGL_GL_PREFERENCE=LEGACY \
		-DEXPERIMENTAL=${SNAPSHOT} \
		-DSNAPSHOT=${SNAPSHOT} \
		-DOPENSCAD_VERSION="$OPENSCAD_VERSION" \
		-DOPENSCAD_COMMIT="$OPENSCAD_COMMIT" \
		&& \
	cmake --build . "-j$JOBS" -v

RUN \
	cmake --install build --prefix=AppDir/usr -v

RUN \
	export PATH=/appimage/usr/bin:"$PATH" && \
	VERSION="${OPENSCAD_VERSION:-$(date +%Y.%m.%d).ai}" linuxdeploy --plugin qt --output appimage --appdir AppDir && \
	mkdir -p out && \
	cp -iv OpenSCAD*.AppImage out/

ENTRYPOINT tar --create -C /openscad/out .
