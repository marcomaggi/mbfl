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


#### helpers

function operator_return_nine () {
    return 9
}
function test_string_less_first_char () {
    mbfl_mandatory_parameter(VALUE1, 1, first value)
    mbfl_mandatory_parameter(VALUE2, 2, second value)

    mbfl_string_less mbfl_string_idx(VALUE1, 0) mbfl_string_idx(VALUE2, 0)
}


#### index arrays: makers

function mbfl-containers-array-tabulate-1.1 () {
    mbfl_declare_index_array_varref(ARRY)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (0 1 2 3 4))

    mbfl_array_tabulate _(ARRY) 5
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-tabulate-1.2 () {
    mbfl_declare_index_array_varref(ARRY)
    mbfl_declare_index_array_varref(EXPECTED_RESULT)

    mbfl_array_tabulate _(ARRY) 0
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}

### ------------------------------------------------------------------------

function initialiser_mbfl_containers_array_tabulate_2_1 () {
    mbfl_mandatory_nameref_parameter(RV, 1, result variable)
    mbfl_mandatory_parameter(IDX,        2, slot index)

    let RV=100*IDX
    return_success
}
function mbfl-containers-array-tabulate-2.1 () {
    mbfl_declare_index_array_varref(ARRY)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (0 100 200 300 400))

    mbfl_array_tabulate _(ARRY) 5 'initialiser_mbfl_containers_array_tabulate_2_1'
    #mbfl_array_dump _(ARRY) ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}

### ------------------------------------------------------------------------

function mbfl-containers-array-iota-1.1 () {
    mbfl_declare_index_array_varref(ARRY)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (0 1 2 3 4))

    mbfl_array_iota _(ARRY) 5
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-iota-1.2 () {
    mbfl_declare_index_array_varref(ARRY)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (10 15 20 25 30))

    mbfl_array_iota _(ARRY) 5 10 5
    #mbfl_array_dump _(ARRY) ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-iota-1.3 () {
    mbfl_declare_index_array_varref(ARRY)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (1 1.1 1.2 1.3 1.4))

    mbfl_array_iota _(ARRY) 5 1.0 0.1
    #mbfl_array_dump _(ARRY) ARRY
    #mbfl_array_dump _(EXPECTED_RESULT) EXPECTED_RESULT
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}


#### index arrays: multi inspection

function mbfl-containers-array-multi-equal-size-1.1 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e))
    mbfl_declare_index_array_varref(ARRY2, (A B C D E))
    mbfl_declare_index_array_varref(ARRY3, (. . . . .))
    mbfl_declare_index_array_varref(ARRYS, (_(ARRY1) _(ARRY2) _(ARRY3)))
    mbfl_declare_integer_varref(SIZE)

    mbfl_multi_array_equal_size_var _(SIZE) _(ARRYS) &&
	dotest-equal 5 "$SIZE"
}
function mbfl-containers-array-multi-equal-size-1.2 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e))
    mbfl_declare_index_array_varref(ARRYS, (_(ARRY1)))
    mbfl_declare_integer_varref(SIZE)

    mbfl_multi_array_equal_size_var _(SIZE) _(ARRYS) &&
	dotest-equal 5 "$SIZE"
}
function mbfl-containers-array-multi-equal-size-1.3 () {
    mbfl_declare_index_array_varref(ARRYS)
    mbfl_declare_integer_varref(SIZE)

    mbfl_multi_array_equal_size_var _(SIZE) _(ARRYS) &&
	dotest-equal 0 "$SIZE"
}

function mbfl-containers-array-multi-equal-size-2.1 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d))
    mbfl_declare_index_array_varref(ARRY2, (A B C D E))
    mbfl_declare_index_array_varref(ARRY3, (. . . . .))
    mbfl_declare_index_array_varref(ARRYS, (_(ARRY1) _(ARRY2) _(ARRY3)))
    mbfl_declare_integer_varref(SIZE)

    ! mbfl_multi_array_equal_size_var _(SIZE) _(ARRYS)
}
function mbfl-containers-array-multi-equal-size-2.2 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e))
    mbfl_declare_index_array_varref(ARRY2, (A B C D))
    mbfl_declare_index_array_varref(ARRY3, (. . . . .))
    mbfl_declare_index_array_varref(ARRYS, (_(ARRY1) _(ARRY2) _(ARRY3)))
    mbfl_declare_integer_varref(SIZE)

    ! mbfl_multi_array_equal_size_var _(SIZE) _(ARRYS)
}
function mbfl-containers-array-multi-equal-size-2.3 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e))
    mbfl_declare_index_array_varref(ARRY2, (A B C D E))
    mbfl_declare_index_array_varref(ARRY3, (. . . .))
    mbfl_declare_index_array_varref(ARRYS, (_(ARRY1) _(ARRY2) _(ARRY3)))
    mbfl_declare_integer_varref(SIZE)

    ! mbfl_multi_array_equal_size_var _(SIZE) _(ARRYS)
}

### ------------------------------------------------------------------------

function mbfl-containers-array-multi-homologous-slots-1.1 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e))
    mbfl_declare_index_array_varref(ARRY2, (f g h i l))
    mbfl_declare_index_array_varref(ARRY3, (m n o p q))
    mbfl_declare_index_array_varref(ARRYS, (_(ARRY1) _(ARRY2) _(ARRY3)))

    mbfl_declare_index_array_varref(RESULT0)
    mbfl_declare_index_array_varref(RESULT1)
    mbfl_declare_index_array_varref(RESULT2)
    mbfl_declare_index_array_varref(RESULT3)
    mbfl_declare_index_array_varref(RESULT4)

    mbfl_declare_index_array_varref(EXPECTED_RESULT0, (a f m))
    mbfl_declare_index_array_varref(EXPECTED_RESULT1, (b g n))
    mbfl_declare_index_array_varref(EXPECTED_RESULT2, (c h o))
    mbfl_declare_index_array_varref(EXPECTED_RESULT3, (d i p))
    mbfl_declare_index_array_varref(EXPECTED_RESULT4, (e l q))

    mbfl_multi_array_homologous_slots_var _(RESULT0) _(ARRYS) 0
    mbfl_multi_array_homologous_slots_var _(RESULT1) _(ARRYS) 1
    mbfl_multi_array_homologous_slots_var _(RESULT2) _(ARRYS) 2
    mbfl_multi_array_homologous_slots_var _(RESULT3) _(ARRYS) 3
    mbfl_multi_array_homologous_slots_var _(RESULT4) _(ARRYS) 4

    mbfl_array_equal		_(EXPECTED_RESULT0) _(RESULT0) &&
	mbfl_array_equal	_(EXPECTED_RESULT1) _(RESULT1) &&
	mbfl_array_equal	_(EXPECTED_RESULT2) _(RESULT2) &&
	mbfl_array_equal	_(EXPECTED_RESULT3) _(RESULT3) &&
	mbfl_array_equal	_(EXPECTED_RESULT4) _(RESULT4)
}
function mbfl-containers-array-multi-homologous-slots-1.2 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e))
    mbfl_declare_index_array_varref(ARRYS, (_(ARRY1)))

    mbfl_declare_index_array_varref(RESULT0)
    mbfl_declare_index_array_varref(RESULT1)
    mbfl_declare_index_array_varref(RESULT2)
    mbfl_declare_index_array_varref(RESULT3)
    mbfl_declare_index_array_varref(RESULT4)

    mbfl_declare_index_array_varref(EXPECTED_RESULT0, (a))
    mbfl_declare_index_array_varref(EXPECTED_RESULT1, (b))
    mbfl_declare_index_array_varref(EXPECTED_RESULT2, (c))
    mbfl_declare_index_array_varref(EXPECTED_RESULT3, (d))
    mbfl_declare_index_array_varref(EXPECTED_RESULT4, (e))

    mbfl_multi_array_homologous_slots_var _(RESULT0) _(ARRYS) 0
    mbfl_multi_array_homologous_slots_var _(RESULT1) _(ARRYS) 1
    mbfl_multi_array_homologous_slots_var _(RESULT2) _(ARRYS) 2
    mbfl_multi_array_homologous_slots_var _(RESULT3) _(ARRYS) 3
    mbfl_multi_array_homologous_slots_var _(RESULT4) _(ARRYS) 4

    mbfl_array_equal		_(EXPECTED_RESULT0) _(RESULT0) &&
	mbfl_array_equal	_(EXPECTED_RESULT1) _(RESULT1) &&
	mbfl_array_equal	_(EXPECTED_RESULT2) _(RESULT2) &&
	mbfl_array_equal	_(EXPECTED_RESULT3) _(RESULT3) &&
	mbfl_array_equal	_(EXPECTED_RESULT4) _(RESULT4)
}
function mbfl-containers-array-multi-homologous-slots-1.3 () {
    mbfl_declare_index_array_varref(ARRYS)
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT)

    mbfl_multi_array_homologous_slots_var _(RESULT) _(ARRYS) 0

    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}


#### index arrays: selectors

function mbfl-containers-array-take-1.1 () {
    mbfl_declare_index_array_varref(ARRY, (a b c d e f g h i))
    mbfl_declare_index_array_varref(L_RESULT)
    mbfl_declare_index_array_varref(R_RESULT)
    mbfl_declare_index_array_varref(L_EXPECTED_RESULT, (a b c))
    mbfl_declare_index_array_varref(R_EXPECTED_RESULT, (g h i))

    mbfl_array_left_take  _(L_RESULT) _(ARRY) 3
    mbfl_array_right_take _(R_RESULT) _(ARRY) 3

    # mbfl_array_dump _(L_RESULT) L_RESULT
    # mbfl_array_dump _(R_RESULT) R_RESULT

    mbfl_array_equal	 _(L_EXPECTED_RESULT) _(L_RESULT) &&
	mbfl_array_equal _(R_EXPECTED_RESULT) _(R_RESULT)
}
function mbfl-containers-array-take-1.2 () {
    mbfl_declare_index_array_varref(ARRY, (a b c d e f g h i))
    mbfl_declare_index_array_varref(L_RESULT)
    mbfl_declare_index_array_varref(R_RESULT)
    mbfl_declare_index_array_varref(L_EXPECTED_RESULT)
    mbfl_declare_index_array_varref(R_EXPECTED_RESULT)

    mbfl_array_left_take  _(L_RESULT) _(ARRY) 0
    mbfl_array_right_take _(R_RESULT) _(ARRY) 0

    mbfl_array_equal     _(L_EXPECTED_RESULT) _(L_RESULT) &&
	mbfl_array_equal _(R_EXPECTED_RESULT) _(R_RESULT)
}

### ------------------------------------------------------------------------

function mbfl-containers-array-drop-1.1 () {
    mbfl_declare_index_array_varref(ARRY, (a b c d e f g h i))
    mbfl_declare_index_array_varref(L_RESULT)
    mbfl_declare_index_array_varref(R_RESULT)
    mbfl_declare_index_array_varref(L_EXPECTED_RESULT, (d e f g h i))
    mbfl_declare_index_array_varref(R_EXPECTED_RESULT, (a b c d e f))

    mbfl_array_left_drop  _(L_RESULT) _(ARRY) 3
    mbfl_array_right_drop _(R_RESULT) _(ARRY) 3

    # mbfl_array_dump _(L_RESULT) L_RESULT
    # mbfl_array_dump _(R_RESULT) R_RESULT

    mbfl_array_equal	 _(L_EXPECTED_RESULT) _(L_RESULT) &&
	mbfl_array_equal _(R_EXPECTED_RESULT) _(R_RESULT)
}

