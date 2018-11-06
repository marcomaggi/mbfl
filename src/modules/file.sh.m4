# file.sh --
#
# Part of: Marco's BASH Functions Library
# Contents: file functions
# Date: Fri Apr 18, 2003
#
# Abstract
#
#       This is a collection of file functions for the GNU BASH shell.
#
#	NOTE  The file  name  functions are  not  implemented using  the
#	parameter expansion  functionalities; in the way  the author has
#	understood  parameter expansion:  there are  cases that  are not
#	correctly handled.
#
# Copyright (c) 2003-2005, 2009, 2013, 2017, 2018 Marco Maggi
# <marco.maggi-ipsu@poste.it>
#
# This is free software; you  can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the
# Free Software  Foundation; either version  3.0 of the License,  or (at
# your option) any later version.
#
# This library  is distributed in the  hope that it will  be useful, but
# WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
# MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
# Lesser General Public License for more details.
#
# You  should have  received a  copy of  the GNU  Lesser  General Public
# License along  with this library; if  not, write to  the Free Software
# Foundation, Inc.,  59 Temple Place,  Suite 330, Boston,  MA 02111-1307
# USA.
#

#page
#### pathname parsing utilities

# Scan  backwards the  PATHNAME  starting at  INDEX,  assuming that  the
# character at INDEX is a dot:
#
#   test "${PATHNAME:$INDEX:1}" = .
#
# Return  successfully if  INDEX  is  referencing the  second  dot in  a
# double-dot component as in:
#
#   /path/to/..			..
#             ^                  ^
#           INDEX              INDEX
#
# otherwise return unsuccessfully.
#
function mbfl_p_file_backwards_looking_at_double_dot () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    mbfl_mandatory_integer_parameter(INDEX, 2, pathname index)

    if ((0 < INDEX))
    then
	local -r ch="${PATHNAME:$((INDEX - 1)):1}"

	# For the case of standalone double-dot "..":
	if   ((1 == INDEX)) && test "$ch" = '.'
	then return 0
	     # For the case of double-dot as last component "/path/to/..":
	elif ((1 < INDEX))  && test \( "$ch" = '.' \) -a \( "${PATHNAME:$((INDEX - 2)):1}" = '/' \)
	then return 0
	else return 1
	fi
    else return 1
    fi
}

# Scan backwards the PATHNAME starting at INDEX.  Return successfully if
# INDEX references the first character in a pathname component, as in:
#
#   /path/to/file.ext              file.ext
#            ^                     ^
#          INDEX                 INDEX
#
function mbfl_p_file_looking_at_component_beginning () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    mbfl_mandatory_integer_parameter(INDEX, 2, pathname index)

    test 0 -eq $INDEX -o "${PATHNAME:$((INDEX - 1)):1}" = '/'
}

#page
#### changing directory functions

function mbfl_cd () {
    mbfl_mandatory_parameter(DIRECTORY, 1, directory)
    shift 1
    DIRECTORY=$(mbfl_file_normalise "$DIRECTORY")
    mbfl_message_verbose "entering directory: '${DIRECTORY}'\n"
    mbfl_change_directory "$DIRECTORY" "$@"
}
function mbfl_change_directory () {
    mbfl_mandatory_parameter(DIRECTORY, 1, directory)
    shift 1
    cd "$@" "$DIRECTORY" &>/dev/null
}

#page
#### pathname name functions: extension

