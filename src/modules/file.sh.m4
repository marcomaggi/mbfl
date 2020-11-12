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
#	NOTE  The   file  name  functions  are   not  implemented  using  the   parameter  expansion
#	functionalities; in the  way the author has understood parameter  expansion: there are cases
#	that are not correctly handled.
#
# Copyright (c) 2003-2005, 2009, 2013, 2017, 2018, 2020 Marco Maggi
# <mrc.mgg@gmail.com>
#
# This is free software; you can redistribute it and/or  modify it under the terms of the GNU Lesser
# General Public  License as published by  the Free Software  Foundation; either version 3.0  of the
# License, or (at your option) any later version.
#
# This library is distributed in the hope that  it will be useful, but WITHOUT ANY WARRANTY; without
# even the  implied warranty of MERCHANTABILITY  or FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the  GNU Lesser General Public License along with this library;
# if not,  write to  the Free  Software Foundation,  Inc., 59  Temple Place,  Suite 330,  Boston, MA
# 02111-1307 USA.
#

#page
#### helpers

function mbfl_file_p_validate_executable_hard_coded_pathname () {
    mbfl_mandatory_parameter(PROGRAM_PATHNAME, 1, executable program pathname)

    ! mbfl_string_equal '/bin/false' "$PROGRAM_PATHNAME" && mbfl_file_is_executable "$PROGRAM_PATHNAME"
}

#page
#### pathname parsing utilities

# Scan  backwards the  PATHNAME  starting at  INDEX,  assuming that  the
# character at INDEX is a dot:
#
#   test "mbfl_string_idx(PATHNAME, $INDEX)" = .
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
	local -r ch=mbfl_string_idx(PATHNAME, $((INDEX - 1)))

	# For the case of standalone double-dot "..":
	if   ((1 == INDEX)) && test "$ch" = '.'
	then return_success
	     # For the case of double-dot as last component "/path/to/..":
	elif ((1 < INDEX))  && test \( "$ch" = '.' \) -a \( "mbfl_string_idx(PATHNAME, $((INDEX - 2)))" = '/' \)
	then return_success
	else return_because_failure
	fi
    else return_because_failure
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

    test 0 -eq $INDEX -o "mbfl_string_idx(PATHNAME, $((INDEX - 1)))" = '/'
}

#page
#### changing directory functions

function mbfl_cd () {
    mbfl_mandatory_parameter(DIRECTORY, 1, directory)
    shift 1
    mbfl_file_normalise_var DIRECTORY "$DIRECTORY"
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
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable)
    mbfl_mandatory_parameter(mbfl_PATHNAME, 2, pathname)
    local -i mbfl_I
    local mbfl_result

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
    for ((mbfl_I=mbfl_string_len(mbfl_PATHNAME); mbfl_I > 0; --mbfl_I))
    do
        if test "mbfl_string_idx(mbfl_PATHNAME, $mbfl_I)" = '/'
	then break
	else
	    if mbfl_string_is_equal_unquoted_char "$mbfl_PATHNAME" $mbfl_I .
	    then
		if test "mbfl_string_idx(mbfl_PATHNAME, $((mbfl_I - 1)))" = '/'
		then
		    # There is no extension.   So we break because there
		    # is no point in continuing.
		    break
		else
		    # Found an extension.  Store it and break.
		    mbfl_result=${mbfl_PATHNAME:$((mbfl_I + 1))}
		    break
		fi
	    fi
	fi
    done
    mbfl_RESULT_VARREF=$mbfl_result
    return_success
}
function mbfl_file_extension () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    local RESULT_VARNAME
    if mbfl_file_extension_var RESULT_VARNAME "$PATHNAME"
    then echo "$RESULT_VARNAME"
    else return $?
    fi
}

#page
#### pathname name functions: dirname

function mbfl_file_dirname_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable)
    mbfl_optional_parameter(mbfl_PATHNAME, 2)
    local -i mbfl_I
    local mbfl_result=.

    # We search for the last slash character in the pathname.
    #
    for ((mbfl_I=mbfl_string_len(mbfl_PATHNAME); mbfl_I >= 0; --mbfl_I))
    do
        if test "mbfl_string_idx(mbfl_PATHNAME, ${mbfl_I})" = '/'
	then
	    # Skip consecutive slashes.
            while test \( ${mbfl_I} -gt 0 \) -a \( "mbfl_string_idx(mbfl_PATHNAME, ${mbfl_I})" = '/' \)
            do let --mbfl_I
            done

	    mbfl_result=${mbfl_PATHNAME:0:$((mbfl_I + 1))}
	    break
        fi
    done
    mbfl_RESULT_VARREF=$mbfl_result
    return_success
}
function mbfl_file_dirname () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    local RESULT_VARNAME
    if mbfl_file_dirname_var RESULT_VARNAME "$PATHNAME"
    then echo "$RESULT_VARNAME"
    else return $?
    fi
}

#page
#### pathname name functions: rootname

function mbfl_file_rootname_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable)
    mbfl_mandatory_parameter(mbfl_PATHNAME, 2, pathname)
    local -i mbfl_I=mbfl_string_len(mbfl_PATHNAME)
    local mbfl_ch mbfl_result

    # Special handling for standalone  slash, standalone dot, standalone
    # double-dot.
    if test \( "$mbfl_PATHNAME" = '/' \) -o \( "$mbfl_PATHNAME" = '.' \) -o \( "$mbfl_PATHNAME" = '..' \)
    then mbfl_result=$mbfl_PATHNAME
    else
	# Skip the trailing slashes.
	while ((0 < mbfl_I)) && test "mbfl_string_idx(mbfl_PATHNAME, $((mbfl_I - 1)))" = '/'
	do let --mbfl_I
	done
	mbfl_PATHNAME=${mbfl_PATHNAME:0:$mbfl_I}

	if ((1 == mbfl_I))
	then mbfl_result=$mbfl_PATHNAME
	else
	    for ((mbfl_I=mbfl_string_len(mbfl_PATHNAME); $mbfl_I >= 0; --mbfl_I))
	    do
		mbfl_ch=mbfl_string_idx(mbfl_PATHNAME, $mbfl_I)
		if test "$mbfl_ch" = '.'
		then
		    if mbfl_p_file_backwards_looking_at_double_dot "$mbfl_PATHNAME" $mbfl_I || \
			    mbfl_p_file_looking_at_component_beginning "$mbfl_PATHNAME" $mbfl_I
		    then
			# The pathname is one among:
			#
			#   /path/to/..
			#   ..
			#
			# print the full pathname.
			mbfl_result=$mbfl_PATHNAME
			break
		    elif ((0 < mbfl_I))
		    then
			mbfl_result=${mbfl_PATHNAME:0:$mbfl_I}
			break
		    else
			mbfl_result=$mbfl_PATHNAME
			break
		    fi
		elif test "$mbfl_ch" = '/'
		then
		    mbfl_result=$mbfl_PATHNAME
		    break
		fi
	    done
	fi
    fi
    mbfl_RESULT_VARREF=$mbfl_result
    return_success
}

