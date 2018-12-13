# variables.test --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for the variable manipulation functions
# Date: Wed Apr 23, 2003
#
# Abstract
#
#	To select the tests in this file:
#
#		$ make all test file=variables
#
# Copyright (c) 2004, 2005, 2013, 2018 Marco Maggi
# <marco.maggi-ipsu@poste.it>
#
# This is free software; you  can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the
# Free Software Foundation; either version 3 of the License, or (at your
# option) any later version.
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

#PAGE
#### setup

source setup.sh

#page
#### array variables

function variable-find-in-array-1.1 () {
    declare -a mbfl_FIELDS=(abc def ghi lmn)

    mbfl_variable_find_in_array abc mbfl_FIELDS | dotest-output 0
}
function variable-find-in-array-1.2 () {
    declare -a mbfl_FIELDS=(abc def ghi lmn)

    mbfl_variable_find_in_array def mbfl_FIELDS | dotest-output 1
}
function variable-find-in-array-1.3 () {
    declare -a mbfl_FIELDS=(abc def ghi lmn)

    mbfl_variable_find_in_array lmn mbfl_FIELDS | dotest-output 3
}
function variable-find-in-array-1.4 () {
    declare -a mbfl_FIELDS=("abc 123" def ghi lmn)

    mbfl_variable_find_in_array gasp mbfl_FIELDS | dotest-output
}

function variable-find-in-array-2.1 () {
    declare -a mbfl_FIELDS=(abc def ghi lmn)
    mbfl_variable_element_is_in_array abc
}

### ------------------------------------------------------------------------

function variable-element-is-in-array-1.1 () {
    declare -a mbfl_FIELDS=(abc def ghi lmn)
    mbfl_variable_element_is_in_array lmn
}
function variable-element-is-in-array-1.2 () {
    declare -a mbfl_FIELDS=(abc def ghi lmn)
    ! mbfl_variable_element_is_in_array gasp
}

#page
#### colon variables

function variable-colon-variable-to-array-1.1 () {
    local v=a:b:c:d:e
    local -a mbfl_FIELDS

    mbfl_variable_colon_variable_to_array v
    dotest-equal 5 "${#mbfl_FIELDS[*]}" && \
	dotest-equal a "${mbfl_FIELDS[0]}" && \
	dotest-equal b "${mbfl_FIELDS[1]}" && \
	dotest-equal c "${mbfl_FIELDS[2]}" && \
	dotest-equal d "${mbfl_FIELDS[3]}" && \
	dotest-equal e "${mbfl_FIELDS[4]}"
}
function variable-colon-variable-to-array-1.2 () {
    local v
    local -a mbfl_FIELDS=(a b c d e)

    mbfl_variable_array_to_colon_variable v
    dotest-equal a:b:c:d:e $v
}
### ------------------------------------------------------------------------

function variable-colon-variable-to-array-2.1 () {
    local v=a:b:c:b:d:e:e

    mbfl_variable_colon_variable_drop_duplicate v
    dotest-equal a:b:c:d:e $v
}

#page
#### variables allocation

function variable-alloc-1.1 () {
    local NAME
    mbfl_variable_alloc NAME
    local -n NAMEREF=$NAME

    NAMEREF=123
    dotest-equal 123 ${!NAME}
}

#page
#### local variable references, simple variables

# Local varref, no init value, no attributes.  Variable set and ref.
#
function varref-local-simple-1.1 () {
    mbfl_local_varref(VAR)

    VAR=123
    dotest-equal 123 "$VAR"
}

# Local varref, init value, no attributes.  Variable set and ref.
#
function varref-local-simple-1.2 () {
    mbfl_local_varref(VAR,, -i)

    VAR=123
    dotest-equal 123 "$VAR"
}

# Local varref, init value, attributes.  Variable set and ref.
#
function varref-local-simple-1.3 () {
    mbfl_local_varref(VAR, 123, -i)

    dotest-equal 123 "$VAR"
}

# Local varref, init value, no attributes.  Variable set and ref.
#
function varref-local-simple-1.4 () {
    mbfl_local_varref(VAR, 123)

    dotest-equal 123 "$VAR"
}

### ------------------------------------------------------------------------

