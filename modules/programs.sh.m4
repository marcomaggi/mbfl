# programs.sh.m4 --
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

#PAGE
function mbfl_set_option_test ()   { function mbfl_option_test () { return 0; }; }
function mbfl_unset_option_test () { function mbfl_option_test () { return 1; }; }
mbfl_unset_option_test
function mbfl_exit_program_not_found () { exit 20; }
#page
function mbfl_program_check () {
    local item= path=


    for item in "${@}"; do
        path=`mbfl_program_find ${item}`
        test -x "${path}" || {
            mbfl_message_error "cannot find executable '${item}'"
            return 1
        }
    done
    return 0
}
function mbfl_program_exec () {
    mbfl_option_test && { echo "${@}" >&2; return 0; }
    eval "${@}"
}
function mbfl_program_find () {
    type -ap "${1:?${FUNCNAME} error: missing program name}"
}
#page
declare -a mbfl_program_NAMES mbfl_program_PATHS
declare -i mbfl_program_INDEX=0

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
            mbfl_message_verbose "found \"${item}\": \"${path}\""
        else
            retval=1
        fi
    done
    return $retval
}
function mbfl_program_found () {
    local PROGRAM="${1:?${FUNCNAME} error: missing program name}"
    local i=

    for ((i=0; $i < $mbfl_program_INDEX; ++i)); do
        test "${mbfl_program_NAMES[$i]}" = "${PROGRAM}" && {
            test "${mbfl_program_NAMES[$i]}" != : && {
                echo "${mbfl_program_PATHS[$i]}"
                return 0
            }
            break
        }
    done

    mbfl_message_error "executable not found \"${PROGRAM}\""
    mbfl_exit_program_not_found
}

### end of file
# Local Variables:
# mode: sh
# page-delimiter: "^#page$"
# indent-tabs-mode: nil
# End:
