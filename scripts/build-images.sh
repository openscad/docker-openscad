#!/bin/bash -xe

build () {
	REF="$1"
	BRANCH="$2"
	DOCKERTAG1="$3"
	DOCKERTAG2="$4"
	VERSION="$5"
	DIR="$6"
	FILE="$7"

	DOCKERTAG1_ARGS=""
	DOCKERTAG2_ARGS=""

	if [ -n "$FILE" ]; then
		DOCKERFILE_ARGS="-f ${DIR}/${FILE}"
	fi

	if [ -z "$VERSION" ]; then
		VERSION="$DOCKERTAG1"
	fi

	if [ -n "$DOCKERTAG1" ]; then
		DOCKERTAG1_ARGS="-t openscad/openscad:$DOCKERTAG1"
	fi
	if [ -n "$DOCKERTAG2" ]; then
		DOCKERTAG2_ARGS="-t openscad/openscad:$DOCKERTAG2"
	fi

	echo "Building $BRANCH with version $VERSION..."
	docker buildx build \
		--push \
		--platform linux/amd64,linux/arm64 \
		--build-arg=REFS="$REF" \
		--build-arg=BRANCH="$BRANCH" \
		--build-arg OPENSCAD_VERSION="$VERSION" \
		--build-arg BUILD_TYPE="Release" \
		--build-arg DEBUG="-" \
		--build-arg JOBS=4 \
		$DOCKERTAG1_ARGS \
		$DOCKERTAG2_ARGS \
		$DOCKERFILE_ARGS \
		"$DIR"
}

V=$(git log -1 --date="format:%Y.%m.%d.dd%j%H" --format="%cd")

build	tags	openscad-2015.03-3	2015.03	""	""	openscad/stretch	Dockerfile
build	tags	openscad-2019.05	2019.05	""	""	openscad/buster		Dockerfile
build	tags	openscad-2021.01	2021.01	latest	""	openscad/buster		Dockerfile
build	heads	master			dev	""	"$V"	openscad/bookworm	Dockerfile
build	heads	master			egl	""	"$V"	openscad/bookworm	Dockerfile.egl

docker image list -f 'reference=openscad/openscad'
