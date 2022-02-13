#!/bin/bash -e

clean () {
	rm -f ???_build-*.log
}

build () {
	DIR="$1"
	TAG="$2"
	NAME="${TAG#*/}"
	shift
	shift

	COUNT=$(( $COUNT + 1 ))
	LOG=$(printf "%03d_build-%s.log" "$COUNT" "$NAME")

	echo "*" | tee "$LOG"
	echo "* $(date): building $NAME" | tee -a "$LOG"
	echo "* $(date): log in $LOG" | tee -a "$LOG"
	echo "*" | tee -a "$LOG"
	time docker build -t "$TAG":latest --build-arg=JOBS=8 "$@" "$DIR"/"$NAME"/ 2>&1 >> "$LOG"
	echo "*" | tee -a "$LOG"
	echo "* $(date): finished $NAME" | tee -a "$LOG"
	echo "*" | tee -a "$LOG"
}

list () {
	REF="$1"

	date
	docker image list -f "reference=${REF}"
}
