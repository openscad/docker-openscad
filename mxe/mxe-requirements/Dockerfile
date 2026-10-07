#
# Build: docker build -t openscad/mxe-requirements .
# Use: docker run --rm -it -v openscad/mxe-requirements
#
FROM buildpack-deps:trixie

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
	python-is-python3 \
	python3-mako \
	python3-yaml \
	libgl1-mesa-dev \
	libclang-dev \
	libpcre2-dev \
	libtool-bin \
	ninja-build \
	p7zip-full \
	autopoint \
	intltool \
	itstool \
	libtool \
	bison \
	gnupg \
	gperf \
	scons \
	unzip \
	cmake \
	meson \
	flex \
	less \
	lzip \
	nsis \
	ruby \
	ncat \
	zstd \
	vim \
	zip
