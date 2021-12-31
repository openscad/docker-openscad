#!/bin/bash -xe

build () {
	REF="$1"
	BRANCH="$2"
	DOCKERTAG="$3"
	VERSION="$4"
	DIR="$5"
	FILE="$6"

	if [ -n "$FILE" ]; then
		DOCKERFILE_ARGS="-f ${DIR}/${FILE}"
	fi

	if [ -z "$VERSION" ]; then
		VERSION="$DOCKERTAG"
	fi

	echo "Building $BRANCH with version $VERSION..."
	docker build \
		-t openscad/openscad:"$DOCKERTAG" \
		--build-arg=REFS="$REF" \
		--build-arg=BRANCH="$BRANCH" \
		--build-arg OPENSCAD_VERSION="$VERSION" \
		$DOCKERFILE_ARGS \
		"$DIR"
}

V=$(git log -1 --date="format:%Y.%m.%d.dd%j%H" --format="%cd")

build	tags	openscad-2015.03-3	2015.03	""	openscad/stretch
build	tags	openscad-2019.05	2019.05	""	openscad/buster
build	tags	openscad-2021.01	2021.01	""	openscad/buster
build	heads	master			dev	"$V"	openscad/bookworm

docker tag openscad/openscad:2021.01 openscad/openscad:latest
