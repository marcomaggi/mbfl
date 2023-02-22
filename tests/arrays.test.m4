# arrays.test --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for the arrays module
# Date: Nov 15, 2018
#
# Abstract
#
#
# Copyright (c) 2018, 2020, 2023 Marco Maggi <mrc.mgg@gmail.com>
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

mbfl_load_library("$MBFL_TESTS_LIBMBFL_CORE")
mbfl_load_library("$MBFL_TESTS_LIBMBFL_TEST")


#### arrays inspection

function array-inspection-1.1 () {
    local -a ARRY
    mbfl_array_is_empty ARRY
}
function array-inspection-1.2 () {
    local -a ARRY
    ARRY=(a b c)
    ! mbfl_array_is_empty ARRY
}

### --------------------------------------------------------------------

function array-inspection-2.1 () {
    local -a ARRY
    ! mbfl_array_is_not_empty ARRY
}
function array-inspection-2.2 () {
    local -a ARRY
    ARRY=(a b c)
    mbfl_array_is_not_empty ARRY
}


#### array length

function array-length-1.1 () {
    local -a ARRY
    mbfl_array_length ARRY | dotest-output 0
}
function array-length-1.2 () {
    local -a ARRY
    ARRY=(a b c)
    mbfl_array_length ARRY | dotest-output 3
}

### --------------------------------------------------------------------

function array-length-var-1.1 () {
    local -a ARRY
    local -i RV
    mbfl_array_length_var RV ARRY
    dotest-equal 0 "$RV"
}
function array-length-var-1.2 () {
    local -a ARRY
    local -i RV
    ARRY=(a b c)
    mbfl_array_length_var RV ARRY
    dotest-equal 3 "$RV"
}


#### array copying

function array-copy-assoc-length-1.1 () {
    mbfl_local_varref(SRC,([a]=1 [b]=2 [c]=3), -A)
    mbfl_local_varref(DST,, -A)


    mbfl_array_copy mbfl_datavar(DST) mbfl_datavar(SRC)
    mbfl_array_length DST | dotest-output 3
}
function array-copy-numeric-length-1.2 () {
    mbfl_local_varref(SRC,([a]=1 [b]=2 [c]=3), -A)
    mbfl_local_varref(DST,, -A)


    mbfl_array_copy mbfl_datavar(DST) mbfl_datavar(SRC)
    mbfl_array_length DST | dotest-output 3
}

function array-copy-assoc-elms-1.1 () {
    mbfl_local_varref(SRC,([a]=1 [b]=2 [c]=3), -A)
    mbfl_local_varref(DST,, -A)


    mbfl_array_copy mbfl_datavar(DST) mbfl_datavar(SRC)
    dotest-equal 1 mbfl_slot_ref(DST, a) && \
	dotest-equal 2 mbfl_slot_ref(DST, b) && \
	dotest-equal 3 mbfl_slot_ref(DST, c)
}
function array-copy-numeric-elms-1.2 () {
    mbfl_local_varref(SRC,([a]=1 [b]=2 [c]=3), -A)
    mbfl_local_varref(DST,, -A)


    mbfl_array_copy mbfl_datavar(DST) mbfl_datavar(SRC)
    dotest-equal 1 mbfl_slot_ref(DST, a) && \
	dotest-equal 2 mbfl_slot_ref(DST, b) && \
	dotest-equal 3 mbfl_slot_ref(DST, c)
}


#### preprocessor macros

function array-macro-slot-set-ref-1.1 () {
    mbfl_declare_numeric_array(ARRY)
    mbfl_slot_set(ARRY, 0, 'abc')
    dotest-equal 'abc' mbfl_slot_ref(ARRY, 0)
}

function array-macro-slot-set-ref-1.2 () {
    mbfl_declare_symbolic_array(ARRY)
    mbfl_slot_set(ARRY, 'key', 'abc')
    dotest-equal 'abc' mbfl_slot_ref(ARRY, 'key')
}

### ------------------------------------------------------------------------

function array-macro-slot-value-len-1.1 () {
    mbfl_declare_numeric_array(ARRY)
    mbfl_slot_set(ARRY, 0, 'abc')
    dotest-equal 3 mbfl_slot_value_len(ARRY, 0)
}

### ------------------------------------------------------------------------

function array-macro-slot-append-1.1 () {
    mbfl_declare_symbolic_array(PAIRS)
    mbfl_slot_set(PAIRS, 'abc', '123')
    mbfl_slot_append(PAIRS, 'abc', '+456')
    dotest-equal '123+456' mbfl_slot_ref(PAIRS, 'abc')
}

function array-macro-slot-append-1.2 () {
    mbfl_declare_symbolic_array(PAIRS)
    mbfl_slot_append(PAIRS, 'abc', '+456')
    dotest-equal '+456' mbfl_slot_ref(PAIRS, 'abc')
}

function array-macro-slot-append-1.3 () {
    mbfl_declare_symbolic_array(PAIRS)
    mbfl_slot_set(PAIRS, 'abc', '123')
    mbfl_slot_append(PAIRS, 'abc', ' 456')
    dotest-equal '123 456' "mbfl_slot_ref(PAIRS, 'abc')"
}

function array-macro-slot-append-1.4 () {
    mbfl_declare_symbolic_array(PAIRS)
    mbfl_slot_append(PAIRS, 'abc', ' 456')
    dotest-equal ' 456' "mbfl_slot_ref(PAIRS, 'abc')"
}

### ------------------------------------------------------------------------

# Put on the same line two macros that expand into  a string containing a sharp sign "#"; see if the
# sharp sign is interpreted as a comment delimiter (wrong) or not (right).
#
function array-macro-misc-1.1 () {
    mbfl_declare_numeric_array(ARRY1, (a b c d))
    mbfl_declare_numeric_array(ARRY2, (e f g))
    local RV

    if ((mbfl_slots_number(ARRY1) == mbfl_slots_number(ARRY2)))
    then RV=0
    else RV=1
    fi
    dotest-equal 1 $RV
}

# Put on the same line two macros that expand into  a string containing a sharp sign "#"; see if the
# sharp sign is interpreted as a comment delimiter (wrong) or not (right).
#
function array-macro-misc-1.2 () {
    mbfl_declare_numeric_array(ARRY1, (a b c d))
    mbfl_declare_numeric_array(ARRY2, (e f g))
    local RV

    if ((2 < mbfl_slots_number(ARRY1) || 3 == mbfl_slots_number(ARRY2)))
    then RV=0
    else RV=1
    fi
    dotest-equal 0 $RV
}


#### let's go

dotest array-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
