#
# Build: docker build -t openscad/mxe-requirements .
# Use: docker run --rm -it -v openscad/mxe-requirements
#
FROM buildpack-deps:buster

RUN apt-get update

RUN apt-get install -y --no-install-recommends autopoint bison flex gperf libtool ninja-build ruby scons unzip p7zip-full intltool libtool libtool-bin zip lzip gnupg
