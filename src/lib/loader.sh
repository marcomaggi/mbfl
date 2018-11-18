declare mbfl_INTERACTIVE=no
declare mbfl_LOADED=no
declare mbfl_HARDCODED=
declare mbfl_INSTALLED=$(type -p mbfl-config &>/dev/null && mbfl-config) &>/dev/null

declare item
for item in "$MBFL_LIBRARY" "$mbfl_HARDCODED" "$mbfl_INSTALLED"
do
    if test -n "$item" -a -f "$item" -a -r "$item"
    then
        if source "$item" &>/dev/null
        then
	    declare -r mbfl_LOADED_LIBRARY=$item
	    break
        else
            printf '%s error: loading MBFL file "%s"\n' "$script_PROGNAME" "$item" >&2
            exit 100
        fi
    fi
done
unset -v item
if test "$mbfl_LOADED" != yes
then
    printf '%s error: incorrect evaluation of MBFL\n' "$script_PROGNAME" >&2
    exit 100
fi
