#
# Build: docker build -t openscad/mxe-i686-deps .
# Use: docker run --rm -it openscad/mxe-i686-deps
#
FROM openscad/mxe-base:latest

ARG JOBS=2
ARG CLEAN=clean-junk

WORKDIR /mxe

RUN \
	--mount=type=cache,id=pkg,target=/mxe/pkg \
	eval `bash /tmp/packages.lst` && \
	make "JOBS=${JOBS}" "-j${JOBS}" \
		MXE_SETTINGS_FILE=/tmp/settings.mk \
		MXE_PLUGIN_DIRS="${PLUGIN_DIRS}" \
		MXE_TARGETS="${TARGET_32}" \
		${PKG_MXE_DEP} \
	&& \
	make ${CLEAN}
