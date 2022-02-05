#
# Build: docker build -t openscad/mxe-x86_64-deps .
# Use: docker run --rm -it openscad/mxe-x86_64-deps
#
FROM openscad/mxe-x86_64-gcc:latest

ARG JOBS=2

WORKDIR /mxe

RUN \
  make "JOBS=${JOBS}" "-j${JOBS}" \
    MXE_TARGETS=x86_64-w64-mingw32.static.posix \
      mpfr \
      eigen \
      libxml2 \
      freetype \
      fontconfig \
      harfbuzz \
      cairo \
      glib \
      libzip \
      lib3mf \
      double-conversion \
      nsis \
    && \
  make clean-junk
