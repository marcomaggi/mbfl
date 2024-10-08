#! libmbfl-containers.bash.m4 --
#!
#! Part of: Marco's BASH Functions Library
#! Contents: containers library
#! Date: Apr  9, 2023
#!
#! Abstract
#!
#!	This library implements common containers as default objects.
#!
#!	We take the Segewick-Bentley 2-partition and 3-partitions implementation from:
#!
#!		https://sedgewick.io/
#!		https://sedgewick.io/wp-content/themes/sedgewick/talks/2002QuicksortIsOptimal.pdf
#!
#! Copyright (c) 2023, 2024 Marco Maggi
#! <mrc.mgg@gmail.com>
#!
#! This is free software; you can redistribute it and/or  modify it under the terms of the GNU Lesser
#! General Public  License as published by  the Free Software  Foundation; either version 3.0  of the
#! License, or (at your option) any later version.
#!
#! This library is distributed in the hope that  it will be useful, but WITHOUT ANY WARRANTY; without
#! even the  implied warranty of MERCHANTABILITY  or FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU
#! Lesser General Public License for more details.
#!
#! You should have received a copy of the  GNU Lesser General Public License along with this library;
#! if not,  write to  the Free  Software Foundation,  Inc., 59  Temple Place,  Suite 330,  Boston, MA
#! 02111-1307 USA.
#!


#### macros

MBFL_DEFINE_UNDERSCORE_MACRO_FOR_SLOTS
MBFL_DEFINE_QQ_MACRO

# MBFL_ARRAY_SWAP(mbfl_ARRY, mbfl_I, mbfl_J)
m4_define([[[MBFL_ARRAY_SWAP]]],[[[
declare $2_VALUE=_(mbfl_ARRY, [[[$]]]$2)
mbfl_slot_set($1, [[[$]]]$2,  _($1, [[[$]]]$3))
mbfl_slot_set($1, [[[$]]]$3, "[[[$]]]$2_VALUE")
]]])


#### global variables

mbfl_default_class_declare(mbfl_stack_t)
mbfl_default_class_declare(mbfl_vector_t)

mbfl_default_class_define _(mbfl_stack_t)  _(mbfl_default_object) 'mbfl_stack'  array
mbfl_default_class_define _(mbfl_vector_t) _(mbfl_default_object) 'mbfl_vector' array


#### arrays: subroutines for multi arrays handling

# Given the  index array of  index arrays "mbfl_ARRYS"  store in the  result variable the  number of
# slots in the first subarray.
#
function mbfl_p_multi_array_number_of_slots_var () {
    mbfl_mandatory_nameref_parameter(mbfl_SLOTS_NUMBER, 1, reference to result variable)
    mbfl_mandatory_nameref_parameter(mbfl_ARRYS,        2, reference to index array of index arrays)
    mbfl_declare_nameref(mbfl_ARRY, mbfl_slot_ref(mbfl_ARRYS, 0))
    mbfl_SLOTS_NUMBER=mbfl_slots_number(mbfl_ARRY)
}


#### inserting single values

function mbfl_array_push_front () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,		1, index array)
    mbfl_mandatory_parameter(mbfl_OBJ,			2, the object to push on the array)

    mbfl_array_insert_value_bang _(mbfl_ARRY) 0 QQ(mbfl_OBJ)
}
function mbfl_array_push_back () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,		1, index array)
    mbfl_mandatory_parameter(mbfl_OBJ,			2, the object to push on the array)
    declare -i mbfl_DIM=mbfl_slots_number(mbfl_ARRY)

    mbfl_array_insert_value_bang _(mbfl_ARRY) $mbfl_DIM QQ(mbfl_OBJ)
}

### ------------------------------------------------------------------------

function mbfl_array_pop_front_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,		1, result variable)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,		2, index array)

    mbfl_RV=mbfl_slot_qref(mbfl_ARRY, 0)
    mbfl_array_remove _(mbfl_ARRY) _(mbfl_ARRY) 0
}
function mbfl_array_pop_back_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,		1, result variable)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,		2, index array)
    declare -i mbfl_DIM=mbfl_slots_number(mbfl_ARRY)
    declare -i mbfl_LAST=$((mbfl_DIM-1))

    mbfl_RV=mbfl_slot_qref(mbfl_ARRY, $mbfl_LAST)
    mbfl_array_remove _(mbfl_ARRY) _(mbfl_ARRY) $mbfl_LAST
}

### ------------------------------------------------------------------------

function mbfl_array_front_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,		1, result variable)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,		2, index array)

    mbfl_RV=mbfl_slot_qref(mbfl_ARRY, 0)
}
function mbfl_array_back_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,		1, result variable)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,		2, index array)
    declare -i mbfl_DIM=mbfl_slots_number(mbfl_ARRY)
    declare -i mbfl_LAST=$((mbfl_DIM-1))

    mbfl_RV=mbfl_slot_qref(mbfl_ARRY, $mbfl_LAST)
}

### ------------------------------------------------------------------------

function mbfl_array_pop_front () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,		1, index array)

    mbfl_array_remove _(mbfl_ARRY) _(mbfl_ARRY) 0
}
function mbfl_array_pop_back () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,		1, index array)
    declare -i mbfl_DIM=mbfl_slots_number(mbfl_ARRY)
    declare -i mbfl_LAST=$((mbfl_DIM-1))

    mbfl_array_remove _(mbfl_ARRY) _(mbfl_ARRY) $mbfl_LAST
}


#### arrays: makers

function mbfl_array_tabulate () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,		1, destination index array)
    mbfl_mandatory_integer_parameter(mbfl_NUM_OF_SLOTS,	2, number of slots to initialise)
    mbfl_optional_parameter(mbfl_INITIALISER,		3)
    declare -i mbfl_I

    if mbfl_string_empty(mbfl_INITIALISER)
    then
	for ((mbfl_I=0; mbfl_I < mbfl_NUM_OF_SLOTS; ++mbfl_I))
	do mbfl_slot_set(mbfl_ARRY, $mbfl_I, $mbfl_I)
	done
    else
	mbfl_declare_varref(mbfl_RV)

	for ((mbfl_I=0; mbfl_I < mbfl_NUM_OF_SLOTS; ++mbfl_I))
	do
	    "$mbfl_INITIALISER" _(mbfl_RV) $mbfl_I
	    mbfl_RETURN_STATUS=$?
	    if ((0 == $mbfl_RETURN_STATUS))
	    then mbfl_slot_set(mbfl_ARRY, $mbfl_I, "$mbfl_RV")
	    else return $mbfl_RETURN_STATUS
	    fi
	done
    fi
}
function mbfl_array_iota () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,	1, destination index array)
    mbfl_mandatory_parameter(mbfl_NUM_OF_SLOTS,	2, number of slots to initialise)
    mbfl_optional_parameter(mbfl_START,		3, 0)
    mbfl_optional_parameter(mbfl_STEP,		4, 1)
    declare -i mbfl_I
    mbfl_declare_varref(mbfl_VALUE)

    for ((mbfl_I=0; mbfl_I < mbfl_NUM_OF_SLOTS; ++mbfl_I))
    do
	mbfl_math_expr_var _(mbfl_VALUE) "${mbfl_START}+${mbfl_STEP}*${mbfl_I}"
	mbfl_slot_set(mbfl_ARRY, $mbfl_I, "$mbfl_VALUE")
    done
}


#### arrays: inspection

function mbfl_multi_array_equal_size_var () {
    mbfl_mandatory_nameref_parameter(mbfl_SIZE_RV, 1, reference to result variable)
    mbfl_mandatory_nameref_parameter(mbfl_ARRYS,   2, reference to index array of index arrays)
    declare -i mbfl_NUM_OF_ARRYS=mbfl_slots_number(mbfl_ARRYS)

    if   ((0 == mbfl_NUM_OF_ARRYS))
    then mbfl_SIZE_RV=0
    else
	mbfl_declare_nameref(mbfl_ARRY0, mbfl_slot_ref(mbfl_ARRYS, 0))
	declare -i mbfl_I mbfl_NUM_OF_SLOTS0=mbfl_slots_number(mbfl_ARRY0)

	for ((mbfl_I=1; mbfl_I < mbfl_NUM_OF_ARRYS; ++mbfl_I))
	do
	    mbfl_declare_nameref(mbfl_ARRY, mbfl_slot_ref(mbfl_ARRYS, $mbfl_I))
	    if ((mbfl_NUM_OF_SLOTS0 != mbfl_slots_number(mbfl_ARRY)))
	    then return_failure
	    fi
	done
	mbfl_SIZE_RV=$mbfl_NUM_OF_SLOTS0
    fi
    return_success
}
function mbfl_multi_array_minsize_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,		1, reference result variable)
    mbfl_mandatory_nameref_parameter(mbfl_ARRYS,	2, reference to index array of index arrays)
    declare -i mbfl_ARRYS_DIM=mbfl_slots_number(mbfl_ARRYS)

    if ((0 == mbfl_ARRYS_DIM))
    then mbfl_RV=0
    else
	mbfl_declare_nameref(mbfl_ARRY, _(mbfl_ARRYS, 0))
	declare -i mbfl_I mbfl_MIN_DIM=mbfl_slots_number(mbfl_ARRY)

	for ((mbfl_I=1; mbfl_I < mbfl_ARRYS_DIM; ++mbfl_I))
	do
	    mbfl_declare_nameref(mbfl_ARRY, _(mbfl_ARRYS, $mbfl_I))
	    declare -i mbfl_DIM=mbfl_slots_number(mbfl_ARRY)
	    mbfl_MIN_DIM='(mbfl_MIN_DIM<=mbfl_DIM)?mbfl_MIN_DIM:mbfl_DIM'
	done
	mbfl_RV=mbfl_MIN_DIM
    fi
}
function mbfl_multi_array_homologous_slots_var () {
    mbfl_mandatory_nameref_parameter(mbfl_HOMOLOGOUS_VALUES,	1, reference to result index array variable)
    mbfl_mandatory_nameref_parameter(mbfl_ARRYS,		2, reference to index array of index arrays)
    mbfl_mandatory_parameter(mbfl_INDEX,			3, slot index)

    declare -i mbfl_NUM_OF_ARRYS=mbfl_slots_number(mbfl_ARRYS)

    if ((0 == mbfl_NUM_OF_ARRYS))
    then return_success
    else
	declare -i mbfl_I mbfl_J

	for ((mbfl_I=0; mbfl_I < mbfl_NUM_OF_ARRYS; ++mbfl_I))
	do
	    mbfl_declare_nameref(mbfl_ARRY, _(mbfl_ARRYS, $mbfl_I))
	    mbfl_slot_set(mbfl_HOMOLOGOUS_VALUES, $mbfl_I, _(mbfl_ARRY, $mbfl_INDEX))
	done
    fi
}


#### arrays: selectors