function mbfl_file_rootname () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    local RESULT_VARNAME
    if mbfl_file_rootname_var RESULT_VARNAME "$PATHNAME"
    then echo "$RESULT_VARNAME"
    else return $?
    fi
}

#page
#### pathname name functions: tailname

function mbfl_file_tail_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable)
    mbfl_mandatory_parameter(mbfl_PATHNAME, 2, pathname)
    local -i mbfl_I
    # If no slash is present: the result is the full pathname.
    local result=$mbfl_PATHNAME

    for ((mbfl_I=mbfl_string_len(mbfl_PATHNAME); $mbfl_I >= 0; --mbfl_I))
    do
        if test "mbfl_string_idx(mbfl_PATHNAME, $mbfl_I)" = '/'
	then
            result=${mbfl_PATHNAME:$((mbfl_I + 1))}
            break
	fi
    done
    mbfl_RESULT_VARREF=$result
    return_success
}

function mbfl_file_tail () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    local RESULT_VARNAME
    if mbfl_file_tail_var RESULT_VARNAME "$PATHNAME"
    then echo "$RESULT_VARNAME"
    else return $?
    fi
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
        if test "mbfl_string_idx(PATHNAME, $i)" = '/'
	then
            SPLITPATH[$SPLITCOUNT]=${PATHNAME:$last_found:$(($i-$last_found))}
            let ++SPLITCOUNT
	    let ++i
            mbfl_string_skip "$PATHNAME" i '/'
            last_found=$i
        fi
    done
    SPLITPATH[$SPLITCOUNT]=${PATHNAME:$last_found}
    let ++SPLITCOUNT
    return_success
}

#page
#### pathname normalisation: stripping slashes

function mbfl_file_strip_trailing_slash_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable)
    mbfl_mandatory_parameter(mbfl_PATHNAME, 2, pathname)
    local -i mbfl_I=mbfl_string_len(mbfl_PATHNAME)
    local mbfl_result

    # Skip the trailing slashes.
    while ((0 < mbfl_I)) && test "mbfl_string_idx(mbfl_PATHNAME, $((mbfl_I - 1)))" = '/'
    do let --mbfl_I
    done
    if ((0 == mbfl_I))
    then mbfl_result='.'
    else mbfl_result=${mbfl_PATHNAME:0:$mbfl_I}
    fi
    mbfl_RESULT_VARREF=$mbfl_result
}

function mbfl_file_strip_trailing_slash () {
    mbfl_mandatory_parameter(mbfl_PATHNAME, 1, pathname)
    local RESULT_VARNAME
    if mbfl_file_strip_trailing_slash_var RESULT_VARNAME "$mbfl_PATHNAME"
    then echo "$RESULT_VARNAME"
    else return $?
    fi
}

### --------------------------------------------------------------------

function mbfl_file_strip_leading_slash_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable)
    mbfl_mandatory_parameter(mbfl_PATHNAME, 2, pathname)
    local mbfl_result

    if test "mbfl_string_idx(mbfl_PATHNAME, 0)" = '/'
    then
	local -i mbfl_I=1 mbfl_len=mbfl_string_len(mbfl_PATHNAME)
	# Skip the leading slashes.
	while ((mbfl_I < mbfl_len)) && test "mbfl_string_idx(mbfl_PATHNAME, $mbfl_I)" = '/'
	do let ++mbfl_I
	done
	if ((mbfl_len == mbfl_I))
	then mbfl_result='.'
	else mbfl_result=${mbfl_PATHNAME:$mbfl_I}
	fi
    else mbfl_result=$mbfl_PATHNAME
    fi
    mbfl_RESULT_VARREF=$mbfl_result
}

function mbfl_file_strip_leading_slash () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    local RESULT_VARNAME
    if mbfl_file_strip_leading_slash_var RESULT_VARNAME "$PATHNAME"
    then echo "$RESULT_VARNAME"
    else return $?
    fi
}

#page
#### pathname normalisation: full normalisation

function mbfl_file_normalise_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable)
    mbfl_mandatory_parameter(mbfl_PATHNAME, 2, pathname)
    mbfl_optional_parameter(mbfl_PREFIX, 3)
    local mbfl_result mbfl_ORGPWD=$PWD

    if mbfl_file_is_absolute "$mbfl_PATHNAME"
    then
	mbfl_p_file_normalise1_var mbfl_result "$mbfl_PATHNAME"
	mbfl_RESULT_VARREF=$mbfl_result
    elif mbfl_file_is_directory "$mbfl_PREFIX"
    then
        mbfl_PATHNAME=${mbfl_PREFIX}/${mbfl_PATHNAME}
        mbfl_p_file_normalise1_var mbfl_result "$mbfl_PATHNAME"
	mbfl_RESULT_VARREF=$mbfl_result
    elif mbfl_string_is_not_empty "$mbfl_PREFIX"
    then
	local mbfl_PATHNAME1 mbfl_PATHNAME2
        mbfl_p_file_remove_dots_from_pathname_var mbfl_PREFIX   "$mbfl_PREFIX"
        mbfl_p_file_remove_dots_from_pathname_var mbfl_PATHNAME1 "$mbfl_PATHNAME"
        mbfl_file_strip_trailing_slash_var        mbfl_PATHNAME2 "$mbfl_PATHNAME1"
        printf -v mbfl_RESULT_VARREF '%s/%s' "$mbfl_PREFIX" "$mbfl_PATHNAME2"
    else
	mbfl_p_file_normalise1_var mbfl_result "$mbfl_PATHNAME"
	mbfl_RESULT_VARREF=$mbfl_result
    fi
    cd "$mbfl_ORGPWD" >/dev/null
    return_success
}

function mbfl_file_normalise () {
    mbfl_mandatory_parameter(mbfl_PATHNAME, 1, pathname)
    mbfl_optional_parameter(mbfl_PREFIX, 2)
    local RESULT_VARNAME
    if mbfl_file_normalise_var RESULT_VARNAME "$mbfl_PATHNAME" "$mbfl_PREFIX"
    then echo "$RESULT_VARNAME"
    else return $?
    fi
}

### --------------------------------------------------------------------

function mbfl_p_file_remove_dots_from_pathname_var () {
    mbfl_mandatory_nameref_parameter(RESULT_VARREF1, 1, result variable)
    mbfl_mandatory_parameter(mbfl_PATHNAME, 2, pathname)
    local -a SPLITPATH
    local -i SPLITCOUNT
    local -a mbfl_output
    local -i mbfl_output_counter mbfl_input_counter

    mbfl_file_split "$mbfl_PATHNAME"
    for ((mbfl_input_counter=0, mbfl_output_counter=0; mbfl_input_counter < SPLITCOUNT; ++mbfl_input_counter))
    do
        case ${SPLITPATH[$mbfl_input_counter]} in
            '.')
            ;;
            '..')
                let --mbfl_output_counter
                ;;
            *)
                mbfl_output[$mbfl_output_counter]=${SPLITPATH[$mbfl_input_counter]}
                let ++mbfl_output_counter
                ;;
        esac
    done
    {
	local -i i
	mbfl_PATHNAME=${mbfl_output[0]}
	for ((i=1; $i < $mbfl_output_counter; ++i))
	do mbfl_PATHNAME+=/${mbfl_output[$i]}
	done
    }
    RESULT_VARREF1=$mbfl_PATHNAME
}

function mbfl_p_file_normalise1_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF1, 1, result variable)
    mbfl_mandatory_parameter(mbfl_PATHNAME, 2, pathname)

    if mbfl_file_is_directory "$mbfl_PATHNAME"
    then mbfl_p_file_normalise2_var mbfl_RESULT_VARREF1 "$mbfl_PATHNAME"
    else
        local mbfl_TAILNAME mbfl_DIRNAME
	mbfl_file_tail_var    mbfl_TAILNAME "$mbfl_PATHNAME"
        mbfl_file_dirname_var mbfl_DIRNAME  "$mbfl_PATHNAME"
        if mbfl_file_is_directory "$mbfl_DIRNAME"
        then mbfl_p_file_normalise2_var mbfl_RESULT_VARREF1 "$mbfl_DIRNAME" "$mbfl_TAILNAME"
        else mbfl_file_strip_trailing_slash_var mbfl_RESULT_VARREF1 "$mbfl_PATHNAME"
        fi
    fi
}
function mbfl_p_file_normalise2_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF2, 1, result variable)
    mbfl_mandatory_parameter(mbfl_PATHNAME, 2, pathname)
    mbfl_optional_parameter(mbfl_TAILNAME, 3)

    cd "$mbfl_PATHNAME" >/dev/null
    if mbfl_string_is_not_empty "$mbfl_TAILNAME"
    then printf -v mbfl_RESULT_VARREF2 '%s/%s' "$PWD" "$mbfl_TAILNAME"
    else mbfl_RESULT_VARREF2=$PWD
    fi
    cd - >/dev/null
}

#page
#### pathname normalisation: realpath

function mbfl_file_enable_realpath () {
    : mbfl_declare_program realpath
}

function mbfl_exec_realpath () {
    if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_REALPATH"
    then mbfl_program_exec "$mbfl_PROGRAM_REALPATH" "$@"
    else
	mbfl_message_error_printf 'program "realpath" not executable, tested pathname is: "%s"' "$mbfl_PROGRAM_REALPATH"
	return_because_program_not_found
    fi
}
function mbfl_file_realpath () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    shift
    mbfl_exec_realpath "$@" -- "$PATHNAME"
}
function mbfl_file_realpath_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable)
    mbfl_mandatory_parameter(mbfl_PATHNAME, 2, pathname)
    shift 2

    if ! mbfl_RESULT_VARREF=$(mbfl_file_realpath "$mbfl_PATHNAME" "$@")
    then return $?
    fi
}

#page
#### relative pathnames: extracting subpathnames

function mbfl_file_subpathname_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable)
    mbfl_mandatory_parameter(mbfl_PATHNAME, 2, pathname)
    mbfl_mandatory_parameter(mbfl_BASEDIR, 3, base directory)

    # If mbfl_BASEDIR ends with a slash: remove it.
    if test "${mbfl_BASEDIR:$((${#mbfl_BASEDIR}-1))}" = '/'
    then mbfl_BASEDIR=${mbfl_BASEDIR:0:$((${#mbfl_BASEDIR}-1))}
    fi

    if test "$mbfl_PATHNAME" = "$mbfl_BASEDIR"
    then
        mbfl_RESULT_VARREF='./'
        return_success
    elif test "${mbfl_PATHNAME:0:${#mbfl_BASEDIR}}" = "$mbfl_BASEDIR"
    then
        printf -v mbfl_RESULT_VARREF './%s' "${mbfl_PATHNAME:$((${#mbfl_BASEDIR}+1))}"
        return_success
    else return_because_failure
    fi
}

function mbfl_file_subpathname () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    mbfl_mandatory_parameter(BASEDIR, 2, base directory)
    local RESULT_VARNAME
    if mbfl_file_subpathname_var RESULT_VARNAME "$PATHNAME" "$BASEDIR"
    then echo "$RESULT_VARNAME"
    else return $?
    fi
}

#page
#### file pathname type functions

function mbfl_file_is_absolute () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    test "mbfl_string_idx(PATHNAME, 0)" = '/'
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
    test "mbfl_string_idx(PATHNAME, 0)" != '/'
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

function mbfl_file_find_tmpdir_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable)
    mbfl_optional_parameter(mbfl_TMPDIR, 2, "$mbfl_option_mbfl_TMPDIR")

    if mbfl_file_directory_is_writable "$mbfl_TMPDIR"
    then
        mbfl_RESULT_VARREF=$mbfl_TMPDIR
        return_success
    elif mbfl_string_is_not_empty "$USER"
    then
        mbfl_TMPDIR=/tmp/${USER}
        if mbfl_file_directory_is_writable "$mbfl_TMPDIR"
	then
            mbfl_RESULT_VARREF=$mbfl_TMPDIR
            return_success
	else return_because_failure
	fi
    else
	mbfl_TMPDIR=/tmp
	if mbfl_file_directory_is_writable "$mbfl_TMPDIR"
	then
            mbfl_RESULT_VARREF=$mbfl_TMPDIR
            return_success
	else
	    mbfl_message_error 'cannot find usable value for "mbfl_TMPDIR"'
	    return_because_failure
	fi
    fi
}

function mbfl_file_find_tmpdir () {
    mbfl_optional_parameter(TMPDIR, 1, "$mbfl_option_TMPDIR")
    local RESULT_VARNAME
    if mbfl_file_find_tmpdir_var RESULT_VARNAME "$TMPDIR"
    then echo "$RESULT_VARNAME"
    else return $?
    fi
}

#page
#### removal functions: removing files

function mbfl_file_enable_remove () {
    : mbfl_declare_program rm
    : mbfl_declare_program rmdir
}

function mbfl_exec_rm () {
    if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_RM"
    then
	local FLAGS
	if mbfl_option_verbose_program
	then FLAGS+=' --verbose'
	fi
	mbfl_program_exec "$mbfl_PROGRAM_RM" $FLAGS "$@"
    else
	mbfl_message_error_printf 'program "rm" not executable, tested pathname is: "%s"' "$mbfl_PROGRAM_RM"
	return_because_program_not_found
    fi
}
function mbfl_file_remove () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    local FLAGS='--force --recursive'
    if ! mbfl_option_test
    then
        if ! mbfl_file_exists "$PATHNAME"
	then
            mbfl_message_error_printf 'pathname does not exist: "%s"' "$PATHNAME"
            return_because_failure
	fi
    fi
    mbfl_exec_rm $FLAGS -- "$PATHNAME"
}
function mbfl_file_remove_file () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    local FLAGS='--force'
    if ! mbfl_option_test
    then
        if ! mbfl_file_is_file "$PATHNAME"
	then
            mbfl_message_error_printf 'pathname is not a file: "%s"' "$PATHNAME"
            return_because_failure
        fi
    fi
    mbfl_exec_rm $FLAGS -- "$PATHNAME"
}
function mbfl_file_remove_symlink () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    local FLAGS='--force'
    if ! mbfl_option_test
    then
        if ! mbfl_file_is_symlink "$PATHNAME"
	then
            mbfl_message_error_printf 'pathname is not a symbolic link: "%s"' "$PATHNAME"
            return_because_failure
        fi
    fi
    mbfl_exec_rm $FLAGS -- "$PATHNAME"
}
function mbfl_file_remove_file_or_symlink () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    local FLAGS='--force'
    if ! mbfl_option_test
    then
	if      ! mbfl_file_is_file    "$PATHNAME" ||
		! mbfl_file_is_symlink "$PATHNAME"
	then
            mbfl_message_error_printf 'pathname is neither a file nor a symbolic link: "%s"' "$PATHNAME"
            return_because_failure
        fi
    fi
    mbfl_exec_rm $FLAGS -- "$PATHNAME"
}

