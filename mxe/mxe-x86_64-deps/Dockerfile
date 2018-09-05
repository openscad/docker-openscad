#
# Build: docker build -t openscad/mxe-x86_64-deps .
# Use: docker run --rm -it openscad/mxe-x86_64-deps
#
FROM openscad/mxe-x86_64-gcc:latest

ENV MXE_TARGETS=x86_64-w64-mingw32.static.posix

WORKDIR /mxe

RUN make qtbase qtmultimedia qscintilla2 mpfr eigen opencsg cgal nsis glib libxml2 freetype fontconfig harfbuzz libzip