function mbfl_array_left_take () {
    mbfl_mandatory_nameref_parameter(mbfl_DST_ARRY,	1, reference to destination index array)
    mbfl_mandatory_nameref_parameter(mbfl_SRC_ARRY,	2, reference to source index array)
    mbfl_mandatory_integer_parameter(mbfl_NUM_OF_SLOTS,	3, number of slots)

    mbfl_array_range_copy _(mbfl_DST_ARRY) 0 _(mbfl_SRC_ARRY) 0 $mbfl_NUM_OF_SLOTS
}
function mbfl_array_right_take () {
    mbfl_mandatory_nameref_parameter(mbfl_DST_ARRY,	1, reference to destination index array)
    mbfl_mandatory_nameref_parameter(mbfl_SRC_ARRY,	2, reference to source index array)
    mbfl_mandatory_integer_parameter(mbfl_NUM_OF_SLOTS,	3, number of slots)

    declare -i mbfl_START=mbfl_slots_number(mbfl_SRC_ARRY)-mbfl_NUM_OF_SLOTS
    declare -i mbfl_COUNT=mbfl_NUM_OF_SLOTS
    mbfl_array_range_copy _(mbfl_DST_ARRY) 0 _(mbfl_SRC_ARRY) $mbfl_START $mbfl_COUNT
}
function mbfl_array_left_drop () {
    mbfl_mandatory_nameref_parameter(mbfl_DST_ARRY,	1, reference to destination index array)
    mbfl_mandatory_nameref_parameter(mbfl_SRC_ARRY,	2, reference to source index array)
    mbfl_mandatory_integer_parameter(mbfl_NUM_OF_SLOTS,	3, number of slots)

    declare -i mbfl_START=mbfl_NUM_OF_SLOTS
    declare -i mbfl_COUNT=mbfl_slots_number(mbfl_SRC_ARRY)-mbfl_NUM_OF_SLOTS
    mbfl_array_range_copy _(mbfl_DST_ARRY) 0 _(mbfl_SRC_ARRY) $mbfl_START $mbfl_COUNT
}
function mbfl_array_right_drop () {
    mbfl_mandatory_nameref_parameter(mbfl_DST_ARRY,	1, reference to destination index array)
    mbfl_mandatory_nameref_parameter(mbfl_SRC_ARRY,	2, reference to source index array)
    mbfl_mandatory_integer_parameter(mbfl_NUM_OF_SLOTS,	3, number of slots)

    declare -i mbfl_START=0
    declare -i mbfl_COUNT=mbfl_slots_number(mbfl_SRC_ARRY)-mbfl_NUM_OF_SLOTS
    mbfl_array_range_copy _(mbfl_DST_ARRY) 0 _(mbfl_SRC_ARRY) $mbfl_START $mbfl_COUNT
}
function mbfl_array_split_at () {
    mbfl_mandatory_nameref_parameter(mbfl_PREFIX_ARRY,	1, reference to prefix index array)
    mbfl_mandatory_nameref_parameter(mbfl_SUFFIX_ARRY,	2, reference to suffix index array)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,		3, reference to source index array)
    mbfl_mandatory_integer_parameter(mbfl_IDX,		4, index)

    declare -i mbfl_COUNT=mbfl_slots_number(mbfl_ARRY)-mbfl_IDX
    mbfl_array_range_copy _(mbfl_PREFIX_ARRY) 0 _(mbfl_ARRY) 0 $mbfl_IDX
    mbfl_array_range_copy _(mbfl_SUFFIX_ARRY) 0 _(mbfl_ARRY) $mbfl_IDX $mbfl_COUNT
}


#### arrays: comparison between two arrays

function mbfl_array_equal_prefix_length_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,		1, reference result variable)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY1,	2, reference to index array one)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY2,	3, reference to index array two)
    mbfl_optional_parameter(mbfl_ISEQUAL,		4, mbfl_string_equal)

    if mbfl_string_eq(_(mbfl_ARRY1),_(mbfl_ARRY2))
    then mbfl_RV=mbfl_slots_number(mbfl_ARRY1)
    else
	declare -i mbfl_I mbfl_DIM1=mbfl_slots_number(mbfl_ARRY1) mbfl_DIM2=mbfl_slots_number(mbfl_ARRY2)
	declare -i mbfl_MIN_DIM='(mbfl_DIM11<mbfl_DIM2)?mbfl_DIM1:mbfl_DIM2'

	for ((mbfl_I=0; mbfl_I < mbfl_MIN_DIM; ++mbfl_I))
	do
	    if ! "$mbfl_ISEQUAL" _(mbfl_ARRY1, $mbfl_I) _(mbfl_ARRY2, $mbfl_I)
	    then
		mbfl_RV=$mbfl_I
		return_success
	    fi
	done
	mbfl_RV=$mbfl_MIN_DIM
    fi
}
function mbfl_array_equal_suffix_length_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,		1, reference result variable)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY1,	2, reference to index array one)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY2,	3, reference to index array two)
    mbfl_optional_parameter(mbfl_ISEQUAL,		4, mbfl_string_equal)

    if mbfl_string_eq(_(mbfl_ARRY1),_(mbfl_ARRY2))
    then mbfl_RV=mbfl_slots_number(mbfl_ARRY1)
    else
	declare -i mbfl_DIM1=mbfl_slots_number(mbfl_ARRY1) mbfl_DIM2=mbfl_slots_number(mbfl_ARRY2)
	declare -i mbfl_MIN_DIM='(mbfl_DIM11<mbfl_DIM2)?mbfl_DIM1:mbfl_DIM2'
	declare -i mbfl_I mbfl_J mbfl_K

	for ((mbfl_I=0, mbfl_J=mbfl_DIM1-1, mbfl_K=mbfl_DIM2-1; mbfl_I < mbfl_MIN_DIM; ++mbfl_I, --mbfl_J, --mbfl_K))
	do
	    if ! "$mbfl_ISEQUAL" _(mbfl_ARRY1, $mbfl_J) _(mbfl_ARRY2, $mbfl_K)
	    then
		mbfl_RV=$mbfl_I
		return_success
	    fi
	done
	mbfl_RV=$mbfl_MIN_DIM
    fi
}

### ------------------------------------------------------------------------

function mbfl_array_equal () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY1,	1, reference to index array one)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY2,	2, reference to index array two)
    mbfl_optional_parameter(mbfl_ISEQUAL,		3, mbfl_string_equal)

    if mbfl_string_eq(_(mbfl_ARRY1),_(mbfl_ARRY2))
    then mbfl_RV=mbfl_slots_number(mbfl_ARRY1)
    else
	declare -i mbfl_I mbfl_DIM1=mbfl_slots_number(mbfl_ARRY1) mbfl_DIM2=mbfl_slots_number(mbfl_ARRY2)

	if (( mbfl_DIM1 != mbfl_DIM2 ))
	then return_failure
	else
	    for ((mbfl_I=0; mbfl_I < mbfl_DIM1; ++mbfl_I))
	    do
		#echo $FUNCNAME _(mbfl_ARRY1, $mbfl_I) _(mbfl_ARRY2, $mbfl_I) >&2
		if ! "$mbfl_ISEQUAL" _(mbfl_ARRY1, $mbfl_I) _(mbfl_ARRY2, $mbfl_I)
		then return_failure
		fi
	    done
	    return_success
	fi
    fi
}
function mbfl_array_less () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY1,	1, reference to index array one)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY2,	2, reference to index array two)
    mbfl_optional_parameter(mbfl_ISEQUAL,		3, mbfl_string_equal)
    mbfl_optional_parameter(mbfl_ISLESS,		4, mbfl_string_less)

    if mbfl_string_eq(_(mbfl_ARRY1),_(mbfl_ARRY2))
    then return_failure
    else
	mbfl_declare_integer_varref(mbfl_LEN)

	mbfl_array_equal_prefix_length_var _(mbfl_LEN) _(mbfl_ARRY1) _(mbfl_ARRY2) "$mbfl_ISEQUAL"

	if ((mbfl_LEN == mbfl_slots_number(mbfl_ARRY1)))
	then
	    if ((mbfl_LEN == mbfl_slots_number(mbfl_ARRY2)))
	    then
		# The arrays have the same length and are equal slot-by-slot.
		return_failure
	    else
		# ARRY2 has a prefix equal to ARRY1, but ARRY2 is longer.
		return_success
	    fi
	elif ((mbfl_LEN == mbfl_slots_number(mbfl_ARRY2)))
	then
	    # ARRY1 has a prefix equal to ARRY2, but ARRY1 is longer.
	    return_failure
	elif "$mbfl_ISLESS" _(mbfl_ARRY1, $mbfl_LEN) _(mbfl_ARRY2, $mbfl_LEN);
	then return_success
	else return_failure
	fi
    fi
}
function mbfl_array_greater () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY1,	1, reference to index array one)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY2,	2, reference to index array two)
    mbfl_optional_parameter(mbfl_ISEQUAL,		3, mbfl_string_equal)
    mbfl_optional_parameter(mbfl_ISLESS,		4, mbfl_string_less)

    if mbfl_string_eq(_(mbfl_ARRY1),_(mbfl_ARRY2))
    then return_failure
    else
	mbfl_declare_integer_varref(mbfl_LEN)

	mbfl_array_equal_prefix_length_var _(mbfl_LEN) _(mbfl_ARRY1) _(mbfl_ARRY2) "$mbfl_ISEQUAL"

	if ((mbfl_LEN == mbfl_slots_number(mbfl_ARRY1)))
	then
	    if ((mbfl_LEN == mbfl_slots_number(mbfl_ARRY2)))
	    then
		# The arrays have the same length and are equal slot-by-slot.
		return_failure
	    else
		# ARRY2 has a prefix equal to ARRY1, but ARRY2 is longer.
		return_failure
	    fi
	elif ((mbfl_LEN == mbfl_slots_number(mbfl_ARRY2)))
	then
	    # ARRY1 has a prefix equal to ARRY2, but ARRY1 is longer.
	    return_success
	elif "$mbfl_ISLESS" _(mbfl_ARRY1, $mbfl_LEN) _(mbfl_ARRY2, $mbfl_LEN)
	then return_failure
	else return_success
	fi
    fi
}
function mbfl_array_leq () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY1,	1, reference to index array one)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY2,	2, reference to index array two)
    mbfl_optional_parameter(mbfl_ISEQUAL,		3, mbfl_string_equal)
    mbfl_optional_parameter(mbfl_ISLESS,		4, mbfl_string_less)

    if mbfl_string_eq(_(mbfl_ARRY1),_(mbfl_ARRY2))
    then return_success
    else
	mbfl_declare_integer_varref(mbfl_LEN)

	mbfl_array_equal_prefix_length_var _(mbfl_LEN) _(mbfl_ARRY1) _(mbfl_ARRY2) "$mbfl_ISEQUAL"

	if ((mbfl_LEN == mbfl_slots_number(mbfl_ARRY1)))
	then
	    if ((mbfl_LEN == mbfl_slots_number(mbfl_ARRY2)))
	    then
		# The arrays have the same length and are equal slot-by-slot.
		return_success
	    else
		# ARRY2 has a prefix equal to ARRY1, but ARRY2 is longer.
		return_success
	    fi
	elif ((mbfl_LEN == mbfl_slots_number(mbfl_ARRY2)))
	then
	    # ARRY1 has a prefix equal to ARRY2, but ARRY1 is longer.
	    return_failure
	elif "$mbfl_ISLESS" _(mbfl_ARRY1, $mbfl_LEN) _(mbfl_ARRY2, $mbfl_LEN)
	then return_success
	else return_failure
	fi
    fi
}
function mbfl_array_geq () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY1,	1, reference to index array one)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY2,	2, reference to index array two)
    mbfl_optional_parameter(mbfl_ISEQUAL,		3, mbfl_string_equal)
    mbfl_optional_parameter(mbfl_ISLESS,		4, mbfl_string_less)

    if mbfl_string_eq(_(mbfl_ARRY1),_(mbfl_ARRY2))
    then return_success
    else
	mbfl_declare_integer_varref(mbfl_LEN)

	mbfl_array_equal_prefix_length_var _(mbfl_LEN) _(mbfl_ARRY1) _(mbfl_ARRY2) "$mbfl_ISEQUAL"

	if ((mbfl_LEN == mbfl_slots_number(mbfl_ARRY1)))
	then
	    if ((mbfl_LEN == mbfl_slots_number(mbfl_ARRY2)))
	    then
		# The arrays have the same length and are equal slot-by-slot.
		return_success
	    else
		# ARRY2 has a prefix equal to ARRY1, but ARRY2 is longer.
		return_failure
	    fi
	elif ((mbfl_LEN == mbfl_slots_number(mbfl_ARRY2)))
	then
	    # ARRY1 has a prefix equal to ARRY2, but ARRY1 is longer.
	    return_success
	elif "$mbfl_ISLESS" _(mbfl_ARRY1, $mbfl_LEN) _(mbfl_ARRY2, $mbfl_LEN)
	then return_failure
	else return_success
	fi
    fi
}


#### arrays: multi comparison

function mbfl_multi_array_equal_prefix_length_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,		1, reference result variable)
    mbfl_mandatory_nameref_parameter(mbfl_ARRYS,	2, reference to index array of index arrays)
    mbfl_optional_parameter(mbfl_ISEQUAL,		3, mbfl_string_equal)

    mbfl_declare_integer_varref(mbfl_MINSIZE)
    mbfl_multi_array_minsize_var _(mbfl_MINSIZE) _(ARRYS)

    if ((0 == mbfl_MINSIZE))
    then
	mbfl_RV=0
	return_success
    else
	mbfl_declare_integer_varref(mbfl_HOMO_VALUES)
	declare -i mbfl_I

	for ((mbfl_I=0; mbfl_I < mbfl_MINSIZE; ++mbfl_I))
	do
	    mbfl_multi_array_homologous_slots_var _(mbfl_HOMO_VALUES) _(mbfl_ARRYS) $mbfl_I
	    if ! mbfl_array_equal_values _(mbfl_HOMO_VALUES)
	    then
		mbfl_RV=$mbfl_I
		return_success
	    fi
	done
	mbfl_RV=$mbfl_MINSIZE
    fi
}
function mbfl_multi_array_equal_suffix_length_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,		1, reference result variable)
    mbfl_mandatory_nameref_parameter(mbfl_ARRYS,	2, reference to index array of index arrays)
    mbfl_optional_parameter(mbfl_ISEQUAL,		3, mbfl_string_equal)

    mbfl_declare_integer_varref(mbfl_MINSIZE)
    mbfl_multi_array_minsize_var _(mbfl_MINSIZE) _(ARRYS)

    if ((0 == mbfl_MINSIZE))
    then
	mbfl_RV=0
	return_success
    else
	mbfl_declare_integer_varref(mbfl_HOMO_VALUES)
	declare -i mbfl_I

	for ((mbfl_I=mbfl_MINSIZE-1; mbfl_I >= 0; --mbfl_I))
	do
	    mbfl_multi_array_homologous_slots_var _(mbfl_HOMO_VALUES) _(mbfl_ARRYS) $mbfl_I
	    if ! mbfl_array_equal_values _(mbfl_HOMO_VALUES)
	    then
		mbfl_RV=$mbfl_I
		return_success
	    fi
	done
	mbfl_RV=$mbfl_MINSIZE
    fi
}

### ------------------------------------------------------------------------

function mbfl_multi_array_equal () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRYS,	1, reference to index array of index arrays)
    mbfl_optional_parameter(mbfl_ISEQUAL,		2, mbfl_string_equal)

    if ((1 < mbfl_slots_number(mbfl_ARRYS)))
    then
	mbfl_declare_integer_varref(mbfl_NUM_OF_SLOTS)

	if mbfl_multi_array_equal_size_var _(mbfl_NUM_OF_SLOTS) _(mbfl_ARRYS)
	then
	    mbfl_declare_index_array_varref(mbfl_HOMOLOGOUS_VALUES)
	    declare -i mbfl_I

	    #echo $FUNCNAME mbfl_NUM_OF_SLOTS=$mbfl_NUM_OF_SLOTS >&2
	    for ((mbfl_I=0; mbfl_I < mbfl_NUM_OF_SLOTS; ++mbfl_I))
	    do
		mbfl_multi_array_homologous_slots_var _(mbfl_HOMOLOGOUS_VALUES) _(mbfl_ARRYS) $mbfl_I
		#mbfl_array_dump _(mbfl_HOMOLOGOUS_VALUES) mbfl_HOMOLOGOUS_VALUES$mbfl_I
		if ! mbfl_array_equal_values _(mbfl_HOMOLOGOUS_VALUES) "$mbfl_ISEQUAL"
		then return_failure
		fi
	    done
	else return_failure
	fi
    fi
    return_success
}
# NOTE Can we do better than comparing the arrays two by two?  Maybe.  (Marco Maggi; May  1, 2023)
#
function mbfl_p_multi_array_compar () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRYS,	1, reference to index array of index arrays)
    mbfl_mandatory_parameter(mbfl_ISEQUAL,		2, isequal operator)
    mbfl_mandatory_parameter(mbfl_ISLESS,		3, isless operator)
    mbfl_mandatory_parameter(mbfl_ARRY_COMPAR,		4, array comparison operator)
    declare -i mbfl_ARRYS_DIM=mbfl_slots_number(mbfl_ARRYS)

    if ((1 < mbfl_ARRYS_DIM))
    then
	declare -i mbfl_I mbfl_J

	for ((mbfl_I=0, mbfl_J=1; mbfl_I < mbfl_ARRYS_DIM-1; ++mbfl_I, ++mbfl_J))
	do
	    if ! "$mbfl_ARRY_COMPAR" _(mbfl_ARRYS, $mbfl_I) _(mbfl_ARRYS, $mbfl_J) "$mbfl_ISEQUAL" "$mbfl_ISLESS"
	    then return_failure
	    fi
	done
    fi
    return_success
}
function mbfl_multi_array_less () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRYS,	1, reference to index array of index arrays)
    mbfl_optional_parameter(mbfl_ISEQUAL,		2, mbfl_string_equal)
    mbfl_optional_parameter(mbfl_ISLESS,		3, mbfl_string_less)

    mbfl_p_multi_array_compar _(mbfl_ARRYS) "$mbfl_ISEQUAL" "$mbfl_ISLESS" mbfl_array_less
}
function mbfl_multi_array_greater () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRYS,	1, reference to index array of index arrays)
    mbfl_optional_parameter(mbfl_ISEQUAL,		2, mbfl_string_equal)
    mbfl_optional_parameter(mbfl_ISLESS,		3, mbfl_string_less)

    mbfl_p_multi_array_compar _(mbfl_ARRYS) "$mbfl_ISEQUAL" "$mbfl_ISLESS" mbfl_array_greater
}
function mbfl_multi_array_leq () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRYS,	1, reference to index array of index arrays)
    mbfl_optional_parameter(mbfl_ISEQUAL,		2, mbfl_string_equal)
    mbfl_optional_parameter(mbfl_ISLESS,		3, mbfl_string_less)

    mbfl_p_multi_array_compar _(mbfl_ARRYS) "$mbfl_ISEQUAL" "$mbfl_ISLESS" mbfl_array_leq
}
function mbfl_multi_array_geq () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRYS,	1, reference to index array of index arrays)
    mbfl_optional_parameter(mbfl_ISEQUAL,		2, mbfl_string_equal)
    mbfl_optional_parameter(mbfl_ISLESS,		3, mbfl_string_less)

    mbfl_p_multi_array_compar _(mbfl_ARRYS) "$mbfl_ISEQUAL" "$mbfl_ISLESS" mbfl_array_geq
}


#### arrays: comparison misc

function mbfl_array_equal_values () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,	1, reference to index array)
    mbfl_optional_parameter(mbfl_ISEQUAL,	2, mbfl_string_equal)
    declare -i mbfl_DIM=mbfl_slots_number(mbfl_ARRY)

    #mbfl_array_dump _(mbfl_ARRY) mbfl_ARRY

    if ((0 != mbfl_DIM && 1 != mbfl_DIM))
    then
	declare -i mbfl_I
	declare mbfl_VALUE0=_(mbfl_ARRY, 0)

	for ((mbfl_I=1; mbfl_I < mbfl_DIM; ++mbfl_I))
	do
	    #echo $FUNCNAME $mbfl_I VALUE0="$mbfl_VALUE0" VALUE${mbfl_I}=_(mbfl_ARRY, $mbfl_I) >&2
	    if ! "$mbfl_ISEQUAL" "$mbfl_VALUE0" _(mbfl_ARRY, $mbfl_I)
	    then return_failure
	    fi
	done
    fi
    return_success
}


#### index arrays: searching

m4_define([[[MBFL_CONTAINERS_DEFINE_ARRAY_FIND_CONTAINING_FUNC]]],[[[
function $1 () {
    mbfl_mandatory_nameref_parameter(mbfl_IDX_RV,	1, result variable)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,		2, source array)
    mbfl_mandatory_parameter(mbfl_VALUE,		3, target value)
    mbfl_optional_parameter(mbfl_ISEQUAL,		4, mbfl_string_equal)
    declare -i mbfl_I mbfl_NUM_OF_SLOTS=mbfl_slots_number(mbfl_ARRY)

    for $2
    do
	if "$mbfl_ISEQUAL" "$mbfl_VALUE" _(mbfl_ARRY, $mbfl_I)
	then
	    mbfl_IDX_RV=$mbfl_I
	    return_success
	fi
    done
    return_failure
}
]]])

MBFL_CONTAINERS_DEFINE_ARRAY_FIND_CONTAINING_FUNC([[[mbfl_array_find_left_slot_containing_value_var]]],
						  [[[((mbfl_I=0; mbfl_I < mbfl_NUM_OF_SLOTS; ++mbfl_I))]]])
MBFL_CONTAINERS_DEFINE_ARRAY_FIND_CONTAINING_FUNC([[[mbfl_array_find_right_slot_containing_value_var]]],
						  [[[((mbfl_I=mbfl_NUM_OF_SLOTS-1; mbfl_I >= 0; --mbfl_I))]]])

### ------------------------------------------------------------------------

function mbfl_array_find_left_slot_containing_value () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,		1, source array)
    mbfl_mandatory_parameter(mbfl_VALUE,		2, target value)
    mbfl_optional_parameter(mbfl_ISEQUAL,		3, mbfl_string_equal)
    mbfl_declare_integer_varref(mbfl_IDX_RV)
    mbfl_array_find_left_slot_containing_value_var _(mbfl_IDX_RV) _(mbfl_ARRY) "$mbfl_VALUE" "$mbfl_ISEQUAL"
}
function mbfl_array_find_right_slot_containing_value () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,		1, source array)
    mbfl_mandatory_parameter(mbfl_VALUE,		2, target value)
    mbfl_optional_parameter(mbfl_ISEQUAL,		3, mbfl_string_equal)
    mbfl_declare_integer_varref(mbfl_IDX_RV)
    mbfl_array_find_left_slot_containing_value_var _(mbfl_IDX_RV) _(mbfl_ARRY) "$mbfl_VALUE" "$mbfl_ISEQUAL"
}

### ------------------------------------------------------------------------

m4_define([[[MBFL_CONTAINERS_DEFINE_ARRAY_FIND_SATISFYING_FUNC]]],[[[
function $1 () {
    mbfl_mandatory_nameref_parameter(mbfl_IDX_RV,	1, result variable)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,		2, source array)
    mbfl_mandatory_parameter(mbfl_PRED,			3, predicate)
    declare -i mbfl_I mbfl_NUM_OF_SLOTS=mbfl_slots_number(mbfl_ARRY)

    for $2
    do
	if "$mbfl_PRED" _(mbfl_ARRY, $mbfl_I)
	then
	    mbfl_IDX_RV=$mbfl_I
	    return_success
	fi
    done
    return_failure
}
]]])

MBFL_CONTAINERS_DEFINE_ARRAY_FIND_SATISFYING_FUNC([[[mbfl_array_find_left_slot_satisfying_pred_var]]],
						  [[[((mbfl_I=0; mbfl_I < mbfl_NUM_OF_SLOTS; ++mbfl_I))]]])
MBFL_CONTAINERS_DEFINE_ARRAY_FIND_SATISFYING_FUNC([[[mbfl_array_find_right_slot_satisfying_pred_var]]],
						  [[[((mbfl_I=mbfl_NUM_OF_SLOTS-1; mbfl_I >= 0; --mbfl_I))]]])

### ------------------------------------------------------------------------

function mbfl_array_find_left_slot_satisfying_pred () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,		1, source array)
    mbfl_mandatory_parameter(mbfl_PRED,			2, predicate)
    mbfl_declare_integer_varref(mbfl_IDX_RV)
    mbfl_array_find_left_slot_satisfying_pred_var _(mbfl_IDX_RV) _(mbfl_ARRY) "$mbfl_PRED"
}
function mbfl_array_find_right_slot_satisfying_pred () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,		1, source array)
    mbfl_mandatory_parameter(mbfl_PRED,			2, predicate)
    mbfl_declare_integer_varref(mbfl_IDX_RV)
    mbfl_array_find_left_slot_satisfying_pred_var _(mbfl_IDX_RV) _(mbfl_ARRY) "$mbfl_PRED"
}


#### arrays: filtering