function mbfl_file_extension_var () {
    mbfl_mandatory_nameref_parameter(RESULT_VARREF, 1, result variable)
    mbfl_mandatory_parameter(PATHNAME, 2, pathname)
    local -i i
    local result

    # We search for the last dot  character in the pathname.  If we find
    # a slash first: we return with empty extension.
    #
    # If the  dot is the  first character in  the tailname: there  is no
    # extension.   So if  the dot  is the  first character  in the  full
    # pathname, as in:
    #
    #   .dotfile
    #
    # there is no extension,  so we iterate from the end  only up to the
    # second character  (string index 1).   There is never need  to look
    # for a dot as first character (string index 0).
    #
    # If the  character before the first  dot is the slash, as in:
    #
    #   /path/to/.dotfile
    #
    # there is no extension.  So we check for this case.
    #
    for ((i=${#PATHNAME}; $i > 0; --i))
    do
        if test "${PATHNAME:$i:1}" = '/'
	then break
	else
	    if mbfl_string_is_equal_unquoted_char "$PATHNAME" $i .
	    then
		if test "${PATHNAME:$((i - 1)):1}" = '/'
		then
		    # There is no extension.   So we break because there
		    # is no point in continuing.
		    break
		else
		    # Found an extension.  Store it and break.
		    result="${PATHNAME:$((i + 1))}"
		    break
		fi
	    fi
	fi
    done
    RESULT_VARREF="$result"
    return 0
}
function mbfl_file_extension () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    local RESULT_VARNAME
    mbfl_file_extension_var RESULT_VARNAME "$PATHNAME"
    echo "$RESULT_VARNAME"
}

#page
#### pathname name functions: dirname

function mbfl_file_dirname_var () {
    mbfl_mandatory_nameref_parameter(RESULT_VARREF, 1, result variable)
    mbfl_optional_parameter(PATHNAME, 2)
    local -i i
    local result=.

    # We search for the last slash character in the pathname.
    #
    for ((i=${#PATHNAME}; $i >= 0; --i))
    do
        if test "${PATHNAME:$i:1}" = '/'
	then
	    # Skip consecutive slashes.
            while test \( $i -gt 0 \) -a \( "${PATHNAME:$i:1}" = '/' \)
            do let --i
            done

	    result="${PATHNAME:0:$((i + 1))}"
	    break
        fi
    done
    RESULT_VARREF="$result"
    return 0
}
function mbfl_file_dirname () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    local RESULT_VARNAME
    mbfl_file_dirname_var RESULT_VARNAME "$PATHNAME"
    echo "$RESULT_VARNAME"
}

#page
#### pathname name functions: rootname

function mbfl_file_rootname_var () {
    mbfl_mandatory_nameref_parameter(RESULT_VARREF, 1, result variable)
    mbfl_mandatory_parameter(PATHNAME, 2, pathname)
    local -i i=${#PATHNAME}
    local ch result

    # Special handling for standalone  slash, standalone dot, standalone
    # double-dot.
    if test \( "$PATHNAME" = '/' \) -o \( "$PATHNAME" = '.' \) -o \( "$PATHNAME" = '..' \)
    then result="$PATHNAME"
    else
	# Skip the trailing slashes.
	while ((0 < i)) && test "${PATHNAME:$((i - 1)):1}" = '/'
	do let --i
	done
	PATHNAME="${PATHNAME:0:$i}"

	if ((1 == i))
	then result="$PATHNAME"
	else
	    for ((i=${#PATHNAME}; $i >= 0; --i))
	    do
		ch="${PATHNAME:$i:1}"
		if test "$ch" = '.'
		then
		    if mbfl_p_file_backwards_looking_at_double_dot "$PATHNAME" $i || \
			    mbfl_p_file_looking_at_component_beginning "$PATHNAME" $i
		    then
			# The pathname is one among:
			#
			#   /path/to/..
			#   ..
			#
			# print the full pathname.
			result="$PATHNAME"
			break
		    elif ((0 < i))
		    then
			result="${PATHNAME:0:$i}"
			break
		    else
			result="$PATHNAME"
			break
		    fi
		elif test "$ch" = '/'
		then
		    result="$PATHNAME"
		    break
		fi
	    done
	fi
    fi
    RESULT_VARREF="$result"
    return 0
}

function mbfl_file_rootname () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    local RESULT_VARNAME
    mbfl_file_rootname_var RESULT_VARNAME "$PATHNAME"
    echo "$RESULT_VARNAME"
}

#page
#### pathname name functions: tailname

function mbfl_file_tail_var () {
    mbfl_mandatory_nameref_parameter(RESULT_VARREF, 1, result variable)
    mbfl_mandatory_parameter(PATHNAME, 2, pathname)
    local -i i
    # If no slash is present: the result is the full pathname.
    local result="$PATHNAME"

    for ((i=${#PATHNAME}; $i >= 0; --i))
    do
        if test "${PATHNAME:$i:1}" = '/'
	then
            result="${PATHNAME:$((i + 1))}"
            break
	fi
    done
    RESULT_VARREF="$result"
    return 0
}

function mbfl_file_tail () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    local RESULT_VARNAME
    mbfl_file_tail_var RESULT_VARNAME "$PATHNAME"
    echo "$RESULT_VARNAME"
}

#page
#### pathname name functions: splitting components

function mbfl_file_split () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    local i=0 last_found=0 len=${#PATHNAME}

    mbfl_string_skip "$PATHNAME" i '/'
    last_found=$i
    for ((SPLITCOUNT=0; $i < $len; ++i))
    do
        if test "${PATHNAME:$i:1}" = '/'
	then
            SPLITPATH[$SPLITCOUNT]="${PATHNAME:$last_found:$(($i-$last_found))}"
            let ++SPLITCOUNT
	    let ++i
            mbfl_string_skip "$PATHNAME" i '/'
            last_found=$i
        fi
    done
    SPLITPATH[$SPLITCOUNT]="${PATHNAME:$last_found}"
    let ++SPLITCOUNT
    return 0
}

#page
#### pathname normalisation: stripping slashes

function mbfl_file_strip_trailing_slash_var () {
    mbfl_mandatory_nameref_parameter(RESULT_VARREF, 1, result variable)
    mbfl_mandatory_parameter(PATHNAME, 2, pathname)
    local -i i=${#PATHNAME}
    local result

    # Skip the trailing slashes.
    while ((0 < i)) && test "${PATHNAME:$((i - 1)):1}" = '/'
    do let --i
    done
    if ((0 == i))
    then result='.'
    else result="${PATHNAME:0:$i}"
    fi
    RESULT_VARREF="$result"
}

function mbfl_file_strip_trailing_slash () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    local RESULT_VARNAME
    mbfl_file_strip_trailing_slash_var RESULT_VARNAME "$PATHNAME"
    echo "$RESULT_VARNAME"
}

### --------------------------------------------------------------------

function mbfl_file_strip_leading_slash_var () {
    mbfl_mandatory_nameref_parameter(RESULT_VARREF, 1, result variable)
    mbfl_mandatory_parameter(PATHNAME, 2, pathname)
    local result

    if test "${PATHNAME:0:1}" = '/'
    then
	local -i i=1 len=${#PATHNAME}
	# Skip the leading slashes.
	while ((i < len)) && test "${PATHNAME:$i:1}" = '/'
	do let ++i
	done
	if ((len == i))
	then result='.'
	else result="${PATHNAME:$i}"
	fi
    else result="$PATHNAME"
    fi
    RESULT_VARREF="$result"
}

function mbfl_file_strip_leading_slash () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    local RESULT_VARNAME
    mbfl_file_strip_leading_slash_var RESULT_VARNAME "$PATHNAME"
    echo "$RESULT_VARNAME"
}

#page
#### pathname normalisation: full normalisation

function mbfl_file_normalise_var () {
    mbfl_mandatory_nameref_parameter(RESULT_VARREF, 1, result variable)
    mbfl_mandatory_parameter(PATHNAME, 2, pathname)
    mbfl_optional_parameter(PREFIX, 3)
    local dirname tailame result ORGPWD="$PWD"

    if mbfl_file_is_absolute "$PATHNAME"
    then
	mbfl_p_file_normalise1_var result "$PATHNAME"
	RESULT_VARREF="$result"
    elif mbfl_file_is_directory "$PREFIX"
    then
        PATHNAME="${PREFIX}/${PATHNAME}"
        mbfl_p_file_normalise1_var result "$PATHNAME"
	RESULT_VARREF="$result"
    elif test -n "$PREFIX"
    then
	local PATHNAME1 PATHNAME2
        mbfl_p_file_remove_dots_from_pathname_var PREFIX   "$PREFIX"
        mbfl_p_file_remove_dots_from_pathname_var PATHNAME1 "$PATHNAME"
        mbfl_file_strip_trailing_slash_var        PATHNAME2 "$PATHNAME1"
        printf -v RESULT_VARREF '%s/%s' "$PREFIX" "$PATHNAME2"
    else
	mbfl_p_file_normalise1_var result "$PATHNAME"
	RESULT_VARREF="$result"
    fi
    cd "$ORGPWD" >/dev/null
    return 0
}

function mbfl_file_normalise () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    mbfl_optional_parameter(PREFIX, 2)
    local RESULT_VARNAME
    mbfl_file_normalise_var RESULT_VARNAME "$PATHNAME" "$PREFIX"
    echo "$RESULT_VARNAME"
}

### --------------------------------------------------------------------

function mbfl_p_file_remove_dots_from_pathname_var () {
    mbfl_mandatory_nameref_parameter(RESULT_VARREF1, 1, result variable)
    mbfl_mandatory_parameter(PATHNAME, 2, pathname)
    local -a SPLITPATH
    local -i SPLITCOUNT
    local -a output
    local -i output_counter input_counter

    mbfl_file_split "$PATHNAME"
    for ((input_counter=0, output_counter=0; input_counter < SPLITCOUNT; ++input_counter))
    do
        case "${SPLITPATH[$input_counter]}" in
            '.')
                ;;
            '..')
                let --output_counter
                ;;
            *)
                output[$output_counter]="${SPLITPATH[$input_counter]}"
                let ++output_counter
                ;;
        esac
    done
    {
	local -i i
	PATHNAME="${output[0]}"
	for ((i=1; $i < $output_counter; ++i))
	do PATHNAME+="/${output[$i]}"
	done
    }
    RESULT_VARREF1="$PATHNAME"
}

function mbfl_p_file_normalise1_var () {
    mbfl_mandatory_nameref_parameter(RESULT_VARREF1, 1, result variable)
    mbfl_mandatory_parameter(PATHNAME, 2, pathname)

    if mbfl_file_is_directory "$PATHNAME"
    then mbfl_p_file_normalise2_var RESULT_VARREF1 "$PATHNAME"
    else
        local TAILNAME DIRNAME
	mbfl_file_tail_var    TAILNAME "$PATHNAME"
        mbfl_file_dirname_var DIRNAME  "$PATHNAME"
        if mbfl_file_is_directory "$DIRNAME"
        then mbfl_p_file_normalise2_var RESULT_VARREF1 "$DIRNAME" "$TAILNAME"
        else mbfl_file_strip_trailing_slash_var RESULT_VARREF1 "$PATHNAME"
        fi
    fi
}
function mbfl_p_file_normalise2_var () {
    mbfl_mandatory_nameref_parameter(RESULT_VARREF2, 1, result variable)
    mbfl_mandatory_parameter(PATHNAME, 2, pathname)
    mbfl_optional_parameter(TAILNAME, 3)

    cd "$PATHNAME" >/dev/null
    if test -n "$TAILNAME"
    then printf -v RESULT_VARREF2 '%s/%s' "$PWD" "$TAILNAME"
    else RESULT_VARREF2="$PWD"
    fi
    cd - >/dev/null
}

#page
#### relative pathnames: extracting subpathnames

function mbfl_file_subpathname_var () {
    mbfl_mandatory_nameref_parameter(RESULT_VARREF, 1, result variable)
    mbfl_mandatory_parameter(PATHNAME, 2, pathname)
    mbfl_mandatory_parameter(BASEDIR, 3, base directory)

    # If BASEDIR ends with a slash: remove it.
    if test "${BASEDIR:$((${#BASEDIR}-1))}" = '/'
    then BASEDIR="${BASEDIR:0:$((${#BASEDIR}-1))}"
    fi

    if test "$PATHNAME" = "$BASEDIR"
    then
        RESULT_VARREF='./'
        return 0
    elif test "${PATHNAME:0:${#BASEDIR}}" = "$BASEDIR"
    then
        printf -v RESULT_VARREF './%s' "${PATHNAME:$((${#BASEDIR}+1))}"
        return 0
    else return 1
    fi
}

function mbfl_file_subpathname () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    mbfl_mandatory_parameter(BASEDIR, 2, base directory)
    local RESULT_VARNAME
    if mbfl_file_subpathname_var RESULT_VARNAME "$PATHNAME" "$BASEDIR"
    then
	echo "$RESULT_VARNAME"
	return 0
    else return 1
    fi
}

#page
#### file pathname type functions

function mbfl_file_is_absolute () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    test "${PATHNAME:0:1}" = '/'
}
function mbfl_file_is_absolute_dirname () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    mbfl_file_is_directory "$PATHNAME" && mbfl_file_is_absolute "$PATHNAME"
}
function mbfl_file_is_absolute_filename () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    mbfl_file_is_file "$PATHNAME" && mbfl_file_is_absolute "$PATHNAME"
}

### --------------------------------------------------------------------

function mbfl_file_is_relative () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    test "${PATHNAME:0:1}" != '/'
}
function mbfl_file_is_relative_dirname () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    mbfl_file_is_directory "$PATHNAME" && mbfl_file_is_relative "$PATHNAME"
}
function mbfl_file_is_relative_filename () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    mbfl_file_is_file "$PATHNAME" && mbfl_file_is_relative "$PATHNAME"
}

#PAGE
#### temporary directory functions

function mbfl_file_find_tmpdir () {
    local TMPDIR="${1:-${mbfl_option_TMPDIR}}"
    mbfl_file_directory_is_writable "$TMPDIR" && {
        printf "${TMPDIR}\n"
        return 0
    }
    test -n "$USER" && {
        TMPDIR="/tmp/${USER}"
        mbfl_file_directory_is_writable "$TMPDIR" && {
            printf "${TMPDIR}\n"
            return 0
        }
    }
    TMPDIR=/tmp
    mbfl_file_directory_is_writable "$TMPDIR" && {
        printf "${TMPDIR}\n"
        return 0
    }
    mbfl_message_error "cannot find usable value for 'TMPDIR'"
    return 1
}

#page
#### file removal functions

function mbfl_file_enable_remove () {
    mbfl_declare_program rm
    mbfl_declare_program rmdir
}
function mbfl_file_remove () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    local FLAGS="--force --recursive"
    mbfl_option_test || {
        mbfl_file_exists "$PATHNAME" || {
            mbfl_message_error_printf 'pathname does not exist "%s"' "$PATHNAME"
            return 1
        }
    }
    mbfl_exec_rm "$PATHNAME" ${FLAGS}
}
function mbfl_file_remove_file () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    local FLAGS="--force"
    mbfl_option_test || {
        mbfl_file_is_file "$PATHNAME" || {
            mbfl_message_error_printf 'pathname is not a file "%s"' "$PATHNAME"
            return 1
        }
    }
    mbfl_exec_rm "$PATHNAME" ${FLAGS}
}
function mbfl_file_remove_symlink () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    local FLAGS="--force"
    mbfl_option_test || {
        mbfl_file_is_symlink "$PATHNAME" || {
            mbfl_message_error_printf 'pathname is not a symbolic link "%s"' "$PATHNAME"
            return 1
        }
    }
    mbfl_exec_rm "$PATHNAME" ${FLAGS}
}
function mbfl_file_remove_file_or_symlink () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    local FLAGS="--force"
    mbfl_option_test || {
        mbfl_file_is_file "$PATHNAME" && ! mbfl_file_is_symlink "$PATHNAME" || {
            mbfl_message_error_printf 'pathname is neither a file nor a symbolic link "%s"' "$PATHNAME"
            return 1
        }
    }
    mbfl_exec_rm "$PATHNAME" ${FLAGS}
}
function mbfl_exec_rm () {
    local RM FLAGS
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    shift
    RM=$(mbfl_program_found rm) || exit $?
    mbfl_option_verbose_program && FLAGS+=' --verbose'
    mbfl_program_exec "$RM" ${FLAGS} "$@" -- "$PATHNAME"
}

