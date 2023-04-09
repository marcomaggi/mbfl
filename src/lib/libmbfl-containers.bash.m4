#! libmbfl-containers.bash.m4 --
#!
#! Part of: Marco's BASH Functions Library
#! Contents: containers library
#! Date: Apr  9, 2023
#!
#! Abstract
#!
#!	This library implements common containers as default objects.
#!
#! Copyright (c) 2023 Marco Maggi
#! <mrc.mgg@gmail.com>
#!
#! This is free software; you can redistribute it and/or  modify it under the terms of the GNU Lesser
#! General Public  License as published by  the Free Software  Foundation; either version 3.0  of the
#! License, or (at your option) any later version.
#!
#! This library is distributed in the hope that  it will be useful, but WITHOUT ANY WARRANTY; without
#! even the  implied warranty of MERCHANTABILITY  or FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU
#! Lesser General Public License for more details.
#!
#! You should have received a copy of the  GNU Lesser General Public License along with this library;
#! if not,  write to  the Free  Software Foundation,  Inc., 59  Temple Place,  Suite 330,  Boston, MA
#! 02111-1307 USA.
#!


#### global variables

# if mbfl_string_neq_yes("$mbfl_INTERACTIVE")
# then
# fi


#### macros

# With one parameter is expands into a use  of "mbfl_datavar()"; with two parameters it expands into
# a use of "mbfl_slot_qref".
#
m4_define([[[_]]],[[[m4_ifelse($#,1,[[[mbfl_datavar([[[$1]]])]]],$#,2,[[[mbfl_slot_qref([[[$1]]],[[[$2]]])]]],[[[MBFL_P_WRONG_NUM_ARGS($#,1 or 2)]]])]]])


#### stacks

function mbfl_stack_push () {
    mbfl_mandatory_nameref_parameter(mbfl_STACK, 1, reference to index array representing a stack)
    mbfl_mandatory_parameter(mbfl_OBJ,           2, the object to push on the stack)

    mbfl_slot_set(mbfl_STACK, mbfl_slots_number(mbfl_STACK), "$mbfl_OBJ")
    return_success
}
function mbfl_stack_pop () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,    1, reference to the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_STACK, 2, reference to index array representing a stack)

    if (( 0 < mbfl_slots_number(mbfl_STACK) ))
    then
	mbfl_RV=mbfl_slot_ref(mbfl_STACK, -1)
	unset -v mbfl_slot_spec(mbfl_STACK, -1)
	return_success
    else
	mbfl_message_error_printf 'attempt to pop from an empty stack: "%s"' _(mbfl_STACK)
	return_failure
    fi
}
function mbfl_stack_copy () {
    mbfl_mandatory_nameref_parameter(mbfl_DST_STACK, 1, reference to index array representing the destination stack)
    mbfl_mandatory_nameref_parameter(mbfl_SRC_STACK, 2, reference to index array representing the source stack)
    declare -i mbfl_I mbfl_NUM=mbfl_slots_number(mbfl_SRC_STACK)

    for ((mbfl_I=0; mbfl_I<mbfl_NUM; ++mbfl_I))
    do mbfl_slot_set(mbfl_DST_STACK, $mbfl_I, mbfl_slot_qref(mbfl_SRC_STACK,$mbfl_I))
    done
}
function mbfl_stack_equal () {
    mbfl_mandatory_nameref_parameter(mbfl_STACK1, 1, reference to index array representing a stack)
    mbfl_mandatory_nameref_parameter(mbfl_STACK2, 2, reference to index array representing a stack)
    mbfl_optional_parameter(mbfl_COMPAR,          3)

    if (( mbfl_slots_number(mbfl_STACK2) != mbfl_slots_number(mbfl_STACK1) ))
    then return_failure
    fi

    if mbfl_string_empty(mbfl_COMPAR)
    then mbfl_COMPAR='mbfl_string_equal'
    fi

    {
	declare -i mbfl_I mbfl_NUM=mbfl_slots_number(mbfl_STACK2)
	for ((mbfl_I=0; mbfl_I<mbfl_NUM; ++mbfl_I))
	do
	    if ! "$mbfl_COMPAR" mbfl_slot_qref(mbfl_STACK1, $mbfl_I) mbfl_slot_qref(mbfl_STACK2, $mbfl_I)
	    then return_failure
	    fi
	done
    }
    return_success
}

#!# end of file
# Local Variables:
# mode: sh
# End:
