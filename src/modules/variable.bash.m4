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
# Copyright (c) 2004-2005, 2009, 2013, 2018, 2020, 2023 Marco Maggi
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
    mbfl_mandatory_parameter(mbfl_ELEMENT, 1, element parameter)
    local -i mbfl_I mbfl_ARRAY_DIM=mbfl_slots_number(mbfl_FIELDS)

    for ((mbfl_I=0; mbfl_I < mbfl_ARRAY_DIM; ++mbfl_I))
    do
	if mbfl_string_equal "$mbfl_ELEMENT" mbfl_slot_qref(mbfl_FIELDS, $mbfl_I)
	then
	    echo $mbfl_I
	    return_because_success
	fi
    done
    return_because_failure
}
function mbfl_variable_element_is_in_array () {
    local mbfl_POS
    mbfl_POS=$(mbfl_variable_find_in_array "$@")
}

function mbfl_variable_colon_variable_to_array () {
    mbfl_mandatory_parameter(COLON_VARIABLE, 1, colon variable)
    # Here we NEED to save IFS, else it will be left set to ":".
    local mbfl_ORGIFS=$IFS
    IFS=: mbfl_FIELDS=(${!COLON_VARIABLE})
    IFS=$mbfl_ORGIFS

# The  following is  an  old version.   It  passed the  test
# suite.  I am keeping it here just in case.
#
#     local mbfl_ORGIFS=${IFS} item count=0
#     IFS=:
#     for item in ${!COLON_VARIABLE} ; do
# 	IFS=${mbfl_ORGIFS}
# 	mbfl_FIELDS[${count}]=${item}
# 	let ++count
#     done
#     IFS=${mbfl_ORGIFS}
    return 0
}
function mbfl_variable_array_to_colon_variable () {
    mbfl_mandatory_parameter(COLON_VARIABLE, 1, colon variable)
    local -i i mbfl_DIMENSION=mbfl_slots_number(mbfl_FIELDS)

    if test $mbfl_DIMENSION = 0
    then eval $COLON_VARIABLE=
    else
	eval ${COLON_VARIABLE}=\'"mbfl_slot_ref(mbfl_FIELDS, 0)"\'
	for ((i=1; $i < $mbfl_DIMENSION; ++i))
        do eval $COLON_VARIABLE=\'"${!COLON_VARIABLE}:mbfl_slot_ref(mbfl_FIELDS, $i)"\'
	done
    fi
    return 0
}
function mbfl_variable_colon_variable_drop_duplicate () {
    mbfl_mandatory_parameter(COLON_VARIABLE, 1, colon variable)
    local mbfl_ITEM
    mbfl_declare_index_array(mbfl_FIELDS)
    mbfl_declare_index_array(FIELDS)
    local -i mbfl_DIMENSION mbfl_COUNT i

    mbfl_variable_colon_variable_to_array "$COLON_VARIABLE"
    mbfl_DIMENSION=mbfl_slots_number(mbfl_FIELDS)

    FIELDS=("mbfl_slot_ref(mbfl_FIELDS, @)")
    mbfl_FIELDS=()

    for ((i=0, mbfl_COUNT=0; i < mbfl_DIMENSION; ++i))
    do
	mbfl_ITEM=mbfl_slot_ref(FIELDS, $i)
	if mbfl_variable_element_is_in_array "$mbfl_ITEM"
	then continue
	fi
	mbfl_FIELDS[$mbfl_COUNT]=$mbfl_ITEM
	let ++mbfl_COUNT
    done

    mbfl_variable_array_to_colon_variable $COLON_VARIABLE
    return 0
}


#### variables allocation

# FIXME DAMMIT!!!  This  is "wrong": "test -v" will  return true only if the variable  has been set,
# not if  the variable has just  been declared.  This makes  it improbably possible to  generate two
# equal identifiers.
#
function mbfl_variable_alloc () {
    mbfl_mandatory_nameref_parameter(_mbfl___RV, 1, result variable)
    mbfl_optional_parameter(_mbfl___STEM, 2)

    _mbfl___RV=mbfl_u_variable_${_mbfl___STEM}${RANDOM}
    while test -v $_mbfl___RV
    do _mbfl___RV=mbfl_u_variable_${_mbfl___STEM}${RANDOM}
    done
    #echo $FUNCNAME $_mbfl___RV >&2
    return 0
}

# declare -i MBFL_VARIABLE_COUNTER=0

# function mbfl_variable_alloc () {
#     mbfl_mandatory_nameref_parameter(_mbfl___RV, 1, result variable)
#     printf -v _mbfl___RV 'mbfl_u_variable_%d' $MBFL_VARIABLE_COUNTER
#     printf '%s\n' $_mbfl___RV >&2
#     let ++MBFL_VARIABLE_COUNTER
# }

### end of file
# Local Variables:
# mode: sh
# End:
