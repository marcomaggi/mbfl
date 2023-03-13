#!/bin/sh
# configure.sh --
#

set -ex

prefix=/

../configure \
    --config-cache				\
    --cache-file=config.cache			\
    --enable-maintainer-mode                    \
    --prefix="${prefix}"			\
    --with-vc					\
    "$@"

### end of file