### ------------------------------------------------------------------------

function mbfl-containers-array-split-at-1.1 () {
    mbfl_declare_index_array_varref(ARRY, (a b c d e f g h i))
    mbfl_declare_index_array_varref(PREFIX)
    mbfl_declare_index_array_varref(SUFFIX)
    mbfl_declare_index_array_varref(EXPECTED_PREFIX, (a b c d))
    mbfl_declare_index_array_varref(EXPECTED_SUFFIX, (e f g h i))

    mbfl_array_split_at _(PREFIX) _(SUFFIX) _(ARRY) 4

    mbfl_array_equal	 _(EXPECTED_PREFIX) _(PREFIX) &&
	mbfl_array_equal _(EXPECTED_SUFFIX) _(SUFFIX)
}
function mbfl-containers-array-split-at-1.2 () {
    mbfl_declare_index_array_varref(ARRY, (a b c d e f g h i))
    mbfl_declare_index_array_varref(PREFIX)
    mbfl_declare_index_array_varref(SUFFIX)
    mbfl_declare_index_array_varref(EXPECTED_PREFIX, ())
    mbfl_declare_index_array_varref(EXPECTED_SUFFIX, (a b c d e f g h i))

    mbfl_array_split_at _(PREFIX) _(SUFFIX) _(ARRY) 0

    mbfl_array_equal	 _(EXPECTED_PREFIX) _(PREFIX) &&
	mbfl_array_equal _(EXPECTED_SUFFIX) _(SUFFIX)
}
function mbfl-containers-array-split-at-1.3 () {
    mbfl_declare_index_array_varref(ARRY, (a b c d e f g h i))
    mbfl_declare_index_array_varref(PREFIX)
    mbfl_declare_index_array_varref(SUFFIX)
    mbfl_declare_index_array_varref(EXPECTED_PREFIX, (a b c d e f g h i))
    mbfl_declare_index_array_varref(EXPECTED_SUFFIX, ())

    mbfl_array_split_at _(PREFIX) _(SUFFIX) _(ARRY) mbfl_slots_number(ARRY)

    mbfl_array_equal	 _(EXPECTED_PREFIX) _(PREFIX) &&
	mbfl_array_equal _(EXPECTED_SUFFIX) _(SUFFIX)
}


#### index arrays: comparison

function mbfl-containers-array-equal-values-1.1 () {
    mbfl_declare_index_array_varref(ARRY, (0 0 0 0 0 0))
    mbfl_array_equal_values _(ARRY)
}
function mbfl-containers-array-equal-values-1.2 () {
    mbfl_declare_index_array_varref(ARRY, (0))
    mbfl_array_equal_values _(ARRY)
}
function mbfl-containers-array-equal-values-1.3 () {
    mbfl_declare_index_array_varref(ARRY)
    mbfl_array_equal_values _(ARRY)
}
function mbfl-containers-array-equal-values-2.1 () {
    mbfl_declare_index_array_varref(ARRY, (3 0 0 0 0))
    ! mbfl_array_equal_values _(ARRY)
}
function mbfl-containers-array-equal-values-2.2 () {
    mbfl_declare_index_array_varref(ARRY, (0 0 3 0 0))
    ! mbfl_array_equal_values _(ARRY)
}

### ------------------------------------------------------------------------

function mbfl-containers-array-equal-1.1 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e f g h i l))
    mbfl_declare_index_array_varref(ARRY2, (a b c d e f g h i l))

    mbfl_array_equal _(ARRY1) _(ARRY2)
}
function mbfl-containers-array-equal-1.2 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e f g h i l))
    mbfl_declare_index_array_varref(ARRY2, (a b c D E F g h i l))

    ! mbfl_array_equal _(ARRY1) _(ARRY2)
}
function mbfl-containers-array-equal-1.3 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e f g h i l))
    mbfl_declare_index_array_varref(ARRY2, (a b c d e f g))

    ! mbfl_array_equal _(ARRY1) _(ARRY2)
}
function mbfl-containers-array-equal-1.4 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e f g))
    mbfl_declare_index_array_varref(ARRY2, (a b c d e f g h i l))

    ! mbfl_array_equal _(ARRY1) _(ARRY2)
}

### ------------------------------------------------------------------------

function mbfl-containers-array-multi-equal-1.1 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e))
    mbfl_declare_index_array_varref(ARRY2, (a b c d e))
    mbfl_declare_index_array_varref(ARRY3, (a b c d e))
    mbfl_declare_index_array_varref(ARRYS, (_(ARRY1) _(ARRY2) _(ARRY3)))

    mbfl_multi_array_equal _(ARRYS)
}
function mbfl-containers-array-multi-equal-1.2 () {
    mbfl_declare_index_array_varref(ARRY1, ())
    mbfl_declare_index_array_varref(ARRY2, ())
    mbfl_declare_index_array_varref(ARRY3, ())
    mbfl_declare_index_array_varref(ARRYS, (_(ARRY1) _(ARRY2) _(ARRY3)))

    mbfl_multi_array_equal _(ARRYS)
}
function mbfl-containers-array-multi-equal-1.3 () {
    mbfl_declare_index_array_varref(ARRYS)

    mbfl_multi_array_equal _(ARRYS)
}

function mbfl-containers-array-multi-equal-2.1 () {
    mbfl_declare_index_array_varref(ARRY1, (a b X d e))
    mbfl_declare_index_array_varref(ARRY2, (a b c d e))
    mbfl_declare_index_array_varref(ARRY3, (a b c d e))
    mbfl_declare_index_array_varref(ARRYS, (_(ARRY1) _(ARRY2) _(ARRY3)))

    ! mbfl_multi_array_equal _(ARRYS)
}


#### index arrays: filtering

function pred_mbfl_containers_array_filter_1_1 () {
    mbfl_mandatory_parameter(X, 1, value)
    mbfl_declare_varref(Y)

    mbfl_math_expr_var _(Y) "$X % 2"
    if (( 0 == Y ))
    then return_success
    else return_failure
    fi
}
function mbfl-containers-array-filter-1.1 () {
    mbfl_declare_index_array_varref(ARRY, (0 1 2 3 4 5 6 7 8 9))
    mbfl_declare_index_array_varref(RESULT)

    mbfl_declare_index_array_varref(EXPECTED_RESULT, (0 2 4 6 8))

    mbfl_array_filter _(RESULT) 'pred_mbfl_containers_array_filter_1_1' _(ARRY)
    #mbfl_array_dump _(RESULT) RESULT
    mbfl_array_equal	_(EXPECTED_RESULT) _(RESULT)
}

### ------------------------------------------------------------------------

function mbfl-containers-array-partition-1.1 () {
    mbfl_declare_index_array_varref(ARRY, (0 1 2 3 4 5 6 7 8 9))
    mbfl_declare_index_array_varref(GOOD_ARRY)
    mbfl_declare_index_array_varref(BAD_ARRY)

    mbfl_declare_index_array_varref(EXPECTED_GOOD_ARRY, (0 2 4 6 8))
    mbfl_declare_index_array_varref(EXPECTED_BAD_ARRY,  (1 3 5 7 9))

    mbfl_array_partition _(GOOD_ARRY) _(BAD_ARRY) 'pred_mbfl_containers_array_filter_1_1' _(ARRY)
    #mbfl_array_dump _(GOOD_ARRY) GOOD_ARRY
    #mbfl_array_dump _(BAD_ARRY) BAD_ARRY

    mbfl_array_equal		_(EXPECTED_GOOD_ARRY)	_(GOOD_ARRY) &&
	mbfl_array_equal	_(EXPECTED_BAD_ARRY)	_(BAD_ARRY)
}


#### index arrays: insertions

