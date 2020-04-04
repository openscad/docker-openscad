#
# Build: docker build -t openscad/mxe-x86_64-deps .
# Use: docker run --rm -it openscad/mxe-x86_64-deps
#
FROM openscad/mxe-x86_64-gcc:latest

ARG JOBS=2

WORKDIR /mxe

# use 32bit makensis from MXE. 64bit version not compatible
RUN \
	make "JOBS=${JOBS}" "-j${JOBS}" \
		MXE_PLUGIN_DIRS=plugins/gcc7 \
		MXE_TARGETS=x86_64-w64-mingw32.static.posix \
		qtbase qtmultimedia qtgamepad qscintilla2 \
		opencsg cgal mpfr eigen \
		libxml2 freetype fontconfig harfbuzz cairo \
		glib libzip lib3mf double-conversion && \
	make "JOBS=${JOBS}" "-j${JOBS}" \
		MXE_PLUGIN_DIRS=plugins/gcc7 \
		MXE_TARGETS=i686-w64-mingw32.static.posix \
		nsis && \
	make MXE_PLUGIN_DIRS=plugins/gcc7 clean-junk
