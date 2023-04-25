# hooks.bash.m4 --
#
# Part of: Marco's BASH functions library
# Contents: Emacs-like hooks
# Date: Mar 26, 2023
#
# Abstract
#
#	Emacs-like hooks implementation.
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


#### local macros

MBFL_DEFINE_UNDERSCORE_MACRO_FOR_SLOTS


#### interface

# For now this is just a placeholder.
#
function mbfl_hook_define () {
    mbfl_mandatory_nameref_parameter(mbfl_HOOK, 1, reference to hook variable)

    mbfl_hook_remove_commands _(mbfl_HOOK)
}
function mbfl_hook_undefine () {
    mbfl_mandatory_nameref_parameter(mbfl_HOOK, 1, reference to hook variable)

    mbfl_hook_remove_commands _(mbfl_HOOK)
}
function mbfl_hook_remove_commands () {
    mbfl_mandatory_nameref_parameter(mbfl_HOOK, 1, reference to hook variable)
    declare -i mbfl_I mbfl_DIM=mbfl_slots_number(mbfl_HOOK)

    for ((mbfl_I=0; mbfl_I < mbfl_DIM; ++mbfl_I))
    do mbfl_variable_unset mbfl_slot_spec(mbfl_HOOK, $mbfl_I)
    done
}
function mbfl_hook_has_commands () {
    mbfl_mandatory_nameref_parameter(mbfl_HOOK, 1, reference to hook variable)
    (( 0 < mbfl_slots_number(mbfl_HOOK) ))
}
function mbfl_hook_add () {
    mbfl_mandatory_nameref_parameter(mbfl_HOOK,	1, reference to hook variable)
    mbfl_mandatory_parameter(mbfl_HOOK_COMMAND,	2, hook command)
    mbfl_optional_parameter(mbfl_IDVAR,		3)
    declare -i mbfl_IDX=mbfl_slots_number(mbfl_HOOK)

    if mbfl_string_not_empty(mbfl_HOOK_COMMAND)
    then
	mbfl_slot_set(mbfl_HOOK, $mbfl_IDX, "$mbfl_HOOK_COMMAND")
	if mbfl_string_not_empty(mbfl_IDVAR)
	then
	    declare -n mbfl_ID_VARREF=$mbfl_IDVAR
	    mbfl_ID_VARREF=$mbfl_IDX
	fi
    else
	mbfl_message_warning_printf 'attempt to register empty string as handler for signal "%s"' "$mbfl_SIGNAME"
	return_failure
    fi
}
function mbfl_hook_remove () {
    mbfl_mandatory_nameref_parameter(mbfl_HOOK,		1, reference to hook variable)
    mbfl_mandatory_integer_parameter(mbfl_HANDLER_ID,	2, handler id)
    # We must  NOT unset  this array  key/value pair:  we must really  set it  to the  empty string.
    # If the array is:
    #
    #    mbfl_HOOK[0]=hook_0
    #    mbfl_HOOK[1]=hook_1
    #    mbfl_HOOK[2]=hook_2
    #
    # and we unset "mbfl_HOOK[1]" and , the resulting array is:
    #
    #    mbfl_HOOK[0]=hook_0
    #    mbfl_HOOK[2]=hook_2
    #
    # unsetting it will cause:
    #
    #    mbfl_slots_number(mbfl_HOOK) => 2
    #
    # because there are 2 slots, but this will cause the "for" loops used in this module to fail:
    #
    #    for ((mbfl_I=0; mbfl_I < mbfl_slots_number(mbfl_HOOK); ++mbfl_I))
    #
    # because 2 is not one  more than the highest slot key.
    #
    # We could still correctly loop over the keys with:
    #
    #    for KEY in mbfl_slots_keys(mbfl_HOOK)
    #
    # but I have decided that I like the for-with-counter loop more.  (Marco Maggi; Apr 25, 2023)
    mbfl_slot_set(mbfl_HOOK, $mbfl_HANDLER_ID)
}
function mbfl_hook_run () {
    mbfl_mandatory_nameref_parameter(mbfl_HOOK, 1, reference to hook variable)
    declare -i mbfl_I mbfl_DIM=mbfl_slots_number(mbfl_HOOK)
    declare mbfl_COMMAND

    for ((mbfl_I=0; mbfl_I < mbfl_DIM; ++mbfl_I))
    do mbfl_p_hook_run_command _(mbfl_HOOK) $mbfl_I
    done
}
function mbfl_hook_reverse_run () {
    mbfl_mandatory_nameref_parameter(mbfl_HOOK, 1, reference to hook variable)
    declare -i mbfl_I mbfl_DIM=mbfl_slots_number(mbfl_HOOK)

    for ((mbfl_I=mbfl_DIM-1; mbfl_I >= 0; --mbfl_I))
    do mbfl_p_hook_run_command _(mbfl_HOOK) $mbfl_I
    done
}
function mbfl_p_hook_run_command () {
    mbfl_mandatory_nameref_parameter(mbfl_HOOK, 1, reference to hook variable)
    mbfl_mandatory_integer_parameter(mbfl_IDX,  2, command index)

    # This can be empty if we have removed a command from the hook.
    declare mbfl_COMMAND=_(mbfl_HOOK,$mbfl_IDX)
    if mbfl_string_not_empty(mbfl_COMMAND)
    then eval "$mbfl_COMMAND"
    fi
}

### end of file
# Local Variables:
# mode: sh
# End:
