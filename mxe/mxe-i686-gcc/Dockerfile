#
# Build: docker build -t mxe-i686-gcc .
# Use: docker run --rm -it mxe-i686-gcc
#
FROM openscad/mxe-requirements:latest

ENV MXE_TARGETS=i686-w64-mingw32.static.posix

WORKDIR /

RUN git clone https://github.com/mxe/mxe
RUN cd mxe && make gcc 
