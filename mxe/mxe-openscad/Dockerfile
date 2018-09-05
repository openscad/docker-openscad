#
# Build: docker build -t openscad/mxe-openscad .
# Use: docker run --rm -it openscad/mxe-openscad
#
FROM openscad/mxe-x86_64-deps:latest

ENV MXE_TARGETS=x86_64-w64-mingw32.static.posix

WORKDIR /

RUN git clone https://github.com/openscad/openscad
RUN cd openscad
RUN source ./scripts/setenv-mingw-xbuild.sh 64
RUN ./scripts/release-common.sh mingw64
