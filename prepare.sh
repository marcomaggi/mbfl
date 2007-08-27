# prepare.sh --

set -x

(cd ..
    if test configure.ac -nt configure -o configure.ds -nt configure ; then
        autoconf
    fi)

../configure "$@"

### end of file
