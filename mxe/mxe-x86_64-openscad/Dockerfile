#
# Build: docker build -t openscad/mxe-x86_64-openscad .
# Use: docker run --rm -it openscad/mxe-x86_64-openscad
#
FROM openscad/mxe-x86_64-deps:latest

ARG SUFFIX=
ARG OPENSCAD_VERSION=

WORKDIR /openscad
RUN git clone https://github.com/openscad/openscad .
RUN \
	export MXEDIR=/mxe ; \
	. ./scripts/setenv-mingw-xbuild.sh 64 && ./scripts/release-common.sh -snapshot -mingw64 -v "$OPENSCAD_VERSION"; \
	mkdir -p out; \
	for f in mingw*/*.zip mingw*/*.exe; do \
		N=$(basename "$f" | sed -e "s/\\(-x86-[36][24]\\)/\\1${SUFFIX}/;"); \
		cp -iv "$f" out/"$N"; \
	done

ENTRYPOINT tar --create -C /openscad/out .
