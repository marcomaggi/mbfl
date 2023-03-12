# struct.bash.m4 --
#
# Part of: Marco's BASH functions library
# Contents: data structures module
# Date: Mar 12, 2023
#
# Abstract
#
#	Simple data structures implementation on top of index arrays.
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

m4_define([[[_]]],[[[mbfl_datavar([[[$1]]])]]])


#### data structure type definition

function mbfl_struct_define_type () {
    mbfl_mandatory_parameter(mbfl_TYPE_NAME, 1, reference variable to the struct array)
    shift
    local -ar mbfl_FIELD_NAMES=("$@")
    local mbfl_FIELD_NAME
    local mbfl_CONSTRUCTOR_BODY mbfl_PREDICATE_BODY mbfl_ACCESSOR_BODY mbfl_MUTATOR_BODY
    local mbfl_CONSTRUCTOR_NAME mbfl_PREDICATE_NAME mbfl_ACCESSOR_NAME mbfl_MUTATOR_NAME
    local -i mbfl_KEY_COUNT=1 mbfl_PARAMETER_COUNT=2

    printf -v mbfl_CONSTRUCTOR_NAME '%s_init' "$mbfl_TYPE_NAME"
    printf -v mbfl_PREDICATE_NAME   '%s?'     "$mbfl_TYPE_NAME"

    mbfl_CONSTRUCTOR_BODY='{ '
    mbfl_CONSTRUCTOR_BODY+="local -n mbfl_STRU=\${1:?\"missing reference to struct '$mbfl_TYPE_NAME' variable parameter to '\$FUNCNAME'\"};"
    mbfl_CONSTRUCTOR_BODY+="mbfl_STRU[0]=$mbfl_TYPE_NAME;"

    for mbfl_FIELD_NAME in mbfl_slots_qvalues(mbfl_FIELD_NAMES)
    do
	printf -v mbfl_MUTATOR_NAME  '%s_%s_set' "$mbfl_TYPE_NAME" "$mbfl_FIELD_NAME"
	printf -v mbfl_ACCESSOR_NAME '%s_%s_ref' "$mbfl_TYPE_NAME" "$mbfl_FIELD_NAME"

	# Add a field initialisation to the Constructor.
	{
	    mbfl_CONSTRUCTOR_BODY+="mbfl_STRU[$mbfl_KEY_COUNT]=\${$mbfl_PARAMETER_COUNT:?"
	    mbfl_CONSTRUCTOR_BODY+="\"missing field value parameter '$mbfl_FIELD_NAME' to '\$FUNCNAME'\"};"
	}
	# Define the field mutator.
	{
	    mbfl_MUTATOR_BODY='{ '
	    mbfl_MUTATOR_BODY+="local -n mbfl_STRU=\${1:?\"missing reference to struct '$mbfl_TYPE_NAME' parameter to '\$FUNCNAME'\"};"
	    mbfl_MUTATOR_BODY+="mbfl_STRU[$mbfl_KEY_COUNT]=\${2:?\"missing field value parameter to '\$FUNCNAME'\"};"
	    mbfl_MUTATOR_BODY+='}'
	    mbfl_p_struct_make_function "$mbfl_MUTATOR_NAME" "$mbfl_MUTATOR_BODY"
	}
	# Define the field accessor.
	{
	    mbfl_ACCESSOR_BODY='{ '
	    mbfl_ACCESSOR_BODY+="local -n mbfl_STRU=\${1:?\"missing reference to struct '$mbfl_TYPE_NAME' parameter to '\$FUNCNAME'\"};"
	    mbfl_ACCESSOR_BODY+="local -n mbfl_RV=\${2:?\"missing result variable parameter to '\$FUNCNAME'\"};"
	    mbfl_ACCESSOR_BODY+="mbfl_RV=\${mbfl_STRU[$mbfl_KEY_COUNT]};"
	    mbfl_ACCESSOR_BODY+='}'
	    mbfl_p_struct_make_function "$mbfl_ACCESSOR_NAME" "$mbfl_ACCESSOR_BODY"
	}

	let ++mbfl_KEY_COUNT ++mbfl_PARAMETER_COUNT
    done

    mbfl_CONSTRUCTOR_BODY+='}'
    mbfl_p_struct_make_function "$mbfl_CONSTRUCTOR_NAME" "$mbfl_CONSTRUCTOR_BODY"

    # Define the predicate function.
    {
	local mbfl_PREDICATE_BODY="{ local -n mbfl_STRU=\${1:?\"missing struct '$mbfl_TYPE_NAME' variable parameter to '\$FUNCNAME'\"};"
	mbfl_PREDICATE_BODY+="test '$mbfl_TYPE_NAME' = \"\${mbfl_STRU[0]}\"; }"
	mbfl_p_struct_make_function "$mbfl_PREDICATE_NAME" "$mbfl_PREDICATE_BODY"
    }
}

function mbfl_struct_make () {
    mbfl_mandatory_parameter(mbfl_TYPE,  1, data structure type descriptor)
    mbfl_mandatory_nameref_parameter(mbfl_STRU, 2, variable referencing a data structure)
    shift 2
    local mbfl_CONSTRUCTOR_NAME
    printf -v mbfl_CONSTRUCTOR_NAME '%s_init' "$mbfl_TYPE"
    "$mbfl_CONSTRUCTOR_NAME" _(mbfl_STRU) "$@"
}
function mbfl_struct_is_a () {
    mbfl_mandatory_nameref_parameter(mbfl_STRU, 1, variable referencing a data structure)
    mbfl_mandatory_parameter(mbfl_TYPE,  2, data structure type descriptor)
    test -v _(mbfl_STRU) -a -v mbfl_slot_spec(mbfl_STRU, 0) -a "$mbfl_TYPE" '=' mbfl_slot_qref(mbfl_STRU,0)
}


#### helper functions

function mbfl_p_struct_make_function () {
    mbfl_mandatory_parameter(mbfl_FUNCNAME, 1, function name)
    mbfl_mandatory_parameter(mbfl_BODY,     2, function body)
    #echo function "$mbfl_FUNCNAME" '()' "$mbfl_BODY"; echo
    eval function "$mbfl_FUNCNAME" '()' "$mbfl_BODY"
}

### end of file
# Local Variables:
# mode: sh
# End:
