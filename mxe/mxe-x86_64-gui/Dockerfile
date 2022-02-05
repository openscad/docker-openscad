#
# Build: docker build -t openscad/mxe-x86_64-gui .
# Use: docker run --rm -it openscad/mxe-x86_64-gui
#
FROM openscad/mxe-x86_64-deps:latest

ARG JOBS=2

WORKDIR /mxe

RUN \
	make "JOBS=${JOBS}" "-j${JOBS}" \
		MXE_TARGETS=x86_64-w64-mingw32.static.posix \
                opencsg \
                cgal \
		qtbase \
                qtmultimedia \
                qtgamepad \
                qtsvg \
                qscintilla2 \
	&& \
	make clean-junk
