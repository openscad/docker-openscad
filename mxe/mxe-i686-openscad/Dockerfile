#
# Build: docker build -t openscad/mxe-i686-openscad .
# Use: docker run --rm -it openscad/mxe-i686-openscad
#
FROM openscad/mxe-i686-deps:latest

WORKDIR /openscad
RUN git clone https://github.com/openscad/openscad .
RUN \
	export MXEDIR=/mxe ; \
	if [ x"$CIRCLECI" = xtrue ]; then \
		export SUFFIX="-ci${CIRCLE_BUILD_NUM}"; \
		export OPENSCAD_VERSION="$(date +%Y.%m.%d).${CIRCLE_BUILD_NUM}"; \
	else \
		export SUFFIX=""; \
		export OPENSCAD_VERSION="$(date +%Y.%m.%d)"; \
	fi; \
	. ./scripts/setenv-mingw-xbuild.sh 32 && ./scripts/release-common.sh -snapshot -mingw32 -v "$OPENSCAD_VERSION"; \
	mkdir -p out; \
	for f in mingw*/*.zip mingw*/*.exe; do \
		N=$(basename "$f" | sed -e "s/\\(-x86-[36][24]\\)/\\1${SUFFIX}/;"); \
		cp -iv "$f" out/"$N"; \
	done

ENTRYPOINT tar --create -C /openscad/out .
