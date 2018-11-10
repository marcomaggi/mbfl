#!/bin/sh
# configure.sh --
#

set -xe

prefix=/
if test -d /lib64
then libdir=${prefix}/lib64
else libdir=${prefix}/lib
fi
BASH_PROGRAM=/bin/bash

../configure \
    --config-cache                              \
    --cache-file=../config.cache                \
    --enable-maintainer-mode			\
    --prefix="${prefix}"                        \
    --libdir="${libdir}"                        \
    BASH_PROGRAM="$BASH_PROGRAM"		\
    "$@"

### end of file