#page
#### file copy functions

function mbfl_file_enable_copy () {
    mbfl_declare_program cp
}
function mbfl_file_copy () {
    mbfl_mandatory_parameter(SOURCE, 1, source pathname)
    mbfl_mandatory_parameter(TARGET, 2, target pathname)
    shift 2
    mbfl_option_test || {
        mbfl_file_is_readable "$SOURCE" || {
            mbfl_message_error_printf 'copying file "%s"' "$SOURCE"
            return 1
        }
    }
    mbfl_file_exists "$TARGET" && {
        if mbfl_file_is_directory "$TARGET"
        then mbfl_message_error_printf 'target of copy exists and it is a directory "%s"' "$TARGET"
        else mbfl_message_error_printf 'target file of copy already exists "%s"' "$TARGET"
        fi
        return 1
    }
    mbfl_exec_cp "$SOURCE" "$TARGET" "$@"
}
function mbfl_file_copy_to_directory () {
    mbfl_mandatory_parameter(SOURCE, 1, source pathname)
    mbfl_mandatory_parameter(TARGET, 2, target pathname)
    shift 2
    mbfl_option_test || {
        { mbfl_file_is_readable    "$SOURCE" print_error && \
            mbfl_file_exists       "$TARGET" print_error && \
            mbfl_file_is_directory "$TARGET" print_error
        } || {
            mbfl_message_error_printf 'copying file "%s"' "$SOURCE"
            return 1
        }
    }
    mbfl_exec_cp_to_dir "$SOURCE" "$TARGET" "$@"
}
function mbfl_exec_cp () {
    local CP FLAGS
    mbfl_mandatory_parameter(SOURCE, 1, source pathname)
    mbfl_mandatory_parameter(TARGET, 2, target pathname)
    shift 2
    CP=$(mbfl_program_found cp) || exit $?
    mbfl_option_verbose_program && FLAGS+=' --verbose'
    mbfl_program_exec ${CP} ${FLAGS} "$@" -- "$SOURCE" "$TARGET"
}
function mbfl_exec_cp_to_dir () {
    local CP FLAGS
    mbfl_mandatory_parameter(SOURCE, 1, source pathname)
    mbfl_mandatory_parameter(TARGET, 2, target pathname)
    shift 2
    CP=$(mbfl_program_found cp) || exit $?
    mbfl_option_verbose_program && FLAGS+=' --verbose'
    mbfl_program_exec ${CP} ${FLAGS} "$@" --target-directory="${TARGET}/" -- "$SOURCE"
}

