# configure.sh --

set -xe

(cd ..
    if test \
        configure -ot prepare.sh   -o \
        configure -ot configure.ac -o \
        configure -ot aclocal.m4   -o \
        configure -ot infrastructure/develstuff.autoconf
    then
        autoconf
    fi)

../configure \
    --config-cache                              \
    --with-abi=local-slackware                  \
    --enable-doc-pdf                            \

### end of file
