#
# Build: docker build -t openscad/mxe-openscad .
# Use: docker run --rm -it openscad/mxe-openscad
#
FROM openscad/mxe-i686-deps:latest

WORKDIR /
RUN git clone https://github.com/openscad/openscad

WORKDIR /openscad
RUN export MXEDIR=/mxe ; . ./scripts/setenv-mingw-xbuild.sh 32 && ./scripts/release-common.sh -snapshot mingw32
RUN find / -type d || true

ENTRYPOINT tar --create -C /openscad/mingw32.static.posix --exclude "./[^O]*" .
