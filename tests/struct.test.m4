# struct.test.m4 --
#
# Part of: Marco's BASH function libraries
# Contents: tests for the struct module
# Date: Mar 12, 2023
#
# Abstract
#
#	This file must be executed with:
#
#		$ make all test TESTMATCH=struct-
#
#	will select these tests.
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
mbfl_load_library("$MBFL_LIBMBFL_TEST")

m4_define([[[_]]],[[[mbfl_datavar([[[$1]]])]]])


#### tests for the built-in data structure type "mbfl_struct_top"

function struct-top-1.1 () {
    mbfl_struct_top? _(mbfl_struct_top) &&
	! mbfl_struct_top_descriptor? _(mbfl_struct_top)
}
function struct-top-1.2 () {
    declare TYPE
    mbfl_struct_type_var TYPE _(mbfl_struct_top)
    dotest-equal _(mbfl_struct_top) $TYPE
}
function struct-top-1.3 () {
    mbfl_struct_descriptor? _(mbfl_struct_top)
}

### ------------------------------------------------------------------------
### inspecting the fields

function struct-top-fields-2.1 () {
    declare NAME
    mbfl_struct_descriptor_name_var NAME _(mbfl_struct_top)
    dotest-equal 'mbfl_struct_top' "$NAME"
}
function struct-top-fields-2.2 () {
    declare PARENT
    mbfl_struct_descriptor_parent_var PARENT _(mbfl_struct_top)
    dotest-equal '' "$PARENT"
}
function struct-top-fields-2.3 () {
    declare FIELDS_NUMBER
    mbfl_struct_descriptor_fields_number_var FIELDS_NUMBER _(mbfl_struct_top)
    dotest-equal 3 "$FIELDS_NUMBER"
}


#### tests for the built-in data structure type "mbfl_struct_top_descriptor"

function struct-top-descriptor-1.1 () {
    ! mbfl_struct_top? _(mbfl_struct_top_descriptor) &&
	mbfl_struct_top_descriptor? _(mbfl_struct_top_descriptor)
}
function struct-top-descriptor-1.2 () {
    declare TYPE
    mbfl_struct_type_var TYPE _(mbfl_struct_top_descriptor)
    dotest-equal _(mbfl_struct_top) $TYPE
}
function struct-top-descriptor-1.3 () {
    mbfl_struct_descriptor? _(mbfl_struct_top_descriptor)
}

### ------------------------------------------------------------------------
### inspecting the fields

function struct-top-descriptor-fields-2.1 () {
    declare NAME
    mbfl_struct_descriptor_name_var NAME _(mbfl_struct_top_descriptor)
    dotest-equal 'mbfl_struct_top_descriptor' "$NAME"
}
function struct-top-descriptor-fields-2.2 () {
    declare PARENT
    mbfl_struct_descriptor_parent_var PARENT _(mbfl_struct_top_descriptor)
    dotest-equal '' "$PARENT"
}
function struct-top-descriptor-fields-2.3 () {
    declare FIELDS_NUMBER
    mbfl_struct_descriptor_fields_number_var FIELDS_NUMBER _(mbfl_struct_top_descriptor)
    dotest-equal 0 "$FIELDS_NUMBER"
}


#### simple tests

# Test  for: mbfl_struct_declare,  mbfl_struct_define_type,  struct  constructor, struct  predicate,
# field accessors.
#
function struct-simple-1.1 () {
    mbfl_struct_declare(greek)
    mbfl_struct_declare(self)
    declare A=0 B=0 C=0
    declare PREDICATE_RESULT
    declare IS_A_RESULT

    mbfl_struct_define_type _(greek) _(mbfl_struct_top_descriptor) 'greek' alpha beta gamma

    greek_init _(self) 1 2 3
    # mbfl_array_dump _(greek)
    # mbfl_array_dump _(self)

    greek_alpha_var A _(self)
    greek_beta_var  B _(self)
    greek_gamma_var C _(self)

    # echo mbfl_struct_top datavar _(mbfl_struct_top) >&2
    # echo mbfl_struct_top_descriptor datavar _(mbfl_struct_top_descriptor) >&2
    # echo greek datavar _(greek) >&2
    # echo self slot 0 ${self[0]} >&2

    greek? _(self)
    PREDICATE_RESULT=$?

    mbfl_struct_is_a _(self) _(greek)
    IS_A_RESULT=$?

    dotest-equal 0 $PREDICATE_RESULT 'result of applying the predicate' &&
	dotest-equal 0 $IS_A_RESULT 'result of applying the is_a function' &&
      	dotest-equal 1 $A 'value of field alpha' &&
      	dotest-equal 2 $B 'value of field beta'  &&
      	dotest-equal 3 $C 'value of field gamma'
}

# Test  for: mbfl_struct_declare,  mbfl_struct_define_type,  struct  constructor, struct  predicate,
# field accessors, field mutators.
#
function struct-simple-1.2 () {
    mbfl_struct_declare(greek)
    mbfl_struct_declare(self)
    declare A=0 B=0 C=0
    declare PREDICATE_RESULT
    declare IS_A_RESULT

    mbfl_struct_define_type _(greek) _(mbfl_struct_top_descriptor) 'greek' alpha beta gamma

    greek_init _(self) 1 2 3
    # mbfl_array_dump _(greek)
    # mbfl_array_dump _(self)

    greek_alpha_set _(self) 11
    greek_beta_set  _(self) 22
    greek_gamma_set _(self) 33

    greek_alpha_var A _(self)
    greek_beta_var  B _(self)
    greek_gamma_var C _(self)

    greek? _(self)
    PREDICATE_RESULT=$?

    mbfl_struct_is_a _(self) _(greek)
    IS_A_RESULT=$?

    dotest-equal 0 $PREDICATE_RESULT 'result of applying the predicate' &&
	dotest-equal 0 $IS_A_RESULT 'result of applying the is_a function' &&
	dotest-equal 11 $A &&
	dotest-equal 22 $B &&
	dotest-equal 33 $C
}

# Test for: mbfl_struct_define.
#
function struct-simple-1.3 () {
    mbfl_struct_declare(greek)
    mbfl_struct_declare(self)
    declare A=0 B=0 C=0
    declare PREDICATE_RESULT
    declare IS_A_RESULT

    mbfl_struct_define_type _(greek) _(mbfl_struct_top_descriptor) 'greek' alpha beta gamma
    mbfl_struct_define      _(self) _(greek) 1 2 3

    # echo greek datavar _(greek) >&2
    # mbfl_array_dump _(greek)
    # echo self datavar _(self) >&2
    # mbfl_array_dump _(self)

    greek? _(self)
    PREDICATE_RESULT=$?

    mbfl_struct_is_a _(self) _(greek)
    IS_A_RESULT=$?

    greek_alpha_var A _(self)
    greek_beta_var  B _(self)
    greek_gamma_var C _(self)

    dotest-equal 0 $PREDICATE_RESULT 'result of applying the predicate' &&
	dotest-equal 0 $IS_A_RESULT 'result of applying the is_a function' &&
      	dotest-equal 1 $A 'value of field alpha' &&
      	dotest-equal 2 $B 'value of field beta'  &&
      	dotest-equal 3 $C 'value of field gamma'
}

# Test for: mbfl_struct_declare_global, mbfl_struct_unset.
#
function struct-simple-1.4 () {
    mbfl_struct_declare(greek)
    mbfl_struct_declare_global(self)
    declare A=0 B=0 C=0 DATAVAR
    declare PREDICATE_RESULT
    declare IS_A_RESULT

    mbfl_struct_define_type _(greek) _(mbfl_struct_top_descriptor) 'greek' alpha beta gamma

    #dotest-set-debug

    mbfl_location_enter
    {
	greek_init _(self) 1 2 3
	mbfl_location_handler "mbfl_struct_unset(self)"
	mbfl_location_handler "dotest-debug $FUNCNAME: unset variable _(self)"

	# We store  the datavar  to check later  that it  does not exist  anymore after  exiting the
	# location.
	DATAVAR=_(self)

	greek_alpha_var A _(self)
	greek_beta_var  B _(self)
	greek_gamma_var C _(self)

	greek? _(self)
	PREDICATE_RESULT=$?

	mbfl_struct_is_a _(self) _(greek)
	IS_A_RESULT=$?

	dotest-equal 0 $PREDICATE_RESULT 'result of applying the predicate' &&
	    dotest-equal 0 $IS_A_RESULT 'result of applying the is_a function' &&
      	    dotest-equal 1 $A 'value of field alpha' &&
      	    dotest-equal 2 $B 'value of field beta'  &&
      	    dotest-equal 3 $C 'value of field gamma' &&
	    test -v _(self) &&
	    test -v $DATAVAR
    }
    mbfl_location_leave
    # After exiting the location: the instance variable should not exist anymore.
    {
	declare BLOCK_RV=$?
	declare NOT_EXIST

	! test -v $DATAVAR
	NOT_EXIST=$?

	dotest-equal 0 $NOT_EXIST 'the datavar of the data-structure instance does not exist anymore' &&
	    return $BLOCK_RV
    }
}


#### define new data structure types and inspect them

# function struct-type-1.1 () {
#     mbfl_struct_declare(color)
#     mbfl_struct_define_type _(color) colour red green blue
#     declare TYPE PARENT NAME

#     mbfl_struct_descriptor_type_ref	_(color) TYPE
#     mbfl_struct_descriptor_parent_ref	_(color) PARENT
#     mbfl_struct_descriptor_name_ref	_(color) NAME

#     #dotest-set-debug
#     dotest-debug mbfl_top_struct _(mbfl_top_struct)
#     dotest-debug TYPE $TYPE
#     dotest-debug PARENT $PARENT
#     dotest-debug NAME $NAME

#     #mbfl_array_dump _(color)

#     ! mbfl_top_struct? _(color) &&
# 	mbfl_struct_descriptor? _(color) &&
# 	mbfl_struct_is_a _(color) _(mbfl_top_struct) &&
# 	dotest-equal _(mbfl_top_struct) $TYPE &&
# 	dotest-equal _(mbfl_top_struct) $PARENT &&
# 	dotest-equal 'colour' $NAME
# }


#### testing errors regarding data-structure type-descriptors

function struct-error-descriptor-1.1 () {
    mbfl_struct_declare(self)
    declare RV

    mbfl_struct_define _(self) _(mbfl_struct_top_descriptor)
    RV=$?
    dotest-equal 1 $RV 'attempt to instantiate abstract data type'
}


#### testing errors regarding data-structure instances

function struct-error-instance-1.1 () {
    mbfl_struct_declare(color)
    mbfl_struct_declare(greek)
    mbfl_struct_declare(self)
    declare RED RV

    mbfl_struct_define_type _(greek) _(mbfl_struct_top_descriptor) 'greek' alpha beta gamma
    mbfl_struct_define_type _(color) _(mbfl_struct_top_descriptor) 'color' red green blue

    greek_init _(self) 1 2 3
    color_red_var RED _(self)
    RV=$?

    dotest-equal 1 $RV 'applied field accessor to instance of wrong type'
}

function struct-error-instance-1.2 () {
    mbfl_struct_declare(color)
    mbfl_struct_declare(greek)
    mbfl_struct_declare(self)
    declare RV

    mbfl_struct_define_type _(greek) _(mbfl_struct_top_descriptor) 'greek' alpha beta gamma
    mbfl_struct_define_type _(color) _(mbfl_struct_top_descriptor) 'color' red green blue

    greek_init _(self) 1 2 3
    color_red_set _(self) 11
    RV=$?

    dotest-equal 1 $RV 'applied field mutator to instance of wrong type'
}


#### let's go

dotest struct-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
