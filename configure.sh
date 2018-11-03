#!/bin/sh
# configure.sh --
#

set -xe

prefix=/
if test -d /lib64
then libdir=${prefix}/lib64
else libdir=${prefix}/lib
fi

../configure \
    --config-cache                              \
    --cache-file=../config.cache                \
    --enable-maintainer-mode			\
    --prefix="${prefix}"                        \
    --libdir="${libdir}"                        \
    "$@"

### end of file
