# object.test.m4 --
#
# Part of: Marco's BASH function libraries
# Contents: tests for the object module
# Date: Mar 12, 2023
#
# Abstract
#
#	This file must be executed with:
#
#		$ make all test TESTMATCH=object-
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

# With one parameter is expands into a use  of "mbfl_datavar()"; with two parameters it expands into
# a use of "mbfl_slot_qref".
#
m4_define([[[_]]],[[[m4_ifelse($#,1,[[[mbfl_datavar([[[$1]]])]]],[[[mbfl_slot_qref([[[$1]]],[[[$2]]])]]])]]])


#### tests for the built-in data structure type "mbfl_standard_object"

function object-standard-object-1.1 () {
    ! mbfl_standard_object_is_the_standard_class _(mbfl_standard_object) &&
	mbfl_standard_object_is_the_standard_object _(mbfl_standard_object)
}
function object-standard-object-1.2 () {
    declare TYPE
    mbfl_standard_object_class_var TYPE _(mbfl_standard_object)
    dotest-equal _(mbfl_standard_class) $TYPE
}
function object-standard-object-1.3 () {
    mbfl_standard_object_is_a _(mbfl_standard_object)
}
function object-standard-object-1.4 () {
    mbfl_standard_class_is_a _(mbfl_standard_object)
}

### ------------------------------------------------------------------------
### inspecting the fields

function object-standard-object-2.1 () {
    declare NAME
    mbfl_standard_class_name_var NAME _(mbfl_standard_object)
    dotest-equal 'mbfl_standard_object' "$NAME"
}
function object-standard-object-2.2 () {
    mbfl_declare_varref(PARENT)
    mbfl_standard_class_parent_var _(PARENT) _(mbfl_standard_object)
    dotest-equal '' "$PARENT" 'parent of mbfl_standard_object'
}
function object-standard-object-2.3 () {
    declare FIELDS_NUMBER
    mbfl_standard_class_fields_number_var FIELDS_NUMBER _(mbfl_standard_object)
    dotest-equal 0 "$FIELDS_NUMBER" 'number of fields in instances of mbfl_standard_object'
}


#### tests for the built-in data structure type "mbfl_standard_class"

function object-standard-class-1.1 () {
    ! mbfl_standard_object_is_the_standard_object _(mbfl_standard_class) &&
	mbfl_standard_object_is_the_standard_class _(mbfl_standard_class)
}
function object-standard-class-1.2 () {
    declare TYPE
    mbfl_standard_object_class_var TYPE _(mbfl_standard_class)
    dotest-equal _(mbfl_standard_class) $TYPE
}
function object-standard-class-1.3 () {
    mbfl_standard_object_is_a _(mbfl_standard_class)
}
function object-standard-class-1.4 () {
    mbfl_standard_class_is_a _(mbfl_standard_class)
}
function object-standard-class-1.5 () {
    mbfl_standard_metaclass_is_a _(mbfl_standard_class)
}
function object-standard-class-1.6 () {
    mbfl_standard_classes_are_parent_and_child _(mbfl_standard_object) _(mbfl_standard_class)
}

### ------------------------------------------------------------------------
### inspecting the fields

function object-standard-class-2.1 () {
    declare NAME
    mbfl_standard_class_name_var NAME _(mbfl_standard_class)
    dotest-equal 'mbfl_standard_class' "$NAME"
}
function object-standard-class-2.2 () {
    declare PARENT
    mbfl_standard_class_parent_var PARENT _(mbfl_standard_class)
    dotest-equal _(mbfl_standard_object) "$PARENT" 'parent of mbfl_standard_class'
}
function object-standard-class-2.3 () {
    declare FIELDS_NUMBER
    mbfl_standard_class_fields_number_var FIELDS_NUMBER _(mbfl_standard_class)
    dotest-equal 3 "$FIELDS_NUMBER" 'number of fields in instances of mbfl_standard_class'
}


#### simple tests

# Test  for: mbfl_standard_object_declare,  mbfl_standard_class_define,  struct  constructor, struct  predicate,
# field accessors.
#
function object-simple-1.1 () {
    mbfl_standard_class_declare(greek)
    mbfl_standard_object_declare(self)
    declare A=0 B=0 C=0
    declare PREDICATE_RESULT
    declare IS_A_RESULT

    mbfl_standard_class_define _(greek) _(mbfl_standard_object) 'greek' alpha beta gamma

    greek_define _(self) 1 2 3
    # mbfl_array_dump _(greek)
    # mbfl_array_dump _(self)

    greek_alpha_var A _(self)
    greek_beta_var  B _(self)
    greek_gamma_var C _(self)

    # echo mbfl_struct_top datavar _(mbfl_class) >&2
    # echo mbfl_object datavar _(mbfl_standard_object) >&2
    # echo greek datavar _(greek) >&2
    # echo self slot 0 ${self[0]} >&2

    greek_is_a _(self)
    PREDICATE_RESULT=$?

    mbfl_standard_object_is_of_class _(self) _(greek)
    IS_A_RESULT=$?

    dotest-equal 0 $PREDICATE_RESULT 'result of applying the predicate' &&
	dotest-equal 0 $IS_A_RESULT 'result of applying the is_a function' &&
      	dotest-equal 1 $A 'value of field alpha' &&
      	dotest-equal 2 $B 'value of field beta'  &&
      	dotest-equal 3 $C 'value of field gamma'
}

# Test  for: mbfl_standard_object_declare,  mbfl_standard_class_define,  struct  constructor, struct  predicate,
# field accessors, field mutators.
#
function object-simple-1.2 () {
    mbfl_standard_class_declare(greek)
    mbfl_standard_object_declare(self)
    declare A=0 B=0 C=0
    declare PREDICATE_RESULT
    declare IS_A_RESULT

    mbfl_standard_class_define _(greek) _(mbfl_standard_object) 'greek' alpha beta gamma

    greek_define _(self) 1 2 3
    # mbfl_array_dump _(greek)
    # mbfl_array_dump _(self)

    greek_alpha_set _(self) 11
    greek_beta_set  _(self) 22
    greek_gamma_set _(self) 33

    greek_alpha_var A _(self)
    greek_beta_var  B _(self)
    greek_gamma_var C _(self)

    greek_is_a _(self)
    PREDICATE_RESULT=$?

    mbfl_standard_object_is_of_class _(self) _(greek)
    IS_A_RESULT=$?

    dotest-equal 0 $PREDICATE_RESULT 'result of applying the predicate' &&
	dotest-equal 0 $IS_A_RESULT 'result of applying the is_a function' &&
	dotest-equal 11 $A &&
	dotest-equal 22 $B &&
	dotest-equal 33 $C
}

# Test for: mbfl_standard_object_declare_global, mbfl_standard_object_unset.
#
function object-simple-1.3 () {
    mbfl_standard_class_declare(greek)
    mbfl_standard_object_declare_global(self)
    declare A=0 B=0 C=0 DATAVAR
    declare PREDICATE_RESULT
    declare IS_A_RESULT

    mbfl_standard_class_define _(greek) _(mbfl_standard_object) 'greek' alpha beta gamma

    #dotest-set-debug

    mbfl_location_enter
    {
	greek_define _(self) 1 2 3
	mbfl_location_handler "mbfl_standard_object_unset(self)"
	mbfl_location_handler "dotest-debug $FUNCNAME: unset variable _(self)"

	# We store  the datavar  to check later  that it  does not exist  anymore after  exiting the
	# location.
	DATAVAR=_(self)

	greek_alpha_var A _(self)
	greek_beta_var  B _(self)
	greek_gamma_var C _(self)

	greek_is_a _(self)
	PREDICATE_RESULT=$?

	mbfl_standard_object_is_of_class _(self) _(greek)
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


#### single inheritance

# Define a type-descriptor with parent, use the accessors.
#
function object-single-inheritance-1.1 () {
    mbfl_standard_class_declare(color_red)
    mbfl_standard_class_declare(color_red_green)
    mbfl_standard_object_declare(self)
    declare RED GREEN
    declare RED_PREDICATE_RESULT RED_GREEN_PREDICATE_RESULT

    mbfl_standard_class_define _(color_red) _(mbfl_standard_object) 'color_red' red
    # echo color_red datavar _(color_red) >&2
    # mbfl_array_dump _(color_red)

    mbfl_standard_class_define _(color_red_green) _(color_red) 'color_red_green' green
    # echo color_red_green datavar _(color_red_green) >&2
    # mbfl_array_dump _(color_red_green)

    color_red_green_define _(self) 1 2
    # echo self datavar _(self) >&2
    # mbfl_array_dump _(self)

    color_red_green_red_var   RED   _(self)
    color_red_green_green_var GREEN _(self)

    color_red_is_a _(self)
    RED_PREDICATE_RESULT=$?

    color_red_green_is_a _(self)
    RED_GREEN_PREDICATE_RESULT=$?

    dotest-equal 0 $RED_PREDICATE_RESULT 'result of applying color_red_is_a' &&
	dotest-equal 0 $RED_GREEN_PREDICATE_RESULT 'result of applying color_red_green_is_a' &&
	dotest-equal 1 $RED 'value of red field' &&
	dotest-equal 2 $GREEN 'value of green field'
}

# Define a type-descriptor with parent, use the accessors and the mutators.
#
function object-single-inheritance-1.2 () {
    mbfl_standard_class_declare(color_red)
    mbfl_standard_class_declare(color_red_green)
    mbfl_standard_object_declare(self)
    declare RED GREEN
    declare RED_PREDICATE_RESULT RED_GREEN_PREDICATE_RESULT

    mbfl_standard_class_define _(color_red) _(mbfl_standard_object) 'color_red' red
    # echo color_red datavar _(color_red) >&2
    # mbfl_array_dump _(color_red)

    mbfl_standard_class_define _(color_red_green) _(color_red) 'color_red_green' green
    # echo color_red_green datavar _(color_red_green) >&2
    # mbfl_array_dump _(color_red_green)

    color_red_green_define _(self) 1 2
    # echo self datavar _(self) >&2
    # mbfl_array_dump _(self)

    color_red_green_red_set   _(self) 11
    color_red_green_green_set _(self) 22

    color_red_green_red_var   RED   _(self)
    color_red_green_green_var GREEN _(self)

    color_red_is_a _(self)
    RED_PREDICATE_RESULT=$?

    color_red_green_is_a _(self)
    RED_GREEN_PREDICATE_RESULT=$?

    dotest-equal 0 $RED_PREDICATE_RESULT 'result of applying color_red_is_a' &&
	dotest-equal 0 $RED_GREEN_PREDICATE_RESULT 'result of applying color_red_green_is_a' &&
	dotest-equal 11 $RED 'value of red field' &&
	dotest-equal 22 $GREEN 'value of green field'
}

# Define a type-descriptor with parent, use the parent accessors and the mutators.
#
function object-single-inheritance-1.3 () {
    mbfl_standard_class_declare(color_red)
    mbfl_standard_class_declare(color_red_green)
    mbfl_standard_object_declare(self)
    declare RED GREEN
    declare RED_PREDICATE_RESULT RED_GREEN_PREDICATE_RESULT

    mbfl_standard_class_define _(color_red) _(mbfl_standard_object) 'color_red' red
    # echo color_red datavar _(color_red) >&2
    # mbfl_array_dump _(color_red)

    mbfl_standard_class_define _(color_red_green) _(color_red) 'color_red_green' green
    # echo color_red_green datavar _(color_red_green) >&2
    # mbfl_array_dump _(color_red_green)

    color_red_green_define _(self) 1 2
    # echo self datavar _(self) >&2
    # mbfl_array_dump _(self)

    color_red_red_set         _(self) 11
    color_red_green_green_set _(self) 22

    color_red_red_var         RED   _(self)
    color_red_green_green_var GREEN _(self)

    color_red_is_a _(self)
    RED_PREDICATE_RESULT=$?

    color_red_green_is_a _(self)
    RED_GREEN_PREDICATE_RESULT=$?

    dotest-equal 0 $RED_PREDICATE_RESULT 'result of applying color_red_is_a' &&
	dotest-equal 0 $RED_GREEN_PREDICATE_RESULT 'result of applying color_red_green_is_a' &&
	dotest-equal 11 $RED 'value of red field' &&
	dotest-equal 22 $GREEN 'value of green field'
}

### ------------------------------------------------------------------------

# Define a type-descriptor with parent having parent, use the accessors.
#
function object-single-inheritance-2.1 () {
    mbfl_standard_class_declare(color_red)
    mbfl_standard_class_declare(color_red_green)
    mbfl_standard_class_declare(color_red_green_blue)
    mbfl_standard_object_declare(self)
    declare RED GREEN BLUE
    declare RED_PREDICATE_RESULT RED_GREEN_PREDICATE_RESULT RED_GREEN_BLUE_PREDICATE_RESULT

    mbfl_standard_class_define _(color_red) _(mbfl_standard_object) 'color_red' red
    # echo color_red datavar _(color_red) >&2
    # mbfl_array_dump _(color_red)

    mbfl_standard_class_define _(color_red_green) _(color_red) 'color_red_green' green
    # echo color_red_green datavar _(color_red_green) >&2
    # mbfl_array_dump _(color_red_green)

    mbfl_standard_class_define _(color_red_green_blue) _(color_red_green) 'color_red_green_blue' blue

    color_red_green_blue_define _(self) 1 2 3
    # echo self datavar _(self) >&2
    # mbfl_array_dump _(self)

    color_red_green_blue_red_var   RED   _(self)
    color_red_green_blue_green_var GREEN _(self)
    color_red_green_blue_blue_var  BLUE  _(self)

    color_red_is_a _(self)
    RED_PREDICATE_RESULT=$?

    color_red_green_is_a _(self)
    RED_GREEN_PREDICATE_RESULT=$?

    color_red_green_blue_is_a _(self)
    RED_GREEN_BLUE_PREDICATE_RESULT=$?

    dotest-equal 0 $RED_PREDICATE_RESULT 'result of applying color_red_is_a' &&
	dotest-equal 0 $RED_GREEN_PREDICATE_RESULT 'result of applying color_red_green_is_a' &&
	dotest-equal 0 $RED_GREEN_BLUE_PREDICATE_RESULT 'result of applying color_red_green_blue_is_a' &&
	dotest-equal 1 $RED   'value of red field' &&
	dotest-equal 2 $GREEN 'value of green field' &&
	dotest-equal 3 $BLUE  'value of blue field'
}

# Define a type-descriptor with parent having parent, use the accessors and the mutator.
#
function object-single-inheritance-2.2 () {
    mbfl_standard_class_declare(color_red)
    mbfl_standard_class_declare(color_red_green)
    mbfl_standard_class_declare(color_red_green_blue)
    mbfl_standard_object_declare(self)
    declare RED GREEN BLUE
    declare RED_PREDICATE_RESULT RED_GREEN_PREDICATE_RESULT RED_GREEN_BLUE_PREDICATE_RESULT

    mbfl_standard_class_define _(color_red) _(mbfl_standard_object) 'color_red' red
    # echo color_red datavar _(color_red) >&2
    # mbfl_array_dump _(color_red)

    mbfl_standard_class_define _(color_red_green) _(color_red) 'color_red_green' green
    # echo color_red_green datavar _(color_red_green) >&2
    # mbfl_array_dump _(color_red_green)

    mbfl_standard_class_define _(color_red_green_blue) _(color_red_green) 'color_red_green_blue' blue

    color_red_green_blue_define _(self) 1 2 3
    # echo self datavar _(self) >&2
    # mbfl_array_dump _(self)

    color_red_green_blue_red_set   _(self) 11
    color_red_green_blue_green_set _(self) 22
    color_red_green_blue_blue_set  _(self) 33

    color_red_green_blue_red_var   RED   _(self)
    color_red_green_blue_green_var GREEN _(self)
    color_red_green_blue_blue_var  BLUE  _(self)

    color_red_is_a _(self)
    RED_PREDICATE_RESULT=$?

    color_red_green_is_a _(self)
    RED_GREEN_PREDICATE_RESULT=$?

    color_red_green_blue_is_a _(self)
    RED_GREEN_BLUE_PREDICATE_RESULT=$?

    dotest-equal 0 $RED_PREDICATE_RESULT 'result of applying color_red_is_a' &&
	dotest-equal 0 $RED_GREEN_PREDICATE_RESULT 'result of applying color_red_green_is_a' &&
	dotest-equal 0 $RED_GREEN_BLUE_PREDICATE_RESULT 'result of applying color_red_green_blue_is_a' &&
	dotest-equal 11 $RED   'value of red field' &&
	dotest-equal 22 $GREEN 'value of green field' &&
	dotest-equal 33 $BLUE  'value of blue field'
}

# Define a type-descriptor with parent having parent, use the parent accessors and mutator.
#
function object-single-inheritance-2.3 () {
    mbfl_standard_class_declare(color_red)
    mbfl_standard_class_declare(color_red_green)
    mbfl_standard_class_declare(color_red_green_blue)
    mbfl_standard_object_declare(self)
    declare RED GREEN BLUE
    declare RED_PREDICATE_RESULT RED_GREEN_PREDICATE_RESULT RED_GREEN_BLUE_PREDICATE_RESULT

    mbfl_standard_class_define _(color_red) _(mbfl_standard_object) 'color_red' red
    # echo color_red datavar _(color_red) >&2
    # mbfl_array_dump _(color_red)

    mbfl_standard_class_define _(color_red_green) _(color_red) 'color_red_green' green
    # echo color_red_green datavar _(color_red_green) >&2
    # mbfl_array_dump _(color_red_green)

    mbfl_standard_class_define _(color_red_green_blue) _(color_red_green) 'color_red_green_blue' blue

    color_red_green_blue_define _(self) 1 2 3
    # echo self datavar _(self) >&2
    # mbfl_array_dump _(self)

    color_red_red_set			_(self) 11
    color_red_green_green_set		_(self) 22
    color_red_green_blue_blue_set	_(self) 33

    color_red_red_var			RED   _(self)
    color_red_green_green_var		GREEN _(self)
    color_red_green_blue_blue_var	BLUE  _(self)

    color_red_is_a _(self)
    RED_PREDICATE_RESULT=$?

    color_red_green_is_a _(self)
    RED_GREEN_PREDICATE_RESULT=$?

    color_red_green_blue_is_a _(self)
    RED_GREEN_BLUE_PREDICATE_RESULT=$?

    dotest-equal 0 $RED_PREDICATE_RESULT 'result of applying color_red_is_a' &&
	dotest-equal 0 $RED_GREEN_PREDICATE_RESULT 'result of applying color_red_green_is_a' &&
	dotest-equal 0 $RED_GREEN_BLUE_PREDICATE_RESULT 'result of applying color_red_green_blue_is_a' &&
	dotest-equal 11 $RED   'value of red field' &&
	dotest-equal 22 $GREEN 'value of green field' &&
	dotest-equal 33 $BLUE  'value of blue field'
}


#### inspection of custom type-descriptors

function object-custom-classes-1.1 () {
    mbfl_standard_class_declare(greek)
    mbfl_standard_class_define _(greek) _(mbfl_standard_object) 'greek' alpha beta gamma
    mbfl_standard_object_is_a _(greek)
}
function object-custom-classes-1.2 () {
    mbfl_standard_class_declare(greek)
    mbfl_standard_class_define _(greek) _(mbfl_standard_object) 'greek' alpha beta gamma
    mbfl_standard_class_is_a _(greek)
}
function object-custom-classes-1.2.1 () {
    mbfl_standard_class_declare(greek)
    mbfl_standard_class_define _(greek) _(mbfl_standard_object) 'greek' alpha beta gamma
    ! mbfl_standard_metaclass_is_a _(greek)
}
function object-custom-classes-1.3 () {
    mbfl_standard_class_declare(greek)
    mbfl_standard_class_define _(greek) _(mbfl_standard_object) 'greek' alpha beta gamma
    ! mbfl_standard_object_is_the_standard_object _(greek)
}
function object-custom-classes-1.4 () {
    mbfl_standard_class_declare(greek)
    mbfl_standard_class_define _(greek) _(mbfl_standard_object) 'greek' alpha beta gamma
    ! mbfl_standard_object_is_the_standard_class _(greek)
}
function object-custom-classes-1.5 () {
    mbfl_standard_class_declare(greek)
    mbfl_standard_class_define _(greek) _(mbfl_standard_object) 'greek' alpha beta gamma
    ! mbfl_standard_object_is_the_standard_class _(greek)
}
function object-custom-classes-1.6 () {
    mbfl_standard_class_declare(greek)
    mbfl_standard_class_define _(greek) _(mbfl_standard_object) 'greek' alpha beta gamma
    mbfl_standard_classes_are_parent_and_child _(mbfl_standard_object) _(greek)
}
function object-custom-classes-1.7 () {
    mbfl_standard_class_declare(greek)
    mbfl_standard_class_define _(greek) _(mbfl_standard_object) 'greek' alpha beta gamma
    ! mbfl_standard_classes_are_parent_and_child _(mbfl_standard_class) _(greek)
}

### ------------------------------------------------------------------------

function object-custom-classes-2.1 () {
    mbfl_standard_object_declare(one)
    mbfl_standard_object_declare(two)
    mbfl_standard_class_define _(one) _(mbfl_standard_object) 'one' a
    mbfl_standard_class_define _(two) _(one) 'two' b
    mbfl_standard_object_is_a _(two) && mbfl_standard_class_is_a _(two) && ! mbfl_standard_metaclass_is_a _(two)
}
function object-custom-classes-2.2 () {
    mbfl_standard_object_declare(one)
    mbfl_standard_object_declare(two)
    mbfl_standard_class_define _(one) _(mbfl_standard_object) 'one' a
    mbfl_standard_class_define _(two) _(one) 'two' b
    mbfl_standard_classes_are_parent_and_child _(one) _(two)
}


#### testing errors regarding data-structure type-descriptors

function object-error-class-1.1 () {
    mbfl_standard_object_declare(one)
    mbfl_standard_object_declare(two)
    declare RV

    mbfl_standard_class_define _(one) _(mbfl_standard_object) 'one' a B c
    mbfl_standard_class_define _(two) _(one) 'two' d B e
    RV=$?

    dotest-equal 1 $RV 'duplicate field name'
}


#### testing errors regarding data-structure instances

function object-error-instance-1.1 () {
    mbfl_standard_class_declare(color)
    mbfl_standard_class_declare(greek)
    mbfl_standard_object_declare(self)
    declare RED RV

    mbfl_standard_class_define _(greek) _(mbfl_standard_object) 'greek' alpha beta gamma
    mbfl_standard_class_define _(color) _(mbfl_standard_object) 'color' red green blue

    greek_define _(self) 1 2 3
    color_red_var RED _(self)
    RV=$?

    dotest-equal 1 $RV 'applied field accessor to instance of wrong type'
}

function object-error-instance-1.2 () {
    mbfl_standard_class_declare(color)
    mbfl_standard_class_declare(greek)
    mbfl_standard_object_declare(self)
    declare RV

    mbfl_standard_class_define _(greek) _(mbfl_standard_object) 'greek' alpha beta gamma
    mbfl_standard_class_define _(color) _(mbfl_standard_object) 'color' red green blue

    greek_define _(self) 1 2 3
    color_red_set _(self) 11
    RV=$?

    dotest-equal 1 $RV 'applied field mutator to instance of wrong type'
}


#### predefined constants

function object-predefined-constants-1.1 () {
    mbfl_is_the_unspecified _(mbfl_unspecified)
}
function object-predefined-constants-1.2 () {
    ! mbfl_is_the_unspecified _(mbfl_undefined)
}
function object-predefined-constants-1.3 () {
    mbfl_predefined_constant_is_a _(mbfl_unspecified)
}

### ------------------------------------------------------------------------

function object-predefined-constants-2.1 () {
    mbfl_is_the_undefined _(mbfl_undefined)
}
function object-predefined-constants-2.2 () {
    ! mbfl_is_the_undefined _(mbfl_unspecified)
}
function object-predefined-constants-1.3 () {
    mbfl_predefined_constant_is_a _(mbfl_undefined)
}


#### let's go

dotest object-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