#page
#### file move functions

function mbfl_file_enable_move () {
    mbfl_declare_program mv
}
function mbfl_file_move () {
    mbfl_mandatory_parameter(SOURCE, 1, source pathname)
    mbfl_mandatory_parameter(TARGET, 2, target pathname)
    shift 2
    mbfl_option_test || {
        mbfl_file_pathname_is_readable "$SOURCE" print_error || {
            mbfl_message_error "moving '${SOURCE}'"
            return 1
        }
    }
    mbfl_exec_mv "$SOURCE" "$TARGET" "$@"
}
function mbfl_file_move_to_directory () {
    mbfl_mandatory_parameter(SOURCE, 1, source pathname)
    mbfl_mandatory_parameter(TARGET, 2, target pathname)
    shift 2
    mbfl_option_test || {
        { mbfl_file_pathname_is_readable "$SOURCE" print_error && \
            mbfl_file_exists             "$TARGET" print_error && \
            mbfl_file_is_directory       "$TARGET" print_error
        } || {
            mbfl_message_error "moving file '${SOURCE}'"
            return 1
        }
    }
    mbfl_exec_mv_to_dir "$SOURCE" "$TARGET" "$@"
}
function mbfl_exec_mv () {
    local MV FLAGS
    mbfl_mandatory_parameter(SOURCE, 1, source pathname)
    mbfl_mandatory_parameter(TARGET, 2, target pathname)
    shift 2
    MV=$(mbfl_program_found mv) || exit $?
    mbfl_option_verbose_program && FLAGS+=' --verbose'
    mbfl_program_exec ${MV} ${FLAGS} "$@" -- "$SOURCE" "$TARGET"
}
function mbfl_exec_mv_to_dir () {
    local MV FLAGS
    mbfl_mandatory_parameter(SOURCE, 1, source pathname)
    mbfl_mandatory_parameter(TARGET, 2, target pathname)
    shift 2
    MV=$(mbfl_program_found mv) || exit $?
    mbfl_option_verbose_program && FLAGS+=' --verbose'
    mbfl_program_exec ${MV} ${FLAGS} "$@" --target-directory="${TARGET}/" -- "$SOURCE"
}

#page
#### directory remove functions

function mbfl_file_remove_directory () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    mbfl_optional_parameter(REMOVE_SILENTLY, 2, no)
    local FLAGS=
    mbfl_file_is_directory "$PATHNAME" || {
        mbfl_message_error "pathname is not a directory '${PATHNAME}'"
        return 1
    }
    test "$REMOVE_SILENTLY" = 'yes' && \
        FLAGS="${FLAGS} --ignore-fail-on-non-empty"
    mbfl_exec_rmdir "$PATHNAME" ${FLAGS}
}
function mbfl_file_remove_directory_silently () {
    mbfl_file_remove_directory "$1" yes
}
function mbfl_exec_rmdir () {
    local RMDIR FLAGS
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    shift
    RMDIR=$(mbfl_program_found rmdir) || exit $?
    mbfl_option_verbose_program && FLAGS+=' --verbose'
    mbfl_program_exec "$RMDIR" $FLAGS "$@" "$PATHNAME"
}

#page
#### directory creation functions

function mbfl_file_enable_make_directory () {
    mbfl_declare_program mkdir
}
function mbfl_file_make_directory () {
    local MKDIR FLAGS
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    mbfl_optional_parameter(PERMISSIONS, 2, 0775)
    MKDIR=$(mbfl_program_found mkdir) || exit $?
    FLAGS="--parents --mode=${PERMISSIONS}"
    mbfl_option_verbose_program && FLAGS+=' --verbose'
    mbfl_program_exec "$MKDIR" $FLAGS "$PATHNAME"
}
function mbfl_file_make_if_not_directory () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    mbfl_optional_parameter(PERMISSIONS, 2, 0775)
    mbfl_file_is_directory   "$PATHNAME" || \
    mbfl_file_make_directory "$PATHNAME" "$PERMISSIONS"
    mbfl_program_reset_sudo_user
}

#page
#### symbolic link functions

function mbfl_file_enable_symlink () {
    mbfl_declare_program ln
}
function mbfl_file_symlink () {
    local LN FLAGS="--symbolic"
    mbfl_mandatory_parameter(ORIGINAL_NAME, 1, original name)
    mbfl_mandatory_parameter(SYMLINK_NAME, 2, symbolic link name)
    LN=$(mbfl_program_found ln) || exit $?
    mbfl_option_verbose_program && FLAGS+=' --verbose'
    mbfl_program_exec "$LN" ${FLAGS} "$ORIGINAL_NAME" "$SYMLINK_NAME"
}

#page
#### file listing functions

