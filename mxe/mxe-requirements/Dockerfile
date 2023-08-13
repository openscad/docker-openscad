#
# Build: docker build -t openscad/mxe-requirements .
# Use: docker run --rm -it -v openscad/mxe-requirements
#
FROM buildpack-deps:bookworm

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
	python-is-python3 \
	python3-mako \
	libpcre3-dev \
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
	vim \
	zip
