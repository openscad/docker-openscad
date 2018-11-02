#
# Build: docker build -t openscad/mxe-x86_64-openscad .
# Use: docker run --rm -it openscad/mxe-x86_64-openscad
#
FROM openscad/mxe-x86_64-deps:latest

ARG SUFFIX=
ARG BRANCH=master
ARG OPENSCAD_VERSION=

WORKDIR /openscad
RUN \
	git clone https://github.com/openscad/openscad . && \
	git checkout "${BRANCH}" && \
	git rev-parse --abbrev-ref HEAD && \
	git log -n8 --pretty=tformat:"%h %ai (%aN) %s"
RUN \
	export MXEDIR=/mxe ; \
	export LIB3MF_INCLUDEPATH=/mxe/usr/x86_64-w64-mingw32.static.posix/include/lib3mf ; \
	. ./scripts/setenv-mingw-xbuild.sh 64 && ./scripts/release-common.sh -snapshot -mingw64 -v "$OPENSCAD_VERSION"; \
	mkdir -p out; \
	for f in mingw*/*.zip mingw*/*.exe; do \
		N=$(basename "$f" | sed -e "s/\\(-x86-[36][24]\\)/\\1${SUFFIX}/;"); \
		cp -iv "$f" out/"$N"; \
	done

ENTRYPOINT tar --create -C /openscad/out .