# Local varref, no init value, no attributes.  Variable set and ref in a
# sub-function.
#
function varref-local-simple-2.1 () {
    mbfl_local_varref(VAR)
    local RV

    worker-varref-local-simple-2.1 mbfl_datavar(VAR) RV

    dotest-equal 123 "$RV" && dotest-equal 123 "$VAR"
}
function worker-varref-local-simple-2.1 () {
    mbfl_mandatory_nameref_parameter(VAR, 1, variable reference)
    mbfl_mandatory_nameref_parameter(RV, 2, result variable reference)

    #dotest-set-debug
    dotest-debug "VARNAME=$1 VAR=$VAR"

    VAR=123
    RV="$VAR"
}

#page
#### local variable references, array variables

# Local varref, no init value, no attributes.  Variable set and ref.
#
function varref-local-array-1.1 () {
    mbfl_local_varref(VAR)

    VAR[KEY]=123
    dotest-equal 123 "${VAR[KEY]}"
}

# Local varref, init value, no attributes.  Variable set and ref.
#
function varref-local-array-1.2 () {
    mbfl_local_varref(VAR,, -A)

    VAR[KEY]=123
    dotest-equal 123 "${VAR[KEY]}"
}

### ------------------------------------------------------------------------

# Local varref, no init value, no attributes.  Variable set and ref in a
# sub-function.
#
function varref-local-array-2.1 () {
    mbfl_local_varref(VAR)
    local RV

    worker-varref-local-array-2.1 mbfl_datavar(VAR) RV

    dotest-equal 123 "$RV" && dotest-equal 123 "${VAR[KEY]}"
}
function worker-varref-local-array-2.1 () {
    mbfl_mandatory_nameref_parameter(VAR, 1, variable reference)
    mbfl_mandatory_nameref_parameter(RV, 2, result variable reference)

    #dotest-set-debug
    dotest-debug "VARNAME=$1 VAR=$VAR"

    VAR[KEY]=123
    RV="${VAR[KEY]}"
}

### ------------------------------------------------------------------------

# Local  varref, no  init value,  no attributes.   Variable set  in the
# uplevel function, lower level function.
#
function varref-local-array-2.2 () {
    mbfl_local_varref(VAR)
    local RV

    VAR[KEY]=123
    worker-varref-local-array-2.2 mbfl_datavar(VAR) RV

    dotest-equal 123 "$RV" && dotest-equal 123 "${VAR[KEY]}"
}
function worker-varref-local-array-2.2 () {
    mbfl_mandatory_nameref_parameter(VAR, 1, variable reference)
    mbfl_mandatory_nameref_parameter(RV, 2, result variable reference)

    #dotest-set-debug
    dotest-debug "VARNAME=$1 VAR=$VAR"

    RV="${VAR[KEY]}"
}

### ------------------------------------------------------------------------

# Local varref, no init value,  associative array attribute.  A value of
# the array is itself  a local varref.  Another value of  the array is a
# simple value.
#
function varref-local-array-3.1 () {
    mbfl_local_varref(ARRY,,-A)
    mbfl_local_varref(VAR)
    local RV1 RV2

    ARRY[KEY]=mbfl_datavar(VAR)
    ARRY[VAL]=456
    worker-varref-local-array-3.1 mbfl_datavar(ARRY) RV1 RV2

    dotest-equal 123 "$VAR" && \
	dotest-equal 456 "${ARRY[VAL]}" && \
	dotest-equal 123 "$RV1" && \
	dotest-equal 456 "$RV2"
}
function worker-varref-local-array-3.1 () {
    mbfl_mandatory_nameref_parameter(VAR, 1, variable reference)
    mbfl_mandatory_nameref_parameter(RV1, 2, result variable reference)
    mbfl_mandatory_nameref_parameter(RV2, 3, result variable reference)
    local -n VAR=${ARRY[KEY]}

    #dotest-set-debug
    dotest-debug "VARNAME=$1 ARRY[KEY]=${ARRY[KEY]}"
    VAR=123
    RV1=$VAR
    RV2=${ARRY[VAL]}
}

### ------------------------------------------------------------------------

