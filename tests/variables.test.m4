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
# Copyright (c) 2004, 2005, 2013, 2018, 2020, 2023 Marco Maggi
# <mrc.mgg@gmail.com>
#
# The author hereby  grants permission to use,  copy, modify, distribute, and  license this software
# and its documentation  for any purpose, provided  that existing copyright notices  are retained in
# all copies and that this notice is  included verbatim in any distributions.  No written agreement,
# license,  or royalty  fee is  required for  any  of the  authorized uses.   Modifications to  this
# software may  be copyrighted by their  authors and need  not follow the licensing  terms described
# here, provided that the new terms are clearly indicated  on the first page of each file where they
# apply.
#
# IN NO EVENT SHALL THE AUTHOR OR DISTRIBUTORS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL,
# INCIDENTAL, OR CONSEQUENTIAL DAMAGES  ARISING OUT OF THE USE OF  THIS SOFTWARE, ITS DOCUMENTATION,
# OR ANY  DERIVATIVES THEREOF,  EVEN IF  THE AUTHOR  HAVE BEEN  ADVISED OF  THE POSSIBILITY  OF SUCH
# DAMAGE.
#
# THE AUTHOR AND  DISTRIBUTORS SPECIFICALLY DISCLAIM ANY WARRANTIES, INCLUDING,  BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.
# THIS  SOFTWARE IS  PROVIDED  ON AN  \"AS  IS\" BASIS,  AND  THE AUTHOR  AND  DISTRIBUTORS HAVE  NO
# OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
#


#### setup

mbfl_load_library("$MBFL_LIBMBFL_CORE")
mbfl_load_library("$MBFL_LIBMBFL_TEST")


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


#### variables allocation

function variable-alloc-1.1 () {
    local NAME
    mbfl_variable_alloc NAME
    local -n NAMEREF=$NAME

    NAMEREF=123
    dotest-equal 123 ${!NAME}
}


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

    worker-varref-local-simple-2.1 mbfl_datavar(VAR)

    dotest-equal 123 "$RV" && dotest-equal 123 "$VAR"
}
function worker-varref-local-simple-2.1 () {
    mbfl_mandatory_nameref_parameter(VAR, 1, variable reference)

    #dotest-set-debug
    dotest-debug "VARNAME=$1 VAR=$VAR"

    VAR=123
    RV="$VAR"
}


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

    worker-varref-local-array-2.1 mbfl_datavar(VAR)

    dotest-equal 123 "$RV" && dotest-equal 123 "${VAR[KEY]}"
}
function worker-varref-local-array-2.1 () {
    mbfl_mandatory_nameref_parameter(VAR, 1, variable reference)

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
    worker-varref-local-array-2.2 mbfl_datavar(VAR)

    dotest-equal 123 "$RV" && dotest-equal 123 "${VAR[KEY]}"
}
function worker-varref-local-array-2.2 () {
    mbfl_mandatory_nameref_parameter(VAR, 1, variable reference)

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
    worker-varref-local-array-3.1 mbfl_datavar(ARRY)

    dotest-equal 123 "$VAR" && \
	dotest-equal 456 "${ARRY[VAL]}" && \
	dotest-equal 123 "$RV1" && \
	dotest-equal 456 "$RV2"
}
function worker-varref-local-array-3.1 () {
    mbfl_mandatory_nameref_parameter(VAR, 1, variable reference)
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
    worker-varref-local-array-3.2 mbfl_datavar(ARRY)

    dotest-equal 123 "$VAR" && \
	dotest-equal 456 "${ARRY[2]}" && \
	dotest-equal 123 "$RV1" && \
	dotest-equal 456 "$RV2"
}
function worker-varref-local-array-3.2 () {
    mbfl_mandatory_nameref_parameter(VAR, 1, variable reference)
    local -n VAR=${ARRY[1]}

    #dotest-set-debug
    dotest-debug "VARNAME=$1 ARRY[1]=${ARRY[1]}"
    VAR=123
    RV1=$VAR
    RV2=${ARRY[2]}
}


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
    mbfl_declare_varref(VAR, 123)
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
    mbfl_declare_varref(VAR, 123)
    local RV

    mbfl_location_enter
    {
        mbfl_location_handler "mbfl_variable_unset(mbfl_datavar(VAR))"

	RV=$VAR
    }
    mbfl_location_leave

    dotest-equal 123 "$RV" && dotest-equal '' $VAR
}


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
    mbfl_declare_varref(VAR, 123, -g)

    RV=mbfl_datavar(VAR)
}


#### let's go

dotest variable-
dotest varref-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