function mbfl_array_filter () {
    mbfl_mandatory_nameref_parameter(mbfl_DST_ARRY,	1, reference to destination index array)
    mbfl_mandatory_parameter(mbfl_PRED,			2, predicate)
    mbfl_mandatory_nameref_parameter(mbfl_SRC_ARRY,	3, reference to source index array)
    declare -i mbfl_I mbfl_J mbfl_SRC_DIM=mbfl_slots_number(mbfl_SRC_ARRY)

    for ((mbfl_I=0, mbfl_J=0; mbfl_I < mbfl_SRC_DIM; ++mbfl_I))
    do
	declare mbfl_SRC_VALUE=_(mbfl_SRC_ARRY, $mbfl_I)

	if "$mbfl_PRED" "$mbfl_SRC_VALUE"
	then
	    mbfl_slot_set(mbfl_DST_ARRY, $mbfl_J, "$mbfl_SRC_VALUE")
	    let ++mbfl_J
	fi
    done
}
function mbfl_array_partition () {
    mbfl_mandatory_nameref_parameter(mbfl_GOOD_ARRY,	1, reference to destination index array)
    mbfl_mandatory_nameref_parameter(mbfl_BAD_ARRY,	2, reference to destination index array)
    mbfl_mandatory_parameter(mbfl_PRED,			3, predicate)
    mbfl_mandatory_nameref_parameter(mbfl_SRC_ARRY,	4, reference to source index array)
    declare -i mbfl_I mbfl_J mbfl_K mbfl_SRC_DIM=mbfl_slots_number(mbfl_SRC_ARRY)

    for ((mbfl_I=0, mbfl_J=0, mbfl_K=0; mbfl_I < mbfl_SRC_DIM; ++mbfl_I))
    do
	declare mbfl_SRC_VALUE=_(mbfl_SRC_ARRY, $mbfl_I)
	if "$mbfl_PRED" "$mbfl_SRC_VALUE"
	then
	    mbfl_slot_set(mbfl_GOOD_ARRY, $mbfl_J, "$mbfl_SRC_VALUE")
	    let ++mbfl_J
	else
	    mbfl_slot_set(mbfl_BAD_ARRY,  $mbfl_K, "$mbfl_SRC_VALUE")
	    let ++mbfl_K
	fi
    done
}


#### array: insertions

function mbfl_array_insert_slot_bang () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY, 1, index array)
    mbfl_mandatory_integer_parameter(mbfl_IDX,  2, slot index)
    declare -i mbfl_I mbfl_DIM=mbfl_slots_number(mbfl_ARRY)

    for ((mbfl_I=mbfl_DIM; mbfl_I > mbfl_IDX; --mbfl_I))
    do
	declare mbfl_VALUE=_(mbfl_ARRY, $((mbfl_I-1)))
	_(mbfl_ARRY, $mbfl_I, "$mbfl_VALUE")
    done
}
function mbfl_array_insert_value_bang () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,	1, index array)
    mbfl_mandatory_integer_parameter(mbfl_IDX,	2, slot index)
    mbfl_mandatory_parameter(mbfl_VALUE,	3, new value)

    mbfl_array_insert_slot_bang _(mbfl_ARRY) $mbfl_IDX
    _(mbfl_ARRY, $mbfl_IDX, "$mbfl_VALUE")
}

### ------------------------------------------------------------------------

# Before:
#
#  A B C D E F G
# |-|-|-|-|-|-|-|
#
# after:
#
#  A B C         D E F G
# |-|-|-|-|-|-|-|-|-|-|-|
#
#       |.......| mbfl_NUM
#
function mbfl_array_insert_multi_slot_bang () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY, 1, index array)
    mbfl_mandatory_integer_parameter(mbfl_IDX,  2, slot index)
    mbfl_mandatory_integer_parameter(mbfl_NUM,  3, slots number)
    declare -i mbfl_I

    for ((mbfl_I=mbfl_slots_number(mbfl_ARRY)+mbfl_NUM-1; mbfl_I >= mbfl_IDX+mbfl_NUM; --mbfl_I))
    do _(mbfl_ARRY, $mbfl_I, _(mbfl_ARRY, $((mbfl_I-mbfl_NUM))))
    done
}
function mbfl_array_insert_multi_value_bang () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY1, 1, target index array)
    mbfl_mandatory_integer_parameter(mbfl_IDX,   2, slot index)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY2, 3, index array to be inserted)
    declare -i mbfl_I mbfl_DIM2=mbfl_slots_number(mbfl_ARRY2)

    mbfl_array_insert_multi_slot_bang _(mbfl_ARRY1) $mbfl_IDX mbfl_slots_number(mbfl_ARRY2)

    for ((mbfl_I=0; mbfl_I < mbfl_DIM2; ++mbfl_I))
    do _(mbfl_ARRY1, $((mbfl_I+mbfl_IDX)), _(mbfl_ARRY2, $mbfl_I))
    done
}


#### arrays: removal and deletion

function mbfl_array_remove () {
    mbfl_mandatory_nameref_parameter(mbfl_DST_ARRY,	1, reference to destination index array)
    mbfl_mandatory_nameref_parameter(mbfl_SRC_ARRY,	2, reference to source index array)
    mbfl_mandatory_integer_parameter(mbfl_IDX,		3, index of value to remove)
    declare -i mbfl_I mbfl_J mbfl_DIM=mbfl_slots_number(mbfl_SRC_ARRY)

    for ((mbfl_I=0, mbfl_J=0; mbfl_I < mbfl_DIM; ++mbfl_I))
    do
	if (( mbfl_I != mbfl_IDX ))
	then
	    _(mbfl_DST_ARRY, $mbfl_J, _(mbfl_SRC_ARRY, $mbfl_I))
	    let ++mbfl_J
	fi
    done
    if mbfl_string_equal _(mbfl_DST_ARRY) _(mbfl_SRC_ARRY)
    then mbfl_variable_unset mbfl_slot_spec(mbfl_DST_ARRY, $((mbfl_DIM-1)))
    fi
}
function mbfl_array_delete () {
    mbfl_mandatory_nameref_parameter(mbfl_DST_ARRY,	1, reference to destination index array)
    mbfl_mandatory_nameref_parameter(mbfl_SRC_ARRY,	2, reference to source index array)
    mbfl_mandatory_parameter(mbfl_VALUE,		3, value to remove)
    mbfl_optional_parameter(mbfl_ISEQUAL,		4, mbfl_string_equal)
    declare -i mbfl_I mbfl_J mbfl_DIM=mbfl_slots_number(mbfl_SRC_ARRY)

    for ((mbfl_I=0, mbfl_J=0; mbfl_I < mbfl_DIM; ++mbfl_I))
    do
	declare mbfl_SRC_VALUE=_(mbfl_SRC_ARRY, $mbfl_I)
	if ! "$mbfl_ISEQUAL" "$mbfl_SRC_VALUE" "$mbfl_VALUE"
	then
	    mbfl_slot_set(mbfl_DST_ARRY, $mbfl_J, "$mbfl_SRC_VALUE")
	    let ++mbfl_J
	fi
    done
}
function mbfl_array_delete_duplicates () {
    mbfl_mandatory_nameref_parameter(mbfl_DST_ARRY,	1, reference to destination index array)
    mbfl_mandatory_nameref_parameter(mbfl_SRC_ARRY,	2, reference to source index array)
    mbfl_optional_parameter(mbfl_ISEQUAL,		3, mbfl_string_equal)
    declare -i mbfl_SRC_IDX mbfl_DST_IDX

    # Iterate over  mbfl_SRC_ARRY right-to-left: we  have to keep the  original values order  in the
    # result, so we remove the rightmost duplicates.
    #
    for ((mbfl_SRC_IDX=mbfl_slots_number(mbfl_SRC_ARRY)-1, mbfl_DST_IDX=0; mbfl_SRC_IDX >=0; --mbfl_SRC_IDX))
    do
	declare mbfl_SRC_VALUE=_(mbfl_SRC_ARRY, $mbfl_SRC_IDX)
	declare mbfl_THERE_IS_NO_DUPLICATE=true
	declare -i mbfl_I

	# Search for a duplicate right-to-left.
	#
	for ((mbfl_I=mbfl_SRC_IDX-1; mbfl_I >= 0; --mbfl_I))
	do
	    if "$mbfl_ISEQUAL" "$mbfl_SRC_VALUE" _(mbfl_SRC_ARRY,$mbfl_I)
	    then
		mbfl_THERE_IS_NO_DUPLICATE=false
		break
	    fi
	done
	if $mbfl_THERE_IS_NO_DUPLICATE
	then
	    # Store the unique value left-to-right.
	    mbfl_slot_set(mbfl_DST_ARRY, $mbfl_DST_IDX, "$mbfl_SRC_VALUE")
	    let ++mbfl_DST_IDX
	fi
    done
    mbfl_array_reverse_bang _(mbfl_DST_ARRY)
}


#### arrays: folding

m4_define([[[MBFL_DEFINE_ARRAY_FOLD_FUNC]]],[[[
function $1 () {
    mbfl_mandatory_parameter(mbfl_ACCUM,	1, the nil value)
    mbfl_mandatory_parameter(mbfl_OPERATOR,	2, operator to apply)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,	3, reference to the index array)
    declare -i mbfl_I mbfl_NUM_OF_SLOTS=mbfl_slots_number(mbfl_ARRY) mbfl_RETURN_STATUS

    for $2
    do
	"$mbfl_OPERATOR" "$mbfl_ACCUM" _(mbfl_ARRY, $mbfl_I)
	mbfl_RETURN_STATUS=$?
	if ((0 != mbfl_RETURN_STATUS))
	then return $mbfl_RETURN_STATUS
	fi
    done
}
]]])
MBFL_DEFINE_ARRAY_FOLD_FUNC([[[mbfl_array_left_fold]]], [[[((mbfl_I=0; mbfl_I < mbfl_NUM_OF_SLOTS; ++mbfl_I))]]])
MBFL_DEFINE_ARRAY_FOLD_FUNC([[[mbfl_array_right_fold]]],[[[((mbfl_I=mbfl_NUM_OF_SLOTS-1; mbfl_I >= 0; --mbfl_I))]]])

m4_define([[[MBFL_DEFINE_MULTI_ARRAY_FOLD_FUNC]]],[[[
function $1 () {
    mbfl_mandatory_parameter(mbfl_ACCUM,		1, the nil value)
    mbfl_mandatory_parameter(mbfl_OPERATOR,		2, operator to apply)
    mbfl_mandatory_nameref_parameter(mbfl_ARRYS,	3, reference to the index array of index arrays)

    if ((0 != mbfl_slots_number(mbfl_ARRYS)))
    then
	mbfl_declare_integer_varref(mbfl_NUM_OF_SLOTS)
	mbfl_p_multi_array_number_of_slots_var _(mbfl_NUM_OF_SLOTS) _(mbfl_ARRYS)

	mbfl_declare_index_array_varref(mbfl_HOMOLOGOUS_VALUES)
	declare -i mbfl_I

	for $2
	do
	    mbfl_multi_array_homologous_slots_var _(mbfl_HOMOLOGOUS_VALUES) _(mbfl_ARRYS) $mbfl_I
	    "$mbfl_OPERATOR" "$mbfl_ACCUM" _(mbfl_HOMOLOGOUS_VALUES)
	    mbfl_RETURN_STATUS=$?
	    if ((0 != mbfl_RETURN_STATUS))
	    then return $mbfl_RETURN_STATUS
	    fi
	done
    fi
    return_success
}
]]])
MBFL_DEFINE_MULTI_ARRAY_FOLD_FUNC([[[mbfl_multi_array_left_fold]]], [[[((mbfl_I=0; mbfl_I < mbfl_NUM_OF_SLOTS; ++mbfl_I))]]])
MBFL_DEFINE_MULTI_ARRAY_FOLD_FUNC([[[mbfl_multi_array_right_fold]]],[[[((mbfl_I=mbfl_NUM_OF_SLOTS-1; mbfl_I >= 0; --mbfl_I))]]])


#### arrays: for-each iterations

m4_define([[[MBFL_DEFINE_ARRAY_FOREACH_FUNC]]],[[[
function $1 () {
    mbfl_declare_index_array_varref(mbfl_ACCUM, ${1:?"missing parameter operator in call to '$FUNCNAME'"})
    $2 _(mbfl_ACCUM) \
       'mbfl_p_array_fold_operator_foreach' \
       ${2:?"missing parameter reference to index array in call to '$FUNCNAME'"}
}
]]])
MBFL_DEFINE_ARRAY_FOREACH_FUNC([[[mbfl_array_left_foreach]]], [[[mbfl_array_left_fold]]])
MBFL_DEFINE_ARRAY_FOREACH_FUNC([[[mbfl_array_right_foreach]]],[[[mbfl_array_right_fold]]])
function mbfl_p_array_fold_operator_foreach () {
    mbfl_mandatory_nameref_parameter(mbfl_ACCUM,1, the accumulator)
    mbfl_mandatory_parameter(mbfl_VALUE,	2, the value from the array)
    "$mbfl_ACCUM" "$mbfl_VALUE"
}

### ------------------------------------------------------------------------

