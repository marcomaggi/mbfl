# program.sh.m4 --
# 
# Part of: Marco's BASH Functions Library
# Contents: program functions
# Date: Thu May  1, 2003
# 
# Abstract
# 
#
# Copyright (c) 2003, 2004, 2005 Marco Maggi
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
## ------------------------------------------------------------
## Obsolete program finding functions.
## ------------------------------------------------------------

function mbfl_program_check () {
    local item= path=

    for item in "${@}"; do
        path=$(mbfl_program_find "${item}")
        if ! mbfl_file_is_executable "${path}" ; then
            mbfl_message_error "cannot find executable '${item}'"
            return 1
        fi
    done
    return 0
}
function mbfl_program_find () {
    mandatory_parameter(PROGRAM, 1, program)
    local program=

    for program in $(type -ap "${PROGRAM}"); do
        if mbfl_file_is_executable "${program}" ; then
            printf "${program}\n"
            return 0
        fi
    done
    return 0
}

#page
## ------------------------------------------------------------
## Program execution functions.
## ------------------------------------------------------------

declare mbfl_program_SUDO_USER='nosudo'
declare mbfl_program_BASH=${BASH}

function mbfl_program_enable_sudo () {
    mbfl_declare_program sudo
}
function mbfl_program_declare_sudo_user () {
    mandatory_parameter(PERSONA, 1, sudo user name)
    mbfl_program_SUDO_USER=${PERSONA}
}
function mbfl_program_reset_sudo_user () {
    mbfl_program_SUDO_USER='nosudo'
}
function mbfl_program_exec () {
    local PERSONA=${mbfl_program_SUDO_USER} USE_SUDO='no' SUDO
    mbfl_program_SUDO_USER='nosudo'

    if test "${PERSONA}" != 'nosudo' ; then
        SUDO=$(mbfl_program_found sudo)
        USE_SUDO=yes
    fi

    if mbfl_option_test || mbfl_option_show_program ; then
        if test "${USE_SUDO}" = 'yes' ; then
            echo "${SUDO}" -u "${PERSONA}" "${@}" >&2
        else
            echo "${@}" >&2
        fi
    fi
    if ! mbfl_option_test ; then
        if test "${USE_SUDO}" = 'yes' ; then
            "${SUDO}" -u "${PERSONA}" "${@}"
        else
            "${@}"
        fi
    fi
}
function mbfl_program_bash () {
    mandatory_parameter(COMMAND, 1, command)
    mbfl_program_exec "${mbfl_program_BASH}" -c "${COMMAND}"
}

#page
## ------------------------------------------------------------
## Program finding functions.
## ------------------------------------------------------------

if test "${mbfl_INTERACTIVE}" != 'yes'; then
    declare -a mbfl_program_NAMES mbfl_program_PATHS
fi
function mbfl_declare_program () {
    mandatory_parameter(PROGRAM, 1, program)
    local next_free_index=${#mbfl_program_NAMES[@]}

    mbfl_program_NAMES[${next_free_index}]="${PROGRAM}"
    mbfl_program_PATHS[${next_free_index}]=$(mbfl_program_find "${PROGRAM}")
    return 0
}
function mbfl_program_validate_declared () {
    local i= name= path= retval=0
    local number_of_programs=${#mbfl_program_NAMES[@]}

    for ((i=0; ${i} < ${number_of_programs}; ++i)); do
        name="${mbfl_program_NAMES[$i]}"
        path="${mbfl_program_PATHS[$i]}"

        if test -n "${path}" -a -x "${path}"; then
            mbfl_message_verbose "found '${name}': '${path}'\n"
        else
            mbfl_message_verbose "*** not found '${name}', path: '${path}'\n"
            retval=1
        fi
    done
    return $retval
}
function mbfl_program_found () {
    mandatory_parameter(PROGRAM, 1, program name)
    local number_of_programs=${#mbfl_program_NAMES[@]} i=

    if test "${PROGRAM}" != ':' ; then
        for ((i=0; $i < ${number_of_programs}; ++i)); do
            if test "${mbfl_program_NAMES[$i]}" = "${PROGRAM}" ; then
                echo "${mbfl_program_PATHS[$i]}"
                return 0
            fi
        done
    fi

    mbfl_message_error "executable not found '${PROGRAM}'"
    mbfl_exit_program_not_found
}

#page
## ------------------------------------------------------------
## Program validation functions.
## ------------------------------------------------------------

function mbfl_program_main_validate_programs () {
    mbfl_program_validate_declared || mbfl_exit_program_not_found
}

### end of file
# Local Variables:
# mode: sh
# End:
