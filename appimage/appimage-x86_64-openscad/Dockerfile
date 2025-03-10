#
# Build: docker build --progress=plain --load -t openscad/appimage-x86_64-openscad .
# Use: docker run --rm openscad/appimage-x86_64-openscad | tar tvf -
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
	export OPENSCAD_VERSION="$(date +%Y.%m.%d).ai" && \
	export OPENSCAD_COMMIT=$(/bin/"$COMMIT" && git log -1 --pretty=format:%h || echo "") && \
	mkdir build && \
	cd build && \
	cmake .. \
		-DOPENSCAD_VERSION="$OPENSCAD_VERSION" \
		-DOPENSCAD_COMMIT="$OPENSCAD_COMMIT" \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
                -DUSE_BUILTIN_OPENCSG=ON \
                -DMANIFOLD_PYBIND=OFF \
                -DMANIFOLD_TEST=OFF \
                -DENABLE_PYTHON=ON \
		-DENABLE_TESTS=OFF \
		-DEXPERIMENTAL=${SNAPSHOT} \
		-DSNAPSHOT=${SNAPSHOT} \
		&& \
	make -j"$JOBS" && \
	make install DESTDIR=../AppDir

RUN \
	export PATH=/appimage/usr/bin:"$PATH" && \
	( cd AppDir/usr/bin && ln -s openscad openscad-python ) && \
	mv -iv AppDir/usr/share/applications/openscad.desktop AppDir/usr/share/applications/org.openscad.OpenSCAD.desktop && \
	sed -i -e 's/openscad.desktop/org.openscad.OpenSCAD.desktop/' AppDir/usr/share/metainfo/org.openscad.OpenSCAD.appdata.xml && \
	sed -i -e '/<content_rating/d' AppDir/usr/share/metainfo/org.openscad.OpenSCAD.appdata.xml && \
	DEBUG=1 \
	EXTRA_QT_MODULES=svg \
	LINUXDEPLOY_OUTPUT_VERSION="${OPENSCAD_VERSION:-$(date +%Y.%m.%d).ai}" \
	PYTHON_VERSION=$(python3 -c "import sys; v=sys.version_info; print(f'{v.major}.{v.minor}.{v.micro}')") \
	linuxdeploy --plugin python --plugin qt --output appimage --appdir AppDir && \
	mkdir -p out && \
	cp -iv OpenSCAD*.AppImage out/

ENTRYPOINT [ "tar", "--create", "-C", "/openscad/out", "." ]
