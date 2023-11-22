#
# Build: docker build -t openscad/mxe-x86_64-openscad .
# Use: docker run --rm -it openscad/mxe-x86_64-openscad
#
FROM openscad/mxe-x86_64-gui:latest

ARG SUFFIX=
ARG GITHUB_USER=openscad
ARG GITHUB_REPO=openscad
ARG BRANCH=master
ARG REFS=heads
ARG OPENSCAD_VERSION=
ARG RELEASE_TYPE=snapshot
ARG JOBS=2

WORKDIR /openscad

# Invalidate docker cache if the branch changes
ADD https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/git/refs/${REFS}/${BRANCH} version.json

RUN \
	cat version.json && rm -f version.json && \
	git clone --recursive "https://github.com/${GITHUB_USER}/${GITHUB_REPO}" . && \
	git checkout "${BRANCH}" && \
	git rev-parse --abbrev-ref HEAD && \
	git log -n8 --pretty=tformat:"%h %ai (%aN) %s"
RUN \
	export LC_ALL=C.UTF-8 ; \
	export MXEDIR=/mxe ; \
	export PKG_CONFIG_PATH=/mxe/usr/x86_64-w64-mingw32.static.posix/lib/pkgconfig ; \
	bash -c 'ln -sfv /usr/bin/python{3,}' ; \
	export NUMCPU="$JOBS" ; \
	export LIB3MF_INCLUDEPATH=/mxe/usr/x86_64-w64-mingw32.static.posix/include/lib3mf ; \
	export LIB3MF_LIBPATH=/mxe/usr/x86_64-w64-mingw32.static.posix/lib ; \
	sed -ie 's/WARNING_FLAGS -Werror/WARNING_FLAGS/' submodules/manifold/CMakeLists.txt ; \
	./scripts/release-common.sh -v "${OPENSCAD_VERSION}" mingw64 ${RELEASE_TYPE} ; \
	mkdir -p out; \
	for f in mingw*/*.zip mingw*/*Installer.exe; do \
		N=$(basename "$f" | sed -e "s/\\(-x86-[36][24]\\)/\\1${SUFFIX}/;"); \
		cp -iv "$f" out/"$N"; \
	done

ENTRYPOINT tar --create -C /openscad/out .
