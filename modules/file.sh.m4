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
# Copyright (c) 2003, 2004 Marco Maggi
# 
# This is free software; you  can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the
# Free Software  Foundation; either version  2.1 of the License,  or (at
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
# USA
# 

#PAGE
# mbfl_file_extension --
#
#       Extracts the extension from a file name.
#
#  Arguments:
#
#       $1 -    the file name
#
#  Results:
#
#       Searches the last dot character in the argument string and
#       echoes to stdout the range of characters from the dot to
#       the end, not including the dot.
#
#         If a slash character is found first, echoes to stdout
#       the empty string.
#
#  Side effects:
#
#       None.
#

function mbfl_file_extension () {
    local file="${1:?}"
    local i=
    local ch=

    for ((i="${#file}"; $i >= 0; --i)); do
        ch="${file:$i:1}"
        if test "$ch" = "/" ; then
            return
        elif test "$ch" = "." ; then
            i=$(($i + 1))
            echo "${file:$i}"
            return
        fi
    done
}
#PAGE
# mbfl_file_dirname --
#
#       Extracts the directory part from a fully qualified
#       file name.
#
#  Arguments:
#
#       $1 -    the fully qualified file name
#
#  Results:
#
#       Searches the last slash character in the input string
#       and echoes to stdout the range of characters from
#       the first to the slash, not including the slash.
#
#         If no slash is found: echoes a single dot (the
#       current directory).
#
#         If the input string has the form "/..." or "//..."
#       with no slash characters after the first ones, the
#       string echoed to stdout is a single slash.
#
#  Side effects:
#
#       None.
#

function mbfl_file_dirname () {
    local file="${1:?}"

    local i="${#file}"

    while test $i -ge 0
    do
        if test "${file:$i:1}" = "/"
        then
            while test \( $i -gt 0 \) -a \( "${file:$i:1}" = "/" \)
              do i=$(($i - 1))
            done
            if test $i = 0
                then echo "${file:$i:1}"
            else
                i=$(($i + 1))
                echo "${file:0:$i}"
            fi
            return 0
        fi
        i=$(($i - 1))
    done

    echo "."
    return 0
}

#PAGE
# mbfl_file_normalise --
#
#       Normalises a file name.
#
#  Arguments:
#
#       $1 -    The pathname to be normalised.
#       $2 -    Optional directory to which the name must be
#               normalised; defaults to the current working
#               directory.
#
#  Results:
#
#       If the input string is a relative name, the current
#       process working directory is prepended to it.
#
#         Echoes to stdout the normalised file name.
#

function mbfl_file_normalise () {
    local pathname="${1:?}"
    local prefix="${2}"

    if test -z "${prefix}"; then
        prefix="${PWD}"
    fi

    if test "${pathname:0:1}" = "/"; then
        echo "${pathname}"
    elif test -d "${prefix}"; then
        cd "${prefix}" >/dev/null
        if test -d "${pathname}"; then
            cd "${pathname}" >/dev/null
            echo "${PWD}"
            cd - >/dev/null
        else
            local tailname=$(mbfl_file_tail "${pathname}")
            local dirname=$(mbfl_file_dirname "${pathname}")

            if test -d "${dirname}"; then
                cd "${dirname}" >/dev/null
                echo "${PWD}/${tailname}"
                cd - >/dev/null
            else
                echo "${prefix}/${pathname}"
            fi
        fi
    else
        echo "${prefix}/${pathname}"
    fi

    return 0
}
#PAGE
# mbfl_file_rootname --
#
#       Extracts the root portion of a file name.
#
#  Arguments:
#
#       $1 -    the file name
#
#  Results:
#
#       Searches the last dot character in the argument string and
#       echoes to stdout the range of characters from the beginning
#       to the dot, not including the dot.
#
#         If a slash character is found first, or no dot is found,
#       or the dot is the first character, echoes to stdout the empty
#       string.
#
#  Side effects:
#
#       None.
#

function mbfl_file_rootname () {
    local file="${1:?}"

    local i="${#file}"

    if test $i = 1
    then
        echo "${file}"
        return 0
    fi

    while test $i -ge 0
    do
        ch="${file:$i:1}"
        if test "$ch" = "."
        then
            if test $i -gt 0
            then
                echo "${file:0:$i}"
                break
            else
                echo "${file}"
            fi
        elif test "$ch" = "/"
        then
            echo "${file}"
            break
        fi
        i=$(($i - 1))
    done
    return 0
}

#PAGE
# mbfl_file_split --
#
#       Separates a file name into its components.
#
#  Arguments:
#
#       $1 -    the file name
#
#  Results:
#
#       Replaces all the slash characters in the input string
#       with a newline and echoes the substrings.
#
#  Side effects:
#
#       The correct way to use the fields is:
#
#               mbfl_file_split "$file" | while read field
#               do
#                  ... $field ...
#               done
#

function mbfl_file_split () {
    local file="${1:?}"

    echo -e "${file//\//\\n}"
    return 0
}

#PAGE
# mbfl_file_tail --
#
#       Extracts the file portion from a fully qualified
#       file name.
#
#  Arguments:
#
#       $1 -    the file name
#
#  Results:
#
#       Searches the last slash character in the input string
#       and echoes to stdout the range of characters from
#       the slash to the end, not including the slash.
#
#         If no slash is found: echoes the whole string.
#
#  Side effects:
#
#       None.
#