# Local varref, no init value, array attribute.  A value of the array is
# itself a local varref.  Another value of the array is a simple value.
#
function varref-local-array-3.2 () {
    mbfl_local_index_array_varref(ARRY)
    mbfl_local_varref(VAR)
    local RV1 RV2

    ARRY[1]=mbfl_datavar(VAR)
    ARRY[2]=456
    worker-varref-local-array-3.2 mbfl_datavar(ARRY) RV1 RV2

    dotest-equal 123 "$VAR" && \
	dotest-equal 456 "${ARRY[2]}" && \
	dotest-equal 123 "$RV1" && \
	dotest-equal 456 "$RV2"
}
function worker-varref-local-array-3.2 () {
    mbfl_mandatory_nameref_parameter(VAR, 1, variable reference)
    mbfl_mandatory_nameref_parameter(RV1, 2, result variable reference)
    mbfl_mandatory_nameref_parameter(RV2, 3, result variable reference)
    local -n VAR=${ARRY[1]}

    #dotest-set-debug
    dotest-debug "VARNAME=$1 ARRY[1]=${ARRY[1]}"
    VAR=123
    RV1=$VAR
    RV2=${ARRY[2]}
}

#page
#### global variable references, simple variables

# Global varref, no init value, no attributes.  Variable set and ref.
#
function varref-global-simple-1.1 () {
    mbfl_global_varref(VAR)

    VAR=123
    dotest-equal 123 "$VAR"
}

# Global varref, init value, no attributes.  Variable set and ref.
#
function varref-global-simple-1.2 () {
    mbfl_global_varref(VAR,, -i)

    VAR=123
    dotest-equal 123 "$VAR"
}

# Global varref, init value, attributes.  Variable set and ref.
#
function varref-global-simple-1.3 () {
    mbfl_global_varref(VAR, 123, -i)

    dotest-equal 123 "$VAR"
}

# Global varref, init value, no attributes.  Variable set and ref.
#
function varref-global-simple-1.4 () {
    mbfl_global_varref(VAR, 123)

    dotest-equal 123 "$VAR"
}

### ------------------------------------------------------------------------

# Global varref, no init value, no attributes.  Variable set and ref in a
# sub-function.
#
function varref-global-simple-2.1 () {
    mbfl_global_varref(VAR)
    local RV

    worker-varref-global-simple-2.1 mbfl_datavar(VAR) RV

    dotest-equal 123 "$RV" && dotest-equal 123 "$VAR"
}
function worker-varref-global-simple-2.1 () {
    mbfl_mandatory_nameref_parameter(VAR, 1, variable reference)
    mbfl_mandatory_nameref_parameter(RV, 2, result variable reference)

    #dotest-set-debug
    dotest-debug "VARNAME=$1 VAR=$VAR"

    VAR=123
    RV="$VAR"
}

#page
#### global variable references, array variables

# Global varref, no init value, no attributes.  Variable set and ref.
#
function varref-global-array-1.1 () {
    mbfl_global_varref(VAR)

    VAR[KEY]=123
    dotest-equal 123 "${VAR[KEY]}"
}

# Global varref, init value, no attributes.  Variable set and ref.
#
function varref-global-array-1.2 () {
    mbfl_global_varref(VAR,, -A)

    VAR[KEY]=123
    dotest-equal 123 "${VAR[KEY]}"
}

### ------------------------------------------------------------------------

# Global varref, no init value, no attributes.  Variable set and ref in a
# sub-function.
#
function varref-global-array-2.1 () {
    mbfl_global_varref(VAR)
    local RV

    worker-varref-global-array-2.1 mbfl_datavar(VAR) RV

    dotest-equal 123 "$RV" && dotest-equal 123 "${VAR[KEY]}"
}
function worker-varref-global-array-2.1 () {
    mbfl_mandatory_nameref_parameter(VAR, 1, variable reference)
    mbfl_mandatory_nameref_parameter(RV, 2, result variable reference)

    #dotest-set-debug
    dotest-debug "VARNAME=$1 VAR=$VAR"

    VAR[KEY]=123
    RV="${VAR[KEY]}"
}

### ------------------------------------------------------------------------

# Global  varref, no  init value,  no attributes.   Variable set  in the
# uplevel function, lower level function.
#
function varref-global-array-2.2 () {
    mbfl_global_varref(VAR)
    local RV

    VAR[KEY]=123
    worker-varref-global-array-2.2 mbfl_datavar(VAR) RV

    dotest-equal 123 "$RV" && dotest-equal 123 "${VAR[KEY]}"
}
function worker-varref-global-array-2.2 () {
    mbfl_mandatory_nameref_parameter(VAR, 1, variable reference)
    mbfl_mandatory_nameref_parameter(RV, 2, result variable reference)

    #dotest-set-debug
    dotest-debug "VARNAME=$1 VAR=$VAR"

    RV="${VAR[KEY]}"
}

