# signal.bash.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: functions to deal with signals
# Date: Mon Jul  7, 2003
#
# Abstract
#
#
#
# Copyright (c) 2003-2005, 2009, 2013, 2018, 2020, 2023, 2024 Marco Maggi
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


#### global variables

if mbfl_string_neq_yes("$mbfl_INTERACTIVE")
then
    # Global integer variable representing the maximum signal number.
    #
    declare -i mbfl_signal_MAX_SIGNUM

    # Global assoc array mapping signal names to signal numbers.
    #
    mbfl_declare_assoc_array(mbfl_signal_SIGNAMES_TO_SIGNUMS)

    # Global index array mapping signal numbers to signal names.
    #
    mbfl_declare_assoc_array(mbfl_signal_SIGNUMS_TO_SIGNAMES)

    # Global  index array  mapping signal  numbers  to handler  hooks.   When requested:  a hook  is
    # constructed and its datavar stored in this array to hold signal handlers.
    #
    mbfl_declare_index_array(mbfl_signal_HOOKS)
fi

function mbfl_signal_enable () {
    declare mbfl_SIGNAME
    declare -i mbfl_SIGNUM=0
    {
	while mbfl_SIGNAME=$(kill -l $mbfl_SIGNUM)
	do
	    mbfl_SIGNAME=SIG$mbfl_SIGNAME
	    mbfl_slot_set(mbfl_signal_SIGNAMES_TO_SIGNUMS, "$mbfl_SIGNAME", "$mbfl_SIGNUM")
	    mbfl_slot_set(mbfl_signal_SIGNUMS_TO_SIGNAMES, "$mbfl_SIGNUM",  "$mbfl_SIGNAME")
	    mbfl_slot_set(mbfl_signal_HOOKS, "$mbfl_SIGNUM", _(mbfl_unspecified))
	    let ++mbfl_SIGNUM
	done
    } &>/dev/null
    mbfl_signal_MAX_SIGNUM=$mbfl_SIGNUM

    #mbfl_array_dump mbfl_signal_SIGNAMES_TO_SIGNUMS mbfl_signal_SIGNAMES_TO_SIGNUMS
    #mbfl_array_dump mbfl_signal_SIGNUMS_TO_SIGNAMES mbfl_signal_SIGNUMS_TO_SIGNAMES
}


#### mapping signal string specifications to numbers

function mbfl_string_is_signame () {
    mbfl_mandatory_parameter(mbfl_STR, 1, string)
    mbfl_array_contains mbfl_signal_SIGNAMES_TO_SIGNUMS "$mbfl_STR"
}
function mbfl_string_is_signum () {
    mbfl_mandatory_parameter(mbfl_STR, 1, string)
    mbfl_array_contains mbfl_signal_SIGNUMS_TO_SIGNAMES "$mbfl_STR"
}

### ------------------------------------------------------------------------

function mbfl_signal_map_signame_to_signum_var () {
    mbfl_mandatory_nameref_parameter(mbfl_SIGNUM,	1, result variable)
    mbfl_mandatory_parameter(mbfl_SIGNAME,		2, signal name)

    declare mbfl_OBJECT=_(mbfl_signal_SIGNAMES_TO_SIGNUMS, "$mbfl_SIGNAME")
    if mbfl_string_not_empty(mbfl_OBJECT)
    then
	mbfl_SIGNUM=$mbfl_OBJECT
	return_success
    else return_failure
    fi
}
function mbfl_signal_map_signame_to_signum () {
    mbfl_mandatory_parameter(mbfl_SIGNAME, 1, signal name)
    mbfl_declare_integer_varref(mbfl_SIGNUM)

    mbfl_signal_map_signame_to_signum_var _(mbfl_SIGNUM) "$mbfl_SIGNAME"
    echo -n $mbfl_SIGNUM
}

### ------------------------------------------------------------------------

function mbfl_signal_map_signum_to_signame_var () {
    mbfl_mandatory_nameref_parameter(mbfl_SIGNAME,	1, result variable)
    mbfl_mandatory_parameter(mbfl_SIGNUM,		2, signal number)

    declare mbfl_OBJECT=_(mbfl_signal_SIGNUMS_TO_SIGNAMES, "$mbfl_SIGNUM")
    if mbfl_string_not_empty(mbfl_OBJECT)
    then
	mbfl_SIGNAME=$mbfl_OBJECT
	return_success
    else return_failure
    fi
}
function mbfl_signal_map_signum_to_signame () {
    mbfl_mandatory_parameter(mbfl_SIGNUM, 1, signal number)
    mbfl_declare_varref(mbfl_SIGNAME)

    mbfl_signal_map_signum_to_signame_var _(mbfl_SIGNAME) "$mbfl_SIGNUM"
    echo -n $mbfl_SIGNAME
}


#### signal handlers registry