### ------------------------------------------------------------------------

# This is the executor for the "rmdir" program.
#
function mbfl_exec_rmdir () {
    if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_RMDIR"
    then
	local FLAGS
	if mbfl_option_verbose_program
	then FLAGS+=' --verbose'
	fi
	mbfl_program_exec "$mbfl_PROGRAM_RMDIR" $FLAGS "$@"
    else
	mbfl_message_error_printf 'program "rmdir" not executable, tested pathname is: "%s"' "$mbfl_PROGRAM_RMDIR"
	return_because_program_not_found
    fi
}

function mbfl_file_remove_directory () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    mbfl_optional_parameter(REMOVE_SILENTLY, 2, no)
    if mbfl_file_is_directory "$PATHNAME"
    then
	local FLAGS
	if mbfl_string_equal "$REMOVE_SILENTLY" 'yes'
	then FLAGS+=' --ignore-fail-on-non-empty'
	fi
	mbfl_exec_rmdir $FLAGS -- "$PATHNAME"
    else
        mbfl_message_error "pathname is not a directory '${PATHNAME}'"
        return_because_failure
    fi
}

function mbfl_file_remove_directory_silently () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    mbfl_file_remove_directory "$PATHNAME" yes
}

#page
#### file copy functions

function mbfl_file_enable_copy () {
    : mbfl_declare_program cp
}

function mbfl_exec_cp () {
    if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_CP"
    then
	local FLAGS
	if mbfl_option_verbose_program
	then FLAGS+=' --verbose'
	fi
	mbfl_program_exec "$mbfl_PROGRAM_CP" $FLAGS "$@"
    else
	mbfl_message_error_printf 'program "cp" not executable, tested pathname is: "%s"' "$mbfl_PROGRAM_CP"
	return_because_program_not_found
    fi
}

# This is the executor for the  "rm" program when copying to a directory
# target.
#
function mbfl_exec_cp_to_dir () {
    mbfl_mandatory_parameter(SOURCE,           1, source pathname)
    mbfl_mandatory_parameter(TARGET_DIRECTORY, 2, target directory pathname)
    shift 2
    if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_CP"
    then
	local FLAGS
	if mbfl_option_verbose_program
	then FLAGS+=' --verbose'
	fi
	mbfl_program_exec "$mbfl_PROGRAM_CP" $FLAGS "$@" --target-directory="${TARGET_DIRECTORY}/" -- "$SOURCE"
    else
	mbfl_message_error_printf 'program "cp" not executable, tested pathname is: "%s"' "$mbfl_PROGRAM_CP"
	return_because_program_not_found
    fi
}

function mbfl_file_copy () {
    mbfl_mandatory_parameter(SOURCE, 1, source pathname)
    mbfl_mandatory_parameter(TARGET, 2, target pathname)
    shift 2
    if ! mbfl_option_test
    then
	if ! mbfl_file_is_readable "$SOURCE"
	then
            mbfl_message_error_printf 'copying file "%s"' "$SOURCE"
            return_because_failure
	fi
    fi
    if mbfl_file_exists "$TARGET"
    then
        if mbfl_file_is_directory "$TARGET"
        then mbfl_message_error_printf 'target of copy exists and it is a directory "%s"' "$TARGET"
        else mbfl_message_error_printf 'target file of copy already exists "%s"' "$TARGET"
        fi
        return_because_failure
    else mbfl_exec_cp "$@" -- "$SOURCE" "$TARGET"
    fi
}
function mbfl_file_copy_to_directory () {
    mbfl_mandatory_parameter(SOURCE,           1, source pathname)
    mbfl_mandatory_parameter(TARGET_DIRECTORY, 2, target directory pathname)
    shift 2
    if ! mbfl_option_test
    then
        if      ! mbfl_file_is_readable  "$SOURCE"           print_error || \
		! mbfl_file_exists       "$TARGET_DIRECTORY" print_error || \
		! mbfl_file_is_directory "$TARGET_DIRECTORY" print_error
	then
            mbfl_message_error_printf 'copying file "%s"' "$SOURCE"
            return_because_failure
	fi
    fi
    mbfl_exec_cp "$@" --target-directory="${TARGET_DIRECTORY}/" -- "$SOURCE"
}

#page
#### file move functions

function mbfl_file_enable_move () {
    : mbfl_declare_program mv
}
function mbfl_exec_mv () {
    if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_MV"
    then
	local FLAGS
	if mbfl_option_verbose_program
	then FLAGS+=' --verbose'
	fi
	mbfl_program_exec "$mbfl_PROGRAM_MV" $FLAGS "$@"
    else
	mbfl_message_error_printf 'program "mv" not executable, tested pathname is: "%s"' "$mbfl_PROGRAM_MV"
	return_because_program_not_found
    fi
}
function mbfl_file_move () {
    mbfl_mandatory_parameter(SOURCE, 1, source pathname)
    mbfl_mandatory_parameter(TARGET, 2, target pathname)
    shift 2
    if ! mbfl_option_test
    then
        if ! mbfl_file_pathname_is_readable "$SOURCE" print_error
	then
            mbfl_message_error_printf 'moving "%s"' "$SOURCE"
            return_because_failure
        fi
    fi
    mbfl_exec_mv "$@" -- "$SOURCE" "$TARGET"
}
function mbfl_file_move_to_directory () {
    mbfl_mandatory_parameter(SOURCE,           1, source pathname)
    mbfl_mandatory_parameter(TARGET_DIRECTORY, 2, target directory pathname)
    shift 2
    if ! mbfl_option_test
    then
        if      ! mbfl_file_pathname_is_readable "$SOURCE"           print_error || \
		! mbfl_file_exists               "$TARGET_DIRECTORY" print_error || \
		! mbfl_file_is_directory         "$TARGET_DIRECTORY" print_error
        then
            mbfl_message_error_printf 'moving file "%s"' "$SOURCE"
            return_because_failure
        fi
    fi
    mbfl_exec_mv "$@" --target-directory="${TARGET_DIRECTORY}/" -- "$SOURCE"
}

#page
#### directory creation functions

function mbfl_file_enable_make_directory () {
    : mbfl_declare_program mkdir
}
function mbfl_exec_mkdir () {
    if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_MKDIR"
    then
	local FLAGS
	if mbfl_option_verbose_program
	then FLAGS+=' --verbose'
	fi
	mbfl_program_exec "$mbfl_PROGRAM_MKDIR" $FLAGS "$@"
    else
	mbfl_message_error_printf 'program "mkdir" not executable, tested pathname is: "%s"' "$mbfl_PROGRAM_MKDIR"
	return_because_program_not_found
    fi
}
function mbfl_file_make_directory () {
    mbfl_mandatory_parameter(PATHNAME,   1, pathname)
    mbfl_optional_parameter(PERMISSIONS, 2)
    if mbfl_string_is_empty "$PERMISSIONS"
    then
	shift
	PERMISSIONS=0775
    else shift 2
    fi
    local FLAGS="--parents --mode=${PERMISSIONS}"
    mbfl_exec_mkdir $FLAGS "$@" -- "$PATHNAME"
}
function mbfl_file_make_if_not_directory () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    mbfl_optional_parameter(PERMISSIONS, 2)
    if mbfl_string_is_empty "$PERMISSIONS"
    then
	shift
	PERMISSIONS=0775
    else shift 2
    fi
    # Make sure the directory exists.  If it already exists: clean up the sudo request!
    if mbfl_file_is_directory "$PATHNAME"
    then mbfl_file_make_directory "$PATHNAME" "$PERMISSIONS" "$@"
    else mbfl_program_reset_sudo_user
    fi
}

#page
#### symbolic link functions

function mbfl_file_enable_symlink () {
    : mbfl_declare_program ln
}
function mbfl_exec_ln () {
    if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_LN"
    then
	local FLAGS
	if mbfl_option_verbose_program
	then FLAGS+=' --verbose'
	fi
	mbfl_program_exec "$mbfl_PROGRAM_LN" $FLAGS "$@"
    else
	mbfl_message_error_printf 'program "ln" not executable, tested pathname is: "%s"' "$mbfl_PROGRAM_LN"
	return_because_program_not_found
    fi
}
function mbfl_file_link () {
    mbfl_mandatory_parameter(ORIGINAL_NAME, 1, original name)
    mbfl_mandatory_parameter(LINK_NAME,     2, link name)
    shift 2
    mbfl_exec_ln "$@" -- "$ORIGINAL_NAME" "$LINK_NAME"
}
function mbfl_file_symlink () {
    mbfl_mandatory_parameter(ORIGINAL_NAME, 1, original name)
    mbfl_mandatory_parameter(SYMLINK_NAME,  2, symbolic link name)
    shift 2
    mbfl_exec_ln --symbolic "$@" -- "$ORIGINAL_NAME" "$SYMLINK_NAME"
}

#page
#### file listing functions

function mbfl_file_enable_listing () {
    : mbfl_declare_program ls
    : mbfl_declare_program readlink
}

function mbfl_exec_ls () {
    if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_LS"
    then mbfl_program_exec "$mbfl_PROGRAM_LS" "$@"
    else
	mbfl_message_error_printf 'program not "ls" executable, tested pathname is: "%s"' "$mbfl_PROGRAM_LS"
	return_because_program_not_found
    fi
}
function mbfl_file_listing () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    shift
    mbfl_exec_ls "$@" -- "$PATHNAME"
}
function mbfl_file_long_listing () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    shift
    mbfl_file_listing "$PATHNAME" '-l' "$@"
}

### --------------------------------------------------------------------

function mbfl_exec_readlink () {
    if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_READLINK"
    then
	local FLAGS
	if mbfl_option_verbose_program
	then FLAGS+=' --verbose'
	fi
	mbfl_program_exec "$mbfl_PROGRAM_READLINK" $FLAGS "$@"
    else
	mbfl_message_error_printf 'program not "readlink" executable, tested pathname is: "%s"' "$mbfl_PROGRAM_READLINK"
	return_because_program_not_found
    fi
}

function mbfl_file_read_link () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    shift
    mbfl_exec_readlink "$@" -- "$PATHNAME"
}
function mbfl_file_readlink () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    shift
    mbfl_exec_readlink "$@" -- "$PATHNAME"
}

function mbfl_file_normalise_link () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    mbfl_exec_readlink --canonicalize --no-newline -- "$PATHNAME"
}

#page
#### file permissions inspection functions

function mbfl_file_pathname_p_is () {
    mbfl_mandatory_parameter(PRINT_ERROR, 1, print error argument)
    mbfl_mandatory_parameter(TEST_FLAG,   2, test flag)
    mbfl_mandatory_parameter(DESCRIPTION, 3, test condition description)
    mbfl_optional_parameter(PATHNAME,     4)

    if mbfl_string_is_not_empty "$PATHNAME"
    then
	if test $TEST_FLAG "$PATHNAME"
	then return_success
	else
	    if mbfl_string_equal 'print_error' "$PRINT_ERROR"
	    then mbfl_message_error_printf 'the pathname is not %s: "%s"' "$DESCRIPTION" "$PATHNAME"
	    fi
	    return_failure
	fi
    else
	if mbfl_string_equal 'print_error' "$PRINT_ERROR"
	then mbfl_message_error_printf 'invalid empty pathname argument'
	fi
	return_failure
    fi
}

# ------------------------------------------------------------

function mbfl_file_exists () {
    mbfl_optional_parameter(PATHNAME, 1)
    test -n "$PATHNAME" -a -e "$PATHNAME"
}
function mbfl_file_pathname_is_readable () {
    mbfl_optional_parameter(PATHNAME, 1)
    mbfl_optional_parameter(PRINT_ERROR, 2, no)
    mbfl_file_pathname_p_is "$PRINT_ERROR" '-r' 'readable' "$PATHNAME"
}
function mbfl_file_pathname_is_writable () {
    mbfl_optional_parameter(PATHNAME, 1)
    mbfl_optional_parameter(PRINT_ERROR, 2, no)
    mbfl_file_pathname_p_is "$PRINT_ERROR" '-w' 'writable' "$PATHNAME"
}
function mbfl_file_pathname_is_executable () {
    mbfl_optional_parameter(PATHNAME, 1)
    mbfl_optional_parameter(PRINT_ERROR, 2, no)
    mbfl_file_pathname_p_is "$PRINT_ERROR" '-x' 'executable' "$PATHNAME"
}

# ------------------------------------------------------------

