#
# Build: docker build -t openscad/mxe-i686-deps .
# Use: docker run --rm -it openscad/mxe-i686-deps
#
FROM openscad/mxe-i686-gcc:latest

ARG JOBS=2

WORKDIR /mxe

RUN \
	make "JOBS=${JOBS}" "-j${JOBS}" \
		MXE_PLUGIN_DIRS=plugins/gcc7 \
		MXE_TARGETS=i686-w64-mingw32.static.posix \
		qtbase qtmultimedia qtgamepad qscintilla2 \
		opencsg cgal mpfr eigen \
		libxml2 freetype fontconfig harfbuzz cairo \
		glib libzip lib3mf nsis double-conversion && \
	make MXE_PLUGIN_DIRS=plugins/gcc7 clean-junk
