#
# Build: docker build -t i686-w64-mingw32.static.posix .
# Use: docker run --rm -it i686-w64-mingw32.static.posix
#
FROM openscad/mxe-requirements:latest

ENV MXE_TARGETS=i686-w64-mingw32.static.posix

WORKDIR /

RUN git clone https://github.com/mxe/mxe
RUN cd mxe && make gcc 
