#
# Build: docker build -t openscad/mxe-i686-gui .
# Use: docker run --rm -it openscad/mxe-i686-gui
#
FROM openscad/mxe-i686-deps:latest

ARG JOBS=2

WORKDIR /mxe

RUN \
	make "JOBS=${JOBS}" "-j${JOBS}" \
		MXE_TARGETS=i686-w64-mingw32.static.posix \
                opencsg \
                cgal \
                qtbase \
                qtmultimedia \
                qtgamepad \
                qtsvg \
                qscintilla2 \
		&& \
	make clean-junk
