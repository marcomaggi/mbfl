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