function mbfl-containers-array-insert-slot-1.1 () {
    mbfl_declare_index_array_varref(ARRY,		(a b c d e f g h i))
    mbfl_declare_index_array_varref(EXPECTED_RESULT,	(a b c 99 d e f g h i))

    mbfl_array_insert_slot_bang _(ARRY) 3
    mbfl_slot_set(ARRY, 3, 99)
    #mbfl_array_dump _(ARRY) ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-insert-slot-1.2 () {
    mbfl_declare_index_array_varref(ARRY,		(a b c))
    mbfl_declare_index_array_varref(EXPECTED_RESULT,	(a b c 99))

    mbfl_array_insert_slot_bang _(ARRY) 3
    mbfl_slot_set(ARRY, 3, 99)
    #mbfl_array_dump _(ARRY) ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-insert-slot-1.3 () {
    mbfl_declare_index_array_varref(ARRY,		())
    mbfl_declare_index_array_varref(EXPECTED_RESULT,	(99))

    mbfl_array_insert_slot_bang _(ARRY) 0
    mbfl_slot_set(ARRY, 0, 99)
    #mbfl_array_dump _(ARRY) ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-insert-slot-1.4 () {
    mbfl_declare_index_array_varref(ARRY,		(a))
    mbfl_declare_index_array_varref(EXPECTED_RESULT,	(99 a))

    mbfl_array_insert_slot_bang _(ARRY) 0
    mbfl_slot_set(ARRY, 0, 99)
    #mbfl_array_dump _(ARRY) ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-insert-slot-1.5 () {
    mbfl_declare_index_array_varref(ARRY,		(a))
    mbfl_declare_index_array_varref(EXPECTED_RESULT,	(a 99))

    mbfl_array_insert_slot_bang _(ARRY) 1
    mbfl_slot_set(ARRY, 1, 99)
    #mbfl_array_dump _(ARRY) ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}

### ------------------------------------------------------------------------

function mbfl-containers-array-insert-value-1.1 () {
    mbfl_declare_index_array_varref(ARRY,		(a b c d e f g h i))
    mbfl_declare_index_array_varref(EXPECTED_RESULT,	(a b c 99 d e f g h i))

    mbfl_array_insert_value_bang _(ARRY) 3 99
    #mbfl_array_dump _(ARRY) ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-insert-value-1.2 () {
    mbfl_declare_index_array_varref(ARRY,		(a b c))
    mbfl_declare_index_array_varref(EXPECTED_RESULT,	(a b c 99))

    mbfl_array_insert_value_bang _(ARRY) 3 99
    #mbfl_array_dump _(ARRY) ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-insert-value-1.3 () {
    mbfl_declare_index_array_varref(ARRY,		())
    mbfl_declare_index_array_varref(EXPECTED_RESULT,	(99))

    mbfl_array_insert_value_bang _(ARRY) 0 99
    #mbfl_array_dump _(ARRY) ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-insert-value-1.4 () {
    mbfl_declare_index_array_varref(ARRY,		(a))
    mbfl_declare_index_array_varref(EXPECTED_RESULT,	(99 a))

    mbfl_array_insert_value_bang _(ARRY) 0 99
    #mbfl_array_dump _(ARRY) ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-insert-value-1.5 () {
    mbfl_declare_index_array_varref(ARRY,		(a))
    mbfl_declare_index_array_varref(EXPECTED_RESULT,	(a 99))

    mbfl_array_insert_value_bang _(ARRY) 1 99
    #mbfl_array_dump _(ARRY) ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}

### ------------------------------------------------------------------------

function mbfl-containers-array-insert-multi-slot-1.1 () {
    mbfl_declare_index_array_varref(ARRY,		(a b c  d  e  f  g h i))
    mbfl_declare_index_array_varref(EXPECTED_RESULT,	(a b c 90 91 92 93 d e f g h i))
    #                                                    0 1 2  3  4  5  6 7 8 9 0 1 2

    mbfl_array_insert_multi_slot_bang _(ARRY) 3 4
    mbfl_slot_set(ARRY, 3, 90)
    mbfl_slot_set(ARRY, 4, 91)
    mbfl_slot_set(ARRY, 5, 92)
    mbfl_slot_set(ARRY, 6, 93)
    #mbfl_array_dump _(ARRY) ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-insert-multi-slot-1.2 () {
    mbfl_declare_index_array_varref(ARRY)
    mbfl_declare_index_array_varref(EXPECTED_RESULT,	(90 91 92 93))

    mbfl_array_insert_multi_slot_bang _(ARRY) 0 4
    mbfl_slot_set(ARRY, 0, 90)
    mbfl_slot_set(ARRY, 1, 91)
    mbfl_slot_set(ARRY, 2, 92)
    mbfl_slot_set(ARRY, 3, 93)
    #mbfl_array_dump _(ARRY) ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-insert-multi-slot-1.3 () {
    mbfl_declare_index_array_varref(ARRY,		(a))
    mbfl_declare_index_array_varref(EXPECTED_RESULT,	(a 90 91 92 93))

    mbfl_array_insert_multi_slot_bang _(ARRY) 1 4
    mbfl_slot_set(ARRY, 1, 90)
    mbfl_slot_set(ARRY, 2, 91)
    mbfl_slot_set(ARRY, 3, 92)
    mbfl_slot_set(ARRY, 4, 93)
    #mbfl_array_dump _(ARRY) ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-insert-multi-slot-1.4 () {
    mbfl_declare_index_array_varref(ARRY,		(a))
    mbfl_declare_index_array_varref(EXPECTED_RESULT,	(90 91 92 93 a))

    mbfl_array_insert_multi_slot_bang _(ARRY) 0 4
    mbfl_slot_set(ARRY, 0, 90)
    mbfl_slot_set(ARRY, 1, 91)
    mbfl_slot_set(ARRY, 2, 92)
    mbfl_slot_set(ARRY, 3, 93)
    #mbfl_array_dump _(ARRY) ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-insert-multi-slot-1.5.1 () {
    mbfl_declare_index_array_varref(ARRY,		(a b c))
    mbfl_declare_index_array_varref(EXPECTED_RESULT,	(a b c))

    mbfl_array_insert_multi_slot_bang _(ARRY) 0 0
    #mbfl_array_dump _(ARRY) ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-insert-multi-slot-1.5.2 () {
    mbfl_declare_index_array_varref(ARRY,		(a b c))
    mbfl_declare_index_array_varref(EXPECTED_RESULT,	(a b c))

    mbfl_array_insert_multi_slot_bang _(ARRY) 3 0
    #mbfl_array_dump _(ARRY) ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-insert-multi-slot-1.5.3 () {
    mbfl_declare_index_array_varref(ARRY,		(a b c))
    mbfl_declare_index_array_varref(EXPECTED_RESULT,	(a b c))

    mbfl_array_insert_multi_slot_bang _(ARRY) 1 0
    #mbfl_array_dump _(ARRY) ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}

### ------------------------------------------------------------------------

function mbfl-containers-array-insert-multi-value-1.1 () {
    #                                                    0 1 2             3 4 5 6 7 8
    mbfl_declare_index_array_varref(ARRY1,		(a b c             d e f g h i))
    mbfl_declare_index_array_varref(ARRY2,		      (90 91 92 93))
    mbfl_declare_index_array_varref(EXPECTED_RESULT,	(a b c 90 91 92 93 d e f g h i))
    #                                                    0 1 2  3  4  5  6 7 8 9 0 1 2

    mbfl_array_insert_multi_value_bang _(ARRY1) 3 _(ARRY2)
    #mbfl_array_dump _(ARRY1) ARRY1
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY1)
}
function mbfl-containers-array-insert-multi-value-1.2 () {
    mbfl_declare_index_array_varref(ARRY1)
    mbfl_declare_index_array_varref(ARRY2,		(90 91 92 93))
    mbfl_declare_index_array_varref(EXPECTED_RESULT,	(90 91 92 93))

    mbfl_array_insert_multi_value_bang _(ARRY1) 0 _(ARRY2)
    #mbfl_array_dump _(ARRY1) ARRY1
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY1)
}
function mbfl-containers-array-insert-multi-value-1.3 () {
    mbfl_declare_index_array_varref(ARRY1,		(a))
    mbfl_declare_index_array_varref(ARRY2,		  (90 91 92 93))
    mbfl_declare_index_array_varref(EXPECTED_RESULT,	(a 90 91 92 93))

    mbfl_array_insert_multi_value_bang _(ARRY1) 1 _(ARRY2)
    #mbfl_array_dump _(ARRY1) ARRY1
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY1)
}
function mbfl-containers-array-insert-multi-value-1.4 () {
    mbfl_declare_index_array_varref(ARRY1,		            (a))
    mbfl_declare_index_array_varref(ARRY2,		(90 91 92 93))
    mbfl_declare_index_array_varref(EXPECTED_RESULT,	(90 91 92 93 a))

    mbfl_array_insert_multi_value_bang _(ARRY1) 0 _(ARRY2)
    #mbfl_array_dump _(ARRY1) ARRY1
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY1)
}


#### index arrays: removal and deletion

function mbfl-containers-array-remove-1.1 () {
    mbfl_declare_index_array_varref(ARRY, (a b c D e f g h i))
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c e f g h i))

    mbfl_array_remove _(RESULT) _(ARRY) 3
    #mbfl_array_dump _(RESULT) RESULT
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}
function mbfl-containers-array-remove-1.2 () {
    mbfl_declare_index_array_varref(ARRY, (A b c d e f g h i))
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (b c d e f g h i))

    mbfl_array_remove _(RESULT) _(ARRY) 0
    #mbfl_array_dump _(RESULT) RESULT
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}
function mbfl-containers-array-remove-1.3 () {
    mbfl_declare_index_array_varref(ARRY, (a b c d e f g h I))
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c d e f g h))

    mbfl_array_remove _(RESULT) _(ARRY) 8
    #mbfl_array_dump _(RESULT) RESULT
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}

### ------------------------------------------------------------------------

function mbfl-containers-array-delete-1.1 () {
    mbfl_declare_index_array_varref(ARRY, (a b c D e f g h i))
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c e f g h i))

    mbfl_array_delete _(RESULT) _(ARRY) D
    #mbfl_array_dump _(RESULT) RESULT
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}
function mbfl-containers-array-delete-1.2 () {
    mbfl_declare_index_array_varref(ARRY, (a b D c D e D f D g D h D i))
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c e f g h i))

    mbfl_array_delete _(RESULT) _(ARRY) D
    #mbfl_array_dump _(RESULT) RESULT
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}
function mbfl-containers-array-delete-1.3 () {
    mbfl_declare_index_array_varref(ARRY, (D D D D D D))
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT)

    mbfl_array_delete _(RESULT) _(ARRY) D
    #mbfl_array_dump _(RESULT) RESULT
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}

### ------------------------------------------------------------------------

function mbfl-containers-array-delete-duplicates-1.1 () {
    mbfl_declare_index_array_varref(ARRY, (a b c D e D f D g D h i))
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c D e f g h i))

    mbfl_array_delete_duplicates _(RESULT) _(ARRY)
    #mbfl_array_dump _(RESULT) RESULT
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}
function mbfl-containers-array-delete-duplicates-1.2 () {
    mbfl_declare_index_array_varref(ARRY, (a b c d e f g h i))
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c d e f g h i))

    mbfl_array_delete_duplicates _(RESULT) _(ARRY)
    #mbfl_array_dump _(RESULT) RESULT
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}


#### index arrays: searching

function mbfl-containers-array-find-slot-containing-value-var-1.1 () {
    #                                      0 1 2  3 4 5 6  7 8 9
    mbfl_declare_index_array_varref(ARRY, (a b c 99 d e f 99 g h))
    mbfl_declare_integer_varref(L_IDX)
    mbfl_declare_integer_varref(R_IDX)

    mbfl_array_find_left_slot_containing_value_var _(L_IDX) _(ARRY) 99
    declare -i L_RETURN_STATUS=$?

    mbfl_array_find_right_slot_containing_value_var _(R_IDX) _(ARRY) 99
    declare -i R_RETURN_STATUS=$?

    dotest-equal	0	$L_RETURN_STATUS &&
	dotest-equal	3	$L_IDX &&
	dotest-equal	0	$R_RETURN_STATUS &&
	dotest-equal	7	$R_IDX
}
function mbfl-containers-array-find-slot-containing-value-var-1.2 () {
    mbfl_declare_index_array_varref(ARRY, (a b c d e f g h))
    mbfl_declare_integer_varref(L_IDX)
    mbfl_declare_integer_varref(R_IDX)

    ! mbfl_array_find_left_slot_containing_value_var _(L_IDX) _(ARRY) 99 &&
	! mbfl_array_find_right_slot_containing_value_var _(R_IDX) _(ARRY) 99
}

### ------------------------------------------------------------------------

function mbfl-containers-array-find-slot-containing-value-1.1 () {
    #                                      0 1 2  3 4 5 6  7 8 9
    mbfl_declare_index_array_varref(ARRY, (a b c 99 d e f 99 g h))

    mbfl_array_find_left_slot_containing_value _(ARRY) 99
    declare -i L_RETURN_STATUS=$?

    mbfl_array_find_right_slot_containing_value _(ARRY) 99
    declare -i R_RETURN_STATUS=$?

    dotest-equal	0	$L_RETURN_STATUS &&
	dotest-equal	0	$R_RETURN_STATUS
}
function mbfl-containers-array-find-slot-containing-value-1.2 () {
    mbfl_declare_index_array_varref(ARRY, (a b c d e f g h))

    mbfl_array_find_left_slot_containing_value _(ARRY) 99
    declare -i L_RETURN_STATUS=$?

    mbfl_array_find_right_slot_containing_value _(ARRY) 99
    declare -i R_RETURN_STATUS=$?

    dotest-equal	1	$L_RETURN_STATUS &&
	dotest-equal	1	$R_RETURN_STATUS
}

### ------------------------------------------------------------------------