function mbfl_file_is_file () {
    mbfl_optional_parameter(PATHNAME, 1)
    mbfl_optional_parameter(PRINT_ERROR, 2, no)
    mbfl_file_pathname_p_is "$PRINT_ERROR" '-f' 'a file' "$PATHNAME"
}
function mbfl_file_is_readable () {
    mbfl_optional_parameter(PATHNAME, 1)
    mbfl_optional_parameter(PRINT_ERROR, 2, no)
    mbfl_file_is_file "$PATHNAME" "$PRINT_ERROR" && \
        mbfl_file_pathname_is_readable "$PATHNAME" "$PRINT_ERROR"
}
function mbfl_file_is_writable () {
    mbfl_optional_parameter(PATHNAME, 1)
    mbfl_optional_parameter(PRINT_ERROR, 2, no)
    mbfl_file_is_file "$PATHNAME" "$PRINT_ERROR" && \
        mbfl_file_pathname_is_writable "$PATHNAME" "$PRINT_ERROR"
}
function mbfl_file_is_executable () {
    mbfl_optional_parameter(PATHNAME, 1)
    mbfl_optional_parameter(PRINT_ERROR, 2, no)
    mbfl_file_is_file "$PATHNAME" "$PRINT_ERROR" && \
        mbfl_file_pathname_is_executable "$PATHNAME" "$PRINT_ERROR"
}

# ------------------------------------------------------------

function mbfl_file_is_directory () {
    mbfl_optional_parameter(PATHNAME, 1)
    mbfl_optional_parameter(PRINT_ERROR, 2, no)
    mbfl_file_pathname_p_is "$PRINT_ERROR" '-d' 'a directory' "$PATHNAME"
}
function mbfl_file_directory_is_readable () {
    mbfl_optional_parameter(PATHNAME, 1)
    mbfl_optional_parameter(PRINT_ERROR, 2, no)
    mbfl_file_is_directory "$PATHNAME" "$PRINT_ERROR" && \
        mbfl_file_pathname_is_readable "$PATHNAME" "$PRINT_ERROR"
}
function mbfl_file_directory_is_writable () {
    mbfl_optional_parameter(PATHNAME, 1)
    mbfl_optional_parameter(PRINT_ERROR, 2, no)
    mbfl_file_is_directory "$PATHNAME" "$PRINT_ERROR" && \
        mbfl_file_pathname_is_writable "$PATHNAME" "$PRINT_ERROR"
}
function mbfl_file_directory_is_executable () {
    mbfl_optional_parameter(PATHNAME, 1)
    mbfl_optional_parameter(PRINT_ERROR, 2, no)
    mbfl_file_is_directory "$PATHNAME" "$PRINT_ERROR" && \
        mbfl_file_pathname_is_executable "$PATHNAME" "$PRINT_ERROR"
}
function mbfl_file_directory_validate_writability () {
    mbfl_mandatory_parameter(DIRECTORY, 1, directory pathname)
    mbfl_mandatory_parameter(DESCRIPTION, 2, directory description)
    mbfl_message_verbose "validating ${DESCRIPTION} directory '${DIRECTORY}'\n"
    mbfl_file_is_directory "$DIRECTORY" print_error && mbfl_file_directory_is_writable "$DIRECTORY" print_error
    local -i CODE=$?
    if ((0 != CODE))
    then mbfl_message_error_printf 'unwritable %s directory: "%s"' "$DESCRIPTION" "$DIRECTORY"
    fi
    return $CODE
}

# ------------------------------------------------------------

function mbfl_file_is_symlink () {
    mbfl_optional_parameter(PATHNAME, 1)
    mbfl_optional_parameter(PRINT_ERROR, 2, no)
    mbfl_file_pathname_p_is "$PRINT_ERROR" '-L' 'readable' "$PATHNAME"
}

#page
#### "tar" interface

function mbfl_file_enable_tar () {
    mbfl_declare_program tar
}
function mbfl_exec_tar () {
    mbfl_local_varref(TAR)
    local FLAGS
    mbfl_program_found_var mbfl_datavar(TAR) tar || exit_because_program_not_found
    mbfl_option_verbose_program && FLAGS+=' --verbose'
    mbfl_program_exec "$TAR" ${FLAGS} "$@"
}
function mbfl_tar_exec () {
    mbfl_exec_tar "$@"
}

function mbfl_tar_create_to_stdout () {
    mbfl_mandatory_parameter(DIRECTORY, 1, directory name)
    shift
    mbfl_exec_tar --directory="$DIRECTORY" --create --file=- "$@" .
}
function mbfl_tar_extract_from_stdin () {
    mbfl_mandatory_parameter(DIRECTORY, 1, directory name)
    shift
    mbfl_exec_tar --directory="$DIRECTORY" --extract --file=- "$@"
}
function mbfl_tar_extract_from_file () {
    mbfl_mandatory_parameter(DIRECTORY, 1, directory name)
    mbfl_mandatory_parameter(ARCHIVE_FILENAME, 2, archive pathname)
    shift 2
    mbfl_exec_tar --directory="$DIRECTORY" --extract --file="$ARCHIVE_FILENAME" "$@"
}
function mbfl_tar_create_to_file () {
    mbfl_mandatory_parameter(DIRECTORY, 1, directory name)
    mbfl_mandatory_parameter(ARCHIVE_FILENAME, 2, archive pathname)
    shift 2
    mbfl_exec_tar --directory="$DIRECTORY" --create --file="$ARCHIVE_FILENAME" "$@" .
}
function mbfl_tar_archive_directory_to_file () {
    mbfl_mandatory_parameter(DIRECTORY, 1, directory name)
    mbfl_mandatory_parameter(ARCHIVE_FILENAME, 2, archive pathname)
    shift 2
    local PARENT DIRNAME
    mbfl_file_dirname_var PARENT "$DIRECTORY"
    mbfl_file_tail_var DIRNAME "$DIRECTORY"
    mbfl_exec_tar --directory="$PARENT" --create --file="$ARCHIVE_FILENAME" "$@" "$DIRNAME"
}
function mbfl_tar_list () {
    mbfl_mandatory_parameter(ARCHIVE_FILENAME, 1, archive pathname)
    shift
    mbfl_exec_tar --list --file="$ARCHIVE_FILENAME" "$@"
}

#page
#### file permissions functions

function mbfl_file_enable_permissions () {
    mbfl_file_enable_stat
    : mbfl_declare_program chmod
}
function mbfl_exec_chmod () {
    if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_CHMOD"
    then
	local FLAGS
	if mbfl_option_verbose_program
	then FLAGS+=' --changes'
	fi
	mbfl_program_exec "$mbfl_PROGRAM_CHMOD" $FLAGS "$@"
    else
	mbfl_message_error_printf 'program not "chmod" executable, tested pathname is: "%s"' "$mbfl_PROGRAM_CHMOD"
	return_because_program_not_found
    fi
}
function mbfl_file_chmod () {
    mbfl_mandatory_parameter(PERMISSIONS, 1, permissions)
    mbfl_mandatory_parameter(PATHNAME, 2, pathname)
    shift 2
    mbfl_exec_chmod "$PERMISSIONS" "$@" -- "$PATHNAME"
}

function mbfl_file_get_permissions () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    mbfl_file_stat "$PATHNAME" --printf='0%a\n'
}
function mbfl_file_set_permissions () {
    mbfl_mandatory_parameter(PERMISSIONS, 1, permissions)
    mbfl_mandatory_parameter(PATHNAME, 2, pathname)
    mbfl_file_chmod "$PERMISSIONS" "$PATHNAME"
}