function mbfl_file_enable_listing () {
    mbfl_declare_program ls
    mbfl_declare_program readlink
}
function mbfl_file_listing () {
    local LS
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    shift 1
    LS=$(mbfl_program_found ls) || exit $?
    mbfl_program_exec ${LS} "$@" "$PATHNAME"
}
function mbfl_file_long_listing () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    local LS_FLAGS='-l'
    mbfl_file_listing "$PATHNAME" "$LS_FLAGS"
}
function mbfl_file_get_owner () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    local LS_FLAGS="-l" OWNER
    set -- $(mbfl_file_p_invoke_ls) || return 1
    OWNER=$3
    test -z "$OWNER" && {
        mbfl_message_error "null owner while inspecting '${PATHNAME}'"
        return 1
    }
    printf '%s\n' "$OWNER"
}
function mbfl_file_get_group () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    local LS_FLAGS="-l" GROUP
    set -- $(mbfl_file_p_invoke_ls) || return 1
    GROUP=$4
    test -z "$GROUP" && {
        mbfl_message_error "null group while inspecting '${PATHNAME}'"
        return 1
    }
    printf '%s\n' "$GROUP"
}
function mbfl_file_get_size () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
##    local LS_FLAGS="--block-size=1 --size"
    local output LS_FLAGS="-l"
    output=$(mbfl_file_p_invoke_ls) || return 1
    set -- $output
    printf '%s\n' "${5}"
}
function mbfl_file_p_invoke_ls () {
    local LS
    LS=$(mbfl_program_found ls) || exit $?
    mbfl_file_is_directory "$PATHNAME" && LS_FLAGS="${LS_FLAGS} -d"
    mbfl_program_exec ${LS} ${LS_FLAGS} "$PATHNAME"
}
function mbfl_file_normalise_link () {
    local READLINK
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    READLINK=$(mbfl_program_found readlink) || exit $?
    mbfl_program_exec "$READLINK" -fn "$PATHNAME"
}
function mbfl_file_read_link () {
    local READLINK
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    READLINK=$(mbfl_program_found readlink) || exit $?
    mbfl_program_exec "$READLINK" "$PATHNAME"
}

#page
#### file permissions inspection functions

function mbfl_p_file_print_error_return_result () {
    local RESULT=$?
    test ${RESULT} != 0 -a "$PRINT_ERROR" = 'print_error' && \
        mbfl_message_error "$ERROR_MESSAGE"
    return $RESULT
}

# ------------------------------------------------------------

function mbfl_file_exists () {
    test -e "${1}"
}
function mbfl_file_pathname_is_readable () {
    local PATHNAME=${1}
    local PRINT_ERROR=${2:-no}
    local ERROR_MESSAGE="not readable pathname '${PATHNAME}'"
    test -n "$PATHNAME" -a -r "$PATHNAME"
    mbfl_p_file_print_error_return_result
}
function mbfl_file_pathname_is_writable () {
    local PATHNAME=${1}
    local PRINT_ERROR=${2:-no}
    local ERROR_MESSAGE="not writable pathname '${PATHNAME}'"
    test -n "$PATHNAME" -a -w "$PATHNAME"
    mbfl_p_file_print_error_return_result
}
function mbfl_file_pathname_is_executable () {
    local PATHNAME=${1}
    local PRINT_ERROR=${2:-no}
    local ERROR_MESSAGE="not executable pathname '${PATHNAME}'"
    test -n "$PATHNAME" -a -x "$PATHNAME"
    mbfl_p_file_print_error_return_result
}

# ------------------------------------------------------------

function mbfl_file_is_file () {
    local PATHNAME=${1}
    local PRINT_ERROR=${2:-no}
    local ERROR_MESSAGE="unexistent file '${PATHNAME}'"
    test -n "$PATHNAME" -a -f "$PATHNAME"
    mbfl_p_file_print_error_return_result
}
function mbfl_file_is_readable () {
    local PATHNAME=${1}
    local PRINT_ERROR=${2:-no}
    mbfl_file_is_file "$PATHNAME" "$PRINT_ERROR" && \
        mbfl_file_pathname_is_readable "$PATHNAME" "$PRINT_ERROR"
}
function mbfl_file_is_writable () {
    local PATHNAME=${1}
    local PRINT_ERROR=${2:-no}
    mbfl_file_is_file "$PATHNAME" "$PRINT_ERROR" && \
        mbfl_file_pathname_is_writable "$PATHNAME" "$PRINT_ERROR"
}
function mbfl_file_is_executable () {
    local PATHNAME=${1}
    local PRINT_ERROR=${2:-no}
    mbfl_file_is_file "$PATHNAME" "$PRINT_ERROR" && \
        mbfl_file_pathname_is_executable "$PATHNAME" "$PRINT_ERROR"
}

# ------------------------------------------------------------

function mbfl_file_is_directory () {
    local PATHNAME=${1}
    local PRINT_ERROR=${2:-no}
    local ERROR_MESSAGE="unexistent directory '${PATHNAME}'"
    test -n "$PATHNAME" -a -d "$PATHNAME"
    mbfl_p_file_print_error_return_result
}
function mbfl_file_directory_is_readable () {
    local PATHNAME=${1}
    local PRINT_ERROR=${2:-no}
    mbfl_file_is_directory "$PATHNAME" "$PRINT_ERROR" && \
        mbfl_file_pathname_is_readable "$PATHNAME" "$PRINT_ERROR"
}
function mbfl_file_directory_is_writable () {
    local PATHNAME=${1}
    local PRINT_ERROR=${2:-no}
    mbfl_file_is_directory "$PATHNAME" "$PRINT_ERROR" && \
        mbfl_file_pathname_is_writable "$PATHNAME" "$PRINT_ERROR"
}
function mbfl_file_directory_is_executable () {
    local PATHNAME=${1}
    local PRINT_ERROR=${2:-no}
    mbfl_file_is_directory "$PATHNAME" "$PRINT_ERROR" && \
        mbfl_file_pathname_is_executable "$PATHNAME" "$PRINT_ERROR"
}
function mbfl_file_directory_validate_writability () {
    local code
    mbfl_mandatory_parameter(DIRECTORY, 1, directory pathname)
    mbfl_mandatory_parameter(DESCRIPTION, 2, directory description)
    mbfl_message_verbose "validating ${DESCRIPTION} directory '${DIRECTORY}'\n"
    mbfl_file_is_directory              "$DIRECTORY" print_error && \
    mbfl_file_directory_is_writable     "$DIRECTORY" print_error
    code=$?
    test $code != 0 && mbfl_message_error \
        "unwritable ${DESCRIPTION} directory '${DIRECTORY}'"
    return $code
}