function pred_mbfl_containers_array_find_slot_satisfying_pred_1_1 () {
    mbfl_mandatory_parameter(VALUE, 1, value)
    mbfl_string_equal "$VALUE" '99'
}
function mbfl-containers-array-find-slot-satisfying-pred-var-1.1 () {
    #                                      0 1 2  3 4 5 6  7 8 9
    mbfl_declare_index_array_varref(ARRY, (a b c 99 d e f 99 g h))
    mbfl_declare_integer_varref(L_IDX)
    mbfl_declare_integer_varref(R_IDX)

    mbfl_array_find_left_slot_satisfying_pred_var _(L_IDX) _(ARRY) pred_mbfl_containers_array_find_slot_satisfying_pred_1_1
    declare -i L_RETURN_STATUS=$?

    mbfl_array_find_right_slot_satisfying_pred_var _(R_IDX) _(ARRY) pred_mbfl_containers_array_find_slot_satisfying_pred_1_1
    declare -i R_RETURN_STATUS=$?

    dotest-equal	0	$L_RETURN_STATUS &&
	dotest-equal	3	$L_IDX &&
	dotest-equal	0	$R_RETURN_STATUS &&
	dotest-equal	7	$R_IDX
}
function mbfl-containers-array-find-slot-satisfying-pred-var-1.2 () {
    mbfl_declare_index_array_varref(ARRY, (a b c d e f g h))
    mbfl_declare_integer_varref(L_IDX)
    mbfl_declare_integer_varref(R_IDX)

    ! mbfl_array_find_left_slot_satisfying_pred_var _(L_IDX) _(ARRY) pred_mbfl_containers_array_find_slot_satisfying_pred_1_1 &&
	! mbfl_array_find_right_slot_satisfying_pred_var _(R_IDX) _(ARRY) pred_mbfl_containers_array_find_slot_satisfying_pred_1_1
}

### ------------------------------------------------------------------------

function mbfl-containers-array-find-slot-satisfying-pred-1.1 () {
    #                                      0 1 2  3 4 5 6  7 8 9
    mbfl_declare_index_array_varref(ARRY, (a b c 99 d e f 99 g h))

    mbfl_array_find_left_slot_satisfying_pred _(ARRY) pred_mbfl_containers_array_find_slot_satisfying_pred_1_1
    declare -i L_RETURN_STATUS=$?

    mbfl_array_find_right_slot_satisfying_pred _(ARRY) pred_mbfl_containers_array_find_slot_satisfying_pred_1_1
    declare -i R_RETURN_STATUS=$?

    dotest-equal	0	$L_RETURN_STATUS &&
	dotest-equal	0	$R_RETURN_STATUS
}
function mbfl-containers-array-find-slot-satisfying-pred-1.2 () {
    mbfl_declare_index_array_varref(ARRY, (a b c d e f g h))

    ! mbfl_array_find_left_slot_satisfying_pred _(ARRY) pred_mbfl_containers_array_find_slot_satisfying_pred_1_1 &&
	! mbfl_array_find_right_slot_satisfying_pred _(ARRY) pred_mbfl_containers_array_find_slot_satisfying_pred_1_1
}


#### index arrays: copying

function mbfl-containers-array-range-copy-1.1 () {
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
function mbfl-containers-array-range-copy-1.2 () {
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

function mbfl-containers-array-range-copy-2.1 () {
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
function mbfl-containers-array-range-copy-2.2 () {
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


#### index arrays: folding

function operator_mbfl_containers_array_fold_1_1 () {
    mbfl_mandatory_nameref_parameter(ACCUM, 1, accumulator)
    mbfl_mandatory_parameter(VALUE,         2, array value)
    ACCUM+=$VALUE
}
function mbfl-containers-array-fold-1.1 () {
    mbfl_declare_index_array_varref(ARRY, (a b c d e))
    mbfl_declare_varref(L_ACCUM, '0')
    mbfl_declare_varref(R_ACCUM, '0')
    declare L_EXPECTED_RESULT='0abcde'
    declare R_EXPECTED_RESULT='0edcba'

    mbfl_array_left_fold  _(L_ACCUM) 'operator_mbfl_containers_array_fold_1_1' _(ARRY)
    mbfl_array_right_fold _(R_ACCUM) 'operator_mbfl_containers_array_fold_1_1' _(ARRY)

    dotest-equal "$L_EXPECTED_RESULT" "$L_ACCUM" &&
	dotest-equal "$R_EXPECTED_RESULT" "$R_ACCUM"
}
function mbfl-containers-array-fold-1.2 () {
    mbfl_declare_index_array_varref(ARRY)
    mbfl_declare_varref(L_ACCUM, '0')
    mbfl_declare_varref(R_ACCUM, '0')
    declare L_EXPECTED_RESULT='0'
    declare R_EXPECTED_RESULT='0'

    mbfl_array_left_fold  _(L_ACCUM) 'operator_mbfl_containers_array_fold_1_1' _(ARRY)
    mbfl_array_right_fold _(R_ACCUM) 'operator_mbfl_containers_array_fold_1_1' _(ARRY)

    dotest-equal "$L_EXPECTED_RESULT" "$L_ACCUM" &&
	dotest-equal "$R_EXPECTED_RESULT" "$R_ACCUM"
}
function mbfl-containers-array-fold-1.3 () {
    mbfl_declare_index_array_varref(ARRY, (a b c d e))
    mbfl_declare_varref(L_ACCUM, '0')
    mbfl_declare_varref(R_ACCUM, '0')

    mbfl_array_left_fold  _(L_ACCUM) 'operator_return_nine' _(ARRY)
    declare L_RETURN_STATUS=$?
    mbfl_array_right_fold _(R_ACCUM) 'operator_return_nine' _(ARRY)
    declare R_RETURN_STATUS=$?

    dotest-equal	9 "$L_RETURN_STATUS" 'left return status' &&
	dotest-equal	9 "$R_RETURN_STATUS" 'right return status'
}

### ------------------------------------------------------------------------

function operator_mbfl_containers_multi_array_fold_1_1 () {
    mbfl_mandatory_nameref_parameter(ACCUM,	1, accumulator)
    mbfl_mandatory_nameref_parameter(VALUES,	2, index array of values)
    declare -i I
    declare STR

    #mbfl_array_dump _(VALUES) VALUES
    for ((I=0; I < mbfl_slots_number(VALUES); ++I))
    do STR+=mbfl_slot_qref(VALUES, $I)
    done
    ACCUM+=$STR
}
function mbfl-containers-multi-array-fold-1.1 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e))
    mbfl_declare_index_array_varref(ARRYS, _(ARRY1))
    mbfl_declare_varref(L_ACCUM, '0')
    mbfl_declare_varref(R_ACCUM, '0')
    declare L_EXPECTED_RESULT='0abcde'
    declare R_EXPECTED_RESULT='0edcba'

    mbfl_multi_array_left_fold  _(L_ACCUM) 'operator_mbfl_containers_multi_array_fold_1_1' _(ARRYS)
    mbfl_multi_array_right_fold _(R_ACCUM) 'operator_mbfl_containers_multi_array_fold_1_1' _(ARRYS)

    dotest-equal	"$L_EXPECTED_RESULT" "$L_ACCUM" 'left fold result'	&&
	dotest-equal	"$R_EXPECTED_RESULT" "$R_ACCUM" 'right fold result'
}

### ------------------------------------------------------------------------

function operator_mbfl_containers_multi_array_fold_1_2 () {
    mbfl_mandatory_nameref_parameter(ACCUM,	1, accumulator)
    mbfl_mandatory_nameref_parameter(VALUES,	2, index array of values)
    declare -i I
    declare STR

    #mbfl_array_dump _(VALUES) VALUES
    for ((I=0; I < mbfl_slots_number(VALUES); ++I))
    do STR+=mbfl_slot_qref(VALUES, $I)
    done
    ACCUM+=" $STR"
}
function mbfl-containers-multi-array-fold-1.2 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e))
    mbfl_declare_index_array_varref(ARRY2, (A B C D E))
    mbfl_declare_index_array_varref(ARRY3, (q w e r t))
    mbfl_declare_index_array_varref(ARRYS, (_(ARRY1) _(ARRY2) _(ARRY3)))
    mbfl_declare_varref(L_ACCUM, '0')
    mbfl_declare_varref(R_ACCUM, '0')
    declare L_EXPECTED_RESULT='0 aAq bBw cCe dDr eEt'
    declare R_EXPECTED_RESULT='0 eEt dDr cCe bBw aAq'

    mbfl_multi_array_left_fold  _(L_ACCUM) 'operator_mbfl_containers_multi_array_fold_1_2' _(ARRYS)
    mbfl_multi_array_right_fold _(R_ACCUM) 'operator_mbfl_containers_multi_array_fold_1_2' _(ARRYS)

    dotest-equal	"$L_EXPECTED_RESULT" "$L_ACCUM" 'left fold result'	&&
	dotest-equal	"$R_EXPECTED_RESULT" "$R_ACCUM" 'right fold result'
}

### ------------------------------------------------------------------------

function mbfl-containers-multi-array-fold-1.3 () {
    mbfl_declare_index_array_varref(ARRYS)
    mbfl_declare_varref(L_ACCUM, '0')
    mbfl_declare_varref(R_ACCUM, '0')
    declare L_EXPECTED_RESULT='0'
    declare R_EXPECTED_RESULT='0'

    mbfl_multi_array_left_fold  _(L_ACCUM) 'operator_mbfl_containers_multi_array_fold_1_2' _(ARRYS)
    mbfl_multi_array_right_fold _(R_ACCUM) 'operator_mbfl_containers_multi_array_fold_1_2' _(ARRYS)

    dotest-equal	"$L_EXPECTED_RESULT" "$L_ACCUM" 'left fold result'	&&
	dotest-equal	"$R_EXPECTED_RESULT" "$R_ACCUM" 'right fold result'
}
function mbfl-containers-multi-array-fold-1.4 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e))
    mbfl_declare_index_array_varref(ARRY2, (A B C D E))
    mbfl_declare_index_array_varref(ARRY3, (q w e r t))
    mbfl_declare_index_array_varref(ARRYS, (_(ARRY1) _(ARRY2) _(ARRY3)))
    mbfl_declare_varref(L_ACCUM, '0')
    mbfl_declare_varref(R_ACCUM, '0')

    mbfl_multi_array_left_fold  _(L_ACCUM) 'operator_return_nine' _(ARRYS)
    declare L_RETURN_STATUS=$?
    mbfl_multi_array_right_fold _(R_ACCUM) 'operator_return_nine' _(ARRYS)
    declare R_RETURN_STATUS=$?

    dotest-equal	9 "$L_RETURN_STATUS" 'left return status' &&
	dotest-equal	9 "$R_RETURN_STATUS" 'right return status'
}


#### index arrays: foreach iteration

