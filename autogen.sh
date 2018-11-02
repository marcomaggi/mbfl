#!/bin/sh
# autogen.sh --
#
# Run this in the top source directory to rebuild the infrastructure.

export PATH=/bin:/usr/local/bin:/usr/bin:$PATH

set -xe
test -d meta/autotools || mkdir -p meta/autotools
autoreconf --warnings=all --install --verbose "$@"

### end of file
