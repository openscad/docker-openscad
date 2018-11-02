#
# Build: docker build -t openscad/mxe-x86_64-deps .
# Use: docker run --rm -it openscad/mxe-x86_64-deps
#
FROM openscad/mxe-x86_64-gcc:latest

WORKDIR /mxe

RUN make JOBS=2 -j2 MXE_PLUGIN_DIRS=plugins/gcc7 MXE_TARGETS=x86_64-w64-mingw32.static.posix qtbase qtmultimedia qtgamepad qscintilla2 mpfr eigen opencsg cgal nsis glib libxml2 freetype fontconfig harfbuzz libzip lib3mf