m4_define([[[MBFL_DEFINE_MULTI_ARRAY_FOREACH_FUNC]]],[[[
function $1 () {
    mbfl_declare_index_array_varref(mbfl_ACCUM, ${1:?"missing parameter operator in call to '$FUNCNAME'"})
    $2 _(mbfl_ACCUM) \
       'mbfl_p_multi_array_fold_operator_foreach' \
       ${2:?"missing parameter reference to index array of index arrays in call to '$FUNCNAME'"}
}
]]])
MBFL_DEFINE_MULTI_ARRAY_FOREACH_FUNC([[[mbfl_multi_array_left_foreach]]], [[[mbfl_multi_array_left_fold]]])
MBFL_DEFINE_MULTI_ARRAY_FOREACH_FUNC([[[mbfl_multi_array_right_foreach]]],[[[mbfl_multi_array_right_fold]]])
function mbfl_p_multi_array_fold_operator_foreach () {
    mbfl_mandatory_nameref_parameter(mbfl_ACCUM,1, the accumulator)
    mbfl_mandatory_parameter(mbfl_VALUE,	2, the value from the array)
    "$mbfl_ACCUM" "$mbfl_VALUE"
}


#### arrays: map iterations

m4_define([[[MBFL_DEFINE_ARRAY_MAP_FUNC]]],[[[
function $1 () {
    mbfl_mandatory_nameref_parameter(mbfl_DST_ARRY,	1, reference to destination index array)
    mbfl_mandatory_parameter(mbfl_OPERATOR,		2, operator to map)
    mbfl_mandatory_nameref_parameter(mbfl_SRC_ARRY,	3, reference to source index array)
    declare -i mbfl_I mbfl_NUM_OF_SLOTS=mbfl_slots_number(mbfl_SRC_ARRY) mbfl_RETURN_STATUS
    mbfl_declare_varref(mbfl_DST_VALUE)

    for $2
    do
	"$mbfl_OPERATOR" _(mbfl_DST_VALUE) _(mbfl_SRC_ARRY, $mbfl_I)
	mbfl_RETURN_STATUS=$?
	if ((0 == mbfl_RETURN_STATUS))
	then mbfl_slot_set(mbfl_DST_ARRY, $mbfl_I, "$mbfl_DST_VALUE")
	else return $mbfl_RETURN_STATUS
	fi
    done
}
]]])
MBFL_DEFINE_ARRAY_MAP_FUNC([[[mbfl_array_left_map]]], [[[((mbfl_I=0; mbfl_I < mbfl_NUM_OF_SLOTS; ++mbfl_I))]]])
MBFL_DEFINE_ARRAY_MAP_FUNC([[[mbfl_array_right_map]]],[[[((mbfl_I=mbfl_NUM_OF_SLOTS-1; mbfl_I >= 0; --mbfl_I))]]])

### ------------------------------------------------------------------------

m4_define([[[MBFL_DEFINE_MULTI_ARRAY_MAP_FUNC]]],[[[
function $1 () {
    mbfl_mandatory_nameref_parameter(mbfl_DST_ARRY,  1, reference to index array of index arrays)
    mbfl_mandatory_parameter(mbfl_OPERATOR,	     2, operator to apply)
    mbfl_mandatory_nameref_parameter(mbfl_SRC_ARRYS, 3, reference to index array of index arrays)

    if ((0 != mbfl_slots_number(mbfl_SRC_ARRYS)))
    then
	declare -i mbfl_I

	mbfl_declare_integer_varref(mbfl_NUM_OF_SLOTS)
	mbfl_p_multi_array_number_of_slots_var _(mbfl_NUM_OF_SLOTS) _(mbfl_SRC_ARRYS)

	for $2
	do
	    mbfl_declare_index_array_varref(mbfl_HOMOLOGOUS_VALUES)
	    mbfl_declare_varref(mbfl_NEW_VAL)

	    mbfl_multi_array_homologous_slots_var _(mbfl_HOMOLOGOUS_VALUES) _(mbfl_SRC_ARRYS) $mbfl_I

	    "$mbfl_OPERATOR" _(mbfl_NEW_VAL) _(mbfl_HOMOLOGOUS_VALUES)
	    declare -i mbfl_RETURN_STATUS=$?
	    if ((0 == mbfl_RETURN_STATUS))
	    then mbfl_slot_set(mbfl_DST_ARRY, $mbfl_I, "$mbfl_NEW_VAL")
	    else return $mbfl_RETURN_STATUS
	    fi
	done
    fi
}
]]])
MBFL_DEFINE_MULTI_ARRAY_MAP_FUNC([[[mbfl_multi_array_left_map]]], [[[((mbfl_I=0; mbfl_I < mbfl_NUM_OF_SLOTS; ++mbfl_I))]]])
MBFL_DEFINE_MULTI_ARRAY_MAP_FUNC([[[mbfl_multi_array_right_map]]],[[[((mbfl_I=mbfl_NUM_OF_SLOTS-1; mbfl_I >= 0; --mbfl_I))]]])


#### arrays: copying

function mbfl_array_range_copy () {
    mbfl_mandatory_nameref_parameter(mbfl_DST_ARRY,  1, reference to destination index array)
    mbfl_mandatory_integer_parameter(mbfl_DST_IDX,   2, dst index)
    mbfl_mandatory_nameref_parameter(mbfl_SRC_ARRY,  3, reference to source index array)
    mbfl_mandatory_integer_parameter(mbfl_SRC_IDX,   4, src index)
    mbfl_mandatory_integer_parameter(mbfl_DIM,       5, range dimension)
    declare -i mbfl_I

    # In case DST == SRC.
    if ((mbfl_DST_IDX < mbfl_SRC_IDX))
    then
	for ((mbfl_I=0; mbfl_I < mbfl_DIM; ++mbfl_I))
	do mbfl_slot_set(mbfl_DST_ARRY, $((mbfl_DST_IDX+mbfl_I)), _(mbfl_SRC_ARRY, $((mbfl_SRC_IDX+mbfl_I))))
	done
    else
	for ((mbfl_I=mbfl_DIM-1; mbfl_I >= 0; --mbfl_I))
	do mbfl_slot_set(mbfl_DST_ARRY, $((mbfl_DST_IDX+mbfl_I)), _(mbfl_SRC_ARRY, $((mbfl_SRC_IDX+mbfl_I))))
	done
    fi
}


#### arrays: appending

function mbfl_array_append () {
    mbfl_mandatory_nameref_parameter(mbfl_DST_ARRY,  1, reference to destination index array)
    mbfl_mandatory_nameref_parameter(mbfl_SRC_ARRY,  2, reference to source index array)
    declare -i mbfl_DST_NUM_OF_SLOTS=mbfl_slots_number(mbfl_DST_ARRY)
    declare -i mbfl_SRC_NUM_OF_SLOTS=mbfl_slots_number(mbfl_SRC_ARRY)
    declare -i mbfl_I

    for ((mbfl_I=0; mbfl_I < mbfl_SRC_NUM_OF_SLOTS; ++mbfl_I))
    do mbfl_slot_set(mbfl_DST_ARRY, $((mbfl_DST_NUM_OF_SLOTS+mbfl_I)), _(mbfl_SRC_ARRY,$mbfl_I))
    done
}
function mbfl_multi_array_append () {
    mbfl_mandatory_nameref_parameter(mbfl_DST_ARRY,  1, reference to destination index array)
    mbfl_mandatory_nameref_parameter(mbfl_SRC_ARRYS, 2, reference to index array of source index arrays)
    declare -i mbfl_I mbfl_NUM_OF_SLOTS=mbfl_slots_number(mbfl_SRC_ARRYS)

    for ((mbfl_I=0; mbfl_I < mbfl_NUM_OF_SLOTS; ++mbfl_I))
    do mbfl_array_append _(mbfl_DST_ARRY) _(mbfl_SRC_ARRYS,$mbfl_I)
    done
}


#### arrays: sorting

alias mbfl_array_is_sorted='mbfl_array_is_sorted_less'

function mbfl_array_is_sorted_less () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,	1, reference to index array)
    mbfl_optional_parameter(mbfl_ISLESS,	2, mbfl_string_less)
    declare -ir mbfl_DIM=mbfl_slots_number(mbfl_ARRY)

    if ((0 == mbfl_DIM && 1 == mbfl_DIM))
    then return_success
    else
	declare -i mbfl_I mbfl_J

	for ((mbfl_I=0, mbfl_J=1; mbfl_J < mbfl_DIM; ++mbfl_I, ++mbfl_J))
	do
	    if ! "$mbfl_ISLESS" _(mbfl_ARRY, $mbfl_I) _(mbfl_ARRY, $mbfl_J)
	    then return_failure
	    fi
	done
	return_success
    fi
}
function mbfl_array_is_sorted_greater () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,	1, reference to index array)
    mbfl_optional_parameter(mbfl_ISLESS,	2, mbfl_string_less)
    declare -ir mbfl_DIM=mbfl_slots_number(mbfl_ARRY)

    if ((0 == mbfl_DIM && 1 == mbfl_DIM))
    then return_success
    else
	declare -i mbfl_I mbfl_J

	for ((mbfl_I=mbfl_DIM-2, mbfl_J=mbfl_DIM-1; mbfl_I >= 0; --mbfl_I, --mbfl_J))
	do
	    if ! "$mbfl_ISLESS" _(mbfl_ARRY, $mbfl_J) _(mbfl_ARRY, $mbfl_I)
	    then return_failure
	    fi
	done
	return_success
    fi
}
function mbfl_array_is_sorted_leq () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,	1, reference to index array)
    mbfl_optional_parameter(mbfl_ISEQUAL,	2, mbfl_string_equal)
    mbfl_optional_parameter(mbfl_ISLESS,	3, mbfl_string_less)
    declare -ir mbfl_DIM=mbfl_slots_number(mbfl_ARRY)

    if ((0 == mbfl_DIM && 1 == mbfl_DIM))
    then return_success
    else
	declare -i mbfl_I mbfl_J

	for ((mbfl_I=0, mbfl_J=1; mbfl_J < mbfl_DIM; ++mbfl_I, ++mbfl_J))
	do
	    declare mbfl_LEFT=_(mbfl_ARRY, $mbfl_I) mbfl_RIGHT=_(mbfl_ARRY, $mbfl_J)
	    if ! "$mbfl_ISLESS" "$mbfl_LEFT" "$mbfl_RIGHT" && ! "$mbfl_ISEQUAL" "$mbfl_LEFT" "$mbfl_RIGHT"
	    then return_failure
	    fi
	done
	return_success
    fi
    return_success
}
function mbfl_array_is_sorted_geq () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,	1, reference to index array)
    mbfl_optional_parameter(mbfl_ISEQUAL,	2, mbfl_string_equal)
    mbfl_optional_parameter(mbfl_ISLESS,	3, mbfl_string_less)
    declare -ir mbfl_DIM=mbfl_slots_number(mbfl_ARRY)

    if ((0 == mbfl_DIM && 1 == mbfl_DIM))
    then return_success
    else
	declare -i mbfl_I mbfl_J

	for ((mbfl_I=0, mbfl_J=1; mbfl_J < mbfl_DIM; ++mbfl_I, ++mbfl_J))
	do
	    declare mbfl_LEFT=_(mbfl_ARRY, $mbfl_I) mbfl_RIGHT=_(mbfl_ARRY, $mbfl_J)
	    if ! "$mbfl_ISLESS" "$mbfl_RIGHT" "$mbfl_LEFT" && ! "$mbfl_ISEQUAL" "$mbfl_LEFT" "$mbfl_RIGHT"
	    then return_failure
	    fi
	done
	return_success
    fi
    return_success
}


#### arrays: sorting with quicksort 2-partition
#
# We take the Segewick-Bentley 2-partition implementation from:
#
#  https://sedgewick.io/wp-content/themes/sedgewick/talks/2002QuicksortIsOptimal.pdf
#
# beware that in the pseudo-code it is easy to confuse the letter l (ell) with the digit 1 (one).
#

