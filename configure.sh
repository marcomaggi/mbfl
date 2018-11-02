#!/bin/sh
# configure.sh --
#
# Run this to configure.

set -xe

prefix=/

../configure \
    --enable-maintainer-mode			\
    --config-cache                              \
    --cache-file=../config.cache                \
    --prefix="${prefix}"                        \
    "$@"

### end of file
