#
# Build: docker build -t mxe-i686-gcc .
# Use: docker run --rm -it mxe-i686-gcc
#
FROM openscad/mxe-requirements:latest

WORKDIR /

RUN git clone https://github.com/mxe/mxe
RUN cd mxe && make JOBS=2 -j2 MXE_PLUGIN_DIRS=plugins/gcc7 MXE_TARGETS=i686-w64-mingw32.static.posix gcc 