function mbfl_array_quicksort_bang () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,	1, reference to index array)
    mbfl_optional_parameter(mbfl_ISLESS,	2, mbfl_string_less)
    declare -i mbfl_DIM=mbfl_slots_number(mbfl_ARRY)

    if ((1 < mbfl_DIM))
    then mbfl_p_array_quicksort_bang _(mbfl_ARRY) 0 $((mbfl_DIM-1)) "$mbfl_ISLESS"
    else return_success
    fi
}
function mbfl_p_array_quicksort_bang () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,		1, reference to index array)
    mbfl_mandatory_integer_parameter(mbfl_LEFT,		2, leftmost index of range to be partitioned)
    mbfl_mandatory_integer_parameter(mbfl_RIGHT,	3, rightmost index of range to be partitioned)
    mbfl_mandatory_parameter(mbfl_ISLESS,		4, less-than comparison function)

    if (( mbfl_LEFT >= mbfl_RIGHT ))
    then return_success
    fi

    declare -i mbfl_I=mbfl_LEFT-1
    declare -i mbfl_J=mbfl_RIGHT
    declare    mbfl_PIVOT=_(mbfl_ARRY, $mbfl_RIGHT)

    while true
    do
	while "$mbfl_ISLESS" _(mbfl_ARRY, $((++mbfl_I))) "$mbfl_PIVOT"
	do :
	done
	while "$mbfl_ISLESS" "$mbfl_PIVOT" _(mbfl_ARRY, $((--mbfl_J)))
	do (( mbfl_LEFT == mbfl_J )) && break
	done
	(( mbfl_I >= mbfl_J )) && break
	MBFL_ARRAY_SWAP(mbfl_ARRY,mbfl_I,mbfl_J)
    done
    # We come here after the bottom BREAK is executed, so mbfl_I >= mbfl_J.
    MBFL_ARRAY_SWAP(mbfl_ARRY,mbfl_I,mbfl_RIGHT)

    mbfl_p_array_quicksort_bang _(mbfl_ARRY) $mbfl_LEFT    $((mbfl_I-1)) "$mbfl_ISLESS"
    mbfl_p_array_quicksort_bang _(mbfl_ARRY) $((mbfl_I+1)) $mbfl_RIGHT   "$mbfl_ISLESS"
}


#### arrays: sorting with quicksort 3-partition
#
# We take the Segewick-Bentley 3-partition implementation from:
#
#  https://sedgewick.io/wp-content/themes/sedgewick/talks/2002QuicksortIsOptimal.pdf
#
# beware that in the pseudo-code it is easy to confuse the letter l (ell) with the digit 1 (one).
#
# void
# quicksort(Item a[], int l, int r)
# {
#   int i = l-1;
#   int j = r;
#   int p = l-1;
#   int q = r;
#   Item v = a[r];
#
#   if (r <= l) return;
#
#   for (;;) {
#     while (a[++i] < v) ;
#     while (v < a[--j]) {
#       if (j == l) break;
#     }
#     if (i >= j) {
#       break;
#     }
#     exch(a[i], a[j]);
#     if (a[i] == v) {
#       p++;
#       exch(a[p], a[i]);
#     }
#     if (v == a[j]) {
#       q--;
#       exch(a[j], a[q]);
#     }
#   }
#   exch(a[i], a[r]);
#   j = i-1;
#   i = i+1;
#   for (k = l; k < p; k++, j--) {
#     exch(a[k], a[j]);
#   }
#   for (k = r-1; k > q; k--, i++) {
#     exch(a[i], a[k]);
#   }
#   quicksort(a, l, j);
#   quicksort(a, i, r);
# }
#

function mbfl_array_quicksort3_bang () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,	1, reference to index array)
    mbfl_optional_parameter(mbfl_ISLESS,	2, mbfl_string_less)
    mbfl_optional_parameter(mbfl_ISEQUAL,	3, mbfl_string_equal)
    declare -i mbfl_DIM=mbfl_slots_number(mbfl_ARRY)

    if ((1 < mbfl_DIM))
    then mbfl_p_array_quicksort3_bang _(mbfl_ARRY) 0 $((mbfl_DIM-1)) "$mbfl_ISLESS" "$mbfl_ISEQUAL"
    else return_success
    fi
}
function mbfl_p_array_quicksort3_bang () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,		1, reference to index array)
    mbfl_mandatory_integer_parameter(mbfl_LEFT,		2, leftmost index of range to be partitioned)
    mbfl_mandatory_integer_parameter(mbfl_RIGHT,	3, rightmost index of range to be partitioned)
    mbfl_mandatory_parameter(mbfl_ISLESS,		4, less-than comparison function)
    mbfl_mandatory_parameter(mbfl_ISEQUAL,		5, equal-to comparison function)

    if (( mbfl_LEFT >= mbfl_RIGHT ))
    then return_success
    fi

    declare -i mbfl_I=mbfl_LEFT-1
    declare -i mbfl_J=mbfl_RIGHT
    declare -i mbfl_P=mbfl_LEFT-1
    declare -i mbfl_Q=mbfl_RIGHT
    declare    mbfl_PIVOT=_(mbfl_ARRY, $mbfl_RIGHT)

    while true
    do
	while "$mbfl_ISLESS" _(mbfl_ARRY, $((++mbfl_I))) "$mbfl_PIVOT"
	do :
	done
	while "$mbfl_ISLESS" "$mbfl_PIVOT" _(mbfl_ARRY, $((--mbfl_J)))
	do (( mbfl_LEFT == mbfl_J )) && break
	done
	(( mbfl_I >= mbfl_J )) && break
	MBFL_ARRAY_SWAP(mbfl_ARRY,mbfl_I,mbfl_J)
	if "$mbfl_ISEQUAL" _(mbfl_ARRY,$mbfl_I) "$mbfl_PIVOT"
	then
	    let ++mbfl_P
	    MBFL_ARRAY_SWAP(mbfl_ARRY,mbfl_P,mbfl_I)
	fi
	if "$mbfl_ISEQUAL" "$mbfl_PIVOT" _(mbfl_ARRY,$mbfl_J)
	then
	    let --mbfl_Q
	    MBFL_ARRAY_SWAP(mbfl_ARRY,mbfl_J,mbfl_Q)
	fi
    done
    # We come here after the bottom BREAK is executed, so mbfl_I >= mbfl_J.
    MBFL_ARRAY_SWAP(mbfl_ARRY,mbfl_I,mbfl_RIGHT)
    let mbfl_J=mbfl_I-1
    let ++mbfl_I

    declare -i mbfl_K
    for ((mbfl_K=mbfl_LEFT; mbfl_K < mbfl_P; ++mbfl_K, --mbfl_J))
    do MBFL_ARRAY_SWAP(mbfl_ARRY,mbfl_K,mbfl_J)
    done

    for ((mbfl_K=mbfl_RIGHT-1; mbfl_K > mbfl_Q; --mbfl_K, ++mbfl_I))
    do MBFL_ARRAY_SWAP(mbfl_ARRY,mbfl_I,mbfl_K)
    done

    mbfl_p_array_quicksort3_bang _(mbfl_ARRY) $mbfl_LEFT $mbfl_J     "$mbfl_ISLESS" "$mbfl_ISEQUAL"
    mbfl_p_array_quicksort3_bang _(mbfl_ARRY) $mbfl_I    $mbfl_RIGHT "$mbfl_ISLESS" "$mbfl_ISEQUAL"
}


#### arrays: insert sort

declare -i mbfl_array_INSERTSORT_LINEAR_LIMIT=5

function mbfl_array_insertsort_bang () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,	1, reference to index array)
    mbfl_mandatory_parameter(mbfl_VALUE,	2, new value)
    mbfl_optional_parameter(mbfl_ISLESS,	3, mbfl_string_less)
    declare -i mbfl_I mbfl_DIM=mbfl_slots_number(mbfl_ARRY)

    #echo $FUNCNAME mbfl_DIM=$mbfl_DIM >&2

    if ((0 == mbfl_DIM))
    then mbfl_slot_set(mbfl_ARRY, $mbfl_I, "$mbfl_VALUE")
    elif (( mbfl_DIM < mbfl_array_INSERTSORT_LINEAR_LIMIT ))
    then mbfl_p_array_linear_insertsort_bang _(mbfl_ARRY) 0 $mbfl_DIM "$mbfl_VALUE" "$mbfl_ISLESS"
    else mbfl_p_array_binary_insertsort_bang _(mbfl_ARRY) 0 $mbfl_DIM "$mbfl_VALUE" "$mbfl_ISLESS"
    fi
}
function mbfl_p_array_binary_insertsort_bang () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,		1, reference to index array)
    mbfl_mandatory_integer_parameter(mbfl_BEG,		2, left-inclusive index)
    mbfl_mandatory_integer_parameter(mbfl_END,		3, right-exclusive index)
    mbfl_mandatory_parameter(mbfl_VALUE,		4, new value)
    mbfl_mandatory_parameter(mbfl_ISLESS,		5, isless)
    declare -i mbfl_DELTA=mbfl_END-mbfl_BEG

    if (( mbfl_DELTA < mbfl_array_INSERTSORT_LINEAR_LIMIT ))
    then mbfl_p_array_linear_insertsort_bang _(mbfl_ARRY) $mbfl_BEG $mbfl_END "$mbfl_VALUE" "$mbfl_ISLESS"
    else
	declare -i mbfl_I=mbfl_BEG+mbfl_DELTA/2

	#echo $FUNCNAME mbfl_BEG=$mbfl_BEG mbfl_END=$mbfl_END mbfl_DELTA=$mbfl_DELTA mbfl_I=$mbfl_I "$mbfl_VALUE" _(mbfl_ARRY, $mbfl_I) >&2

	if "$mbfl_ISLESS" "$mbfl_VALUE" _(mbfl_ARRY, $mbfl_I)
	then mbfl_p_array_binary_insertsort_bang _(mbfl_ARRY) $mbfl_BEG $mbfl_I   "$mbfl_VALUE" "$mbfl_ISLESS"
	else mbfl_p_array_binary_insertsort_bang _(mbfl_ARRY) $mbfl_I   $mbfl_END "$mbfl_VALUE" "$mbfl_ISLESS"
	fi
    fi
}
function mbfl_p_array_linear_insertsort_bang () {
    #echo $FUNCNAME >&2
    mbfl_mandatory_nameref_parameter(mbfl_ARRY,		1, reference to index array)
    mbfl_mandatory_integer_parameter(mbfl_BEG,		2, left-inclusive index)
    mbfl_mandatory_integer_parameter(mbfl_END,		3, right-exclusive index)
    mbfl_mandatory_parameter(mbfl_VALUE,		4, new value)
    mbfl_mandatory_parameter(mbfl_ISLESS,		5, isless)
    declare -i mbfl_I mbfl_DIM=mbfl_slots_number(mbfl_ARRY)

    # NOTE!!!!  We  could/should iterate until  mbfl_I < mbfl_BEG this  would seem logical.   But if
    # there is  a substring  of equal values:  we want  to insert the  new value at  the end  of the
    # string.  For this reason we iterate until mbfl_I < mbfl_DIM, this way we will iterate over the
    # substring of equal values until it ends.
    #
    for ((mbfl_I=mbfl_BEG; mbfl_I < mbfl_DIM; ++mbfl_I))
    do
	if "$mbfl_ISLESS" "$mbfl_VALUE" _(mbfl_ARRY, $mbfl_I)
	then
	    mbfl_array_insert_value_bang _(mbfl_ARRY) $mbfl_I "$mbfl_VALUE"
	    return_success
	fi
    done
    if ((mbfl_I == mbfl_END))
    then mbfl_array_insert_value_bang _(mbfl_ARRY) $mbfl_END "$mbfl_VALUE"
    fi
}


#### arrays: set operations