### ------------------------------------------------------------------------

# Global varref, no init value,  associative array attribute.  A value of
# the array is itself  a global varref.  Another value of  the array is a
# simple value.
#
function varref-global-array-3.1 () {
    mbfl_global_varref(ARRY,,-A)
    mbfl_global_varref(VAR)
    local RV1 RV2

    ARRY[KEY]=mbfl_datavar(VAR)
    ARRY[VAL]=456
    worker-varref-global-array-3.1 mbfl_datavar(ARRY) RV1 RV2

    dotest-equal 123 "$VAR" && \
	dotest-equal 456 "${ARRY[VAL]}" && \
	dotest-equal 123 "$RV1" && \
	dotest-equal 456 "$RV2"
}
function worker-varref-global-array-3.1 () {
    mbfl_mandatory_nameref_parameter(VAR, 1, variable reference)
    mbfl_mandatory_nameref_parameter(RV1, 2, result variable reference)
    mbfl_mandatory_nameref_parameter(RV2, 3, result variable reference)
    local -n VAR=${ARRY[KEY]}

    #dotest-set-debug
    dotest-debug "VARNAME=$1 ARRY[KEY]=${ARRY[KEY]}"
    VAR=123
    RV1=$VAR
    RV2=${ARRY[VAL]}
}

### ------------------------------------------------------------------------

# Global varref, no init value, array attribute.  A value of the array is
# itself a global varref.  Another value of the array is a simple value.
#
function varref-global-array-3.2 () {
    mbfl_global_index_array_varref(ARRY)
    mbfl_global_varref(VAR)
    local RV1 RV2

    ARRY[1]=mbfl_datavar(VAR)
    ARRY[2]=456
    worker-varref-global-array-3.2 mbfl_datavar(ARRY) RV1 RV2

    dotest-equal 123 "$VAR" && \
	dotest-equal 456 "${ARRY[2]}" && \
	dotest-equal 123 "$RV1" && \
	dotest-equal 456 "$RV2"
}
function worker-varref-global-array-3.2 () {
    mbfl_mandatory_nameref_parameter(VAR, 1, variable reference)
    mbfl_mandatory_nameref_parameter(RV1, 2, result variable reference)
    mbfl_mandatory_nameref_parameter(RV2, 3, result variable reference)
    local -n VAR=${ARRY[1]}

    #dotest-set-debug
    dotest-debug "VARNAME=$1 ARRY[1]=${ARRY[1]}"
    VAR=123
    RV1=$VAR
    RV2=${ARRY[2]}
}

#page
#### unsetting nameref variables

function varref-unset-1.1 () {
    mbfl_local_varref(VAR, 123)
    local VAR_VAL=$VAR
    local VAR_NAM=mbfl_datavar(VAR)

    mbfl_unset_varref(VAR)

    dotest-equal '' "$VAR" && \
	dotest-equal '' $(eval \$"$VAR_NAM")
}

function varref-unset-2.1 () {
    mbfl_global_varref(VAR, 123)
    local VAR_VAL=$VAR
    local VAR_NAM=mbfl_datavar(VAR)

    mbfl_unset_varref(VAR)

    dotest-equal '' "$VAR" && \
	dotest-equal '' $(eval \$"$VAR_NAM")
}

### ------------------------------------------------------------------------

# Unsetting the data variable using locations.
#
function varref-unset-3.1 () {
    mbfl_global_varref(VAR, 123)
    local RV

    mbfl_location_enter
    {
        mbfl_location_handler "unset -v mbfl_datavar(VAR)"

	RV=$VAR
    }
    mbfl_location_leave

    dotest-equal 123 "$RV" && dotest-equal '' $VAR
}

#page
#### NAMEREF variables, generation in sub-function

function varref-sub-generation-1.1 () {
    local VARNAME

    worker-varref-sub-generation-1.1 VARNAME
    mbfl_local_nameref(VAR, $VARNAME)

    dotest-equal 123 "$VAR"
    mbfl_unset_varref(VAR)
}
function worker-varref-sub-generation-1.1 () {
    mbfl_mandatory_nameref_parameter(RV, 1, result variable name)
    mbfl_global_varref(VAR, 123)

    RV=mbfl_datavar(VAR)
}

#page
#### let's go

dotest variable-
dotest varref-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
