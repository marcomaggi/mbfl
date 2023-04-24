# locations.bash.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: location handlers module
# Date: Nov 28, 2018
#
# Abstract
#
#
# Copyright (c) 2018, 2020, 2023 Marco Maggi <mrc.mgg@gmail.com>
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


#### global variables

mbfl_declare_index_array(mbfl_location_HOOKS)

# Identifier from  the atexit module,  associated to the  atexit handler
# that cleans up the stack of locations.
#
declare mbfl_location_ATEXIT_ID


#### location delimiters

function mbfl_location_enter () {
    mbfl_hook_global_declare(mbfl_HOOK)

    mbfl_hook_define _(mbfl_HOOK)
    mbfl_slot_set(mbfl_location_HOOKS, mbfl_slots_number(mbfl_location_HOOKS), _(mbfl_HOOK))
}
function mbfl_location_leave () {
    # Capture return status of the last executed command.
    declare -i mbfl_RETURN_STATUS=$?
    declare -i mbfl_DIM=mbfl_slots_number(mbfl_location_HOOKS)

    if ((0 < mbfl_DIM))
    then
	declare -i mbfl_I=mbfl_DIM-1

	mbfl_declare_nameref(mbfl_HOOK, _(mbfl_location_HOOKS, $mbfl_I))
	mbfl_hook_reverse_run _(mbfl_HOOK)
	mbfl_variable_unset(mbfl_slot_spec(mbfl_location_HOOKS, $mbfl_I))
	mbfl_hook_undefine _(mbfl_HOOK)
	mbfl_variable_unset(_(mbfl_HOOK))
    fi
    return $mbfl_RETURN_STATUS
}
function mbfl_location_run_all () {
    while ((0 < mbfl_slots_number(mbfl_location_HOOKS)))
    do mbfl_location_leave
    done
}
function mbfl_location_enable_cleanup_atexit () {
    mbfl_atexit_register mbfl_location_run_all mbfl_location_ATEXIT_ID
}
function mbfl_location_disable_cleanup_atexit () {
    mbfl_atexit_forget $mbfl_location_ATEXIT_ID
}
function mbfl_location_hook_var () {
    mbfl_mandatory_nameref_parameter(mbfl_HOOK, 1, result variable)
    declare -i mbfl_DIM=mbfl_slots_number(mbfl_location_HOOKS)

    if ((0 < mbfl_DIM))
    then
	mbfl_HOOK=_(mbfl_location_HOOKS, $mbfl_I)
	return_success
    else return_failure
    fi
}


#### location handlers

function mbfl_location_handler () {
    mbfl_mandatory_parameter(mbfl_HANDLER, 1, location handler)
    declare -i mbfl_DIM=mbfl_slots_number(mbfl_location_HOOKS)

    if ((0 < mbfl_DIM)) && mbfl_string_not_empty(mbfl_HANDLER)
    then
	declare -i mbfl_I=mbfl_DIM-1

	mbfl_declare_nameref(mbfl_HOOK, _(mbfl_location_HOOKS, $mbfl_I))
	mbfl_hook_add _(mbfl_HOOK) "$mbfl_HANDLER"
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
    mbfl_mandatory_parameter(mbfl_NEWPWD, 1, new process working directory)

    if mbfl_directory_is_executable "$mbfl_NEWPWD"
    then
	# We do not want "pushd" to change directory itself; we doit later with "mbfl_cd()".
	pushd -n "$mbfl_NEWPWD" &>/dev/null
	if mbfl_cd "$mbfl_NEWPWD"
	then
	    mbfl_location_handler 'popd'
	    return_success
	else return_failure
	fi
    else return_failure
    fi
}

function mbfl_location_handler_restore_lastpipe () {
    # Upon exiting the location: restore the previous status of "lastpipe".
    mbfl_location_handler "$(shopt -p lastpipe)"
}

### end of file
# Local Variables:
# mode: sh
# End:
