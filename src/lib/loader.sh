# loader.sh

mbfl_INTERACTIVE=no
mbfl_LOADED=no
mbfl_HARDCODED=
mbfl_INSTALLED=$(type -p mbfl-config &>/dev/null && mbfl-config) &>/dev/null
for item in "$MBFL_LIBRARY" "$mbfl_HARDCODED" "$mbfl_INSTALLED"
do
    test -n "$item" -a -f "$item" -a -r "$item" && {
        source "$item" &>/dev/null || {
            printf '%s error: loading MBFL file "%s"\n' \
                "$script_PROGNAME" "$item" >&2
            exit 2
        }
    }
done
unset -v item
test "$mbfl_LOADED" = yes || {
    printf '%s error: incorrect evaluation of MBFL\n' \
        "$script_PROGNAME" >&2
    exit 2
}

### end of file
