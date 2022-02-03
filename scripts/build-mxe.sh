#!/bin/bash -e

COUNT=0

build () {
	NAME="$1"

	COUNT=$(( $COUNT + 1 ))
	LOG=$(printf "%03d_build-mxe-%s.log" "$COUNT" "$NAME")

	echo "*" | tee "$LOG"
	echo "* $(date): building $NAME" | tee -a "$LOG"
	echo "* $(date): log in $LOG" | tee -a "$LOG"
	echo "*" | tee -a "$LOG"
	time docker build -t openscad/"$NAME":latest --build-arg=JOBS=8 mxe/"$NAME"/ 2>&1 >> "$LOG"
	echo "*" | tee -a "$LOG"
	echo "* $(date): finished $NAME" | tee -a "$LOG"
	echo "*" | tee -a "$LOG"
}

rm -f ???_build-mxe-*.log

build mxe-requirements

# build i686-gcc first as this used as base for x86_64-gcc
build mxe-i686-gcc
build mxe-x86_64-gcc

build mxe-x86_64-deps
build mxe-x86_64-gui
build mxe-x86_64-openscad

build mxe-i686-deps
build mxe-i686-gui
build mxe-i686-openscad

date
docker image list -f 'reference=openscad/mxe-*'
