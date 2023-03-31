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
    --with-semver				\
    --with-emacs				\
    "$@"

### end of file
