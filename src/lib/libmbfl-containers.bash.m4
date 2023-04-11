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


#### macros

MBFL_DEFINE_UNDERSCORE_MACRO_FOR_METHODS


#### global variables

if mbfl_string_neq_yes("$mbfl_INTERACTIVE")
then
    mbfl_default_class_declare(mbfl_stack_t)

    mbfl_default_class_define _(mbfl_stack_t) _(mbfl_default_object) 'mbfl_stack' array
fi


#### stacks

m4_define([[[MBFL_STACK_ACCESS_ARRAY]]],[[[
  mbfl_declare_varref($2_DATAVAR)
  mbfl_stack_array_var _($2_DATAVAR) _($1)
  mbfl_declare_nameref($2, $[[[$2]]]_DATAVAR)
]]])

m4_define([[[MBFL_STACK_VALIDATE_PARAMETER]]],[[[
  if ! mbfl_stack_is_a _($1)
  then
      mbfl_message_error_printf 'expected object of class "mbfl_stack" as parameter, got: "%s"' _($1)
      return_failure
  fi
]]])

function mbfl_stack_make () {
    mbfl_mandatory_nameref_parameter(mbfl_STACK, 1, reference to uninitialised object of class mbfl_stack_t)
    mbfl_declare_index_array_varref(mbfl_ARRAY,,-g)

    mbfl_stack_define _(mbfl_STACK) _(mbfl_ARRAY)
}
function mbfl_stack_unmake () {
    mbfl_mandatory_nameref_parameter(mbfl_STACK, 1, reference to object of class mbfl_stack_t)

    MBFL_STACK_VALIDATE_PARAMETER(mbfl_STACK)
    mbfl_declare_varref(mbfl_ARRAY_DATAVAR)
    mbfl_stack_array_var _(mbfl_ARRAY_DATAVAR) _(mbfl_STACK)
    unset -v $mbfl_ARRAY_DATAVAR
}
function mbfl_stack_size_var () {
    mbfl_mandatory_nameref_parameter(mbfl_SIZE,  1, reference to result variable)
    mbfl_mandatory_nameref_parameter(mbfl_STACK, 2, reference to object of class mbfl_stack_t)

    MBFL_STACK_VALIDATE_PARAMETER(mbfl_STACK)
    MBFL_STACK_ACCESS_ARRAY(mbfl_STACK, mbfl_ARRAY)
    mbfl_SIZE=mbfl_slots_number(mbfl_ARRAY)
}
function mbfl_stack_push () {
    mbfl_mandatory_nameref_parameter(mbfl_STACK, 1, reference to object of class mbfl_stack_t)
    mbfl_mandatory_parameter(mbfl_OBJ,           2, the object to push on the stack)

    MBFL_STACK_VALIDATE_PARAMETER(mbfl_STACK)
    MBFL_STACK_ACCESS_ARRAY(mbfl_STACK, mbfl_ARRAY)
    mbfl_slot_set(mbfl_ARRAY, mbfl_slots_number(mbfl_ARRAY), "$mbfl_OBJ")
    return_success
}
function mbfl_stack_pop_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,    1, reference to the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_STACK, 2, reference to object of class mbfl_stack_t)

    MBFL_STACK_VALIDATE_PARAMETER(mbfl_STACK)
    MBFL_STACK_ACCESS_ARRAY(mbfl_STACK, mbfl_ARRAY)
    if (( 0 < mbfl_slots_number(mbfl_ARRAY) ))
    then
	mbfl_RV=mbfl_slot_ref(mbfl_ARRAY, -1)
	unset -v mbfl_slot_spec(mbfl_ARRAY, -1)
	return_success
    else
	mbfl_message_error_printf 'attempt to pop from an empty stack: "%s"' _(mbfl_STACK)
	return_failure
    fi
}
function mbfl_stack_top_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,    1, reference to the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_STACK, 2, reference to object of class mbfl_stack_t)

    MBFL_STACK_VALIDATE_PARAMETER(mbfl_STACK)
    MBFL_STACK_ACCESS_ARRAY(mbfl_STACK, mbfl_ARRAY)
    if (( 0 < mbfl_slots_number(mbfl_ARRAY) ))
    then
	mbfl_RV=mbfl_slot_ref(mbfl_ARRAY, -1)
	return_success
    else
	mbfl_message_error_printf 'attempt to pop from an empty stack: "%s"' _(mbfl_STACK)
	return_failure
    fi
}
function mbfl_stack_copy () {
    mbfl_mandatory_nameref_parameter(mbfl_DST_STACK, 1, reference to destination object of class mbfl_stack_t)
    mbfl_mandatory_nameref_parameter(mbfl_SRC_STACK, 2, reference to source object of class mbfl_stack_t)

    MBFL_STACK_VALIDATE_PARAMETER(mbfl_DST_STACK)
    MBFL_STACK_VALIDATE_PARAMETER(mbfl_SRC_STACK)
    MBFL_STACK_ACCESS_ARRAY(mbfl_DST_STACK, mbfl_DST_ARRAY)
    MBFL_STACK_ACCESS_ARRAY(mbfl_SRC_STACK, mbfl_SRC_ARRAY)

    declare -i mbfl_I mbfl_NUM=mbfl_slots_number(mbfl_SRC_ARRAY)

    for ((mbfl_I=0; mbfl_I<mbfl_NUM; ++mbfl_I))
    do mbfl_slot_set(mbfl_DST_ARRAY, $mbfl_I, mbfl_slot_qref(mbfl_SRC_ARRAY, $mbfl_I))
    done
}
function mbfl_stack_equal () {
    mbfl_mandatory_nameref_parameter(mbfl_STACK1, 1, reference to object of class mbfl_stack_t)
    mbfl_mandatory_nameref_parameter(mbfl_STACK2, 2, reference to object of class mbfl_stack_t)
    mbfl_optional_parameter(mbfl_COMPAR,          3)

    MBFL_STACK_VALIDATE_PARAMETER(mbfl_STACK1)
    MBFL_STACK_VALIDATE_PARAMETER(mbfl_STACK2)
    MBFL_STACK_ACCESS_ARRAY(mbfl_STACK1, mbfl_ARRAY1)
    MBFL_STACK_ACCESS_ARRAY(mbfl_STACK2, mbfl_ARRAY2)

    if (( mbfl_slots_number(mbfl_ARRAY2) != mbfl_slots_number(mbfl_ARRAY1) ))
    then return_failure
    fi

    if mbfl_string_empty(mbfl_COMPAR)
    then mbfl_COMPAR='mbfl_string_equal'
    fi

    {
	declare -i mbfl_I mbfl_NUM=mbfl_slots_number(mbfl_ARRAY2)
	for ((mbfl_I=0; mbfl_I<mbfl_NUM; ++mbfl_I))
	do
	    if ! "$mbfl_COMPAR" mbfl_slot_qref(mbfl_ARRAY1, $mbfl_I) mbfl_slot_qref(mbfl_ARRAY2, $mbfl_I)
	    then return_failure
	    fi
	done
    }
    return_success
}

