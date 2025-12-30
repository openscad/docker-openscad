# syntax=docker/dockerfile:1

# Use the official openscad image as source for binaries
FROM docker.io/openscad/openscad:latest AS openscad-source

# Runtime stage with Selkies GUI
FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="OpenSCAD version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="docker-openscad"

# title
ENV TITLE=OpenSCAD

ENV DEBIAN_FRONTEND=noninteractive

# Copy OpenSCAD binary and resources from the official image
COPY --from=openscad-source /usr/local/ /usr/local/

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/openscad/openscad/master/icons/openscad-256.png && \
  echo "**** install runtime dependencies ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    libcairo2 libdouble-conversion3 libxml2 lib3mf1 libzip5 libharfbuzz0b \
    libboost-thread1.83.0 libboost-program-options1.83.0 libboost-filesystem1.83.0 \
    libboost-regex1.83.0 libmpfr6 libqscintilla2-qt5-15 \
    libqt5multimedia5 libqt5concurrent5 libqt5svg5 libtbb12 libglu1-mesa && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

WORKDIR /openscad

# ports and volumes
EXPOSE 3000

VOLUME /config