# ------------------------------------------------------------

function mbfl_file_is_symlink () {
    local PATHNAME=${1}
    local PRINT_ERROR=${2:-no}
    local ERROR_MESSAGE="not a symbolic link pathname '${PATHNAME}'"
    test -n "$PATHNAME" -a -L "$PATHNAME"
    mbfl_p_file_print_error_return_result
}

#page
#### "tar" interface

function mbfl_file_enable_tar () {
    mbfl_declare_program tar
}
function mbfl_tar_create_to_stdout () {
    mbfl_mandatory_parameter(DIRECTORY, 1, directory name)
    shift
    mbfl_tar_exec --directory="$DIRECTORY" --create --file=- "$@" .
}
function mbfl_tar_extract_from_stdin () {
    mbfl_mandatory_parameter(DIRECTORY, 1, directory name)
    shift
    mbfl_tar_exec --directory="$DIRECTORY" --extract --file=- "$@"
}
function mbfl_tar_extract_from_file () {
    mbfl_mandatory_parameter(DIRECTORY, 1, directory name)
    mbfl_mandatory_parameter(ARCHIVE_FILENAME, 2, archive pathname)
    shift 2
    mbfl_tar_exec --directory="$DIRECTORY" --extract --file="$ARCHIVE_FILENAME" "$@"
}
function mbfl_tar_create_to_file () {
    mbfl_mandatory_parameter(DIRECTORY, 1, directory name)
    mbfl_mandatory_parameter(ARCHIVE_FILENAME, 2, archive pathname)
    shift 2
    mbfl_tar_exec --directory="$DIRECTORY" --create --file="$ARCHIVE_FILENAME" "$@" .
}
function mbfl_tar_archive_directory_to_file () {
    local PARENT DIRNAME
    mbfl_mandatory_parameter(DIRECTORY, 1, directory name)
    mbfl_mandatory_parameter(ARCHIVE_FILENAME, 2, archive pathname)
    shift 2
    mbfl_file_dirname_var PARENT "$DIRECTORY"
    mbfl_file_tail_var DIRNAME "$DIRECTORY"
    mbfl_tar_exec --directory="$PARENT" --create \
        --file="$ARCHIVE_FILENAME" "$@" "$DIRNAME"
}
function mbfl_tar_list () {
    mbfl_mandatory_parameter(ARCHIVE_FILENAME, 1, archive pathname)
    shift
    mbfl_tar_exec --list --file="$ARCHIVE_FILENAME" "$@"
}
function mbfl_tar_exec () {
    local TAR FLAGS
    TAR=$(mbfl_program_found tar) || exit $?
    mbfl_option_verbose_program && FLAGS+=' --verbose'
    mbfl_program_exec "$TAR" ${FLAGS} "$@"
}
#page
#### file permissions functions

function mbfl_file_enable_permissions () {
    mbfl_declare_program ls
    mbfl_declare_program cut
    mbfl_declare_program chmod
}
function mbfl_file_get_permissions () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    local LS CUT SYMBOLIC OWNER GROUP OTHER
    LS=$(mbfl_program_found ls)   || exit $?
    CUT=$(mbfl_program_found cut) || exit $?
    # Here we use '-d' even with files: it appears to work with GNU ls.
    SYMBOLIC=$(mbfl_program_exec ${LS} -ld "$PATHNAME" | \
        mbfl_program_exec ${CUT} -d' ' -f1) || return $?
    mbfl_message_debug "symbolic permissions '${SYMBOLIC}'"
    OWNER=${SYMBOLIC:1:3}
    GROUP=${SYMBOLIC:4:3}
    OTHER=${SYMBOLIC:7:3}
    OWNER=$(mbfl_system_symbolic_to_octal_permissions "$OWNER")
    GROUP=$(mbfl_system_symbolic_to_octal_permissions "$GROUP")
    OTHER=$(mbfl_system_symbolic_to_octal_permissions "$OTHER")
    printf '0%d%d%d\n' "$OWNER" "$GROUP" "$OTHER"
}
function mbfl_file_set_permissions () {
    local CHMOD
    mbfl_mandatory_parameter(PERMISSIONS, 1, permissions)
    mbfl_mandatory_parameter(PATHNAME, 2, pathname)
    CHMOD=$(mbfl_program_found chmod) || exit $?
    mbfl_program_exec ${CHMOD} "$PERMISSIONS" "$PATHNAME"
}

#page
#### file owner and group functions

function mbfl_file_enable_owner_and_group () {
    mbfl_declare_program chown
    mbfl_declare_program chgrp
}
function mbfl_file_set_owner () {
    local CHOWN CHOWN_FLAGS
    mbfl_mandatory_parameter(OWNER, 1, owner)
    mbfl_mandatory_parameter(PATHNAME, 2, pathname)
    CHOWN=$(mbfl_program_found chown) || exit $?
    if mbfl_option_verbose
    then CHOWN_FLAGS='--verbose'
    fi
    mbfl_program_exec ${CHOWN} "$OWNER" "$PATHNAME" $CHOWN_FLAGS
}
function mbfl_file_set_group () {
    local CHGRP CHGRP_FLAGS
    mbfl_mandatory_parameter(GROUP, 1, group)
    mbfl_mandatory_parameter(PATHNAME, 2, pathname)
    CHGRP=$(mbfl_program_found chgrp) || exit $?
    if mbfl_option_verbose
    then CHGRP_FLAGS='--verbose'
    fi
    mbfl_program_exec ${CHGRP} "$GROUP" "$PATHNAME" $CHGRP_FLAGS
}