function mbfl_file_tail () {
    local file="${1:?}"

    local i="${#file}"

    while test $i -ge 0
    do
        ch="${file:$i:1}"
        if test "$ch" = "/"
        then
            i=$(($i + 1))
            echo "${file:$i}"
            return 0
        fi
        i=$(($i - 1))
    done

    echo "${file}"
    return 0
}
#PAGE
# mbfl_file_find_tmpdir --
#
#       Finds a value for the directory of temporary files.
#
#  Arguments:
#
#       $1 -            value provided  by the script
#
#  Results:
#
#       Returns zero if a value is found, else returns 1. Echoes
#       to stdout the pathname.
#
#  Side effects:
#
#       None.
#

function mbfl_file_find_tmpdir () {
    local TMPDIR="${1}"


    if test -n "${TMPDIR}" -a -d "${TMPDIR}" -a -w "${TMPDIR}"
        then
        echo "${TMPDIR}"
        return 0
    fi

    if test -n "${USER}"
        then
        TMPDIR="/tmp/${USER}"
        if test -n "${TMPDIR}" -a -d "${TMPDIR}" -a -w "${TMPDIR}"
            then
            echo "${TMPDIR}"
            return 0
        fi
    fi

    TMPDIR=/tmp
    if test -n "${TMPDIR}" -a -d "${TMPDIR}" -a -w "${TMPDIR}"
        then
        echo "${TMPDIR}"
        return 0
    fi

    mbfl_message_error "cannot find usable value for TMPDIR"
    return 1
}
#page
function mbfl_file_enable_remove () {
    mbfl_declare_program rm
    mbfl_declare_program rmdir
}
function mbfl_file_remove () {
    local PATHNAME="${1:?missing pathname in ${FUNCNAME}}"
    local RM=`mbfl_program_found rm`
    local RM_FLAGS="--force --recursive"

    test -e "${PATHNAME}" || {
        mbfl_message_error "pathname does not exist '${PATHNAME}'"
        return 1
    }
    mbfl_option_verbose && RM_FLAGS="${RM_FLAGS} --verbose"
    mbfl_program_exec $RM $RM_FLAGS "${PATHNAME}" || return 1
}
function mbfl_file_remove_file () {
    local PATHNAME="${1:?missing pathname in ${FUNCNAME}}"
    local RM=`mbfl_program_found rm`
    local RM_FLAGS="--force"

    test -f "${PATHNAME}" || {
        mbfl_message_error "pathname is not a file '${PATHNAME}'"
        return 1
    }
    mbfl_option_verbose && RM_FLAGS="${RM_FLAGS} --verbose"
    mbfl_program_exec $RM $RM_FLAGS "${PATHNAME}" || return 1
}
function mbfl_file_remove_directory () {
    local PATHNAME="${1:?missing pathname in ${FUNCNAME}}"
    local REMOVE_SILENTLY="$2"
    local RMDIR_FLAGS=

    test -d "${PATHNAME}" || {
        mbfl_message_error "pathname is not a directory '${PATHNAME}'"
        return 1
    }

    test "${REMOVE_SILENTLY}" = "yes" && \
        RMDIR_FLAGS="${RMDIR_FLAGS} --ignore-fail-on-non-empty"
    mbfl_option_verbose && \
        RMDIR_FLAGS="${RMDIR_FLAGS} --verbose"

    local RMDIR=`mbfl_program_found rmdir`
    mbfl_program_exec $RMDIR $RMDIR_FLAGS "${PATHNAME}" || return 1
}
function mbfl_file_remove_directory_silently () {
    mbfl_file_remove_directory "$1" yes
}
#page
function mbfl_file_enable_make_directory () {
    mbfl_declare_program mkdir
}
function mbfl_file_make_directory () {
    local PATHNAME="${1:?missing pathname in ${FUNCNAME}}"
    local MKDIR=`mbfl_program_found mkdir`
    local MKDIR_FLAGS="--parents"

    test -d "${PATHNAME}" && return
    mbfl_option_verbose && RM_FLAGS="${MKDIR_FLAGS} --verbose"
    mbfl_program_exec $MKDIR $MKDIR_FLAGS "${PATHNAME}" || return 1    
}
#page
function mbfl_file_enable_listing () {
    mbfl_declare_program ls
}
function mbfl_file_get_owner () {
    local PATHNAME="${1:?missing pathname in ${FUNCNAME}}"
    local LS_FLAGS="-l"

    set -- `mbfl_file_p_invoke_ls || return 1`
    echo "$3"
}
function mbfl_file_get_group () {
    local PATHNAME="${1:?missing pathname in ${FUNCNAME}}"
    local LS_FLAGS="-l"
    
    set -- `mbfl_file_p_invoke_ls || return 1`
    echo "$4"
}
function mbfl_file_get_size () {
    local PATHNAME="${1:?missing pathname in ${FUNCNAME}}"
    local LS_FLAGS="--block-size=1 --size"
    set -- `mbfl_file_p_invoke_ls || return 1`
    echo "$1"
}
function mbfl_file_p_invoke_ls () {
    local LS=`mbfl_program_found ls`
    mbfl_program_exec $LS $LS_FLAGS "${PATHNAME}"
}

### end of file
# Local Variables:
# mode: sh
# page-delimiter: "^#page$"
# indent-tabs-mode: nil
# End:
