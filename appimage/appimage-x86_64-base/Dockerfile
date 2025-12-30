# -----------------------------------------------------------------------------
# Stage 1: Base image (Minimal)
# -----------------------------------------------------------------------------
FROM ubuntu:24.04 AS base
ENV DEBIAN_FRONTEND=noninteractive

# Install only the absolute bare minimum build tools used by almost everyone
# (wget/curl/ca-certificates for downloading, build-essential for compiling)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        git \
        gnupg \
        ninja-build \
        wget \
        && rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------------------------------
# Stage 2: Lib3MF
# -----------------------------------------------------------------------------
FROM base AS lib3mf-builder

# Install Lib3MF specific dependencies
# uuid-dev, libssl-dev etc. are required for Lib3MF
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        uuid-dev \
        && rm -rf /var/lib/apt/lists/*

# 1.8.1
ARG LIB3MF_COMMIT=ff914b9fae76cd6a365952728f44f8d79a9f8f75

WORKDIR /tmp/build

RUN wget -q https://github.com/3MFConsortium/lib3mf/archive/${LIB3MF_COMMIT}.tar.gz -O lib3mf.tar.gz && \
    mkdir lib3mf && \
    tar -xzf lib3mf.tar.gz -C lib3mf --strip-components=1 && \
    rm lib3mf.tar.gz

WORKDIR /tmp/build/lib3mf/build

RUN cmake .. \
    -GNinja \
    -DCMAKE_BUILD_TYPE=Release \
    -DLIB3MF_TESTS=OFF \
    -DUSE_INCLUDED_SSL=OFF \
    -DCMAKE_INSTALL_PREFIX=/inst \
    -DCMAKE_INSTALL_LIBDIR=lib && \
    cmake --build . --config Release && \
    cmake --install .

# -----------------------------------------------------------------------------
# Stage 3: CGAL
# -----------------------------------------------------------------------------
FROM base AS cgal-builder

# Install CGAL specific dependencies
# CGAL often needs GMP/MPFR (though sometimes header-only, full builds need them)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libgmp-dev \
        libboost-dev \
        libmpfr-dev \
        && rm -rf /var/lib/apt/lists/*

# v5.6.3
ARG CGAL_COMMIT=3654f780ae0c64675cabaef0e5ddaf904c48b4b7

WORKDIR /tmp/build

RUN wget -q https://github.com/CGAL/cgal/archive/${CGAL_COMMIT}.tar.gz -O cgal.tar.gz && \
    mkdir cgal && \
    tar -xzf cgal.tar.gz -C cgal --strip-components=1 && \
    rm cgal.tar.gz

WORKDIR /tmp/build/cgal/build

RUN cmake .. \
    -GNinja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCGAL_HEADER_ONLY=OFF \
    -DBUILD_TESTING=OFF \
    -DBUILD_DOC=OFF \
    -DCMAKE_INSTALL_PREFIX=/inst \
    -DCMAKE_INSTALL_LIBDIR=lib && \
    cmake --build . --config Release && \
    cmake --install .

# -----------------------------------------------------------------------------
# Stage 4: QScintilla
# -----------------------------------------------------------------------------
FROM base AS qscintilla-builder

# Install Qt5 dependencies specifically for QScintilla
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        qt5-qmake \
        qtbase5-dev \
        libqt5svg5-dev \
        && rm -rf /var/lib/apt/lists/*

WORKDIR /build
RUN wget -q https://www.riverbankcomputing.com/static/Downloads/QScintilla/2.14.1/QScintilla_src-2.14.1.tar.gz && \
    tar xvf QScintilla_src-2.14.1.tar.gz

WORKDIR /build/QScintilla_src-2.14.1/src
RUN qmake && \
    make -j$(nproc) && \
    make install INSTALL_ROOT=/inst

# -----------------------------------------------------------------------------
# Stage 5: AppImage Tooling (LinuxDeploy)
# -----------------------------------------------------------------------------
FROM base AS deploy-tools

# Dependencies for extracting AppImages and running linuxdeploy scripts
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        file \
        unzip \
        python3-dev \
        && rm -rf /var/lib/apt/lists/*

WORKDIR /appimage

RUN wget -q https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage && \
    wget -q https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage && \
    wget -q https://github.com/t-paul/linuxdeploy-plugin-python/archive/refs/heads/master.zip -O linuxdeploy-plugin-python.zip && \
    wget -q https://raw.githubusercontent.com/linuxdeploy/linuxdeploy-plugin-gtk/master/linuxdeploy-plugin-gtk.sh

RUN chmod +x linuxdeploy*.AppImage *.sh && \
    ./linuxdeploy-x86_64.AppImage --appimage-extract && \
    ./linuxdeploy-plugin-qt-x86_64.AppImage --appimage-extract && \
    mkdir -p usr/bin/share && \
    mv -iv squashfs-root/usr/bin/* usr/bin && \
    mv -iv squashfs-root/plugins . && \
    rm -rf squashfs-root && \
    unzip -p linuxdeploy-plugin-python.zip linuxdeploy-plugin-python-master/linuxdeploy-plugin-python.sh > usr/bin/linuxdeploy-plugin-python.sh && \
    unzip -p linuxdeploy-plugin-python.zip linuxdeploy-plugin-python-master/share/sitecustomize.py > usr/bin/sitecustomize.py && \
    chmod 755 /appimage/usr/bin/linuxdeploy-plugin-python.sh && \
    rm -rf *.AppImage *.zip

# -----------------------------------------------------------------------------
# Stage 6: Final Assembly & OpenSCAD Build Prep
# -----------------------------------------------------------------------------
FROM base AS openscad-appimage-x86_64-base

# Install Runtime/Link-time dependencies required for the final OpenSCAD aggregation
# These are things that OpenSCAD itself needs to compile or run the dependency scripts.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        appstream \
        apt-transport-https \
        apt-utils \
        file \
        libbz2-dev \
        liblzma-dev \
        libqt5svg5-dev \
        libsqlite3-dev \
        libssl-dev \
        libgmp-dev \
        lsb-release \
        ncat \
        nettle-dev \
        openssh-client \
        python3-dev \
        qt5-qmake \
        qtbase5-dev \
        software-properties-common \
        unzip \
        uuid-dev \
        && rm -rf /var/lib/apt/lists/*

WORKDIR /openscad

# 2025-12-23
ARG OPENSCAD_COMMIT=cfdd775c439094698f1c6e5595b7574f636af4da

RUN curl -L "https://github.com/openscad/openscad/archive/${OPENSCAD_COMMIT}.tar.gz" | tar -xz --strip-components=1 && \
    bash ./scripts/uni-get-dependencies.sh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=lib3mf-builder /inst /usr/
COPY --from=cgal-builder /inst /usr/
COPY --from=qscintilla-builder /inst /usr/
RUN ldconfig

COPY --from=deploy-tools /appimage /appimage

RUN bash ./scripts/check-dependencies.sh && \
    find . -maxdepth 1 -mindepth 1 -exec rm -rf {} +

# -----------------------------------------------------------------------------
# Stage 6: Final Build
# -----------------------------------------------------------------------------
FROM openscad-appimage-x86_64-base

WORKDIR /openscad

ARG OPENSCAD_COMMIT=cfdd775c439094698f1c6e5595b7574f636af4da
ARG SNAPSHOT=ON
ARG JOBS=4

RUN \
    git clone "https://github.com/openscad/openscad" . && \
    git checkout "${OPENSCAD_COMMIT}" && \
    git submodule update --init --recursive && \
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
		-DCMAKE_BUILD_TYPE=Release \
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