function mbfl_file_get_permissions_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable)
    mbfl_mandatory_parameter(mbfl_PATHNAME, 2, pathname)
    mbfl_RESULT_VARREF=$(mbfl_file_stat "$mbfl_PATHNAME" --format='0%a')
}

#page
#### file permissions conversions

declare -a mbfl_SYMBOLIC_PERMISSIONS
mbfl_SYMBOLIC_PERMISSIONS[0]='---'
mbfl_SYMBOLIC_PERMISSIONS[1]='--x'
mbfl_SYMBOLIC_PERMISSIONS[2]='-w-'
mbfl_SYMBOLIC_PERMISSIONS[3]='-wx'
mbfl_SYMBOLIC_PERMISSIONS[4]='r--'
mbfl_SYMBOLIC_PERMISSIONS[5]='r-x'
mbfl_SYMBOLIC_PERMISSIONS[6]='rw-'
mbfl_SYMBOLIC_PERMISSIONS[7]='rwx'

function mbfl_file_symbolic_to_octal_permissions () {
    mbfl_mandatory_parameter(MODE, 1, symbolic permissions)
    local -i i
    for ((i=0; i < mbfl_slots_number(mbfl_SYMBOLIC_PERMISSIONS); ++i))
    do
	if mbfl_string_equal mbfl_slot_ref(mbfl_SYMBOLIC_PERMISSIONS, $i) "$MODE"
	then
            printf "%s\n" $i
            return_success
        fi
    done
    return_failure
}

function mbfl_file_octal_to_symbolic_permissions () {
    mbfl_mandatory_parameter(MODE, 1, symbolic permissions)
    printf '%s\n' mbfl_slot_ref(mbfl_SYMBOLIC_PERMISSIONS, $MODE)
}

### ------------------------------------------------------------------------

function mbfl_system_symbolic_to_octal_permissions () {
    mbfl_file_symbolic_to_octal_permissions "$@"
}
function mbfl_system_octal_to_symbolic_permissions () {
    mbfl_file_octal_to_symbolic_permissions "$@"
}

#page
#### file owner and group functions

function mbfl_file_enable_owner_and_group () {
    mbfl_file_enable_stat
    : mbfl_declare_program chown
    : mbfl_declare_program chgrp
}
function mbfl_exec_chown () {
    if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_CHOWN"
    then
	local FLAGS
	if mbfl_option_verbose_program
	then FLAGS+=' --verbose'
	fi
	mbfl_program_exec "$mbfl_PROGRAM_CHOWN" $FLAGS "$@"
    else
	mbfl_message_error_printf 'program not "chown" executable, tested pathname is: "%s"' "$mbfl_PROGRAM_CHOWN"
	return_because_program_not_found
    fi
}
function mbfl_exec_chgrp () {
    if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_CHGRP"
    then
	local FLAGS
	if mbfl_option_verbose_program
	then FLAGS+=' --verbose'
	fi
	mbfl_program_exec "$mbfl_PROGRAM_CHGRP" $FLAGS "$@"
    else
	mbfl_message_error_printf 'program not "chgrp" executable, tested pathname is: "%s"' "$mbfl_PROGRAM_CHGRP"
	return_because_program_not_found
    fi
}

function mbfl_file_set_owner () {
    mbfl_mandatory_parameter(OWNER, 1, owner)
    mbfl_mandatory_parameter(PATHNAME, 2, pathname)
    shift 2
    mbfl_exec_chown "$@" "$OWNER" -- "$PATHNAME"
}
function mbfl_file_set_group () {
    mbfl_mandatory_parameter(GROUP, 1, group)
    mbfl_mandatory_parameter(PATHNAME, 2, pathname)
    shift 2
    mbfl_exec_chgrp "$@" "$GROUP" -- "$PATHNAME"
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
mbfl_p_file_compress_KEEP_ORIGINAL=false
mbfl_p_file_compress_TO_STDOUT=false

function mbfl_file_enable_compress () {
    mbfl_declare_program gzip
    mbfl_declare_program bzip2
    mbfl_declare_program lzip
    mbfl_declare_program xz
    mbfl_file_compress_select_gzip
    mbfl_file_compress_nokeep
}

function mbfl_file_compress_keep     () { mbfl_p_file_compress_KEEP_ORIGINAL=true;  }
function mbfl_file_compress_nokeep   () { mbfl_p_file_compress_KEEP_ORIGINAL=false; }
function mbfl_file_compress_stdout   () { mbfl_p_file_compress_TO_STDOUT=true;      }
function mbfl_file_compress_nostdout () { mbfl_p_file_compress_TO_STDOUT=false;     }

function mbfl_file_compress_select_gzip () {
    mbfl_p_file_compress_FUNCTION=mbfl_p_file_compress_gzip
}
function mbfl_file_compress_select_bzip2 () {
    mbfl_p_file_compress_FUNCTION=mbfl_p_file_compress_bzip2
}
function mbfl_file_compress_select_bzip () {
    mbfl_file_compress_select_bzip2
}
function mbfl_file_compress_select_lzip () {
    mbfl_p_file_compress_FUNCTION=mbfl_p_file_compress_lzip
}
function mbfl_file_compress_select_xz () {
    mbfl_p_file_compress_FUNCTION=mbfl_p_file_compress_xz
}

function mbfl_file_compress () {
    mbfl_mandatory_parameter(FILE, 1, uncompressed source file)
    shift
    mbfl_p_file_compress compress "$FILE" "$@"
}

function mbfl_file_decompress () {
    mbfl_mandatory_parameter(FILE, 1, compressed source file)
    shift
    mbfl_p_file_compress decompress "$FILE" "$@"
}

function mbfl_p_file_compress () {
    mbfl_mandatory_parameter(MODE, 1, compression/decompression mode)
    mbfl_mandatory_parameter(FILE, 2, target file)
    shift 2
    if mbfl_file_is_file "$FILE"
    then ${mbfl_p_file_compress_FUNCTION} ${MODE} "$FILE" "$@"
    else
        mbfl_message_error_printf 'compression target is not a file "%s"' "$FILE"
        return_because_failure
    fi
}

#page
#### compression action functions: gzip

function mbfl_p_file_compress_gzip () {
    mbfl_mandatory_parameter(COMPRESS, 1, compress/decompress mode)
    mbfl_mandatory_parameter(SOURCE, 2, source file)
    shift 2
    mbfl_local_varref(COMPRESSOR)
    local FLAGS='--force' DEST

    mbfl_program_found_var mbfl_datavar(COMPRESSOR) gzip || exit_because_program_not_found
    case $COMPRESS in
        compress)
            printf -v DEST '%s.gz' "$SOURCE"
            ;;
        decompress)
            mbfl_file_rootname_var DEST "$SOURCE"
            FLAGS+=' --decompress'
            ;;
        *)
            mbfl_message_error_printf 'internal error: wrong mode "%s" in "%s"' "$COMPRESS" "$FUNCNAME"
            exit_failure
            ;;
    esac

    if mbfl_option_verbose_program
    then FLAGS+=' --verbose'
    fi

    if $mbfl_p_file_compress_TO_STDOUT
    then
	# When   writing   to   stdout:  we   ignore   the   keep/nokeep
	# configuration and always keep.
        FLAGS+=' --keep --stdout'
        mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE" >"$DEST"
    else
	# The   output  goes   to   a  file:   honour  the   keep/nokeep
	# configuration.
	if $mbfl_p_file_compress_KEEP_ORIGINAL
	then FLAGS+=' --keep'
	fi
	mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE"
    fi
}

#page
#### compression action functions: bzip2

function mbfl_p_file_compress_bzip2 () {
    mbfl_mandatory_parameter(COMPRESS, 1, compress/decompress mode)
    mbfl_mandatory_parameter(SOURCE, 2, target file)
    shift 2
    mbfl_local_varref(COMPRESSOR)
    local FLAGS='--force' DEST

    mbfl_program_found_var mbfl_datavar(COMPRESSOR) bzip2 || exit_because_program_not_found
    case $COMPRESS in
        compress)
            printf -v DEST '%s.bz2' "$SOURCE"
            FLAGS+=' --compress'
            ;;
        decompress)
            mbfl_file_rootname_var DEST "$SOURCE"
            FLAGS+=' --decompress'
            ;;
        *)
            mbfl_message_error_printf 'internal error: wrong mode "%s" in "%s"' "$COMPRESS" "$FUNCNAME"
            exit_failure
            ;;
    esac

    if mbfl_option_verbose_program
    then FLAGS+=' --verbose'
    fi

    if $mbfl_p_file_compress_TO_STDOUT
    then
	# When   writing   to   stdout:  we   ignore   the   keep/nokeep
	# configuration and always keep.
	FLAGS+=' --keep --stdout'
	mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE" >"$DEST"
    else
	# The   output  goes   to   a  file:   honour  the   keep/nokeep
	# configuration.
	if $mbfl_p_file_compress_KEEP_ORIGINAL
	then FLAGS+=' --keep'
	fi
	mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE"
    fi
}

#page
#### compression action functions: lzip

function mbfl_p_file_compress_lzip () {
    mbfl_mandatory_parameter(COMPRESS, 1, compress/decompress mode)
    mbfl_mandatory_parameter(SOURCE, 2, source file)
    shift 2
    mbfl_local_varref(COMPRESSOR)
    local FLAGS='--force' DEST

    mbfl_program_found_var mbfl_datavar(COMPRESSOR) lzip || exit_because_program_not_found
    case $COMPRESS in
        compress)
            printf -v DEST '%s.lz' "$SOURCE"
            ;;
        decompress)
            mbfl_file_rootname_var DEST "$SOURCE"
            FLAGS+=' --decompress'
            ;;
        *)
            mbfl_message_error_printf 'internal error: wrong mode "%s" in "%s"' "$COMPRESS" "$FUNCNAME"
            exit_failure
            ;;
    esac

    if mbfl_option_verbose_program
    then FLAGS+=' --verbose'
    fi

    if $mbfl_p_file_compress_TO_STDOUT
    then
	# When   writing   to   stdout:  we   ignore   the   keep/nokeep
	# configuration and always keep.
        FLAGS+=' --keep --stdout'
        mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE" >"$DEST"
    else
	# The   output  goes   to   a  file:   honour  the   keep/nokeep
	# configuration.
	if $mbfl_p_file_compress_KEEP_ORIGINAL
	then FLAGS+=' --keep'
	fi
	mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE"
    fi
}

#page
#### compression action functions: xz

function mbfl_p_file_compress_xz () {
    mbfl_mandatory_parameter(COMPRESS, 1, compress/decompress mode)
    mbfl_mandatory_parameter(SOURCE, 2, source file)
    shift 2
    mbfl_local_varref(COMPRESSOR)
    local FLAGS='--force' DEST

    mbfl_program_found_var mbfl_datavar(COMPRESSOR) xz || exit_because_program_not_found
    case $COMPRESS in
        compress)
            printf -v DEST '%s.xz' "$SOURCE"
            ;;
        decompress)
            mbfl_file_rootname_var DEST "$SOURCE"
            FLAGS+=' --decompress'
            ;;
        *)
            mbfl_message_error_printf 'internal error: wrong mode "%s" in "%s"' "$COMPRESS" "$FUNCNAME"
            exit_failure
            ;;
    esac

    if mbfl_option_verbose_program
    then FLAGS+=' --verbose'
    fi

    if $mbfl_p_file_compress_TO_STDOUT
    then
	# When   writing   to   stdout:  we   ignore   the   keep/nokeep
	# configuration and always keep.
        FLAGS+=' --keep --stdout'
        mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE" >"$DEST"
    else
	# The   output  goes   to   a  file:   honour  the   keep/nokeep
	# configuration.
	if $mbfl_p_file_compress_KEEP_ORIGINAL
	then FLAGS+=' --keep'
	fi
	mbfl_program_exec "$COMPRESSOR" ${FLAGS} "$@" "$SOURCE"
    fi
}

#page
#### interface to "stat"

function mbfl_file_enable_stat () {
    : mbfl_declare_program stat
}
function mbfl_exec_stat () {
    if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_STAT"
    then mbfl_program_exec "$mbfl_PROGRAM_STAT" "$@"
    else
	mbfl_message_error_printf 'program not "stat" executable, tested pathname is: "%s"' "$mbfl_PROGRAM_STAT"
	return_because_program_not_found
    fi

}
function mbfl_file_stat () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    shift
    mbfl_exec_stat "$@" -- "$PATHNAME"
}
function mbfl_file_stat_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable)
    mbfl_mandatory_parameter(mbfl_PATHNAME,              2, pathname)
    shift 2
    mbfl_RESULT_VARREF=$(mbfl_file_stat "$mbfl_PATHNAME" "$@")
}

### --------------------------------------------------------------------

function mbfl_file_get_owner () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    mbfl_file_stat "$PATHNAME" --format='%U'
}
function mbfl_file_get_group () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    mbfl_file_stat "$PATHNAME" --format='%G'
}
function mbfl_file_get_size () {
    mbfl_mandatory_parameter(PATHNAME, 1, pathname)
    mbfl_file_stat "$PATHNAME" --format='%s'
}

### --------------------------------------------------------------------

function mbfl_file_get_owner_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable)
    mbfl_mandatory_parameter(mbfl_PATHNAME, 2, pathname)
    mbfl_RESULT_VARREF=$(mbfl_file_stat "$mbfl_PATHNAME" --printf='%U')
}
function mbfl_file_get_group_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable)
    mbfl_mandatory_parameter(mbfl_PATHNAME, 2, pathname)
    mbfl_RESULT_VARREF=$(mbfl_file_stat "$mbfl_PATHNAME" --printf='%G')
}
function mbfl_file_get_size_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable)
    mbfl_mandatory_parameter(mbfl_PATHNAME, 2, pathname)
    mbfl_RESULT_VARREF=$(mbfl_file_stat "$mbfl_PATHNAME" --printf='%s')
}


### end of file
# Local Variables:
# mode: sh
# End:
