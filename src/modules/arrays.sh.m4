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


#### array manipulation

function mbfl_array_copy () {
    mbfl_mandatory_nameref_parameter(DST, 1, destination array variable)
    mbfl_mandatory_nameref_parameter(SRC, 2, source array variable)

    local KEY
    for KEY in "${!SRC[@]}"
    do mbfl_slot_set(DST, "$KEY", mbfl_slot_ref(SRC, "$KEY"))
    done
}


### end of file
# Local Variables:
# mode: sh
# End:
