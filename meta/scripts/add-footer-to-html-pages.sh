#!/bin/bash
#

declare -r PACKAGE_NAME=${1:?"missing package name argument"}
declare -r PACKAGE_VERSION=${2:?"missing package version argument"}
shift 2

declare -r GREP=/bin/grep
declare -r SED=/bin/sed
declare -r MV=/bin/mv
declare -r RM=/bin/rm

declare SEXP
printf -v SEXP \
       's_</body>_<p class="customfooter12345">This document describes version <tt>%s</tt> of <em>%s</em>.</p></body>_' \
       "$PACKAGE_VERSION" "$PACKAGE_NAME"

for htmlfile in "$@"
do
    # Process only files that do not already contain the footer.
    if ! "$GREP" -e '<p class="customfooter12345">' --silent "$htmlfile"
    then
	"$MV" "$htmlfile" "$htmlfile".bak
	"$SED" -e "$SEXP" <"$htmlfile".bak >"$htmlfile"
	"$RM" "$htmlfile".bak
    fi
done

### end of file
