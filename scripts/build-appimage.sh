#!/bin/bash -e

COUNT=0

build () {
	DIR="$1"
	TAG="$2"
	NAME="${TAG#*/}"

	COUNT=$(( $COUNT + 1 ))
	LOG=$(printf "%03d_build-%s.log" "$COUNT" "$NAME")

	echo "*" | tee "$LOG"
	echo "* $(date): building $NAME" | tee -a "$LOG"
	echo "* $(date): log in $LOG" | tee -a "$LOG"
	echo "*" | tee -a "$LOG"
	time docker build -t "$TAG":latest --build-arg=JOBS=8 "$DIR"/"$NAME"/ 2>&1 >> "$LOG"
	echo "*" | tee -a "$LOG"
	echo "* $(date): finished $NAME" | tee -a "$LOG"
	echo "*" | tee -a "$LOG"
}

rm -f ???_build-*.log

build appimage openscad/appimage-x86_64-base
build appimage openscad/appimage-x86_64-openscad

date
docker image list -f 'reference=openscad/appimage-*'
