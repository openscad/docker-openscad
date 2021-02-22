#!/bin/bash -e

# This script is intended to build release candidates and releases using
# the docker images for MXE and Linux AppImage.
# The build is configured as release, so experimental features are going
# to be disabled and hidden.

REFS="$1"
BRANCH="$2"
VERSION="$3"

RELEASES="releases"
URL=https://github.com/openscad/openscad.git

build () {
	TAG="$1"
	DIR="$2"
	shift 2
	docker build -t "${TAG}" --build-arg REFS="${REFS}" --build-arg BRANCH="${BRANCH}" --build-arg OPENSCAD_VERSION="${VERSION}" --build-arg RELEASE_TYPE="" "$@" "${DIR}"
}

run () {
	TAG="$1"
	mkdir -p "${RELEASES}"
	docker run -i "${TAG}":latest | tar -x -v -C "${RELEASES}" -f -
}

hash_and_sign () {
	for a in "${RELEASES}"/*.{exe,zip,AppImage,tar.gz,dmg}
	do
		echo "+ $a"
		if [ -f "$a" ]
		then
			sha256sum "$a" | tee "${a}.sha256"; sha512sum "$a" | tee "${a}.sha512"
			if [ -f "$a".asc ]
			then
				echo "Skipping signing as $a.asc already exists"
			else
				gpg -u 8AF822A975097442 --detach-sign --armor "$a"
			fi
		fi
	done
}

main () {
	echo "Branch/Tag for checkout: '${REFS}/${BRANCH}'"
	echo "Version to set in OpenSCAD: '${VERSION}'"
	echo ""
	echo "1) MXE 32-bit"
	echo "2) MXE 64-bit"
	echo "3) AppImage x86 64-bit"
	echo "4) AppImage ARM 64-bit"
	echo ""
	echo "9) Sources"
	echo ""
	echo "0) Hash & Sign"
	echo ""
	echo -n "Select: "
	read nr

	case "$nr" in
		1)
			build openscad/mxe-i686-openscad mxe/mxe-i686-openscad/
			run openscad/mxe-i686-openscad
			;;
		2)
			build openscad/mxe-x86_64-openscad mxe/mxe-x86_64-openscad/
			run openscad/mxe-x86_64-openscad
			;;
		3)
			build openscad/appimage-x86_64-openscad appimage/appimage-x86_64-openscad/ --build-arg SNAPSHOT=-
			run openscad/appimage-x86_64-openscad
			;;
		4)
			build openscad/appimage-arm64v8-openscad appimage/appimage-arm64v8-openscad/ --build-arg SNAPSHOT=-
			run openscad/appimage-arm64v8-openscad
			;;
		9)
			build openscad/src-openscad src/src-openscad --build-arg TAG="${BRANCH}"
			run openscad/src-openscad
			;;
		0)
			hash_and_sign
			;;
		*)
			echo "Unknown selection."
			;;
	esac
}

last_tag () {
	git ls-remote --tags "$URL" | \
	egrep 'refs/tags/openscad-[0-9]{4}.[0-9]{2}[0-9A-Z-]*$' | \
	sed -e 's,.*/,,' | \
	awk -F - '{ if (length($3) == 0) { ext = "{R}" } else if (index($3, "RC") == 1) { ext = "{P}" $3 } else { ext = "{U}" $3 }; print $1 "-" $2 ext}' | \
	sort | \
	sed -e 's,{R},,; s,{[UP]},-,' | \
	tail -n1
}

if [ x = x"$REFS" ]
then
	REFS=tags
	BRANCH=`last_tag`
	VERSION=${BRANCH#openscad-}
fi

main