function mbfl_signal_hook_var () {
    mbfl_mandatory_nameref_parameter(mbfl_HOOK_RV,	1, result variable)
    mbfl_mandatory_parameter(mbfl_SIGNAME,		2, signal name)
    mbfl_declare_integer_varref(mbfl_SIGNUM)

    if ! mbfl_signal_map_signame_to_signum_var _(mbfl_SIGNUM) "$mbfl_SIGNAME"
    then
	mbfl_message_error_printf 'invalid signal name: "%s"' "$mbfl_SIGNAME"
	return_failure
    fi

    declare mbfl_OBJECT=_(mbfl_signal_HOOKS, $mbfl_SIGNUM)
    if mbfl_the_unspecified_p "$mbfl_OBJECT"
    then
	# Declare and define a new global hook...
	mbfl_hook_global_declare(mbfl_THE_HOOK)
	mbfl_hook_define _(mbfl_THE_HOOK)
	# ... store its data variable.
	mbfl_slot_set(mbfl_signal_HOOKS, $mbfl_SIGNUM, _(mbfl_THE_HOOK))
	mbfl_HOOK_RV=_(mbfl_THE_HOOK)
    else mbfl_HOOK_RV="$mbfl_OBJECT"
    fi
}
function mbfl_signal_attach () {
    mbfl_mandatory_parameter(mbfl_SIGNAME, 1, signal name)
    mbfl_mandatory_parameter(mbfl_HANDLER, 2, handler callable identifier)

    if mbfl_string_empty(mbfl_HANDLER)
    then
	mbfl_message_warning_printf 'attempt to register empty string as handler for signal "%s"' "$mbfl_SIGNAME"
	return_failure
    fi

    mbfl_declare_varref(mbfl_HOOK)

    if mbfl_signal_hook_var _(mbfl_HOOK) "$mbfl_SIGNAME"
    then
	# If the hook has no  commands: it means this is the first time we  attach a handler to this
	# signal; so we also trap the signal itself.
	if ! mbfl_hook_has_commands $mbfl_HOOK
	then trap "mbfl_signal_invoke_handlers '$mbfl_SIGNAME'" "$mbfl_SIGNAME"
	fi
	mbfl_hook_add $mbfl_HOOK "$mbfl_HANDLER"
	#mbfl_message_debug_printf 'attached handler to signal "%s": "%s"' "$mbfl_SIGNAME" "$mbfl_HANDLER"
	return_success
    else return_failure
    fi
}
function mbfl_signal_has_handlers () {
    mbfl_mandatory_parameter(mbfl_SIGNAME, 1, signal name)
    mbfl_declare_integer_varref(mbfl_SIGNUM)

    if ! mbfl_signal_map_signame_to_signum_var _(mbfl_SIGNUM) "$mbfl_SIGNAME"
    then
	mbfl_message_error_printf 'invalid signal name: "%s"' "$mbfl_SIGNAME"
	return_failure
    fi

    declare mbfl_OBJECT=_(mbfl_signal_HOOKS, $mbfl_SIGNUM)
    if mbfl_the_unspecified_p "$mbfl_OBJECT"
    then return_failure
    else mbfl_hook_has_commands "$mbfl_OBJECT"
    fi
}
function mbfl_signal_remove_all_handlers () {
    declare -i mbfl_I mbfl_DIM=mbfl_slots_number(mbfl_signal_HOOKS)

    for ((mbfl_I=0; mbfl_I < mbfl_DIM; ++mbfl_I))
    do
	mbfl_declare_nameref(mbfl_HOOK, _(mbfl_signal_HOOKS, $mbfl_I))
	mbfl_hook_undefine _(mbfl_HOOK)
	mbfl_variable_unset(_(mbfl_HOOK))
    done
}
function mbfl_signal_remove_handler () {
    mbfl_mandatory_parameter(mbfl_SIGNAME, 1, signal name)
    mbfl_declare_integer_varref(mbfl_SIGNUM)

    if mbfl_signal_map_signame_to_signum_var _(mbfl_SIGNUM) "$mbfl_SIGNAME"
    then
	mbfl_declare_nameref(mbfl_HOOK, _(mbfl_signal_HOOKS, $mbfl_SIGNUM))
	mbfl_hook_undefine _(mbfl_HOOK)
	mbfl_variable_unset(_(mbfl_HOOK))
    else
	mbfl_message_error_printf 'invalid signal name: "%s"' "$mbfl_SIGNAME"
	return_failure
    fi
}


#### sending signals, invoking signal handlers

function mbfl_signal_send () {
    mbfl_mandatory_parameter(mbfl_SIGNAME,	1, signal name)
    mbfl_mandatory_parameter(mbfl_TARGET_PID,	2, process id)

    if { ! mbfl_string_is_digit "$mbfl_TARGET_PID"; } || (( mbfl_TARGET_PID < 1 ))
    then
	mbfl_message_error_printf 'invalid process ID: "%s"' "$mbfl_TARGET_PID"
	return_failure
    fi

    if ! mbfl_string_is_signame "$mbfl_SIGNAME"
    then
	mbfl_message_error_printf 'invalid signal name: "%s"' "$mbfl_SIGNAME"
	return_failure
    fi

    mbfl_process_kill -s "$mbfl_SIGNAME" $mbfl_TARGET_PID
}
function mbfl_signal_invoke_handlers () {
    mbfl_mandatory_parameter(mbfl_SIGNAME, 1, signal name)
    mbfl_declare_varref(mbfl_HOOK)

    if mbfl_signal_hook_var _(mbfl_HOOK) "$mbfl_SIGNAME"
    then mbfl_hook_run "$mbfl_HOOK"
    else return_failure
    fi
}

### end of file
# Local Variables:
# mode: sh
# End:
