#
# Build: docker build -t openscad/mxe-x86_64-openscad .
# Use: docker run --rm -it openscad/mxe-x86_64-openscad
#
FROM openscad/mxe-x86_64-deps:latest

ARG SUFFIX=
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
	export MXEDIR=/mxe ; \
	export NUMCPU="$JOBS" ; \
	export LIB3MF_INCLUDEPATH=/mxe/usr/x86_64-w64-mingw32.static.posix/include/lib3mf ; \
	export LIB3MF_LIBPATH=/mxe/usr/i686-w64-mingw32.static.posix/lib ; \
	./scripts/release-common.sh snapshot mingw64 -v "$OPENSCAD_VERSION"; \
	mkdir -p out; \
	for f in mingw*/*.zip mingw*/*.exe; do \
		N=$(basename "$f" | sed -e "s/\\(-x86-[36][24]\\)/\\1${SUFFIX}/;"); \
		cp -iv "$f" out/"$N"; \
	done

ENTRYPOINT tar --create -C /openscad/out .
