# variable.sh.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: variable manipulation functions
# Date: Thu Oct  7, 2004
#
# Abstract
#
#
#
# Copyright (c) 2004-2005, 2009, 2013, 2018, 2020 Marco Maggi
# <mrc.mgg@gmail.com>
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


function mbfl_variable_find_in_array () {
    mbfl_mandatory_parameter(ELEMENT, 1, element parameter)
    local -i i ARRAY_DIM=mbfl_slots_number(mbfl_FIELDS)
    for ((i=0; i < ARRAY_DIM; ++i))
    do
	if mbfl_string_equal "mbfl_slot_ref(mbfl_FIELDS, $i)" "$ELEMENT"
	then
	    printf '%d\n' $i
	    return 0
	fi
    done
    return 1
}
function mbfl_variable_element_is_in_array () {
    local pos
    pos=$(mbfl_variable_find_in_array "$@")
}

function mbfl_variable_colon_variable_to_array () {
    mbfl_mandatory_parameter(COLON_VARIABLE, 1, colon variable)
    # Here we NEED to save IFS, else it will be left set to ":".
    local ORGIFS=$IFS
    IFS=: mbfl_FIELDS=(${!COLON_VARIABLE})
    IFS=$ORGIFS

# The  following is  an  old version.   It  passed the  test
# suite.  I am keeping it here just in case.
#
#     local ORGIFS=${IFS} item count=0
#     IFS=:
#     for item in ${!COLON_VARIABLE} ; do
# 	IFS=${ORGIFS}
# 	mbfl_FIELDS[${count}]=${item}
# 	let ++count
#     done
#     IFS=${ORGIFS}
    return 0
}
function mbfl_variable_array_to_colon_variable () {
    mbfl_mandatory_parameter(COLON_VARIABLE, 1, colon variable)
    local -i i dimension=mbfl_slots_number(mbfl_FIELDS)

    if test $dimension = 0
    then eval $COLON_VARIABLE=
    else
	eval ${COLON_VARIABLE}=\'"mbfl_slot_ref(mbfl_FIELDS, 0)"\'
	for ((i=1; $i < $dimension; ++i))
        do eval $COLON_VARIABLE=\'"${!COLON_VARIABLE}:mbfl_slot_ref(mbfl_FIELDS, $i)"\'
	done
    fi
    return 0
}
function mbfl_variable_colon_variable_drop_duplicate () {
    mbfl_mandatory_parameter(COLON_VARIABLE, 1, colon variable)
    local item
    mbfl_local_numeric_array(mbfl_FIELDS)
    mbfl_local_numeric_array(FIELDS)
    local -i dimension count i

    mbfl_variable_colon_variable_to_array "$COLON_VARIABLE"
    dimension=mbfl_slots_number(mbfl_FIELDS)

    FIELDS=("mbfl_slot_ref(mbfl_FIELDS, @)")
    mbfl_FIELDS=()

    for ((i=0, count=0; i < dimension; ++i))
    do
	item=mbfl_slot_ref(FIELDS, $i)
	if mbfl_variable_element_is_in_array "$item"
	then continue
	fi
	mbfl_FIELDS[$count]=$item
	let ++count
    done

    mbfl_variable_array_to_colon_variable $COLON_VARIABLE
    return 0
}


#### variables allocation

function mbfl_variable_alloc () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable)
    local mbfl_NAME

    while true
    do
	mbfl_NAME=mbfl_u_variable_${RANDOM}
	# How do we test if there is a collision  with variable names?  We test the name as a scalar
	# variable name and verify its string length, then we  test the name as an array name and we
	# verify its number of slots.  For some reason I cannot make:
	#
	#    test -v $mbfl_NAME
	#
	# work (Marco Maggi; Nov 19, 2020).
	local -n mbfl_REF=$mbfl_NAME
	if ((0 == mbfl_string_len(mbfl_REF) && 0 == mbfl_slots_number(mbfl_REF)))
	then break
	fi
    done
    mbfl_RESULT_VARREF=$mbfl_NAME
    return 0
}

### end of file
# Local Variables:
# mode: sh
# End:
