#
# Build: docker build -t openscad/mxe-i686-gui .
# Use: docker run --rm -it openscad/mxe-i686-gui
#
FROM openscad/mxe-i686-deps2:latest

ARG JOBS=2

WORKDIR /mxe

RUN \
	make "JOBS=${JOBS}" "-j${JOBS}" \
		MXE_PLUGIN_DIRS=plugins/gcc10 \
		MXE_TARGETS=i686-w64-mingw32.static.posix \
                opencsg \
                cgal \
                qtbase \
                qtmultimedia \
                qtgamepad \
                qtsvg \
                qscintilla2 \
		&& \
	make MXE_PLUGIN_DIRS=plugins/gcc10 clean-junk
