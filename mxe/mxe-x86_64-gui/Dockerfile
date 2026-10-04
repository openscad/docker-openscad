#
# Build: docker build -t openscad/mxe-x86_64-gui .
# Use: docker run --rm -it openscad/mxe-x86_64-gui
#
FROM openscad/mxe-x86_64-deps:latest

ARG JOBS=2
ARG CLEAN=clean-junk

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get install -y --no-install-recommends python3-yaml

COPY packages.lst /tmp
COPY settings.mk /tmp

WORKDIR /mxe

RUN \
	--mount=type=cache,id=pkg,target=/mxe/pkg \
	eval `bash /tmp/packages.lst` && \
	make "JOBS=${JOBS}" "-j${JOBS}" \
		MXE_SETTINGS_FILE=/tmp/settings.mk \
		MXE_PLUGIN_DIRS="${PLUGIN_DIRS}" \
		MXE_TARGETS="${TARGET_64}" \
		${PKG_MXE_GUI} \
	&& \
	make ${CLEAN}
