# exception-handlers.bash.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: exception handlers
# Date: May  3, 2023
#
# Abstract
#
#       This module defines the exception handlers mechanism.
#
#       A lot of ideas were recycled from  the "Revised^6 Report on the Algorithmic Language Scheme"
#       (R6RS): <https://www.r6rs.org/>.
#
# Copyright (c) 2023 Marco Maggi
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


#### macros

MBFL_DEFINE_UNDERSCORE_MACRO_FOR_SLOTS


#### initialisation

alias return_success_after_handling_exception='return 0'
alias return_failure_after_handling_exception='return 1'
alias return_after_not_handling_exception='return 2'

function mbfl_initialise_module_exception_handlers () {
    declare -ga mbfl_exception_handlers_STACK=()
    mbfl_exception_handlers_push 'mbfl_default_exception_handler'
}
function mbfl_default_exception_handler () {
    mbfl_mandatory_nameref_parameter(mbfl_CND, 1, exceptional-condition object)

    #echo $FUNCNAME enter mbfl_CND=$mbfl_CND _(mbfl_CND)  >&2

    if mbfl_warning_condition_is_a _(mbfl_CND) && mbfl_exceptional_condition_is_continuable _(mbfl_CND)
    then
	mbfl_exceptional_condition_print _(mbfl_CND) >&2
	return_success_after_handling_exception
    elif mbfl_uncaught_exceptional_condition_is_a _(mbfl_CND)
    then
	#mbfl_array_dump _(mbfl_CND)
	mbfl_exceptional_condition_print _(mbfl_CND) >&2
	exit_because_uncaught_exception
    else
	mbfl_default_object_declare(mbfl_ENVELOPE_CND)

	#echo $FUNCNAME envelope object _(mbfl_ENVELOPE_CND) uncaught exception ,_(mbfl_CND), >&2
	mbfl_uncaught_exceptional_condition_make _(mbfl_ENVELOPE_CND) $FUNCNAME _(mbfl_CND)
	#mbfl_array_dump _(mbfl_ENVELOPE_CND)
	mbfl_exception_raise _(mbfl_ENVELOPE_CND)
    fi
}


#### interface

function mbfl_exception_handler () {
    mbfl_mandatory_parameter(mbfl_HANDLER, 1, applicable exception handler)

    mbfl_exception_handlers_push "$mbfl_HANDLER"
    mbfl_location_handler 'mbfl_exception_handlers_pop'
}
function mbfl_exception_handlers_push () {
    mbfl_mandatory_parameter(mbfl_HANDLER, 1, applicable exception handler)
    declare -i mbfl_DIM=mbfl_slots_number(mbfl_exception_handlers_STACK)

    mbfl_slot_set(mbfl_exception_handlers_STACK, $mbfl_DIM, "$mbfl_HANDLER")
}
function mbfl_exception_handlers_pop () {
    declare -i mbfl_DIM=mbfl_slots_number(mbfl_exception_handlers_STACK)

    mbfl_variable_unset(mbfl_slot_spec(mbfl_exception_handlers_STACK, $((mbfl_DIM-1))))
}
function mbfl_exception_raise () {
    mbfl_mandatory_nameref_parameter(mbfl_CND, 1, condition object)
    declare -i mbfl_RETURN_STATUS mbfl_I mbfl_DIM=mbfl_slots_number(mbfl_exception_handlers_STACK)
    declare mbfl_HANDLER

    #echo $FUNCNAME enter raising mbfl_CND=$mbfl_CND _(mbfl_CND) >&2

    for ((mbfl_I=mbfl_DIM-1; mbfl_I >= 0; --mbfl_I))
    do
	#echo $FUNCNAME applying the handler $mbfl_I _(mbfl_exception_handlers_STACK, $mbfl_I) "$mbfl_CND" >&2
	mbfl_HANDLER=_(mbfl_exception_handlers_STACK, $mbfl_I)
	# NOTE If the  handler string contains separators:  we want it to be  expanded into multiple
	# strings.  At least for now.  (Marco Maggi; May 14, 2023)
	$mbfl_HANDLER _(mbfl_CND)
	mbfl_RETURN_STATUS=$?
	if ((0 == $mbfl_RETURN_STATUS))
	then
	    #echo $FUNCNAME handler returned successfully >&2

	    # The exception  was handled correctly;  the problem  possibly fixed.  If  the condition
	    # object is continuable: just return to the caller; otherwise exit the script.
	    #
	    if mbfl_exceptional_condition_is_continuable _(mbfl_CND)
	    then
		#echo $FUNCNAME the condition is continuable >&2
		return_success
	    else
		#echo $FUNCNAME the condition is non-continuable so exit >&2
		exit_because_non_continuable_exception
	    fi
	elif ((1 == $mbfl_RETURN_STATUS))
	then
	    # The exception was handled correctly; the problem  was not fixed.  Signal to the caller
	    # that it has to rewind the stack until the beginning of the current operation.
	    return_failure
	fi
	# If we are here: the handler did not handle the exception; try the upper handler.
    done
}

### end of file
# Local Variables:
# mode: sh
# End:
