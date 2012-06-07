# configure.sh --
#

set -xe

prefix=/usr/local

../configure \
    --prefix="$prefix"                          \
    --config-cache                              \
    --cache-file=../config.cache                \
    --with-sendmail                             \
    "$@"

### end of file
