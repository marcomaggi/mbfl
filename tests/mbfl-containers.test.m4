# mbfl-containers.test.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for libmbfl-containers library
# Date: Apr  9, 2023
#
# Abstract
#
#	This file must be executed with one among:
#
#		$ make all test TESTMATCH=mbfl-containers-
#		$ make all check TESTS=tests/mbfl-containers.test ; less tests/mbfl-containers.log
#
#	that will select these tests.
#
# Copyright (c) 2023 Marco Maggi
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
mbfl_load_library("$MBFL_LIBMBFL_CONTAINERS")
mbfl_load_library("$MBFL_LIBMBFL_TEST")


#### macros

MBFL_DEFINE_UNDERSCORE_MACRO_FOR_METHODS


#### index arrays

function mbfl-containers-index-array-equal-1.1 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e f g h i l))
    mbfl_declare_index_array_varref(ARRY2, (a b c d e f g h i l))

    mbfl_array_equal _(ARRY1) _(ARRY2)
}
function mbfl-containers-index-array-equal-1.2 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e f g h i l))
    mbfl_declare_index_array_varref(ARRY2, (a b c D E F g h i l))

    ! mbfl_array_equal _(ARRY1) _(ARRY2)
}
function mbfl-containers-index-array-equal-1.3 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e f g h i l))
    mbfl_declare_index_array_varref(ARRY2, (a b c d e f g))

    ! mbfl_array_equal _(ARRY1) _(ARRY2)
}
function mbfl-containers-index-array-equal-1.4 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e f g))
    mbfl_declare_index_array_varref(ARRY2, (a b c d e f g h i l))

    ! mbfl_array_equal _(ARRY1) _(ARRY2)
}

### ------------------------------------------------------------------------

function mbfl-containers-index-array-range-copy-1.1 () {
    #                                          ---------
    mbfl_declare_index_array_varref(RSLT, (a b e f g h i h i l))
    mbfl_declare_index_array_varref(ARRY, (a b c d e f g h i l))
    #                                      0 1 2 3 4 5 6 7 8 9
    #                                              ---------

    mbfl_array_range_copy _(ARRY) 2 _(ARRY) 4 5
    # mbfl_array_dump _(ARRY) ARRY
    # mbfl_array_dump _(RSLT) RSLT
    mbfl_array_equal _(RSLT) _(ARRY)
}
function mbfl-containers-index-array-range-copy-1.2 () {
    #                                              ---------
    mbfl_declare_index_array_varref(RSLT, (a b c d c d e f g l))
    mbfl_declare_index_array_varref(ARRY, (a b c d e f g h i l))
    #                                      0 1 2 3 4 5 6 7 8 9
    #                                          ---------

    mbfl_array_range_copy _(ARRY) 4 _(ARRY) 2 5
    # mbfl_array_dump _(ARRY) ARRY
    # mbfl_array_dump _(RSLT) RSLT
    mbfl_array_equal _(RSLT) _(ARRY)
}

function mbfl-containers-index-array-range-copy-2.1 () {
    #                                      0 1 2 3 4 5 6 7 8 9
    mbfl_declare_index_array_varref(RSLT, (0 0 0 a b c d 0 0 0))
    mbfl_declare_index_array_varref(DST,  (0 0 0 0 0 0 0 0 0 0))
    mbfl_declare_index_array_varref(SRC,  (9 a b c d 9 9 9 9 9))
    declare -i DST_IDX=3 SRC_IDX=1 DIM=4

    mbfl_array_range_copy _(DST) $DST_IDX _(SRC) $SRC_IDX $DIM
    #mbfl_array_dump _(DST)  DST
    #mbfl_array_dump _(RSLT) RSLT
    mbfl_array_equal _(RSLT) _(DST)
}
function mbfl-containers-index-array-range-copy-2.2 () {
    #                                      0 1 2 3 4 5 6 7 8 9
    mbfl_declare_index_array_varref(RSLT, (0 0 0 a b c d 0 0 0))
    mbfl_declare_index_array_varref(DST,  (0 0 0 0 0 0 0 0 0 0))
    mbfl_declare_index_array_varref(SRC,  (9 9 9 9 9 9 a b c d))
    declare -i DST_IDX=3 SRC_IDX=6 DIM=4

    mbfl_array_range_copy _(DST) $DST_IDX _(SRC) $SRC_IDX $DIM
    #mbfl_array_dump _(DST)  DST
    #mbfl_array_dump _(RSLT) RSLT
    mbfl_array_equal _(RSLT) _(DST)
}

