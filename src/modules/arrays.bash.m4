# arrays.sh.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: utilities for arrays
# Date: Nov 15, 2018
#
# Abstract
#
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


#### array inspection

function mbfl_array_is_empty () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRAY_VARREF, 1, array variable name)
    if ((0 == mbfl_slots_number(mbfl_ARRAY_VARREF)))
    then return 0
    else return 1
    fi
}

function mbfl_array_is_not_empty () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRAY_VARREF, 1, array variable name)
    if ((0 != mbfl_slots_number(mbfl_ARRAY_VARREF)))
    then return 0
    else return 1
    fi
}

function mbfl_array_length_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_nameref_parameter(mbfl_ARRAY_VARREF,  2, array variable name)
    mbfl_RESULT_VARREF=mbfl_slots_number(mbfl_ARRAY_VARREF)
}

function mbfl_array_length () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRAY_VARREF, 1, array variable name)
    echo mbfl_slots_number(mbfl_ARRAY_VARREF)
}

function mbfl_array_contains () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRAY_VARREF, 1, array variable name)
    mbfl_mandatory_parameter(mbfl_KEY, 2, the key to search for)
    test -v mbfl_slot_spec(mbfl_ARRAY_VARREF, $mbfl_KEY)
}

function mbfl_array_contains_value_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,	1, reference to result variable)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,	2, reference to array variable to inspect)
    mbfl_mandatory_parameter(mbfl_ELEMENT,	3, element parameter)
    local mbfl_KEY

    for mbfl_KEY in mbfl_slots_qkeys(mbfl_ARRY)
    do
	if mbfl_string_equal mbfl_slot_qref(mbfl_ARRY, $mbfl_KEY) "$mbfl_ELEMENT"
	then
	    mbfl_RV=$mbfl_KEY
	    return_because_success
	fi
    done
    return_because_failure
}

function mbfl_array_contains_all_keys () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,	1, reference to array variable to inspect)
    mbfl_mandatory_nameref_parameter(mbfl_KEYS,	2, reference to index array holding the keys)
    declare -i mbfl_I mbfl_NUM=mbfl_slots_number(mbfl_KEYS)

    for ((mbfl_I=0; mbfl_I < mbfl_NUM; ++mbfl_I))
    do
	if ! test -v mbfl_slot_spec(mbfl_ARRY, mbfl_slot_ref(mbfl_KEYS,mbfl_I))
	then return_because_failure
	fi
    done
    return_success
}


#### array manipulation

function mbfl_array_copy () {
    mbfl_mandatory_nameref_parameter(mbfl_DST, 1, destination array variable)
    mbfl_mandatory_nameref_parameter(mbfl_SRC, 2, source array variable)

    local mbfl_KEY
    for mbfl_KEY in "${!mbfl_SRC[@]}"
    do mbfl_slot_set(mbfl_DST, "$mbfl_KEY", mbfl_slot_ref(mbfl_SRC, "$mbfl_KEY"))
    done
}


#### debugging

function mbfl_array_dump () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,	1, reference to array variable)
    mbfl_optional_parameter(mbfl_NAME,		2)
    if mbfl_string_empty(mbfl_NAME)
    then mbfl_NAME=$1
    fi
    local mbfl_KEY
    {
	for mbfl_KEY in mbfl_slots_qkeys(mbfl_ARRY)
	do printf '%s[%s]="%s"\n' "$mbfl_NAME" "$mbfl_KEY" mbfl_slot_qref(mbfl_ARRY,"$mbfl_KEY")
	done
    } >&2
}


### end of file
# Local Variables:
# mode: sh
# End:
