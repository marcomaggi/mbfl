#!/bin/bash

SOURCE_FILE=${1:?"missing source file argument"}

PROGNAME=extract-function-names.sh
GREP=/usr/bin/grep
SORT=/usr/bin/sort
SED=/usr/bin/sed

if ! test -f "$SOURCE_FILE"
then
    printf '%s error: invalid source file pathname: "%s"\n' "$PROGNAME" "$SOURCE_FILE"
    exit 1
fi

### ------------------------------------------------------------------------

"$GREP" '^function mbfl_' "$SOURCE_FILE" | \
    "$GREP" --invert-match '^function mbfl_p_' | \
    "$SORT" | \
    "$SED" -e 's/function \([a-zA-Z0-9_]\+\) () {/"\1"/'

"$GREP" '^function mbfl_' "$SOURCE_FILE" | \
    "$GREP" --invert-match '^function mbfl_p_' | \
    "$SORT" | \
    "$SED" -e 's/function \([a-zA-Z0-9_\-]\+\) () {/"\1"/'

### ------------------------------------------------------------------------

"$GREP" '^function dotest-' "$SOURCE_FILE" | \
    "$GREP" --invert-match '^function dotest-p-' | \
    "$SORT" | \
    "$SED" -e 's/function \([a-zA-Z0-9_\-]\+\) () {/"\1"/'

"$GREP" '^alias dotest-' "$SOURCE_FILE" | \
    "$GREP" --invert-match '^alias dotest-p-' | \
    "$SORT" | \
    "$SED" -e 's/alias \([a-zA-Z0-9_\-]\+\)=.*/"\1"/'

### end of file
