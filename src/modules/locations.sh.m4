# locations.sh.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: location handlers module
# Date: Nov 28, 2018
#
# Abstract
#
#
# Copyright (c) 2018, 2020 Marco Maggi <mrc.mgg@gmail.com>
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


#### global variables

mbfl_declare_symbolic_array(mbfl_location_HANDLERS)
declare -i mbfl_location_COUNTER=0

# Identifier from  the atexit module,  associated to the  atexit handler
# that cleans up the stack of locations.
#
declare mbfl_location_ATEXIT_ID


#### location delimiters

# Enter into a new location.  Initialise the internal state.
#
# We start registering locations with a location key of:
#
#   1:count
#
# so that the key:
#
#   0:count
#
# is always  empty.  This  means "$mbfl_location_COUNTER" is  the actual
# number of locations in the array "mbfl_location_HANDLERS".
#
function mbfl_location_enter () {
    let ++mbfl_location_COUNTER
    mbfl_location_HANDLERS[${mbfl_location_COUNTER}:count]=0
}

# Leave  the  current location.   Run  all  the registered  handlers  in
# reverse order.
#
function mbfl_location_leave () {
    # Capture return status of the last executed command.
    local RETURN_STATUS=$?

    if ((0 < mbfl_location_COUNTER))
    then
	local -i i HANDLERS_COUNT=mbfl_slot_ref(mbfl_location_HANDLERS, ${mbfl_location_COUNTER}:count)
	local HANDLER HANDLER_KEY

	for ((i=HANDLERS_COUNT; 0 < i; --i))
	do
	    HANDLER_KEY=${mbfl_location_COUNTER}:${i}
	    HANDLER=mbfl_slot_ref(mbfl_location_HANDLERS, ${HANDLER_KEY})
	    #echo --$FUNCNAME--handler_key--${HANDLER_KEY}-- >&2
	    if mbfl_string_is_not_empty $HANDLER
	    then eval $HANDLER
	    fi
	    unset -v mbfl_location_HANDLERS[${HANDLER_KEY}]
	done
	unset -v mbfl_location_HANDLERS[${mbfl_location_COUNTER}:count]
	let --mbfl_location_COUNTER
    fi

    #echo ${FUNCNAME}: returning "$RETURN_STATUS" >&2
    return $RETURN_STATUS
}

# Run all the handlers.  This is useful as atexit handler.
#
function mbfl_location_run_all () {
    while ((0 < mbfl_location_COUNTER))
    do mbfl_location_leave
    done
}

function mbfl_location_enable_cleanup_atexit () {
    mbfl_atexit_register mbfl_location_run_all mbfl_location_ATEXIT_ID
}

function mbfl_location_disable_cleanup_atexit () {
    mbfl_atexit_forget $mbfl_location_ATEXIT_ID
}


#### location handlers

# Register a new handler in the current location.
#
# We start registering handlers with a handler key of:
#
#   ${mbfl_location_COUNTER}:1
#
# so that the key:
#
#   ${mbfl_location_COUNTER}:0
#
# is always empty.  This means:
#
#   mbfl_location_HANDLERS[${mbfl_location_COUNTER}:count]
#
# is the actual number of handlers in the current location.
#
function mbfl_location_handler () {
    if ((0 < mbfl_location_COUNTER))
    then
	mbfl_mandatory_parameter(HANDLER, 1, location handler)

	local COUNT_KEY=${mbfl_location_COUNTER}:count
	let ++mbfl_location_HANDLERS[${COUNT_KEY}]

	local HANDLER_KEY=${mbfl_location_COUNTER}:mbfl_slot_ref(mbfl_location_HANDLERS, ${COUNT_KEY})
	mbfl_location_HANDLERS[${HANDLER_KEY}]=${HANDLER}

	#echo --$FUNCNAME--count-key--mbfl_slot_ref(mbfl_location_HANDLERS, ${COUNT_KEY})--handler-key--${HANDLER_KEY} >&2
    else
	mbfl_message_error 'attempt to register a location handler outside any location'
	exit_because_no_location
    fi
}

function mbfl_location_handler_suspend_testing () {
    mbfl_option_test_save
    mbfl_location_handler mbfl_option_test_restore
}

function mbfl_location_handler_change_directory () {
    mbfl_mandatory_parameter(NEWPWD, 1, new process working directory)

    if ! mbfl_directory_is_executable "$NEWPWD"
    then
	# We do not want "pushd" to change directory itself; we doit later with "mbfl_cd()".
	pushd -n "$NEWPWD" &>/dev/null
	if mbfl_cd "$NEWPWD"
	then
	    mbfl_location_handler 'popd'
	    return_success
	else return_failure
	fi
    else return_failure
    fi
}

### end of file
# Local Variables:
# mode: sh
# End:
