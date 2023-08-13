#
# Build: docker build -t openscad/mxe-x86_64-deps .
# Use: docker run --rm -it openscad/mxe-x86_64-deps
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
		MXE_TARGETS="${TARGET_64}" \
		${PKG_MXE_DEP} \
	&& \
	make ${CLEAN}
