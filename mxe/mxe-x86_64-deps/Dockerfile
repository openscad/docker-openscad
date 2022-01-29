#
# Build: docker build -t openscad/mxe-x86_64-deps .
# Use: docker run --rm -it openscad/mxe-x86_64-deps
#
FROM openscad/mxe-x86_64-gcc:latest

ARG JOBS=2

WORKDIR /mxe

RUN \
  make "JOBS=${JOBS}" "-j${JOBS}" \
    MXE_PLUGIN_DIRS=plugins/gcc11 \
    MXE_TARGETS=x86_64-w64-mingw32.static.posix \
      mpfr \
      eigen \
      libxml2 \
      freetype \
      fontconfig \
      harfbuzz \
    && \
  make MXE_PLUGIN_DIRS=plugins/gcc11 clean-junk
