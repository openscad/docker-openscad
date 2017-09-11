#
# Build: docker build -t x86_64-w64-mingw32.static.posix .
# Use: docker run --rm -it x86_64-w64-mingw32.static.posix
#
FROM openscad:mxe-requirements

ENV MXE_TARGETS=x86_64-w64-mingw32.static.posix

WORKDIR /

RUN git clone https://github.com/mxe/mxe
RUN cd mxe && make gcc 