### ------------------------------------------------------------------------

function mbfl-containers-index-array-map-1.1 () {
    #                                      0 1 2 3 4
    mbfl_declare_index_array_varref(RSLT, (A B C D E))
    mbfl_declare_index_array_varref(DST,  (. . . . .))
    mbfl_declare_index_array_varref(SRC,  (a b c d e))

    mbfl_array_map mbfl_string_toupper_var _(DST) _(SRC)
    #mbfl_array_dump _(DST)  DST
    #mbfl_array_dump _(RSLT) RSLT
    mbfl_array_equal _(RSLT) _(DST)
}

### ------------------------------------------------------------------------

declare var_mbfl_containers_index_array_for_each_1_1
function func_mbfl_containers_index_array_for_each_1_1 () {
    mbfl_mandatory_parameter(VALUE, 1, value from the array)
    var_mbfl_containers_index_array_for_each_1_1+=$VALUE
}
function mbfl-containers-index-array-for-each-1.1 () {
    mbfl_declare_index_array_varref(ARRY, (a b c d e))
    declare EXPECTED_RESULT='abcde'

    var_mbfl_containers_index_array_for_each_1_1=
    mbfl_array_for_each func_mbfl_containers_index_array_for_each_1_1 _(ARRY)
    dotest-equal "$EXPECTED_RESULT" "$var_mbfl_containers_index_array_for_each_1_1"
}
function mbfl-containers-index-array-for-each-1.2 () {
    mbfl_declare_index_array_varref(ARRY, (a b c d e))
    declare EXPECTED_RESULT=$'a\nb\nc\nd\ne'
    declare RESULT

    RESULT=$(mbfl_array_for_each echo _(ARRY))
    dotest-equal "$EXPECTED_RESULT" "$RESULT"
}

### ------------------------------------------------------------------------

function func_mbfl_containers_index_array_fold_left_1_1 () {
    mbfl_mandatory_nameref_parameter(NIL, 1, the left value)
    mbfl_mandatory_parameter(VALUE, 2, the array value)
    NIL+=$VALUE
}
function mbfl-containers-index-array-fold-left-1.1 () {
    mbfl_declare_index_array_varref(ARRY, (a b c d e))
    mbfl_declare_varref(NIL, '0')
    declare EXPECTED_RESULT='0abcde'

    mbfl_array_fold_left _(NIL) func_mbfl_containers_index_array_fold_left_1_1 _(ARRY)
    dotest-equal "$EXPECTED_RESULT" "$NIL"
}

### ------------------------------------------------------------------------

function func_mbfl_containers_index_array_fold_right_1_1 () {
    mbfl_mandatory_nameref_parameter(NIL, 1, the right value)
    mbfl_mandatory_parameter(VALUE, 2, the array value)
    NIL+=$VALUE
}
function mbfl-containers-index-array-fold-right-1.1 () {
    mbfl_declare_index_array_varref(ARRY, (a b c d e))
    mbfl_declare_varref(NIL, '0')
    declare EXPECTED_RESULT='0edcba'

    mbfl_array_fold_right _(NIL) func_mbfl_containers_index_array_fold_right_1_1 _(ARRY)
    dotest-equal "$EXPECTED_RESULT" "$NIL"
}


#### stacks

function mbfl-containers-stack-example-1.1 () {
    mbfl_default_object_declare(STK)
    mbfl_declare_varref(TOP_A)
    mbfl_declare_varref(POP_A)
    mbfl_declare_varref(POP_B)
    mbfl_declare_integer_varref(BEG_SIZE)
    mbfl_declare_integer_varref(MID_SIZE)
    mbfl_declare_integer_varref(END_SIZE)

    mbfl_location_enter
    {
	mbfl_stack_make _(STK)
	mbfl_location_handler "mbfl_stack_unmake _(STK)"

	mbfl_stack_size_var _(BEG_SIZE) _(STK)

	mbfl_stack_push _(STK) 'ciao'
	mbfl_stack_push _(STK) 'mamma'

	mbfl_stack_size_var _(MID_SIZE) _(STK)

	mbfl_stack_top_var _(TOP_A) _(STK)
	mbfl_stack_pop_var _(POP_A) _(STK)
	mbfl_stack_pop_var _(POP_B) _(STK)

	mbfl_stack_size_var _(END_SIZE) _(STK)

	# mbfl_stack_dump _(STK) STK

	dotest-equal	 2	 "$MID_SIZE"	'stack size'	&&
	    dotest-equal 0	 "$BEG_SIZE"	'stack size'	&&
	    dotest-equal 0	 "$END_SIZE"	'stack size'	&&
	    dotest-equal 'mamma' "$TOP_A"	'top A'		&&
	    dotest-equal 'mamma' "$POP_A"	'pop A'		&&
	    dotest-equal 'ciao'	 "$POP_B"	'pop B'
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function mbfl-containers-stack-equal-1.1 () {
    mbfl_default_object_declare(STK1)
    mbfl_default_object_declare(STK2)

    mbfl_location_enter
    {
	mbfl_stack_make _(STK1)
	mbfl_location_handler "mbfl_stack_unmake _(STK1)"

	mbfl_stack_make _(STK2)
	mbfl_location_handler "mbfl_stack_unmake _(STK2)"

	mbfl_stack_push _(STK1) 'uno'
	mbfl_stack_push _(STK1) 'due'
	mbfl_stack_push _(STK1) 'tre'

	mbfl_stack_copy _(STK2) _(STK1)

	# mbfl_stack_dump _(STK1) STK1
	# mbfl_stack_dump _(STK2) STK2
	mbfl_stack_equal _(STK2) _(STK1)
    }
    mbfl_location_leave
}
function mbfl-containers-stack-equal-2.1 () {
    mbfl_location_enter
    {
	mbfl_default_object_declare(STK1)
	mbfl_location_handler "mbfl_undeclare_varref(_(STK1))"

	mbfl_default_object_declare(STK2)
	mbfl_location_handler "mbfl_undeclare_varref(_(STK2))"

	mbfl_stack_make _(STK1)
	mbfl_location_handler "mbfl_stack_unmake _(STK1)"

	mbfl_stack_make _(STK2)
	mbfl_location_handler "mbfl_stack_unmake _(STK2)"

	mbfl_stack_push _(STK1) 'uno'
	mbfl_stack_push _(STK1) 'due'
	mbfl_stack_push _(STK1) 'tre'

	mbfl_stack_push _(STK1) 'uno'
	mbfl_stack_push _(STK1) 'two'
	mbfl_stack_push _(STK1) 'tre'

	# mbfl_stack_dump _(STK1) STK1
	# mbfl_stack_dump _(STK2) STK2
	! mbfl_stack_equal _(STK2) _(STK1)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function mbfl-containers-stack-methods-1.1 () {
    mbfl_default_object_declare(STK)
    mbfl_declare_varref(TOP_A)
    mbfl_declare_varref(POP_A)
    mbfl_declare_varref(POP_B)
    mbfl_declare_integer_varref(SIZE)

    mbfl_location_enter
    {
	mbfl_stack_make _(STK)
	mbfl_location_handler "mbfl_stack_unmake _(STK)"

	_(STK, push) 'ciao'
	_(STK, push) 'mamma'

	_(STK, size) _(SIZE)

	_(STK, top) _(TOP_A)
	_(STK, pop) _(POP_A)
	_(STK, pop) _(POP_B)

	# mbfl_stack_dump _(STK) STK

	dotest-equal	 2	 "$SIZE"  'stack size'	&&
	    dotest-equal 'mamma' "$TOP_A" 'top A'	&&
	    dotest-equal 'mamma' "$POP_A" 'pop A'	&&
	    dotest-equal 'ciao'	 "$POP_B" 'pop B'
    }
    mbfl_location_leave
}


#### let's go

dotest mbfl-containers-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