function mbfl_array_set_union () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_ARRY,	1, reference to union index array)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY1,	2, reference to source index array)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY2,	3, reference to source index array)
    mbfl_optional_parameter(mbfl_ISEQUAL,		4, mbfl_string_equal)
    declare -i mbfl_DIM1=mbfl_slots_number(mbfl_ARRY1) mbfl_DIM2=mbfl_slots_number(mbfl_ARRY2)
    declare -i mbfl_I mbfl_J mbfl_K=mbfl_DIM1

    mbfl_array_copy _(mbfl_RESULT_ARRY) _(mbfl_ARRY1)

    for ((mbfl_I=0; mbfl_I < mbfl_DIM2; ++mbfl_I))
    do
	declare mbfl_UNIQUE=true
	declare mbfl_VALUE=_(mbfl_ARRY2, $mbfl_I)

	for ((mbfl_J=0; mbfl_J < mbfl_DIM1; ++mbfl_J))
	do
	    if "$mbfl_ISEQUAL" "$mbfl_VALUE" _(mbfl_ARRY1, $mbfl_J)
	    then
		mbfl_UNIQUE=false
		break
	    fi
	done

	if $mbfl_UNIQUE
	then
	    mbfl_slot_set(mbfl_RESULT_ARRY, $mbfl_K, "$mbfl_VALUE")
	    let ++mbfl_K
	fi
    done
}
function mbfl_array_set_intersection () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_ARRY,	1, reference to union index array)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY1,	2, reference to source index array)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY2,	3, reference to source index array)
    mbfl_optional_parameter(mbfl_ISEQUAL,		4, mbfl_string_equal)
    declare -i mbfl_DIM1=mbfl_slots_number(mbfl_ARRY1) mbfl_DIM2=mbfl_slots_number(mbfl_ARRY2)
    declare -i mbfl_I mbfl_J mbfl_K=0

    for ((mbfl_I=0; mbfl_I < mbfl_DIM1; ++mbfl_I))
    do
	declare mbfl_UNIQUE=true
	declare mbfl_VALUE=_(mbfl_ARRY1, $mbfl_I)

	for ((mbfl_J=0; mbfl_J < mbfl_DIM2; ++mbfl_J))
	do
	    declare mbfl_VALUE2=

	    if "$mbfl_ISEQUAL" "$mbfl_VALUE" _(mbfl_ARRY2, $mbfl_J)
	    then
		mbfl_UNIQUE=false
		break
	    fi
	done

	if ! $mbfl_UNIQUE
	then
	    mbfl_slot_set(mbfl_RESULT_ARRY, $mbfl_K, "$mbfl_VALUE")
	    let ++mbfl_K
	fi
    done
}
function mbfl_array_set_xor () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_ARRY,	1, reference to union index array)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY1,	2, reference to source index array)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY2,	3, reference to source index array)
    mbfl_optional_parameter(mbfl_ISEQUAL,		4, mbfl_string_equal)
    declare -i mbfl_DIM1=mbfl_slots_number(mbfl_ARRY1) mbfl_DIM2=mbfl_slots_number(mbfl_ARRY2)
    declare -i mbfl_I mbfl_J mbfl_K=0

    # Store in RESULT all the values from ARRY1 that are not in ARRY2.
    #
    for ((mbfl_I=0; mbfl_I < mbfl_DIM1; ++mbfl_I))
    do
	declare mbfl_VALUE=_(mbfl_ARRY1, $mbfl_I)
	declare mbfl_UNIQUE=true

	for ((mbfl_J=0; mbfl_J < mbfl_DIM2; ++mbfl_J))
	do
	    if "$mbfl_ISEQUAL" "$mbfl_VALUE" _(mbfl_ARRY2, $mbfl_J)
	    then
		mbfl_UNIQUE=false
		break
	    fi
	done

	if $mbfl_UNIQUE
	then
	    mbfl_slot_set(mbfl_RESULT_ARRY, $mbfl_K, "$mbfl_VALUE")
	    let ++mbfl_K
	fi
    done

    # Store in RESULT all the values from ARRY2 that are not in ARRY1.
    #
    for ((mbfl_I=0; mbfl_I < mbfl_DIM2; ++mbfl_I))
    do
	declare mbfl_VALUE=_(mbfl_ARRY2, $mbfl_I)
	declare mbfl_UNIQUE=true

	for ((mbfl_J=0; mbfl_J < mbfl_DIM1; ++mbfl_J))
	do
	    if "$mbfl_ISEQUAL" "$mbfl_VALUE" _(mbfl_ARRY1, $mbfl_J)
	    then
		mbfl_UNIQUE=false
		break
	    fi
	done

	if $mbfl_UNIQUE
	then
	    mbfl_slot_set(mbfl_RESULT_ARRY, $mbfl_K, "$mbfl_VALUE")
	    let ++mbfl_K
	fi
    done
}
function mbfl_array_set_difference () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_ARRY,	1, reference to union index array)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY1,	2, reference to source index array)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY2,	3, reference to source index array)
    mbfl_optional_parameter(mbfl_ISEQUAL,		4, mbfl_string_equal)
    declare -i mbfl_DIM1=mbfl_slots_number(mbfl_ARRY1) mbfl_DIM2=mbfl_slots_number(mbfl_ARRY2)
    declare -i mbfl_I mbfl_J mbfl_K=0

    for ((mbfl_I=0; mbfl_I < mbfl_DIM1; ++mbfl_I))
    do
	declare mbfl_UNIQUE=true
	declare mbfl_VALUE=_(mbfl_ARRY1, $mbfl_I)

	for ((mbfl_J=0; mbfl_J < mbfl_DIM2; ++mbfl_J))
	do
	    if "$mbfl_ISEQUAL" "$mbfl_VALUE" _(mbfl_ARRY2, $mbfl_J)
	    then
		mbfl_UNIQUE=false
		break
	    fi
	done

	if $mbfl_UNIQUE
	then
	    mbfl_slot_set(mbfl_RESULT_ARRY, $mbfl_K, "$mbfl_VALUE")
	    let ++mbfl_K
	fi
    done
}


#### arrays: miscellaneous

function mbfl_array_reverse () {
    mbfl_mandatory_nameref_parameter(mbfl_DST_ARRY,  1, reference to destination index array)
    mbfl_mandatory_nameref_parameter(mbfl_SRC_ARRY,  2, reference to source index array)
    declare -i mbfl_DST_NUM_OF_SLOTS=mbfl_slots_number(mbfl_DST_ARRY)
    declare -i mbfl_SRC_NUM_OF_SLOTS=mbfl_slots_number(mbfl_SRC_ARRY)
    declare -i mbfl_I

    for ((mbfl_I=0; mbfl_I < mbfl_SRC_NUM_OF_SLOTS; ++mbfl_I))
    do mbfl_slot_set(mbfl_DST_ARRY, $mbfl_I, _(mbfl_SRC_ARRY,$((mbfl_SRC_NUM_OF_SLOTS-mbfl_I-1))))
    done
}
function mbfl_array_reverse_bang () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY, 1, index array)
    declare -i mbfl_NUM_OF_SLOTS=mbfl_slots_number(mbfl_ARRY)

    if (( 0 != mbfl_NUM_OF_SLOTS && 1 != mbfl_NUM_OF_SLOTS ))
    then
	declare -i mbfl_I mbfl_J
	declare mbfl_VALUE
	for ((mbfl_I=0, mbfl_J=mbfl_NUM_OF_SLOTS-1; mbfl_I < mbfl_J; ++mbfl_I, --mbfl_J))
	do
	    mbfl_VALUE=_(mbfl_ARRY, $mbfl_J)
	    mbfl_slot_set(mbfl_ARRY, $mbfl_J, _(mbfl_ARRY, $mbfl_I))
	    mbfl_slot_set(mbfl_ARRY, $mbfl_I, "$mbfl_VALUE")
	done
    fi
}
function mbfl_array_swap_bang () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY, 1, reference to index array)
    mbfl_mandatory_integer_parameter(mbfl_IDX1, 2, slot index one)
    mbfl_mandatory_integer_parameter(mbfl_IDX2, 3, slot index two)

    if (( mbfl_IDX1 != mbfl_IDX2 ))
    then
	declare mbfl_VALUE=_(mbfl_ARRY, $mbfl_IDX1)
	mbfl_slot_set(mbfl_ARRY, $mbfl_IDX1, _(mbfl_ARRY, $mbfl_IDX2))
	mbfl_slot_set(mbfl_ARRY, $mbfl_IDX2, "$mbfl_VALUE")
    fi
}
function mbfl_array_zip () {
    mbfl_mandatory_nameref_parameter(mbfl_DST_ARRY,  1, reference to destination index array)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY1,     2, reference to source index array)
    mbfl_mandatory_nameref_parameter(mbfl_ARRY2,     3, reference to source index array)
    declare -i mbfl_NUM_OF_SLOTS=mbfl_slots_number(mbfl_ARRY1)
    declare -i mbfl_I mbfl_J

    for ((mbfl_I=0, mbfl_J=0; mbfl_I < mbfl_NUM_OF_SLOTS; ++mbfl_I, ++mbfl_J))
    do
	mbfl_slot_set(mbfl_DST_ARRY, $mbfl_J, _(mbfl_ARRY1,$mbfl_I))
	let ++mbfl_J
	mbfl_slot_set(mbfl_DST_ARRY, $mbfl_J, _(mbfl_ARRY2,$mbfl_I))
    done
}

function mbfl_array_reset_bang () {
    mbfl_mandatory_nameref_parameter(mbfl_ARRY, 1, reference to index array)
    declare -i mbfl_I mbfl_DIM=mbfl_slots_number(mbfl_ARRY)

    for ((mbfl_I=0; mbfl_I < mbfl_DIM; ++mbfl_I))
    do _(mbfl_ARRY, $mbfl_I, '')
    done
}


#### stacks

m4_define([[[MBFL_STACK_ACCESS_ARRAY]]],[[[
  mbfl_declare_varref($2_DATAVAR)
  mbfl_stack_array_var _($2_DATAVAR) _($1)
  mbfl_declare_nameref($2, $[[[$2]]]_DATAVAR)
]]])

m4_define([[[MBFL_STACK_VALIDATE_PARAMETER]]],[[[
  if ! mbfl_stack_p _($1)
  then
      mbfl_message_error_printf 'expected object of class "mbfl_stack" as parameter, got: "%s"' _($1)
      return_failure
  fi
]]])

function mbfl_stack_make () {
    mbfl_mandatory_nameref_parameter(mbfl_STACK, 1, reference to uninitialised object of class mbfl_stack_t)
    mbfl_declare_index_array_varref(mbfl_ARRAY,,-g)

    mbfl_stack_define _(mbfl_STACK) _(mbfl_ARRAY)
}
function mbfl_stack_unmake () {
    mbfl_mandatory_nameref_parameter(mbfl_STACK, 1, reference to object of class mbfl_stack_t)

    MBFL_STACK_VALIDATE_PARAMETER(mbfl_STACK)
    mbfl_declare_varref(mbfl_ARRAY_DATAVAR)
    mbfl_stack_array_var _(mbfl_ARRAY_DATAVAR) _(mbfl_STACK)
    unset -v $mbfl_ARRAY_DATAVAR
}
function mbfl_stack_size_var () {
    mbfl_mandatory_nameref_parameter(mbfl_SIZE,  1, reference to result variable)
    mbfl_mandatory_nameref_parameter(mbfl_STACK, 2, reference to object of class mbfl_stack_t)

    MBFL_STACK_VALIDATE_PARAMETER(mbfl_STACK)
    MBFL_STACK_ACCESS_ARRAY(mbfl_STACK, mbfl_ARRAY)
    mbfl_SIZE=mbfl_slots_number(mbfl_ARRAY)
}
function mbfl_stack_push () {
    mbfl_mandatory_nameref_parameter(mbfl_STACK, 1, reference to object of class mbfl_stack_t)
    shift
    declare mbfl_VALUE

    MBFL_STACK_VALIDATE_PARAMETER(mbfl_STACK)
    MBFL_STACK_ACCESS_ARRAY(mbfl_STACK, mbfl_ARRAY)
    for mbfl_VALUE in "$@"
    do mbfl_slot_set(mbfl_ARRAY, mbfl_slots_number(mbfl_ARRAY), "$mbfl_VALUE")
    done
    return_success
}
function mbfl_stack_pop_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,    1, reference to the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_STACK, 2, reference to object of class mbfl_stack_t)

    MBFL_STACK_VALIDATE_PARAMETER(mbfl_STACK)
    MBFL_STACK_ACCESS_ARRAY(mbfl_STACK, mbfl_ARRAY)
    if (( 0 < mbfl_slots_number(mbfl_ARRAY) ))
    then
	mbfl_RV=mbfl_slot_ref(mbfl_ARRAY, -1)
	unset -v mbfl_slot_spec(mbfl_ARRAY, -1)
	return_success
    else
	mbfl_message_error_printf 'attempt to pop from an empty stack: "%s"' _(mbfl_STACK)
	return_failure
    fi
}
function mbfl_stack_top_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,    1, reference to the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_STACK, 2, reference to object of class mbfl_stack_t)

    MBFL_STACK_VALIDATE_PARAMETER(mbfl_STACK)
    MBFL_STACK_ACCESS_ARRAY(mbfl_STACK, mbfl_ARRAY)
    if (( 0 < mbfl_slots_number(mbfl_ARRAY) ))
    then
	mbfl_RV=mbfl_slot_ref(mbfl_ARRAY, -1)
	return_success
    else
	mbfl_message_error_printf 'attempt to pop from an empty stack: "%s"' _(mbfl_STACK)
	return_failure
    fi
}
function mbfl_stack_copy () {
    mbfl_mandatory_nameref_parameter(mbfl_DST_STACK, 1, reference to destination object of class mbfl_stack_t)
    mbfl_mandatory_nameref_parameter(mbfl_SRC_STACK, 2, reference to source object of class mbfl_stack_t)

    MBFL_STACK_VALIDATE_PARAMETER(mbfl_DST_STACK)
    MBFL_STACK_VALIDATE_PARAMETER(mbfl_SRC_STACK)
    MBFL_STACK_ACCESS_ARRAY(mbfl_DST_STACK, mbfl_DST_ARRAY)
    MBFL_STACK_ACCESS_ARRAY(mbfl_SRC_STACK, mbfl_SRC_ARRAY)

    declare -i mbfl_I mbfl_NUM=mbfl_slots_number(mbfl_SRC_ARRAY)

    for ((mbfl_I=0; mbfl_I<mbfl_NUM; ++mbfl_I))
    do mbfl_slot_set(mbfl_DST_ARRAY, $mbfl_I, _(mbfl_SRC_ARRAY, $mbfl_I))
    done
}
function mbfl_stack_equal () {
    mbfl_mandatory_nameref_parameter(mbfl_STACK1, 1, reference to object of class mbfl_stack_t)
    mbfl_mandatory_nameref_parameter(mbfl_STACK2, 2, reference to object of class mbfl_stack_t)
    mbfl_optional_parameter(mbfl_ISEQUAL,          3, mbfl_string_equal)

    MBFL_STACK_VALIDATE_PARAMETER(mbfl_STACK1)
    MBFL_STACK_VALIDATE_PARAMETER(mbfl_STACK2)
    MBFL_STACK_ACCESS_ARRAY(mbfl_STACK1, mbfl_ARRAY1)
    MBFL_STACK_ACCESS_ARRAY(mbfl_STACK2, mbfl_ARRAY2)

    if (( mbfl_slots_number(mbfl_ARRAY2) != mbfl_slots_number(mbfl_ARRAY1) ))
    then return_failure
    fi

    {
	declare -i mbfl_I mbfl_NUM=mbfl_slots_number(mbfl_ARRAY2)
	for ((mbfl_I=0; mbfl_I<mbfl_NUM; ++mbfl_I))
	do
	    if ! "$mbfl_ISEQUAL" _(mbfl_ARRAY1, $mbfl_I) _(mbfl_ARRAY2, $mbfl_I)
	    then return_failure
	    fi
	done
    }
    return_success
}

