# exception-handlers.bash.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: exception handlers
# Date: May  3, 2023
#
# Abstract
#
#       This module defines exception handlers.
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

function mbfl_initialise_module_exception_handlers () {
    declare -ga mbfl_exception_handlers_STACK=()
    mbfl_exception_handlers_push 'mbfl_default_exception_handler'
}
function mbfl_default_exception_handler () {
    mbfl_mandatory_nameref_parameter(CND, 1, condition object)
    exit_because_uncaught_exception
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

    for ((mbfl_I=mbfl_DIM-1; mbfl_I >= 0; --mbfl_I))
    do
	#echo $FUNCNAME applying the handler $mbfl_I _(mbfl_exception_handlers_STACK, $mbfl_I) "$mbfl_CND" >&2
	_(mbfl_exception_handlers_STACK, $mbfl_I) _(mbfl_CND)
	mbfl_RETURN_STATUS=$?
	if ((0 == $mbfl_RETURN_STATUS))
	then
	    #echo $FUNCNAME handler returned successfully >&2

	    # The exception  was handled correctly;  the problem  possibly fixed.  If  the condition
	    # object is continuable: just return to the caller; otherwise exit the script.
	    #
	    if mbfl_exceptional_condition_is_continuable _(CND)
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

function return_success_after_handling_exception () { return 0; }
function return_failure_after_handling_exception () { return 1; }
function return_after_not_handling_exception     () { return 2; }

### end of file
# Local Variables:
# mode: sh
# End:
