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
# Copyright (c) 2004-2005, 2009 Marco Maggi <marcomaggi@gna.org>
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

#page
function mbfl_variable_find_in_array () {
    mandatory_parameter(ELEMENT, 1, element parameter)
    declare -i i ARRAY_DIM=${#mbfl_FIELDS[*]}
    for ((i=0; $i < ${ARRAY_DIM}; ++i))
    do test "${mbfl_FIELDS[$i]}" = "${ELEMENT}" && { printf "$i\n"; return 0; }
    done
    return 1
}
function mbfl_variable_element_is_in_array () {
    local pos
    pos=$(mbfl_variable_find_in_array "$@")
}
#page
function mbfl_variable_colon_variable_to_array () {
    mandatory_parameter(COLON_VARIABLE, 1, colon variable)
    local ORGIFS="${IFS}"
    IFS=: mbfl_FIELDS=(${!COLON_VARIABLE})
    IFS="${ORGIFS}"

# The  following is  an  old version.   It  passed the  test
# suite.  I am keeping it here just in case.
#
#     local ORGIFS="${IFS}" item count=0
#     IFS=:
#     for item in ${!COLON_VARIABLE} ; do
# 	IFS="${ORGIFS}"
# 	mbfl_FIELDS[${count}]="${item}"
# 	let ++count
#     done
#     IFS="${ORGIFS}"
    return 0
}
function mbfl_variable_array_to_colon_variable () {
    mandatory_parameter(COLON_VARIABLE, 1, colon variable)
    declare -i i dimension=${#mbfl_FIELDS[*]}

    if test ${dimension} = 0
    then eval ${COLON_VARIABLE}=
    else
	eval ${COLON_VARIABLE}=\'"${mbfl_FIELDS[0]}"\'
	for ((i=1; $i < ${dimension}; ++i))
        do eval ${COLON_VARIABLE}=\'"${!COLON_VARIABLE}:${mbfl_FIELDS[$i]}"\'
	done
    fi
    return 0
}
function mbfl_variable_colon_variable_drop_duplicate () {
    mandatory_parameter(COLON_VARIABLE, 1, colon variable)
    local item
    declare -a mbfl_FIELDS FIELDS
    declare -i dimension count i

    mbfl_variable_colon_variable_to_array "${COLON_VARIABLE}"
    dimension=${#mbfl_FIELDS[*]}

    FIELDS=("${mbfl_FIELDS[@]}")
    mbfl_FIELDS=()

    for ((i=0, count=0; $i < ${dimension}; ++i))
    do
	item="${FIELDS[$i]}"
	mbfl_variable_element_is_in_array "${item}" && continue
	mbfl_FIELDS[${count}]="${item}"
	let ++count
    done

    mbfl_variable_array_to_colon_variable ${COLON_VARIABLE}
    return 0
}

### end of file
# Local Variables:
# mode: sh
# End:
