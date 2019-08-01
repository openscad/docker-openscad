#
# Build: docker build -t mxe-requirements .
# Use: docker run --rm -it -v mxe-requirements
#
FROM buildpack-deps:stretch

RUN apt-get update

RUN apt-get install -y --no-install-recommends autopoint bison flex gperf libtool ruby scons unzip p7zip-full intltool libtool libtool-bin nsis zip lzip gnupg