function mbfl_stack_dump () {
    mbfl_mandatory_nameref_parameter(mbfl_STACK, 1, reference to object of class mbfl_stack_t)
    mbfl_optional_parameter(mbfl_LABEL, 2)

    MBFL_STACK_VALIDATE_PARAMETER(mbfl_STACK)
    MBFL_STACK_ACCESS_ARRAY(mbfl_STACK, mbfl_ARRAY)
    mbfl_array_dump _(mbfl_ARRAY) "$mbfl_LABEL"
}

### ------------------------------------------------------------------------
### the following are wrappers for methods

function mbfl_stack_pop () {
    mbfl_mandatory_nameref_parameter(mbfl_STACK, 1, reference to object of class mbfl_stack_t)
    mbfl_mandatory_nameref_parameter(mbfl_RV,    2, reference to the result variable)
    mbfl_stack_pop_var _(mbfl_RV) _(mbfl_STACK)
}
function mbfl_stack_top () {
    mbfl_mandatory_nameref_parameter(mbfl_STACK, 1, reference to object of class mbfl_stack_t)
    mbfl_mandatory_nameref_parameter(mbfl_RV,    2, reference to the result variable)
    mbfl_stack_top_var _(mbfl_RV) _(mbfl_STACK)
}
function mbfl_stack_size () {
    mbfl_mandatory_nameref_parameter(mbfl_STACK, 1, reference to object of class mbfl_stack_t)
    mbfl_mandatory_nameref_parameter(mbfl_RV,    2, reference to the result variable)
    mbfl_stack_size_var _(mbfl_RV) _(mbfl_STACK)
}

#!# end of file
# Local Variables:
# mode: sh
# End:
