#
# Build: docker build -t openscad/mxe-x86_64-deps .
# Use: docker run --rm -it openscad/mxe-x86_64-deps
#
FROM openscad/mxe-x86_64-gcc:latest

WORKDIR /mxe

RUN make MXE_TARGETS=x86_64-w64-mingw32.static.posix qtbase qtmultimedia qscintilla2 mpfr eigen opencsg cgal nsis glib libxml2 freetype fontconfig harfbuzz libzip
