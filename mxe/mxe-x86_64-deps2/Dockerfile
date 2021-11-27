#
# Build: docker build -t openscad/mxe-x86_64-deps2 .
# Use: docker run --rm -it openscad/mxe-x86_64-deps2
#
FROM openscad/mxe-x86_64-deps:latest

ARG JOBS=2

WORKDIR /mxe

RUN \
	make "JOBS=${JOBS}" "-j${JOBS}" \
		MXE_PLUGIN_DIRS=plugins/gcc10 \
		MXE_TARGETS=x86_64-w64-mingw32.static.posix \
                cairo \
		glib \
                libzip \
                lib3mf \
                double-conversion \
		&& \
	make MXE_PLUGIN_DIRS=plugins/gcc10 clean-junk
