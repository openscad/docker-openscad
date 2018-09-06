#
# Build: docker build -t mxe-x86_64-gcc .
# Use: docker run --rm -it mxe-x86_64-gcc
#
FROM openscad/mxe-requirements:latest

WORKDIR /

RUN git clone https://github.com/mxe/mxe
RUN cd mxe && make MXE_TARGETS=x86_64-w64-mingw32.static.posix gcc 