#page
#### reading and writing files with privileges

function mbfl_file_append () {
    mbfl_mandatory_parameter(STRING, 1, string)
    mbfl_mandatory_parameter(FILENAME, 2, file name)
    mbfl_program_bash_command "printf '%s' '${STRING}' >>'${FILENAME}'"
}
function mbfl_file_write () {
    mbfl_mandatory_parameter(STRING, 1, string)
    mbfl_mandatory_parameter(FILENAME, 2, file name)
    mbfl_program_bash_command "printf '%s' '${STRING}' >'${FILENAME}'"
}
function mbfl_file_read () {
    mbfl_mandatory_parameter(FILENAME, 1, file name)
    mbfl_program_bash_command "printf '%s' \"\$(<${FILENAME})\""
}

#page
#### compression interface functions

mbfl_p_file_compress_FUNCTION=mbfl_p_file_compress_gzip
mbfl_p_file_compress_KEEP_ORIGINAL='no'
mbfl_p_file_compress_TO_STDOUT='no'

function mbfl_file_enable_compress () {
    mbfl_declare_program gzip
    mbfl_declare_program bzip2
    mbfl_file_compress_select_gzip
    mbfl_file_compress_nokeep
}
function mbfl_file_compress_keep ()     { mbfl_p_file_compress_KEEP_ORIGINAL='yes'; }
function mbfl_file_compress_nokeep ()   { mbfl_p_file_compress_KEEP_ORIGINAL='no'; }
function mbfl_file_compress_stdout ()   { mbfl_p_file_compress_TO_STDOUT='yes'; }
function mbfl_file_compress_nostdout () { mbfl_p_file_compress_TO_STDOUT='no'; }
function mbfl_file_compress_select_gzip () {
    mbfl_p_file_compress_FUNCTION=mbfl_p_file_compress_gzip
}
function mbfl_file_compress_select_bzip () {
    mbfl_p_file_compress_FUNCTION=mbfl_p_file_compress_bzip
}
function mbfl_file_compress () {
    mbfl_mandatory_parameter(FILE, 1, target file)
    shift
    mbfl_p_file_compress compress "$FILE" "$@"
}
function mbfl_file_decompress () {
    mbfl_mandatory_parameter(FILE, 1, target file)
    shift
    mbfl_p_file_compress decompress "$FILE" "$@"
}
function mbfl_p_file_compress () {
    mbfl_mandatory_parameter(MODE, 1, compression/decompression mode)
    mbfl_mandatory_parameter(FILE, 2, target file)
    shift 2
    mbfl_file_is_file "$FILE" || {
        mbfl_message_error "compression target is not a file '${FILE}'"
        return 1
    }
    ${mbfl_p_file_compress_FUNCTION} ${MODE} "$FILE" "$@"
}

#page
#### compression action functions

function mbfl_p_file_compress_gzip () {
    local COMPRESSOR FLAGS DEST
    mbfl_mandatory_parameter(COMPRESS, 1, compress/decompress mode)
    mbfl_mandatory_parameter(SOURCE, 2, target file)
    shift 2
    COMPRESSOR=$(mbfl_program_found gzip) || exit $?
    case "$COMPRESS" in
        compress)
            DEST=${SOURCE}.gz
            ;;
        decompress)
            DEST=$(mbfl_file_rootname "$SOURCE")
            FLAGS="${FLAGS} --decompress"
            ;;
        *)
            mbfl_message_error "internal error: wrong mode '${COMPRESS}' in '${FUNCNAME}'"
            exit_failure
            ;;
    esac
    mbfl_option_verbose_program && FLAGS+=' --verbose'
    if test "${mbfl_p_file_compress_TO_STDOUT}" = yes
    then
        FLAGS="${FLAGS} --stdout"
        mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE"
    else
        if test "${mbfl_p_file_compress_KEEP_ORIGINAL}" = yes
        then
            FLAGS="${FLAGS} --stdout"
            mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE" >"$DEST"
        else mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE"
        fi
    fi
}
function mbfl_p_file_compress_bzip () {
    local COMPRESSOR FLAGS DEST
    mbfl_mandatory_parameter(COMPRESS, 1, compress/decompress mode)
    mbfl_mandatory_parameter(SOURCE, 2, target file)
    shift 2
    COMPRESSOR=$(mbfl_program_found bzip2) || exit $?
    case "$COMPRESS" in
        compress)
            DEST=${SOURCE}.bz2
            FLAGS="${FLAGS} --compress"
            ;;
        decompress)
            DEST=$(mbfl_file_rootname "$SOURCE")
            FLAGS="${FLAGS} --decompress"
            ;;
        *)
            mbfl_message_error "internal error: wrong mode '${COMPRESS}' in '${FUNCNAME}'"
            exit_failure
            ;;
    esac
    mbfl_option_verbose_program && FLAGS+=' --verbose'
    if test "${mbfl_p_file_compress_TO_STDOUT}" = yes
    then
        FLAGS="${FLAGS} --keep --stdout"
        mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE"
    else
        test "${mbfl_p_file_compress_KEEP_ORIGINAL}" = yes && \
            FLAGS="${FLAGS} --keep"
        mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE"
    fi
}

#page
#### interface to "stat"

function mbfl_file_enable_stat () {
    mbfl_declare_program stat
}
function mbfl_file_stat () {
    local STAT FLAGS
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    STAT=$(mbfl_program_found stat) || exit $?
    mbfl_program_exec "$STAT" ${FLAGS} "$@"
}


### end of file
# Local Variables:
# mode: sh
# End:
