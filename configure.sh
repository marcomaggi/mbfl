#!/bin/sh
# configure.sh --
#

set -ex

declare -r FINDUTILS_ROOT=/opt/findutils/4.10.0
declare -r MBFL_PROGRAM_FIND=${FINDUTILS_ROOT}/find
declare -r MBFL_PROGRAM_LOCATE=${FINDUTILS_ROOT}/find
declare -r MBFL_PROGRAM_UPDATEDB=${FINDUTILS_ROOT}/updatedb
declare -r MBFL_PROGRAM_XARGS=${FINDUTILS_ROOT}/xargs

prefix=/

../configure \
    --config-cache						\
    --cache-file=config.cache					\
    --enable-maintainer-mode					\
    --prefix="${prefix}"					\
    --with-vc							\
    --with-semver						\
    --with-emacs						\
    MBFL_PROGRAM_FIND=$MBFL_PROGRAM_FIND			\
    MBFL_PROGRAM_LOCATE=$MBFL_PROGRAM_LOCATE			\
    MBFL_PROGRAM_UPDATEDB=$MBFL_PROGRAM_UPDATEDB		\
    MBFL_PROGRAM_XARGS=$MBFL_PROGRAM_XARGS			\
    "$@"

### end of file
