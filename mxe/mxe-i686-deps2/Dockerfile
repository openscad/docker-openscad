#
# Build: docker build -t openscad/mxe-i686-deps2 .
# Use: docker run --rm -it openscad/mxe-i686-deps2
#
FROM openscad/mxe-i686-deps:latest

ARG JOBS=2

WORKDIR /mxe

RUN \
	make "JOBS=${JOBS}" "-j${JOBS}" \
		MXE_PLUGIN_DIRS=plugins/gcc10 \
		MXE_TARGETS=i686-w64-mingw32.static.posix \
                cairo \
                glib \
                libzip \
                lib3mf \
                double-conversion \
		nsis \
		&& \
	make MXE_PLUGIN_DIRS=plugins/gcc10 clean-junk