function operator_mbfl_containers_array_foreach_1_1 () {
    mbfl_mandatory_parameter(VALUE, 1, value from the array)
    echo "$VALUE"
}
function mbfl-containers-array-foreach-1.1 () {
    mbfl_declare_index_array_varref(ARRY, (a b c d e))
    declare L_EXPECTED_RESULT=$'a\nb\nc\nd\ne'
    declare R_EXPECTED_RESULT=$'e\nd\nc\nb\na'

    declare L_RESULT=$(mbfl_array_left_foreach  'operator_mbfl_containers_array_foreach_1_1' _(ARRY))
    declare R_RESULT=$(mbfl_array_right_foreach 'operator_mbfl_containers_array_foreach_1_1' _(ARRY))

    dotest-equal	"$L_EXPECTED_RESULT" "$L_RESULT" 'left foreach result' &&
	dotest-equal	"$R_EXPECTED_RESULT" "$R_RESULT" 'right foreach result'
}
function mbfl-containers-array-foreach-1.2 () {
    mbfl_declare_index_array_varref(ARRY)
    declare L_EXPECTED_RESULT=
    declare R_EXPECTED_RESULT=

    declare L_RESULT=$(mbfl_array_left_foreach  'operator_mbfl_containers_array_foreach_1_1' _(ARRY))
    declare R_RESULT=$(mbfl_array_right_foreach 'operator_mbfl_containers_array_foreach_1_1' _(ARRY))

    dotest-equal	"$L_EXPECTED_RESULT" "$L_RESULT" 'left foreach result' &&
	dotest-equal	"$R_EXPECTED_RESULT" "$R_RESULT" 'right foreach result'
}
function mbfl-containers-array-foreach-1.3 () {
    mbfl_declare_index_array_varref(ARRY, (a b c d e))

    mbfl_array_left_foreach  'operator_return_nine' _(ARRY)
    declare L_RETURN_STATUS=$?
    mbfl_array_right_foreach 'operator_return_nine' _(ARRY)
    declare R_RETURN_STATUS=$?

    dotest-equal	9 "$L_RETURN_STATUS" 'left return status' &&
	dotest-equal	9 "$R_RETURN_STATUS" 'right return status'
}

### ------------------------------------------------------------------------

function operator_mbfl_containers_multi_array_foreach_1_1 () {
    mbfl_mandatory_nameref_parameter(VALUES, 1, reference to index array of homologous values)
    declare -i I VALUE=0

    for ((I=0; I < mbfl_slots_number(VALUES); ++I))
    do let VALUE+=mbfl_slot_ref(VALUES, $I)
    done
    echo "$VALUE"
}
function mbfl-containers-multi-array-foreach-1.1 () {
    mbfl_declare_index_array_varref(ARRY1, (1   2   3   4))
    mbfl_declare_index_array_varref(ARRY2, (10  20  30  40))
    mbfl_declare_index_array_varref(ARRY3, (100 200 300 400))
    mbfl_declare_index_array_varref(ARRYS, (_(ARRY1) _(ARRY2) _(ARRY3)))

    declare L_EXPECTED_RESULT=$'111\n222\n333\n444'
    declare R_EXPECTED_RESULT=$'444\n333\n222\n111'

    declare L_RESULT=$(mbfl_multi_array_left_foreach  'operator_mbfl_containers_multi_array_foreach_1_1' _(ARRYS))
    declare R_RESULT=$(mbfl_multi_array_right_foreach 'operator_mbfl_containers_multi_array_foreach_1_1' _(ARRYS))

    dotest-equal	"$L_EXPECTED_RESULT" "$L_RESULT" 'left foreach result' &&
	dotest-equal	"$R_EXPECTED_RESULT" "$R_RESULT" 'right foreach result'
}
function mbfl-containers-multi-array-foreach-1.2 () {
    mbfl_declare_index_array_varref(ARRY1, (1   2   3   4))
    mbfl_declare_index_array_varref(ARRYS, (_(ARRY1)))

    declare L_EXPECTED_RESULT=$'1\n2\n3\n4'
    declare R_EXPECTED_RESULT=$'4\n3\n2\n1'

    declare L_RESULT=$(mbfl_multi_array_left_foreach  'operator_mbfl_containers_multi_array_foreach_1_1' _(ARRYS))
    declare R_RESULT=$(mbfl_multi_array_right_foreach 'operator_mbfl_containers_multi_array_foreach_1_1' _(ARRYS))

    dotest-equal	"$L_EXPECTED_RESULT" "$L_RESULT" 'left foreach result' &&
	dotest-equal	"$R_EXPECTED_RESULT" "$R_RESULT" 'right foreach result'
}
function mbfl-containers-multi-array-foreach-1.3 () {
    mbfl_declare_index_array_varref(ARRYS)

    declare L_EXPECTED_RESULT=
    declare R_EXPECTED_RESULT=

    declare L_RESULT=$(mbfl_multi_array_left_foreach  'operator_mbfl_containers_multi_array_foreach_1_1' _(ARRYS))
    declare R_RESULT=$(mbfl_multi_array_right_foreach 'operator_mbfl_containers_multi_array_foreach_1_1' _(ARRYS))

    dotest-equal	"$L_EXPECTED_RESULT" "$L_RESULT" 'left foreach result' &&
	dotest-equal	"$R_EXPECTED_RESULT" "$R_RESULT" 'right foreach result'
}
function mbfl-containers-multi-array-foreach-1.4 () {
    mbfl_declare_index_array_varref(ARRY1, (1   2   3   4))
    mbfl_declare_index_array_varref(ARRYS, (_(ARRY1)))

    mbfl_multi_array_left_foreach  'operator_return_nine' _(ARRYS)
    declare L_RETURN_STATUS=$?
    mbfl_multi_array_right_foreach 'operator_return_nine' _(ARRYS)
    declare R_RETURN_STATUS=$?

    dotest-equal	9 "$L_RETURN_STATUS" 'left return status' &&
	dotest-equal	9 "$R_RETURN_STATUS" 'right return status'
}


#### index arrays: mapping

function mbfl-containers-array-map-1.1 () {
    #                                          0 1 2 3 4
    mbfl_declare_index_array_varref(ARRY,     (a b c d e))
    mbfl_declare_index_array_varref(L_RESULT, (. . . . .))
    mbfl_declare_index_array_varref(R_RESULT, (. . . . .))

    mbfl_declare_index_array_varref(L_EXPECTED_RESULT, (A B C D E))
    mbfl_declare_index_array_varref(R_EXPECTED_RESULT, (A B C D E))

    mbfl_array_left_map   _(L_RESULT)'mbfl_string_toupper_var' _(ARRY)
    mbfl_array_right_map _(R_RESULT) 'mbfl_string_toupper_var' _(ARRY)

    mbfl_array_equal _(L_EXPECTED_RESULT) _(L_RESULT) &&
	mbfl_array_equal _(R_EXPECTED_RESULT) _(R_RESULT)
}
function mbfl-containers-array-map-1.2 () {
    mbfl_declare_index_array_varref(ARRY)
    mbfl_declare_index_array_varref(L_RESULT)
    mbfl_declare_index_array_varref(R_RESULT)

    mbfl_declare_index_array_varref(L_EXPECTED_RESULT)
    mbfl_declare_index_array_varref(R_EXPECTED_RESULT)

    mbfl_array_left_map  _(L_RESULT) 'mbfl_string_toupper_var' _(ARRY)
    mbfl_array_right_map _(R_RESULT) 'mbfl_string_toupper_var' _(ARRY)

    mbfl_array_equal _(L_EXPECTED_RESULT) _(L_RESULT) &&
	mbfl_array_equal _(R_EXPECTED_RESULT) _(R_RESULT)
}
function mbfl-containers-array-map-1.3 () {
    mbfl_declare_index_array_varref(ARRY,     (a b c d e))
    mbfl_declare_index_array_varref(L_RESULT, (. . . . .))
    mbfl_declare_index_array_varref(R_RESULT, (. . . . .))

    mbfl_array_left_map  _(L_RESULT) 'operator_return_nine' _(ARRY)
    declare L_RETURN_STATUS=$?
    mbfl_array_right_map _(R_RESULT) 'operator_return_nine' _(ARRY)
    declare R_RETURN_STATUS=$?

    dotest-equal	9 "$L_RETURN_STATUS" 'left return status' &&
	dotest-equal	9 "$R_RETURN_STATUS" 'right return status'
}

### ------------------------------------------------------------------------

function operator_mbfl_containers_multi_array_map_1_1 () {
    mbfl_mandatory_nameref_parameter(RV,    1, reference to result variable)
    mbfl_mandatory_nameref_parameter(ITEMS, 2, reference to index array of items)
    declare -i I VALUE=0

    #mbfl_array_dump _(ITEMS) ITEMS
    for ((I=0; I < mbfl_slots_number(ITEMS); ++I))
    do let VALUE+=mbfl_slot_qref(ITEMS, $I)
    done
    RV+=$VALUE
}
function mbfl-containers-multi-array-map-1.1 () {
    mbfl_declare_index_array_varref(ARRY1, (1   2   3   4))
    mbfl_declare_index_array_varref(ARRY2, (10  20  30  40))
    mbfl_declare_index_array_varref(ARRY3, (100 200 300 400))
    mbfl_declare_index_array_varref(ARRYS, (_(ARRY1) _(ARRY2) _(ARRY3)))

    mbfl_declare_index_array_varref(L_RESULT)
    mbfl_declare_index_array_varref(R_RESULT)

    mbfl_declare_index_array_varref(L_EXPECTED_RESULT, (111 222 333 444))
    mbfl_declare_index_array_varref(R_EXPECTED_RESULT, (111 222 333 444))

    mbfl_multi_array_left_map  _(L_RESULT) 'operator_mbfl_containers_multi_array_map_1_1' _(ARRYS)
    mbfl_multi_array_right_map _(R_RESULT) 'operator_mbfl_containers_multi_array_map_1_1' _(ARRYS)
    mbfl_array_equal _(L_EXPECTED_RESULT) _(L_RESULT) &&
	mbfl_array_equal _(R_EXPECTED_RESULT) _(R_RESULT)
}
function mbfl-containers-multi-array-map-1.2 () {
    mbfl_declare_index_array_varref(ARRY1, (1   2   3   4))
    mbfl_declare_index_array_varref(ARRYS, (_(ARRY1)))

    mbfl_declare_index_array_varref(L_RESULT)
    mbfl_declare_index_array_varref(R_RESULT)

    mbfl_declare_index_array_varref(L_EXPECTED_RESULT, (1 2 3 4))
    mbfl_declare_index_array_varref(R_EXPECTED_RESULT, (1 2 3 4))

    mbfl_multi_array_left_map  _(L_RESULT) 'operator_mbfl_containers_multi_array_map_1_1' _(ARRYS)
    mbfl_multi_array_right_map _(R_RESULT) 'operator_mbfl_containers_multi_array_map_1_1' _(ARRYS)

    mbfl_array_equal _(L_EXPECTED_RESULT) _(L_RESULT) &&
	mbfl_array_equal _(R_EXPECTED_RESULT) _(R_RESULT)
}
function mbfl-containers-multi-array-map-1.3 () {
    mbfl_declare_index_array_varref(ARRYS)

    mbfl_declare_index_array_varref(L_RESULT)
    mbfl_declare_index_array_varref(R_RESULT)

    mbfl_declare_index_array_varref(L_EXPECTED_RESULT)
    mbfl_declare_index_array_varref(R_EXPECTED_RESULT)

    mbfl_multi_array_left_map  _(L_RESULT) 'operator_mbfl_containers_multi_array_map_1_1' _(ARRYS)
    mbfl_multi_array_right_map _(R_RESULT) 'operator_mbfl_containers_multi_array_map_1_1' _(ARRYS)

    mbfl_array_equal _(L_EXPECTED_RESULT) _(L_RESULT) &&
	mbfl_array_equal _(R_EXPECTED_RESULT) _(R_RESULT)
}
function mbfl-containers-multi-array-map-1.4 () {
    mbfl_declare_index_array_varref(ARRY1, (1   2   3   4))
    mbfl_declare_index_array_varref(ARRYS, (_(ARRY1)))

    mbfl_declare_index_array_varref(L_RESULT)
    mbfl_declare_index_array_varref(R_RESULT)

    mbfl_multi_array_left_map  _(L_RESULT) 'operator_return_nine' _(ARRYS)
    declare L_RETURN_STATUS=$?
    mbfl_multi_array_right_map _(R_RESULT) 'operator_return_nine' _(ARRYS)
    declare R_RETURN_STATUS=$?

    dotest-equal	9 "$L_RETURN_STATUS" 'left return status' &&
	dotest-equal	9 "$R_RETURN_STATUS" 'right return status'
}


#### index arrays: appending

function mbfl-containers-array-append-1.1 () {
    mbfl_declare_index_array_varref(DST_ARRY, (a b c d e))
    mbfl_declare_index_array_varref(SRC_ARRY, (A B C D E))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c d e A B C D E))

    mbfl_array_append _(DST_ARRY) _(SRC_ARRY)
    #mbfl_array_dump _(DST_ARRY) DST_ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(DST_ARRY)
}
function mbfl-containers-array-append-1.2 () {
    mbfl_declare_index_array_varref(DST_ARRY)
    mbfl_declare_index_array_varref(SRC_ARRY, (A B C D E))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (A B C D E))

    mbfl_array_append _(DST_ARRY) _(SRC_ARRY)
    #mbfl_array_dump _(DST_ARRY) DST_ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(DST_ARRY)
}
function mbfl-containers-array-append-1.3 () {
    mbfl_declare_index_array_varref(DST_ARRY, (a b c d e))
    mbfl_declare_index_array_varref(SRC_ARRY)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c d e))

    mbfl_array_append _(DST_ARRY) _(SRC_ARRY)
    #mbfl_array_dump _(DST_ARRY) DST_ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(DST_ARRY)
}

### ------------------------------------------------------------------------

function mbfl-containers-multi-array-append-1.1 () {
    mbfl_declare_index_array_varref(DST_ARRY, (a b c d e))
    mbfl_declare_index_array_varref(SRC_ARRY1, (A B C))
    mbfl_declare_index_array_varref(SRC_ARRY2, (D E))
    mbfl_declare_index_array_varref(SRC_ARRY3, (F G H I))
    mbfl_declare_index_array_varref(SRC_ARRYS, (_(SRC_ARRY1) _(SRC_ARRY2) _(SRC_ARRY3)))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c d e A B C D E F G H I))

    mbfl_multi_array_append _(DST_ARRY) _(SRC_ARRYS)
    #mbfl_array_dump _(DST_ARRY) DST_ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(DST_ARRY)
}


#### index arrays: sorting predicates

function mbfl-containers-array-is-sorted-1.1 () {
    mbfl_declare_index_array_varref(ARRY)

    mbfl_array_is_sorted _(ARRY)
}
function mbfl-containers-array-is-sorted-1.2 () {
    mbfl_declare_index_array_varref(ARRY, (a))

    mbfl_array_is_sorted _(ARRY)
}
function mbfl-containers-array-is-sorted-1.3 () {
    mbfl_declare_index_array_varref(ARRY, (a b c d e f))

    mbfl_array_is_sorted _(ARRY)
}
function mbfl-containers-array-is-sorted-1.4 () {
    mbfl_declare_index_array_varref(ARRY, (b a))

    ! mbfl_array_is_sorted _(ARRY)
}
function mbfl-containers-array-is-sorted-1.5 () {
    mbfl_declare_index_array_varref(ARRY, (a b c e d))

    ! mbfl_array_is_sorted _(ARRY)
}
function mbfl-containers-array-is-sorted-2.1 () {
    mbfl_declare_index_array_varref(ARRY, (11 22 33 44))

    mbfl_array_is_sorted _(ARRY) mbfl_integer_less
}
function mbfl-containers-array-is-sorted-2.2 () {
    mbfl_declare_index_array_varref(ARRY, (11 22 999 33 44))

    ! mbfl_array_is_sorted _(ARRY) mbfl_integer_less
}


#### index arrays: sorting with quicksort 2-partition

function mbfl-containers-array-quicksort-1.1 () {
    mbfl_declare_index_array_varref(ARRY)
    mbfl_declare_index_array_varref(EXPECTED_RESULT)

    mbfl_array_quicksort_bang _(ARRY)
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-quicksort-1.2 () {
    mbfl_declare_index_array_varref(ARRY, (a))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a))

    mbfl_array_quicksort_bang _(ARRY)
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-quicksort-1.3.1 () {
    # Array already ordered.
    mbfl_declare_index_array_varref(ARRY, (a b c d e))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c d e))

    mbfl_array_quicksort_bang _(ARRY)
    #mbfl_array_dump _(ARRY)
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-quicksort-1.3.2 () {
    # Array inverse-ordered.
    mbfl_declare_index_array_varref(ARRY, (e d c b a))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c d e))

    mbfl_array_quicksort_bang _(ARRY)
    #mbfl_array_dump _(ARRY)
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-quicksort-1.4.1 () {
    mbfl_declare_index_array_varref(ARRY, (b a c))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c))

    mbfl_array_quicksort_bang _(ARRY)
    #mbfl_array_dump _(ARRY)
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-quicksort-1.4.2 () {
    mbfl_declare_index_array_varref(ARRY, (a c b))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c))

    mbfl_array_quicksort_bang _(ARRY)
    #mbfl_array_dump _(ARRY)
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-quicksort-1.5 () {
    # Odd number of values.
    mbfl_declare_index_array_varref(ARRY, (e b a c d))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c d e))

    #echo $FUNCNAME mbfl_slots_qvalues(ARRY) >&2
    mbfl_array_quicksort_bang _(ARRY)
    #mbfl_array_dump _(ARRY)
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-quicksort-1.6 () {
    # Even number of values.
    mbfl_declare_index_array_varref(ARRY, (e b a f c d))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c d e f))

    mbfl_array_quicksort_bang _(ARRY)
    #mbfl_array_dump _(ARRY)
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-quicksort-1.7.1 () {
    # Values with non-zero multiplicity.
    mbfl_declare_index_array_varref(ARRY, (a b b c d d e))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b b c d d e))

    mbfl_array_quicksort_bang _(ARRY)
    #mbfl_array_dump _(ARRY)
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-quicksort-1.7.2 () {
    # Values with non-zero multiplicity.
    mbfl_declare_index_array_varref(ARRY, (a b c d b e d))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b b c d d e))

    mbfl_array_quicksort_bang _(ARRY)
    #mbfl_array_dump _(ARRY)
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}

function mbfl-containers-array-quicksort-2.1 () {
    mbfl_declare_index_array_varref(ARRY, (6666 9 777 88))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (9 88 777 6666))

    #mbfl_array_dump _(ARRY)
    mbfl_array_quicksort_bang _(ARRY) mbfl_integer_less
    #mbfl_array_dump _(ARRY)
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-quicksort-2.2 () {
    # 100 values.
    if true
    then mbfl_declare_index_array_varref(ARRY,
					 (31701 21560 25510    20147 22805 31603    24581 17618 28331    31937
					  18001 10924  8816    18703  6012 19360    28348 23169 23032     7795
					   4499 16929 23842     8234 22149 27364    24816  4269 28716    19255
					   8674 11405 30773     2090  1866 16831     8079 27315 23323    14416
					  29052 32337 12420    15017 25087 10323     8633  3228 15296    32097
					  31917   568 26998    23994 26255 10605      729 16652 27121    16472
					  29348  9837 17356     4171 26252   938    23685   617  1699    30818
					  11242 23384 28828     5124  9220 23012     5970 31242 19279    21598
					  27827 15491 19120    30117 31452 14024    14668  5410 28796     9564
					  1580  20344    49    25969 13488  8559     9631  2492 25604      628))
    else
	mbfl_declare_index_array_varref(ARRY,
					($RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM))
	echo mbfl_slots_qvalues(ARRY) >&2
    fi

    #mbfl_array_dump _(ARRY)
    mbfl_array_quicksort_bang _(ARRY) mbfl_integer_less
    #mbfl_array_dump _(ARRY)
    mbfl_array_is_sorted _(ARRY) mbfl_integer_less
}
function mbfl-containers-array-quicksort-2.3 () {
    # 101 values.
    if true
    then mbfl_declare_index_array_varref(ARRY,
					 (19613 16958  8121    23854 29912 25794    14559 11395 31855   10989
					  17866  5728  3339    24636 23157 19184    17699 27796 27631   26072
					  10163 30532 30615    12304 30286  2146      508  6453 29424   20388
					  22993   306 13432    26449 13285 19890    10188 22795 29293   21426
					  25697 12921   527    12824 31208 14116     6096  3356 28439    9881
					   3827  3736 23124    27426 16011   455    10955 19610 22168   19862
					   5297  4131 29696    14139 11056 12420    31412 17012 29737   16462
					   7624  4426 27632    13116  5081 20796     5636   138 20528   26684
					  24513 30597  6538    14875  6443 19640     2250  8086  9477   18288
					   3106 17364  4679    22146   285 31056      603  9631 21491   15847
					  21808))
    else
	mbfl_declare_index_array_varref(ARRY,
					($RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM))
	echo mbfl_slots_qvalues(ARRY) >&2
    fi

    #mbfl_array_dump _(ARRY)
    mbfl_array_quicksort_bang _(ARRY) mbfl_integer_less
    #mbfl_array_dump _(ARRY)
    mbfl_array_is_sorted _(ARRY) mbfl_integer_less
}


#### index arrays: sorting with quicksort 3-partition

function mbfl-containers-array-quicksort3-1.1 () {
    mbfl_declare_index_array_varref(ARRY)
    mbfl_declare_index_array_varref(EXPECTED_RESULT)

    mbfl_array_quicksort3_bang _(ARRY)
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-quicksort3-1.2 () {
    mbfl_declare_index_array_varref(ARRY, (a))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a))

    mbfl_array_quicksort3_bang _(ARRY)
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-quicksort3-1.3.1 () {
    # Array already ordered.
    mbfl_declare_index_array_varref(ARRY, (a b c d e))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c d e))

    mbfl_array_quicksort3_bang _(ARRY)
    #mbfl_array_dump _(ARRY)
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-quicksort3-1.3.2 () {
    # Array inverse-ordered.
    mbfl_declare_index_array_varref(ARRY, (e d c b a))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c d e))

    mbfl_array_quicksort3_bang _(ARRY)
    #mbfl_array_dump _(ARRY)
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-quicksort3-1.4.1 () {
    mbfl_declare_index_array_varref(ARRY, (b a c))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c))

    mbfl_array_quicksort3_bang _(ARRY)
    #mbfl_array_dump _(ARRY)
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-quicksort3-1.4.2 () {
    mbfl_declare_index_array_varref(ARRY, (a c b))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c))

    mbfl_array_quicksort3_bang _(ARRY)
    #mbfl_array_dump _(ARRY)
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-quicksort3-1.5 () {
    # Odd number of values.
    mbfl_declare_index_array_varref(ARRY, (e b a c d))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c d e))

    #echo $FUNCNAME mbfl_slots_qvalues(ARRY) >&2
    mbfl_array_quicksort3_bang _(ARRY)
    #mbfl_array_dump _(ARRY)
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-quicksort3-1.6 () {
    # Even number of values.
    mbfl_declare_index_array_varref(ARRY, (e b a f c d))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c d e f))

    mbfl_array_quicksort3_bang _(ARRY)
    #mbfl_array_dump _(ARRY)
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-quicksort3-1.7.1 () {
    # Values with non-zero multiplicity.
    mbfl_declare_index_array_varref(ARRY, (a b b c d d e))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b b c d d e))

    mbfl_array_quicksort3_bang _(ARRY)
    #mbfl_array_dump _(ARRY)
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-quicksort3-1.7.2 () {
    # Values with non-zero multiplicity.
    mbfl_declare_index_array_varref(ARRY, (a b c d b e d))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b b c d d e))

    mbfl_array_quicksort3_bang _(ARRY)
    #mbfl_array_dump _(ARRY)
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}

function mbfl-containers-array-quicksort3-2.1 () {
    mbfl_declare_index_array_varref(ARRY, (6666 9 777 88))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (9 88 777 6666))

    #mbfl_array_dump _(ARRY)
    mbfl_array_quicksort3_bang _(ARRY) mbfl_integer_less mbfl_integer_equal
    #mbfl_array_dump _(ARRY)
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-quicksort3-2.2 () {
    # 100 values.
    if true
    then mbfl_declare_index_array_varref(ARRY,
					 (31701 21560 25510    20147 22805 31603    24581 17618 28331    31937
					  18001 10924  8816    18703  6012 19360    28348 23169 23032     7795
					   4499 16929 23842     8234 22149 27364    24816  4269 28716    19255
					   8674 11405 30773     2090  1866 16831     8079 27315 23323    14416
					  29052 32337 12420    15017 25087 10323     8633  3228 15296    32097
					  31917   568 26998    23994 26255 10605      729 16652 27121    16472
					  29348  9837 17356     4171 26252   938    23685   617  1699    30818
					  11242 23384 28828     5124  9220 23012     5970 31242 19279    21598
					  27827 15491 19120    30117 31452 14024    14668  5410 28796     9564
					  1580  20344    49    25969 13488  8559     9631  2492 25604      628))
    else
	mbfl_declare_index_array_varref(ARRY,
					($RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM))
	echo mbfl_slots_qvalues(ARRY) >&2
    fi

    #mbfl_array_dump _(ARRY)
    mbfl_array_quicksort3_bang _(ARRY) mbfl_integer_less mbfl_integer_equal
    #mbfl_array_dump _(ARRY)
    mbfl_array_is_sorted _(ARRY) mbfl_integer_less mbfl_integer_equal
}
function mbfl-containers-array-quicksort3-2.3 () {
    # 101 values.
    if true
    then mbfl_declare_index_array_varref(ARRY,
					 (19613 16958  8121    23854 29912 25794    14559 11395 31855   10989
					  17866  5728  3339    24636 23157 19184    17699 27796 27631   26072
					  10163 30532 30615    12304 30286  2146      508  6453 29424   20388
					  22993   306 13432    26449 13285 19890    10188 22795 29293   21426
					  25697 12921   527    12824 31208 14116     6096  3356 28439    9881
					   3827  3736 23124    27426 16011   455    10955 19610 22168   19862
					   5297  4131 29696    14139 11056 12420    31412 17012 29737   16462
					   7624  4426 27632    13116  5081 20796     5636   138 20528   26684
					  24513 30597  6538    14875  6443 19640     2250  8086  9477   18288
					   3106 17364  4679    22146   285 31056      603  9631 21491   15847
					  21808))
    else
	mbfl_declare_index_array_varref(ARRY,
					($RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM $RANDOM $RANDOM  $RANDOM
					 $RANDOM))
	echo mbfl_slots_qvalues(ARRY) >&2
    fi

    #mbfl_array_dump _(ARRY)
    mbfl_array_quicksort3_bang _(ARRY) mbfl_integer_less mbfl_integer_equal
    #mbfl_array_dump _(ARRY)
    mbfl_array_is_sorted _(ARRY) mbfl_integer_less mbfl_integer_equal
}


#### index arrays: insert sort

function mbfl-containers-array-insertsort-1.1 () {
    mbfl_location_enter
    {
	mbfl_location_handler 'mbfl_array_INSERTSORT_LINEAR_LIMIT=5'
	mbfl_array_INSERTSORT_LINEAR_LIMIT=100

	mbfl_declare_index_array_varref(ARRY)
	mbfl_declare_index_array_varref(EXPECTED_RESULT, (C))

	mbfl_array_insertsort_bang _(ARRY) C
	mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
    }
    mbfl_location_leave
}
function mbfl-containers-array-insertsort-1.2 () {
    mbfl_location_enter
    {
	mbfl_location_handler 'mbfl_array_INSERTSORT_LINEAR_LIMIT=5'
	mbfl_array_INSERTSORT_LINEAR_LIMIT=100

	mbfl_declare_index_array_varref(ARRY, (A))
	mbfl_declare_index_array_varref(EXPECTED_RESULT, (A C))

	mbfl_array_insertsort_bang _(ARRY) C
	mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
    }
    mbfl_location_leave
}
function mbfl-containers-array-insertsort-1.3 () {
    mbfl_location_enter
    {
	mbfl_location_handler 'mbfl_array_INSERTSORT_LINEAR_LIMIT=5'
	mbfl_array_INSERTSORT_LINEAR_LIMIT=100

	mbfl_declare_index_array_varref(ARRY, (A C))
	mbfl_declare_index_array_varref(EXPECTED_RESULT, (A B C))

	mbfl_array_insertsort_bang _(ARRY) B
	mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
    }
    mbfl_location_leave
}
function mbfl-containers-array-insertsort-1.4 () {
    mbfl_location_enter
    {
	mbfl_location_handler 'mbfl_array_INSERTSORT_LINEAR_LIMIT=5'
	mbfl_array_INSERTSORT_LINEAR_LIMIT=100

	mbfl_declare_index_array_varref(ARRY, (A B C D E F G))
	mbfl_declare_index_array_varref(EXPECTED_RESULT, (A B C D DUH E F G))

	mbfl_array_insertsort_bang _(ARRY) DUH
	mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
    }
    mbfl_location_leave
}
function mbfl-containers-array-insertsort-1.5 () {
    mbfl_location_enter
    {
	mbfl_location_handler 'mbfl_array_INSERTSORT_LINEAR_LIMIT=5'
	mbfl_array_INSERTSORT_LINEAR_LIMIT=100

	mbfl_declare_index_array_varref(ARRY, (A B C D E F G))
	mbfl_declare_index_array_varref(EXPECTED_RESULT, (A B C D E F G H))

	mbfl_array_insertsort_bang _(ARRY) H
	mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
    }
    mbfl_location_leave
}
function mbfl-containers-array-insertsort-1.6 () {
    mbfl_location_enter
    {
	mbfl_location_handler 'mbfl_array_INSERTSORT_LINEAR_LIMIT=5'
	mbfl_array_INSERTSORT_LINEAR_LIMIT=100

	mbfl_declare_index_array_varref(ARRY, (B C D E F G))
	mbfl_declare_index_array_varref(EXPECTED_RESULT, (A B C D E F G))

	mbfl_array_insertsort_bang _(ARRY) A
	mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
    }
    mbfl_location_leave
}
function mbfl-containers-array-insertsort-1.7 () {
    mbfl_location_enter
    {
	mbfl_location_handler 'mbfl_array_INSERTSORT_LINEAR_LIMIT=5'
	mbfl_array_INSERTSORT_LINEAR_LIMIT=100

	mbfl_declare_index_array_varref(ARRY, (A B C DA DB E F G))
	mbfl_declare_index_array_varref(EXPECTED_RESULT, (A B C DA DB DC E F G))

	mbfl_array_insertsort_bang _(ARRY) DC test_string_less_first_char
	#mbfl_array_dump _(ARRY)
	mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function mbfl-containers-array-insertsort-2.1.1 () {
    mbfl_location_enter
    {
	mbfl_location_handler 'mbfl_array_INSERTSORT_LINEAR_LIMIT=5'
	mbfl_array_INSERTSORT_LINEAR_LIMIT=5

	mbfl_declare_index_array_varref(ARRY,            (a b c d e f g   i l m n o p q r s t u v z))
	mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c d e f g h i l m n o p q r s t u v z))
	#                                                 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0

	mbfl_array_insertsort_bang _(ARRY) h
	mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
    }
    mbfl_location_leave
}
function mbfl-containers-array-insertsort-2.1.2 () {
    mbfl_location_enter
    {
	mbfl_location_handler 'mbfl_array_INSERTSORT_LINEAR_LIMIT=5'
	mbfl_array_INSERTSORT_LINEAR_LIMIT=5

	mbfl_declare_index_array_varref(ARRY,            (a b c d e f g   i l m n o p q r s t u v x z))
	mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c d e f g h i l m n o p q r s t u v x z))
	#                                                 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1

	mbfl_array_insertsort_bang _(ARRY) h
	mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
    }
    mbfl_location_leave
}
function mbfl-containers-array-insertsort-2.2.1 () {
    mbfl_location_enter
    {
	mbfl_location_handler 'mbfl_array_INSERTSORT_LINEAR_LIMIT=5'
	mbfl_array_INSERTSORT_LINEAR_LIMIT=5

	mbfl_declare_index_array_varref(EXPECTED_RESULT, (A B C D E F G H I L M N O P Q R S T U V Z))
	#                                                 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0

	for ((mbfl_I=0; mbfl_I < mbfl_slots_number(EXPECTED_RESULT); ++mbfl_I))
	do
	    mbfl_declare_index_array_varref(ARRY)

	    mbfl_array_copy _(ARRY) _(EXPECTED_RESULT)
	    mbfl_array_remove _(ARRY) _(ARRY) $mbfl_I

	    #echo $FUNCNAME mbfl_I=$mbfl_I
	    mbfl_array_insertsort_bang _(ARRY) mbfl_slot_qref(EXPECTED_RESULT, $mbfl_I)
	    #mbfl_array_dump _(ARRY) ARRY
	    if ! mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
	    then
		mbfl_location_leave
		return $?
	    fi
	done
    }
    mbfl_location_leave
}
function mbfl-containers-array-insertsort-2.2.2 () {
    mbfl_location_enter
    {
	mbfl_location_handler 'mbfl_array_INSERTSORT_LINEAR_LIMIT=5'
	mbfl_array_INSERTSORT_LINEAR_LIMIT=5

	mbfl_declare_index_array_varref(EXPECTED_RESULT, (A B C D E F G H I L M N O P Q R S T U V X Z))
	#                                                 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1

	for ((mbfl_I=0; mbfl_I < mbfl_slots_number(EXPECTED_RESULT); ++mbfl_I))
	do
	    mbfl_declare_index_array_varref(ARRY)

	    mbfl_array_copy _(ARRY) _(EXPECTED_RESULT)
	    mbfl_array_remove _(ARRY) _(ARRY) $mbfl_I

	    #echo $FUNCNAME mbfl_I=$mbfl_I
	    mbfl_array_insertsort_bang _(ARRY) mbfl_slot_qref(EXPECTED_RESULT, $mbfl_I)
	    #mbfl_array_dump _(ARRY) ARRY
	    if ! mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
	    then
		mbfl_location_leave
		return $?
	    fi
	done
    }
    mbfl_location_leave
}
function mbfl-containers-array-insertsort-2.3 () {
    mbfl_location_enter
    {
	mbfl_location_handler 'mbfl_array_INSERTSORT_LINEAR_LIMIT=5'
	mbfl_array_INSERTSORT_LINEAR_LIMIT=5

	mbfl_declare_index_array_varref(ARRY,            (a b c d e f g ha hb hc hd he hf    i l m n o p q r s t u v z))
	mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c d e f g ha hb hc hd he hf h0 i l m n o p q r s t u v z))
	#                                                 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9

	mbfl_array_insertsort_bang _(ARRY) h0 test_string_less_first_char
	#mbfl_array_dump _(ARRY) ARRY
	mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
    }
    mbfl_location_leave
}



#### index arrays: set operations

function mbfl-containers-array-set-union-1.1 () {
    mbfl_declare_index_array_varref(ARRY1,	(a b c d e))
    mbfl_declare_index_array_varref(ARRY2,	(e f g h i))
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c d e f g h i))

    mbfl_array_set_union _(RESULT) _(ARRY1) _(ARRY2)
    #mbfl_array_dump _(RESULT)
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}
function mbfl-containers-array-set-union-1.2 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e))
    mbfl_declare_index_array_varref(ARRY2,     (c d e f g h i))
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c d e f g h i))

    mbfl_array_set_union _(RESULT) _(ARRY1) _(ARRY2)
    #mbfl_array_dump _(RESULT)
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}
function mbfl-containers-array-set-union-1.3 () {
    mbfl_declare_index_array_varref(ARRY1)
    mbfl_declare_index_array_varref(ARRY2, (c d e f g h i))
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (c d e f g h i))

    mbfl_array_set_union _(RESULT) _(ARRY1) _(ARRY2)
    #mbfl_array_dump _(RESULT)
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}
function mbfl-containers-array-set-union-1.4 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e))
    mbfl_declare_index_array_varref(ARRY2)
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c d e))

    mbfl_array_set_union _(RESULT) _(ARRY1) _(ARRY2)
    #mbfl_array_dump _(RESULT)
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}

### ------------------------------------------------------------------------

function mbfl-containers-array-set-intersection-1.1 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e))
    mbfl_declare_index_array_varref(ARRY2,     (c d e f g h i))
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (c d e))

    mbfl_array_set_intersection _(RESULT) _(ARRY1) _(ARRY2)
    #mbfl_array_dump _(RESULT)
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}
function mbfl-containers-array-set-intersection-1.2 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e))
    mbfl_declare_index_array_varref(ARRY2, (a b c d e))
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c d e))

    mbfl_array_set_intersection _(RESULT) _(ARRY1) _(ARRY2)
    #mbfl_array_dump _(RESULT)
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}
function mbfl-containers-array-set-intersection-1.3 () {
    mbfl_declare_index_array_varref(ARRY1)
    mbfl_declare_index_array_varref(ARRY2, (c d e f g h i))
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT)

    mbfl_array_set_intersection _(RESULT) _(ARRY1) _(ARRY2)
    #mbfl_array_dump _(RESULT)
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}
function mbfl-containers-array-set-intersection-1.4 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e))
    mbfl_declare_index_array_varref(ARRY2)
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT)

    mbfl_array_set_intersection _(RESULT) _(ARRY1) _(ARRY2)
    #mbfl_array_dump _(RESULT)
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}
function mbfl-containers-array-set-intersection-1.5 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e))
    mbfl_declare_index_array_varref(ARRY2,           (f g h i))
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT)

    mbfl_array_set_intersection _(RESULT) _(ARRY1) _(ARRY2)
    #mbfl_array_dump _(RESULT)
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}

### ------------------------------------------------------------------------

function mbfl-containers-array-set-xor-1.1 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e))
    mbfl_declare_index_array_varref(ARRY2,     (c d e f g h i))
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b f g h i))

    mbfl_array_set_xor _(RESULT) _(ARRY1) _(ARRY2)
    #mbfl_array_dump _(RESULT)
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}
function mbfl-containers-array-set-xor-1.2 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e))
    mbfl_declare_index_array_varref(ARRY2, (a b c d e))
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT)

    mbfl_array_set_xor _(RESULT) _(ARRY1) _(ARRY2)
    #mbfl_array_dump _(RESULT)
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}
function mbfl-containers-array-set-xor-1.3 () {
    mbfl_declare_index_array_varref(ARRY1)
    mbfl_declare_index_array_varref(ARRY2, (c d e f g h i))
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (c d e f g h i))

    mbfl_array_set_xor _(RESULT) _(ARRY1) _(ARRY2)
    #mbfl_array_dump _(RESULT)
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}
function mbfl-containers-array-set-xor-1.4 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e))
    mbfl_declare_index_array_varref(ARRY2)
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c d e))

    mbfl_array_set_xor _(RESULT) _(ARRY1) _(ARRY2)
    #mbfl_array_dump _(RESULT)
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}
function mbfl-containers-array-set-xor-1.5 () {
    mbfl_declare_index_array_varref(ARRY1)
    mbfl_declare_index_array_varref(ARRY2)
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT)

    mbfl_array_set_xor _(RESULT) _(ARRY1) _(ARRY2)
    #mbfl_array_dump _(RESULT)
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}
function mbfl-containers-array-set-xor-1.6 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e))
    mbfl_declare_index_array_varref(ARRY2,           (f g h i))
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c d e f g h i))

    mbfl_array_set_xor _(RESULT) _(ARRY1) _(ARRY2)
    #mbfl_array_dump _(RESULT)
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}

### ------------------------------------------------------------------------

function mbfl-containers-array-set-difference-1.1 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e))
    mbfl_declare_index_array_varref(ARRY2,     (c d e f g h i))
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b))

    mbfl_array_set_difference _(RESULT) _(ARRY1) _(ARRY2)
    #mbfl_array_dump _(RESULT)
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}
function mbfl-containers-array-set-difference-1.2 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e))
    mbfl_declare_index_array_varref(ARRY2, (a b c d e))
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT)

    mbfl_array_set_difference _(RESULT) _(ARRY1) _(ARRY2)
    #mbfl_array_dump _(RESULT)
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}
function mbfl-containers-array-set-difference-1.3 () {
    mbfl_declare_index_array_varref(ARRY1)
    mbfl_declare_index_array_varref(ARRY2, (c d e f g h i))
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT)

    mbfl_array_set_difference _(RESULT) _(ARRY1) _(ARRY2)
    #mbfl_array_dump _(RESULT)
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}
function mbfl-containers-array-set-difference-1.4 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e))
    mbfl_declare_index_array_varref(ARRY2)
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c d e))

    mbfl_array_set_difference _(RESULT) _(ARRY1) _(ARRY2)
    #mbfl_array_dump _(RESULT)
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}
function mbfl-containers-array-set-difference-1.5 () {
    mbfl_declare_index_array_varref(ARRY1)
    mbfl_declare_index_array_varref(ARRY2)
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT)

    mbfl_array_set_difference _(RESULT) _(ARRY1) _(ARRY2)
    #mbfl_array_dump _(RESULT)
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}
function mbfl-containers-array-set-difference-1.6 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e))
    mbfl_declare_index_array_varref(ARRY2,           (f g h i))
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c d e))

    mbfl_array_set_difference _(RESULT) _(ARRY1) _(ARRY2)
    #mbfl_array_dump _(RESULT)
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
}


#### index arrays: miscellaneous

function mbfl-containers-array-reverse-1.1 () {
    mbfl_declare_index_array_varref(DST_ARRY)
    mbfl_declare_index_array_varref(SRC_ARRY, (a b c d e))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (e d c b a))

    mbfl_array_reverse _(DST_ARRY) _(SRC_ARRY)
    mbfl_array_equal _(EXPECTED_RESULT) _(DST_ARRY)
}
function mbfl-containers-array-reverse-1.2 () {
    mbfl_declare_index_array_varref(DST_ARRY)
    mbfl_declare_index_array_varref(SRC_ARRY, (a))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a))

    mbfl_array_reverse _(DST_ARRY) _(SRC_ARRY)
    mbfl_array_equal _(EXPECTED_RESULT) _(DST_ARRY)
}
function mbfl-containers-array-reverse-1.3 () {
    mbfl_declare_index_array_varref(DST_ARRY)
    mbfl_declare_index_array_varref(SRC_ARRY)
    mbfl_declare_index_array_varref(EXPECTED_RESULT)

    mbfl_array_reverse _(DST_ARRY) _(SRC_ARRY)
    mbfl_array_equal _(EXPECTED_RESULT) _(DST_ARRY)
}

### ------------------------------------------------------------------------

function mbfl-containers-array-reverse-bang-1.1 () {
    mbfl_declare_index_array_varref(ARRY, (a b c d e f g h i))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (i h g f e d c b a))

    mbfl_array_reverse_bang _(ARRY)
    #mbfl_array_dump _(ARRY) ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-reverse-bang-1.2 () {
    mbfl_declare_index_array_varref(ARRY, (a b c d e f g h))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (h g f e d c b a))

    mbfl_array_reverse_bang _(ARRY)
    #mbfl_array_dump _(ARRY) ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-reverse-bang-1.3 () {
    mbfl_declare_index_array_varref(ARRY, (a))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a))

    mbfl_array_reverse_bang _(ARRY)
    #mbfl_array_dump _(ARRY) ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-reverse-bang-1.4 () {
    mbfl_declare_index_array_varref(ARRY)
    mbfl_declare_index_array_varref(EXPECTED_RESULT)

    mbfl_array_reverse_bang _(ARRY)
    #mbfl_array_dump _(ARRY) ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}

### ------------------------------------------------------------------------

function mbfl-containers-array-swap-bang-1.1 () {
    mbfl_declare_index_array_varref(ARRY,            (a b c D e F g h i))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c F e D g h i))

    mbfl_array_swap_bang _(ARRY) 3 5
    #mbfl_array_dump _(ARRY) ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}
function mbfl-containers-array-swap-bang-1.2 () {
    mbfl_declare_index_array_varref(ARRY,            (a b c d e f g h i))
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a b c d e f g h i))

    mbfl_array_swap_bang _(ARRY) 4 4
    #mbfl_array_dump _(ARRY) ARRY
    mbfl_array_equal _(EXPECTED_RESULT) _(ARRY)
}

### ------------------------------------------------------------------------

function mbfl-containers-array-zip-1.1 () {
    mbfl_declare_index_array_varref(ARRY1, (a b c d e))
    mbfl_declare_index_array_varref(ARRY2, (A B C D E))
    mbfl_declare_index_array_varref(RESULT)
    mbfl_declare_index_array_varref(EXPECTED_RESULT, (a A b B c C d D e E))

    mbfl_array_zip _(RESULT) _(ARRY1) _(ARRY2)
    #mbfl_array_dump _(RESULT) RESULT
    mbfl_array_equal _(EXPECTED_RESULT) _(RESULT)
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
#!# Local Variables:
#!# mode: sh
#!# End:
