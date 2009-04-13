# interface.sh.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: interfaces to external programs
# Date: Thu Aug 11, 2005
#
# Abstract
#
#
# Copyright (c) 2005, 2009 Marco Maggi <marcomaggi@gna.org>
#
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
## ------------------------------------------------------------
## 'atd' interface.
## ------------------------------------------------------------

mbfl_p_at_queue_letter='a'

function mbfl_at_enable () {
    mbfl_declare_program at
    mbfl_declare_program atq
    mbfl_declare_program atrm
    mbfl_declare_program sort
}
function mbfl_at_validate_queue_letter () {
    mandatory_parameter(QUEUE, 1, queue letter)
    test ${#QUEUE} -eq 1 && mbfl_string_is_alpha_char "${QUEUE}"
}
function mbfl_at_validate_selected_queue () {
    if ! mbfl_at_check_queue_letter "${QUEUE}" ; then
        mbfl_message_error "bad 'at' queue identifier '${QUEUE}'"
        return 1
    fi
}
function mbfl_at_select_queue () {
    mandatory_parameter(QUEUE, 1, queue letter)

    if ! mbfl_at_validate_queue_letter "${QUEUE}" ; then
        mbfl_message_error "bad 'at' queue identifier '${QUEUE}'"
        return 1
    fi
    mbfl_p_at_queue_letter=${QUEUE}
}
function mbfl_at_schedule () {
    mandatory_parameter(SCRIPT, 1, script)
    mandatory_parameter(TIME, 2, time)
    local QUEUE=${mbfl_p_at_queue_letter}
    local AT=$(mbfl_program_found at)

    # The return code of this function is the return code of the
    # following pipe.
    printf %s "${SCRIPT}" | {
        mbfl_program_redirect_stderr_to_stdout
        if ! mbfl_program_exec "${AT}" -q ${QUEUE} ${TIME} ; then
            mbfl_message_error \
                "scheduling command execution '${SCRIPT}' at time '${TIME}'"
            return 1
        fi
    } | {
        if ! { read; read; } ; then
            mbfl_message_error "reading output of 'at'"
            mbfl_message_error \
                "while scheduling command execution '${SCRIPT}' at time '${TIME}'"
            return 1
        fi

        set -- ${REPLY}
        printf %d "$2"
    }
}
function mbfl_at_queue_print_identifiers () {
    local QUEUE=${mbfl_p_at_queue_letter}

    mbfl_p_at_program_atq "${QUEUE}" | while read LINE ; do
        set -- ${LINE}
        printf '%d ' "${1}"
    done
}
function mbfl_at_queue_print_queues () {
    local ATQ=$(mbfl_program_found atq)
    local SORT=$(mbfl_program_found sort)

    {
        mbfl_program_exec "${ATQ}" | while read LINE ; do
            set -- ${LINE}
            printf '%c\n' "${4}"
        done
    } | mbfl_program_exec "${SORT}" -u
}
function mbfl_at_queue_print_jobs () {
    local QUEUE=${mbfl_p_at_queue_letter}
    mbfl_p_at_program_atq "${QUEUE}"
}
function mbfl_at_print_queue () {
    local QUEUE=${mbfl_p_at_queue_letter}
    printf '%c' "${QUEUE}"
}
function mbfl_at_drop () {
    mandatory_parameter(ID, 1, script identifier)
    local ATRM=$(mbfl_program_found atrm)

    mbfl_program_exec "${ATRM}" "${ID}"
}
function mbfl_at_queue_clean () {
    local QUEUE=${mbfl_p_at_queue_letter}
    local item

    for item in $(mbfl_at_queue_print_identifiers "${QUEUE}") ; do
        mbfl_at_drop "${item}"
    done
}

function mbfl_p_at_program_atq () {
    mandatory_parameter(QUEUE, 1, job queue)
    local ATQ=$(mbfl_program_found atq)
    mbfl_program_exec "${ATQ}" -q "${QUEUE}"
}


### end of file
# Local Variables:
# mode: sh
# End: