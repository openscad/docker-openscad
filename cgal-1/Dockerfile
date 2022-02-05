#
# Build: docker build -t openscad/mxe-x86_64-openscad .
# Use: docker run --rm -it openscad/mxe-x86_64-openscad
#
FROM openscad/mxe-x86_64-gui:latest

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /cgal

RUN apt-get update && apt-get install -y --no-install-recommends vim less xz-utils

ADD https://github.com/CGAL/cgal/releases/download/v5.2.4/CGAL-5.2.4-library.tar.xz .
ADD https://github.com/CGAL/cgal/releases/download/v5.3.1/CGAL-5.3.1-library.tar.xz .
ADD https://github.com/CGAL/cgal/releases/download/v5.4/CGAL-5.4-library.tar.xz .

COPY bug.cc .
COPY test_gmp_bug_different_cgal_versions.sh .