function mbfl_stack_dump () {
    mbfl_mandatory_nameref_parameter(mbfl_STACK, 1, reference to object of class mbfl_stack_t)
    mbfl_optional_parameter(mbfl_LABEL, 2)

    MBFL_STACK_VALIDATE_PARAMETER(mbfl_STACK)
    MBFL_STACK_ACCESS_ARRAY(mbfl_STACK, mbfl_ARRAY)
    mbfl_array_dump _(mbfl_ARRAY) "$mbfl_LABEL"
}

### ------------------------------------------------------------------------
### the following are wrappers for methods

function mbfl_stack_pop () {
    mbfl_mandatory_nameref_parameter(mbfl_STACK, 1, reference to object of class mbfl_stack_t)
    mbfl_mandatory_nameref_parameter(mbfl_RV,    2, reference to the result variable)
    mbfl_stack_pop_var _(mbfl_RV) _(mbfl_STACK)
}
function mbfl_stack_top () {
    mbfl_mandatory_nameref_parameter(mbfl_STACK, 1, reference to object of class mbfl_stack_t)
    mbfl_mandatory_nameref_parameter(mbfl_RV,    2, reference to the result variable)
    mbfl_stack_top_var _(mbfl_RV) _(mbfl_STACK)
}
function mbfl_stack_size () {
    mbfl_mandatory_nameref_parameter(mbfl_STACK, 1, reference to object of class mbfl_stack_t)
    mbfl_mandatory_nameref_parameter(mbfl_RV,    2, reference to the result variable)
    mbfl_stack_size_var _(mbfl_RV) _(mbfl_STACK)
}


#### vectors

m4_define([[[MBFL_VECTOR_ACCESS_ARRAY]]],[[[
  mbfl_declare_varref($2_DATAVAR)
  mbfl_vector_array_var _($2_DATAVAR) _($1)
  mbfl_declare_nameref($2, $[[[$2]]]_DATAVAR)
]]])

m4_define([[[MBFL_VECTOR_VALIDATE_PARAMETER]]],[[[
  if ! mbfl_vector_p _($1)
  then
      mbfl_message_error_printf 'expected object of class "mbfl_vector" as parameter, got: "%s"' _($1)
      return_failure
  fi
]]])

function mbfl_vector_make () {
    mbfl_mandatory_nameref_parameter(mbfl_VECTOR, 1, reference to uninitialised object of class mbfl_vector_t)
    mbfl_declare_index_array_varref(mbfl_ARRAY,,-g)

    mbfl_vector_define _(mbfl_VECTOR) _(mbfl_ARRAY)
}
function mbfl_vector_unmake () {
    mbfl_mandatory_nameref_parameter(mbfl_VECTOR, 1, reference to object of class mbfl_vector_t)

    MBFL_VECTOR_VALIDATE_PARAMETER(mbfl_VECTOR)
    mbfl_declare_varref(mbfl_ARRAY_DATAVAR)
    mbfl_vector_array_var _(mbfl_ARRAY_DATAVAR) _(mbfl_VECTOR)
    unset -v $mbfl_ARRAY_DATAVAR
}

### ------------------------------------------------------------------------

function mbfl_vector_size_var () {
    mbfl_mandatory_nameref_parameter(mbfl_SIZE,  1, reference to result variable)
    mbfl_mandatory_nameref_parameter(mbfl_VECTOR, 2, reference to object of class mbfl_vector_t)

    MBFL_VECTOR_VALIDATE_PARAMETER(mbfl_VECTOR)
    MBFL_VECTOR_ACCESS_ARRAY(mbfl_VECTOR, mbfl_ARRAY)
    mbfl_SIZE=mbfl_slots_number(mbfl_ARRAY)
}

### ------------------------------------------------------------------------

function mbfl_vector_push () {
    mbfl_mandatory_nameref_parameter(mbfl_VECTOR, 1, reference to object of class mbfl_vector_t)
    mbfl_mandatory_parameter(mbfl_OBJ,           2, the object to push on the vector)

    MBFL_VECTOR_VALIDATE_PARAMETER(mbfl_VECTOR)
    MBFL_VECTOR_ACCESS_ARRAY(mbfl_VECTOR, mbfl_ARRAY)
    mbfl_slot_set(mbfl_ARRAY, mbfl_slots_number(mbfl_ARRAY), "$mbfl_OBJ")
    return_success
}
function mbfl_vector_pop_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,    1, reference to the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_VECTOR, 2, reference to object of class mbfl_vector_t)

    MBFL_VECTOR_VALIDATE_PARAMETER(mbfl_VECTOR)
    MBFL_VECTOR_ACCESS_ARRAY(mbfl_VECTOR, mbfl_ARRAY)
    if (( 0 < mbfl_slots_number(mbfl_ARRAY) ))
    then
	mbfl_RV=mbfl_slot_ref(mbfl_ARRAY, -1)
	unset -v mbfl_slot_spec(mbfl_ARRAY, -1)
	return_success
    else
	mbfl_message_error_printf 'attempt to pop from an empty vector: "%s"' _(mbfl_VECTOR)
	return_failure
    fi
}
function mbfl_vector_top_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,    1, reference to the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_VECTOR, 2, reference to object of class mbfl_vector_t)

    MBFL_VECTOR_VALIDATE_PARAMETER(mbfl_VECTOR)
    MBFL_VECTOR_ACCESS_ARRAY(mbfl_VECTOR, mbfl_ARRAY)
    if (( 0 < mbfl_slots_number(mbfl_ARRAY) ))
    then
	mbfl_RV=mbfl_slot_ref(mbfl_ARRAY, -1)
	return_success
    else
	mbfl_message_error_printf 'attempt to pop from an empty vector: "%s"' _(mbfl_VECTOR)
	return_failure
    fi
}
function mbfl_vector_copy () {
    mbfl_mandatory_nameref_parameter(mbfl_DST_VECTOR, 1, reference to destination object of class mbfl_vector_t)
    mbfl_mandatory_nameref_parameter(mbfl_SRC_VECTOR, 2, reference to source object of class mbfl_vector_t)

    MBFL_VECTOR_VALIDATE_PARAMETER(mbfl_DST_VECTOR)
    MBFL_VECTOR_VALIDATE_PARAMETER(mbfl_SRC_VECTOR)
    MBFL_VECTOR_ACCESS_ARRAY(mbfl_DST_VECTOR, mbfl_DST_ARRAY)
    MBFL_VECTOR_ACCESS_ARRAY(mbfl_SRC_VECTOR, mbfl_SRC_ARRAY)

    declare -i mbfl_I mbfl_NUM=mbfl_slots_number(mbfl_SRC_ARRAY)

    for ((mbfl_I=0; mbfl_I<mbfl_NUM; ++mbfl_I))
    do mbfl_slot_set(mbfl_DST_ARRAY, $mbfl_I, _(mbfl_SRC_ARRAY, $mbfl_I))
    done
}
function mbfl_vector_equal () {
    mbfl_mandatory_nameref_parameter(mbfl_VECTOR1, 1, reference to object of class mbfl_vector_t)
    mbfl_mandatory_nameref_parameter(mbfl_VECTOR2, 2, reference to object of class mbfl_vector_t)
    mbfl_optional_parameter(mbfl_ISEQUAL,           3, mbfl_string_equal)

    MBFL_VECTOR_VALIDATE_PARAMETER(mbfl_VECTOR1)
    MBFL_VECTOR_VALIDATE_PARAMETER(mbfl_VECTOR2)
    MBFL_VECTOR_ACCESS_ARRAY(mbfl_VECTOR1, mbfl_ARRAY1)
    MBFL_VECTOR_ACCESS_ARRAY(mbfl_VECTOR2, mbfl_ARRAY2)

    if (( mbfl_slots_number(mbfl_ARRAY2) != mbfl_slots_number(mbfl_ARRAY1) ))
    then return_failure
    fi

    {
	declare -i mbfl_I mbfl_NUM=mbfl_slots_number(mbfl_ARRAY2)
	for ((mbfl_I=0; mbfl_I<mbfl_NUM; ++mbfl_I))
	do
	    if ! "$mbfl_ISEQUAL" _(mbfl_ARRAY1, $mbfl_I) _(mbfl_ARRAY2, $mbfl_I)
	    then return_failure
	    fi
	done
    }
    return_success
}

function mbfl_vector_dump () {
    mbfl_mandatory_nameref_parameter(mbfl_VECTOR, 1, reference to object of class mbfl_vector_t)
    mbfl_optional_parameter(mbfl_LABEL, 2)

    MBFL_VECTOR_VALIDATE_PARAMETER(mbfl_VECTOR)
    MBFL_VECTOR_ACCESS_ARRAY(mbfl_VECTOR, mbfl_ARRAY)
    mbfl_array_dump _(mbfl_ARRAY) "$mbfl_LABEL"
}

### ------------------------------------------------------------------------
### the following are wrappers for methods

function mbfl_vector_pop () {
    mbfl_mandatory_nameref_parameter(mbfl_VECTOR, 1, reference to object of class mbfl_vector_t)
    mbfl_mandatory_nameref_parameter(mbfl_RV,    2, reference to the result variable)
    mbfl_vector_pop_var _(mbfl_RV) _(mbfl_VECTOR)
}
function mbfl_vector_top () {
    mbfl_mandatory_nameref_parameter(mbfl_VECTOR, 1, reference to object of class mbfl_vector_t)
    mbfl_mandatory_nameref_parameter(mbfl_RV,    2, reference to the result variable)
    mbfl_vector_top_var _(mbfl_RV) _(mbfl_VECTOR)
}
function mbfl_vector_size () {
    mbfl_mandatory_nameref_parameter(mbfl_VECTOR, 1, reference to object of class mbfl_vector_t)
    mbfl_mandatory_nameref_parameter(mbfl_RV,    2, reference to the result variable)
    mbfl_vector_size_var _(mbfl_RV) _(mbfl_VECTOR)
}



#!# end of file
# Local Variables:
# mode: sh
# End:
