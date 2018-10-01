#
# Build: docker build -t openscad/mxe-openscad .
# Use: docker run --rm -it openscad/mxe-openscad
#
FROM openscad/mxe-x86_64-deps:latest

WORKDIR /
RUN git clone https://github.com/openscad/openscad

WORKDIR /openscad
RUN export MXEDIR=/mxe ; . ./scripts/setenv-mingw-xbuild.sh 64 && ./scripts/release-common.sh -snapshot mingw64
