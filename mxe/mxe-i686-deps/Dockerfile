#
# Build: docker build -t openscad/mxe-i686-deps .
# Use: docker run --rm -it openscad/mxe-i686-deps
#
FROM openscad/mxe-i686-gcc:latest

ARG JOBS=2

WORKDIR /mxe

RUN \
	make "JOBS=${JOBS}" "-j${JOBS}" \
		MXE_PLUGIN_DIRS=plugins/gcc11 \
		MXE_TARGETS=i686-w64-mingw32.static.posix \
		mpfr \
                eigen \
                libxml2 \
                freetype \
                fontconfig \
                harfbuzz \
	&& \
	make MXE_PLUGIN_DIRS=plugins/gcc11 clean-junk
