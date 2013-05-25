# configure.sh --
#

set -xe

prefix=/usr/local

../configure \
    --enable-maintainer-mode                    \
    --prefix="$prefix"                          \
    --config-cache                              \
    --cache-file=../config.cache                \
    --with-sendmail                             \
    "$@"

### end of file
