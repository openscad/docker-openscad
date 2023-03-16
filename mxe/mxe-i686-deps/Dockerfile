#
# Build: docker build -t openscad/mxe-i686-deps .
# Use: docker run --rm -it openscad/mxe-i686-deps
#
FROM openscad/mxe-i686-gcc:latest

ARG JOBS=2

WORKDIR /mxe

RUN \
  make "JOBS=${JOBS}" "-j${JOBS}" \
    MXE_TARGETS=i686-w64-mingw32.static.posix \
      mpfr \
      eigen \
      libxml2 \
      freetype \
      fontconfig \
      harfbuzz \
      cairo \
      glib \
      intel-tbb \
      libzip \
      lib3mf \
      double-conversion \
      nsis \
  && \
  make clean-junk
