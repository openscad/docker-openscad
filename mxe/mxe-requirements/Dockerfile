#
# Build: docker build -t openscad/mxe-requirements .
# Use: docker run --rm -it -v openscad/mxe-requirements
#
FROM buildpack-deps:buster

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
	libtool-bin \
	ninja-build \
	p7zip-full \
	autopoint \
	intltool \
	libtool \
	bison \
	gnupg \
	gperf \
	scons \
	unzip \
	flex \
	less \
	lzip \
	nsis \
	ruby \
	vim \
	zip
