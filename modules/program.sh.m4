# program.sh.m4 --
# 
# Part of: Marco's BASH Functions Library
# Contents: program variables
# Date: Thu May  1, 2003
# 
# Abstract
# 
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

#page
function mbfl_program_check () {
    local item= path=


    for item in "${@}"; do
        path=`mbfl_program_find ${item}`
        if test ! -x "${path}" ; then
            mbfl_message_error "cannot find executable '${item}'"
            return 1
        fi
    done
    return 0
}
function mbfl_program_find () {
    local PROGRAM=${1:?"missing program parameter to ${FUNCNAME}"}
    local program=

    for program in `type -ap "${PROGRAM}"`; do
        if test -n "${program}" -a -x "${program}"; then
            echo "${program}"
            return 0
        fi
    done
    return 0
}
function mbfl_program_exec () {
    if mbfl_option_test || mbfl_option_show_program ; then
        echo "${@}" >&2
    fi
    if ! mbfl_option_test ; then
        "${@}"
    fi
}
#page
if test "${mbfl_INTERACTIVE}" != 'yes'; then
    declare -a mbfl_program_NAMES mbfl_program_PATHS
    declare -i mbfl_program_INDEX=0
fi
function mbfl_declare_program () {
    local PROGRAM="${1:?${FUNCNAME} error: missing program name}"
    local i=$mbfl_program_INDEX

    mbfl_program_NAMES[$i]="${PROGRAM}"
    mbfl_program_PATHS[$i]=`mbfl_program_find "${PROGRAM}"`
    mbfl_program_INDEX=$(($i + 1))
    return 0
}
function mbfl_program_validate_declared () {
    local i= item= path= retval=0


    for ((i=0; $i < $mbfl_program_INDEX; ++i)); do
        item="${mbfl_program_NAMES[$i]}"
        path="${mbfl_program_PATHS[$i]}"

        if mbfl_program_check "${item}"; then
            mbfl_message_verbose "found '${item}': '${path}'\n"
        else
            retval=1
        fi
    done
    return $retval
}
function mbfl_program_found () {
    local PROGRAM="${1:?${FUNCNAME} error: missing program name}"
    local i=

    if test "${PROGRAM}" != ':' ; then
        for ((i=0; $i < $mbfl_program_INDEX; ++i)); do
            if test "${mbfl_program_NAMES[$i]}" = "${PROGRAM}" ; then
                echo "${mbfl_program_PATHS[$i]}"
                return 0
            fi
        done
    fi

    mbfl_message_error "executable not found \"${PROGRAM}\""
    mbfl_exit_program_not_found
}

### end of file
# Local Variables:
# mode: sh
# End:
