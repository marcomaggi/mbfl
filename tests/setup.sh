# setup.sh --

if test -z "${mbfl_LOADED_MBFL_TEST}"
then source "${MBFLTEST_LIBRARY:?}"
fi
if test -z "${mbfl_LOADED_MBFL}"
then
    source "${MBFL_LIBRARY:?}"
    mbfl_main_create_exit_functions
fi

### end of file
