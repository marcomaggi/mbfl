# interface.sh.m4 --
# 
# Part of: Marco's BASH Functions Library
# Contents: interfaces to external programs
# Date: Thu Aug 11, 2005
# 
# Abstract
# 
#
# Copyright (c) 2005 Marco Maggi
# 
# This is free  software you can redistribute it  and/or modify it under
# the terms of  the GNU General Public License as  published by the Free
# Software Foundation; either  version 2, or (at your  option) any later
# version.
# 
# This  file is  distributed in  the hope  that it  will be  useful, but
# WITHOUT   ANY  WARRANTY;  without   even  the   implied  warranty   of
# MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
# General Public License for more details.
# 
# You  should have received  a copy  of the  GNU General  Public License
# along with this file; see the file COPYING.  If not, write to the Free
# Software Foundation,  Inc., 59  Temple Place -  Suite 330,  Boston, MA
# 02111-1307, USA.
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
}
function mbfl_at_validate_queue_letter () {
    mandatory_parameter(QUEUE, 1, queue letter)
    test ${#QUEUE} -eq 1 && mbfl_string_is_alpha_char "${QUEUE}"
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

    printf %s "${SCRIPT}" | mbfl_program_exec "${AT}" -q "${QUEUE}" ${TIME}
}
function mbfl_at_queue_print_identifiers () {
    local QUEUE=${mbfl_p_at_queue_letter}
    local ATQ=$(mbfl_program_found atq)

    mbfl_program_exec "${ATQ}" -q "${QUEUE}" | while read LINE ; do
        set -- ${LINE}
        printf %d "${1}"
    done
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



### end of file
# Local Variables:
# mode: sh
# End:
