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

MBFL_DEFINE_UNDERSCORE_MACRO_FOR_METHODS


#### tests for the built-in data structure type "mbfl_default_object"

function object-default-object-1.1 () {
    ! mbfl_default_object_is_the_default_class _(mbfl_default_object) &&
	mbfl_default_object_is_the_default_object _(mbfl_default_object)
}
function object-default-object-1.2 () {
    declare TYPE
    mbfl_default_object_class_var TYPE _(mbfl_default_object)
    dotest-equal _(mbfl_default_class) $TYPE
}
function object-default-object-1.3 () {
    mbfl_default_object_is_a _(mbfl_default_object)
}
function object-default-object-1.4 () {
    mbfl_default_class_is_a _(mbfl_default_object)
}

### ------------------------------------------------------------------------
### inspecting the fields

function object-default-object-2.1 () {
    declare NAME
    mbfl_default_class_name_var NAME _(mbfl_default_object)
    dotest-equal 'mbfl_default_object' "$NAME"
}
function object-default-object-2.2 () {
    mbfl_declare_varref(PARENT)
    mbfl_default_class_parent_var _(PARENT) _(mbfl_default_object)
    dotest-equal '' "$PARENT" 'parent of mbfl_default_object'
}
function object-default-object-2.3 () {
    declare FIELDS_NUMBER
    mbfl_default_class_fields_number_var FIELDS_NUMBER _(mbfl_default_object)
    dotest-equal 0 "$FIELDS_NUMBER" 'number of fields in instances of mbfl_default_object'
}


#### tests for the built-in data structure type "mbfl_default_class"

function object-default-class-1.1 () {
    ! mbfl_default_object_is_the_default_object _(mbfl_default_class) &&
	mbfl_default_object_is_the_default_class _(mbfl_default_class)
}
function object-default-class-1.2 () {
    declare TYPE
    mbfl_default_object_class_var TYPE _(mbfl_default_class)
    dotest-equal _(mbfl_default_class) $TYPE
}
function object-default-class-1.3 () {
    mbfl_default_object_is_a _(mbfl_default_class)
}
function object-default-class-1.4 () {
    mbfl_default_class_is_a _(mbfl_default_class)
}
function object-default-class-1.5 () {
    mbfl_default_metaclass_is_a _(mbfl_default_class)
}
function object-default-class-1.6 () {
    mbfl_default_classes_are_parent_and_child _(mbfl_default_object) _(mbfl_default_class)
}

### ------------------------------------------------------------------------
### inspecting the fields

function object-default-class-2.1 () {
    declare NAME
    mbfl_default_class_name_var NAME _(mbfl_default_class)
    dotest-equal 'mbfl_default_class' "$NAME"
}
function object-default-class-2.2 () {
    declare PARENT
    mbfl_default_class_parent_var PARENT _(mbfl_default_class)
    dotest-equal _(mbfl_default_object) "$PARENT" 'parent of mbfl_default_class'
}
function object-default-class-2.3 () {
    declare FIELDS_NUMBER
    mbfl_default_class_fields_number_var FIELDS_NUMBER _(mbfl_default_class)
    dotest-equal 3 "$FIELDS_NUMBER" 'number of fields in instances of mbfl_default_class'
}


#### simple tests

# Test  for: mbfl_default_object_declare,  mbfl_default_class_define,  struct  constructor, struct  predicate,
# field accessors.
#
function object-simple-1.1 () {
    mbfl_default_class_declare(greek)
    mbfl_default_object_declare(self)
    declare A=0 B=0 C=0
    declare PREDICATE_RESULT
    declare IS_A_RESULT

    mbfl_default_class_define _(greek) _(mbfl_default_object) 'greek' alpha beta gamma

    greek_define _(self) 1 2 3
    # mbfl_array_dump _(greek)
    # mbfl_array_dump _(self)

    greek_alpha_var A _(self)
    greek_beta_var  B _(self)
    greek_gamma_var C _(self)

    # echo mbfl_struct_top datavar _(mbfl_class) >&2
    # echo mbfl_object datavar _(mbfl_default_object) >&2
    # echo greek datavar _(greek) >&2
    # echo self slot 0 ${self[0]} >&2

    greek_is_a _(self)
    PREDICATE_RESULT=$?

    mbfl_default_object_is_of_class _(self) _(greek)
    IS_A_RESULT=$?

    dotest-equal 0 $PREDICATE_RESULT 'result of applying the predicate' &&
	dotest-equal 0 $IS_A_RESULT 'result of applying the is_a function' &&
      	dotest-equal 1 $A 'value of field alpha' &&
      	dotest-equal 2 $B 'value of field beta'  &&
      	dotest-equal 3 $C 'value of field gamma'
}

# Test  for: mbfl_default_object_declare,  mbfl_default_class_define,  struct  constructor, struct  predicate,
# field accessors, field mutators.
#
function object-simple-1.2 () {
    mbfl_default_class_declare(greek)
    mbfl_default_object_declare(self)
    declare A=0 B=0 C=0
    declare PREDICATE_RESULT
    declare IS_A_RESULT

    mbfl_default_class_define _(greek) _(mbfl_default_object) 'greek' alpha beta gamma

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

    mbfl_default_object_is_of_class _(self) _(greek)
    IS_A_RESULT=$?

    dotest-equal 0 $PREDICATE_RESULT 'result of applying the predicate' &&
	dotest-equal 0 $IS_A_RESULT 'result of applying the is_a function' &&
	dotest-equal 11 $A &&
	dotest-equal 22 $B &&
	dotest-equal 33 $C
}

# Test for: mbfl_default_object_declare_global, mbfl_default_object_unset.
#
function object-simple-1.3 () {
    mbfl_default_class_declare(greek)
    mbfl_default_object_declare_global(self)
    declare A=0 B=0 C=0 DATAVAR
    declare PREDICATE_RESULT
    declare IS_A_RESULT

    mbfl_default_class_define _(greek) _(mbfl_default_object) 'greek' alpha beta gamma

    #dotest-set-debug

    mbfl_location_enter
    {
	greek_define _(self) 1 2 3
	mbfl_location_handler "mbfl_default_object_unset(self)"
	mbfl_location_handler "dotest-debug $FUNCNAME: unset variable _(self)"

	# We store  the datavar  to check later  that it  does not exist  anymore after  exiting the
	# location.
	DATAVAR=_(self)

	greek_alpha_var A _(self)
	greek_beta_var  B _(self)
	greek_gamma_var C _(self)

	greek_is_a _(self)
	PREDICATE_RESULT=$?

	mbfl_default_object_is_of_class _(self) _(greek)
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
    mbfl_default_class_declare(color_red)
    mbfl_default_class_declare(color_red_green)
    mbfl_default_object_declare(self)
    declare RED GREEN
    declare RED_PREDICATE_RESULT RED_GREEN_PREDICATE_RESULT

    mbfl_default_class_define _(color_red) _(mbfl_default_object) 'color_red' red
    # echo color_red datavar _(color_red) >&2
    # mbfl_array_dump _(color_red)

    mbfl_default_class_define _(color_red_green) _(color_red) 'color_red_green' green
    # echo color_red_green datavar _(color_red_green) >&2
    # mbfl_array_dump _(color_red_green)

    if false
    then
	mbfl_array_dump _(mbfl_default_class) mbfl_default_class
	mbfl_array_dump _(color_red) color_red
	mbfl_array_dump _(color_red_green) color_red_green
    fi

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
    mbfl_default_class_declare(color_red)
    mbfl_default_class_declare(color_red_green)
    mbfl_default_object_declare(self)
    declare RED GREEN
    declare RED_PREDICATE_RESULT RED_GREEN_PREDICATE_RESULT

    mbfl_default_class_define _(color_red) _(mbfl_default_object) 'color_red' red
    # echo color_red datavar _(color_red) >&2
    # mbfl_array_dump _(color_red)

    mbfl_default_class_define _(color_red_green) _(color_red) 'color_red_green' green
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
    mbfl_default_class_declare(color_red)
    mbfl_default_class_declare(color_red_green)
    mbfl_default_object_declare(self)
    declare RED GREEN
    declare RED_PREDICATE_RESULT RED_GREEN_PREDICATE_RESULT

    mbfl_default_class_define _(color_red) _(mbfl_default_object) 'color_red' red
    # echo color_red datavar _(color_red) >&2
    # mbfl_array_dump _(color_red)

    mbfl_default_class_define _(color_red_green) _(color_red) 'color_red_green' green
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

function object-single-inheritance-1.4 () {
    mbfl_default_class_declare(mammal)
    mbfl_default_class_declare(pig)
    mbfl_default_object_declare(peppa)
    declare MAMMAL_COLOR PIG_COLOR PIG_NICKNAME
    declare MAMMAL_PREDICATE_RESULT PIG_PREDICATE_RESULT

    mbfl_default_class_define _(mammal) _(mbfl_default_object) 'mammal' color
    mbfl_default_class_define _(pig)    _(mammal)              'pig'    nickname
    if false
    then
	mbfl_array_dump _(mbfl_default_class) mbfl_default_class
	mbfl_array_dump _(mammal) mammal
	mbfl_array_dump _(pig) pig
    fi

    if false
    then
	declare -f mammal_define
	declare -f pig_define
	declare -f mammal_is_a
	declare -f pig_is_a
	declare -f mammal_color_var
	declare -f mammal_color_set
	declare -f pig_color_var
	declare -f pig_color_set
	declare -f pig_nickname_var
	declare -f pig_nickname_set
    fi

    pig_define _(peppa) 'pink' 'peppa'
    if false
    then mbfl_array_dump _(peppa) peppa
    fi

    mammal_color_var MAMMAL_COLOR _(peppa)

    pig_color_var    PIG_COLOR    _(peppa)
    pig_nickname_var PIG_NICKNAME _(peppa)

    mammal_is_a _(peppa)
    COLOR_PREDICATE_RESULT=$?

    pig_is_a _(peppa)
    PIG_PREDICATE_RESULT=$?

    dotest-equal	0	$COLOR_PREDICATE_RESULT	'result of applying mammal_is_a'	&&
	dotest-equal	0	$PIG_PREDICATE_RESULT	'result of applying pig_is_a'		&&
	dotest-equal	'pink'	"$MAMMAL_COLOR"		'value of color field'			&&
	dotest-equal	'pink'	"$PIG_COLOR"		'value of color field'			&&
	dotest-equal	'peppa'	"$PIG_NICKNAME"		'value of nickname field'
}

### ------------------------------------------------------------------------

# Define a type-descriptor with parent having parent, use the accessors.
#
function object-single-inheritance-2.1 () {
    mbfl_default_class_declare(color_red)
    mbfl_default_class_declare(color_red_green)
    mbfl_default_class_declare(color_red_green_blue)
    mbfl_default_object_declare(self)
    declare RED GREEN BLUE
    declare RED_PREDICATE_RESULT RED_GREEN_PREDICATE_RESULT RED_GREEN_BLUE_PREDICATE_RESULT

    mbfl_default_class_define _(color_red) _(mbfl_default_object) 'color_red' red
    # echo color_red datavar _(color_red) >&2
    # mbfl_array_dump _(color_red)

    mbfl_default_class_define _(color_red_green) _(color_red) 'color_red_green' green
    # echo color_red_green datavar _(color_red_green) >&2
    # mbfl_array_dump _(color_red_green)

    mbfl_default_class_define _(color_red_green_blue) _(color_red_green) 'color_red_green_blue' blue

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
    mbfl_default_class_declare(color_red)
    mbfl_default_class_declare(color_red_green)
    mbfl_default_class_declare(color_red_green_blue)
    mbfl_default_object_declare(self)
    declare RED GREEN BLUE
    declare RED_PREDICATE_RESULT RED_GREEN_PREDICATE_RESULT RED_GREEN_BLUE_PREDICATE_RESULT

    mbfl_default_class_define _(color_red) _(mbfl_default_object) 'color_red' red
    # echo color_red datavar _(color_red) >&2
    # mbfl_array_dump _(color_red)

    mbfl_default_class_define _(color_red_green) _(color_red) 'color_red_green' green
    # echo color_red_green datavar _(color_red_green) >&2
    # mbfl_array_dump _(color_red_green)

    mbfl_default_class_define _(color_red_green_blue) _(color_red_green) 'color_red_green_blue' blue

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
    mbfl_default_class_declare(color_red)
    mbfl_default_class_declare(color_red_green)
    mbfl_default_class_declare(color_red_green_blue)
    mbfl_default_object_declare(self)
    declare RED GREEN BLUE
    declare RED_PREDICATE_RESULT RED_GREEN_PREDICATE_RESULT RED_GREEN_BLUE_PREDICATE_RESULT

    mbfl_default_class_define _(color_red) _(mbfl_default_object) 'color_red' red
    # echo color_red datavar _(color_red) >&2
    # mbfl_array_dump _(color_red)

    mbfl_default_class_define _(color_red_green) _(color_red) 'color_red_green' green
    # echo color_red_green datavar _(color_red_green) >&2
    # mbfl_array_dump _(color_red_green)

    mbfl_default_class_define _(color_red_green_blue) _(color_red_green) 'color_red_green_blue' blue

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
    mbfl_default_class_declare(greek)
    mbfl_default_class_define _(greek) _(mbfl_default_object) 'greek' alpha beta gamma
    mbfl_default_object_is_a _(greek)
}
function object-custom-classes-1.2 () {
    mbfl_default_class_declare(greek)
    mbfl_default_class_define _(greek) _(mbfl_default_object) 'greek' alpha beta gamma
    mbfl_default_class_is_a _(greek)
}
function object-custom-classes-1.2.1 () {
    mbfl_default_class_declare(greek)
    mbfl_default_class_define _(greek) _(mbfl_default_object) 'greek' alpha beta gamma
    ! mbfl_default_metaclass_is_a _(greek)
}
function object-custom-classes-1.3 () {
    mbfl_default_class_declare(greek)
    mbfl_default_class_define _(greek) _(mbfl_default_object) 'greek' alpha beta gamma
    ! mbfl_default_object_is_the_default_object _(greek)
}
function object-custom-classes-1.4 () {
    mbfl_default_class_declare(greek)
    mbfl_default_class_define _(greek) _(mbfl_default_object) 'greek' alpha beta gamma
    ! mbfl_default_object_is_the_default_class _(greek)
}
function object-custom-classes-1.5 () {
    mbfl_default_class_declare(greek)
    mbfl_default_class_define _(greek) _(mbfl_default_object) 'greek' alpha beta gamma
    ! mbfl_default_object_is_the_default_class _(greek)
}
function object-custom-classes-1.6 () {
    mbfl_default_class_declare(greek)
    mbfl_default_class_define _(greek) _(mbfl_default_object) 'greek' alpha beta gamma
    mbfl_default_classes_are_parent_and_child _(mbfl_default_object) _(greek)
}
function object-custom-classes-1.7 () {
    mbfl_default_class_declare(greek)
    mbfl_default_class_define _(greek) _(mbfl_default_object) 'greek' alpha beta gamma
    ! mbfl_default_classes_are_parent_and_child _(mbfl_default_class) _(greek)
}

### ------------------------------------------------------------------------

function object-custom-classes-2.1 () {
    mbfl_default_object_declare(one)
    mbfl_default_object_declare(two)
    mbfl_default_class_define _(one) _(mbfl_default_object) 'one' a
    mbfl_default_class_define _(two) _(one) 'two' b
    mbfl_default_object_is_a _(two) && mbfl_default_class_is_a _(two) && ! mbfl_default_metaclass_is_a _(two)
}
function object-custom-classes-2.2 () {
    mbfl_default_object_declare(one)
    mbfl_default_object_declare(two)
    mbfl_default_class_define _(one) _(mbfl_default_object) 'one' a
    mbfl_default_class_define _(two) _(one) 'two' b
    mbfl_default_classes_are_parent_and_child _(one) _(two)
}


#### deep inheritance

function object-deep-inheritance-1.1 () {
    mbfl_default_class_declare(deep1)
    mbfl_default_class_declare(deep2)
    mbfl_default_class_declare(deep3)
    mbfl_default_class_declare(deep4)
    mbfl_default_class_declare(deep5)
    mbfl_default_class_declare(deep6)
    mbfl_default_class_declare(deep7)

    mbfl_default_class_define _(deep1) _(mbfl_default_object) 'deep1' field1
    mbfl_default_class_define _(deep2) _(deep1) 'deep2' field2
    mbfl_default_class_define _(deep3) _(deep2) 'deep3' field3
    mbfl_default_class_define _(deep4) _(deep3) 'deep4' field4
    mbfl_default_class_define _(deep5) _(deep4) 'deep5' field5
    mbfl_default_class_define _(deep6) _(deep5) 'deep6' field6
    mbfl_default_class_define _(deep7) _(deep6) 'deep7' field7

    mbfl_default_object_declare(obj)

    deep7_define _(obj) 1 2 3 4 5 6 7

    declare V1 V2 V3 V4 V5 V6 V7

    deep7_field1_var V1 _(obj)
    deep7_field2_var V2 _(obj)
    deep7_field3_var V3 _(obj)
    deep7_field4_var V4 _(obj)
    deep7_field5_var V5 _(obj)
    deep7_field6_var V6 _(obj)
    deep7_field7_var V7 _(obj)

    dotest-equal	1 "$V1" 'field V1' &&
	dotest-equal	2 "$V2" 'field V2' &&
	dotest-equal	3 "$V3" 'field V3' &&
	dotest-equal	4 "$V4" 'field V4' &&
	dotest-equal	5 "$V5" 'field V5' &&
	dotest-equal	6 "$V6" 'field V6' &&
	dotest-equal	7 "$V7" 'field V7'
}


#### testing errors regarding data-structure type-descriptors

function object-error-class-1.1 () {
    mbfl_default_object_declare(one)
    mbfl_default_object_declare(two)
    declare RV

    mbfl_default_class_define _(one) _(mbfl_default_object) 'one' a B c
    mbfl_default_class_define _(two) _(one) 'two' d B e
    RV=$?

    dotest-equal 1 $RV 'duplicate field name'
}


#### testing errors regarding data-structure instances

function object-error-instance-1.1 () {
    mbfl_default_class_declare(color)
    mbfl_default_class_declare(greek)
    mbfl_default_object_declare(self)
    declare RED RV

    mbfl_default_class_define _(greek) _(mbfl_default_object) 'greek' alpha beta gamma
    mbfl_default_class_define _(color) _(mbfl_default_object) 'color' red green blue

    greek_define _(self) 1 2 3
    color_red_var RED _(self)
    RV=$?

    dotest-equal 1 $RV 'applied field accessor to instance of wrong type'
}

function object-error-instance-1.2 () {
    mbfl_default_class_declare(color)
    mbfl_default_class_declare(greek)
    mbfl_default_object_declare(self)
    declare RV

    mbfl_default_class_define _(greek) _(mbfl_default_object) 'greek' alpha beta gamma
    mbfl_default_class_define _(color) _(mbfl_default_object) 'color' red green blue

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


#### some examples

function object-example-complex-1.1 () {
    mbfl_default_class_declare(complex)
    mbfl_default_object_declare(Z)
    mbfl_declare_varref(REAL)
    mbfl_declare_varref(IMAG)
    mbfl_declare_varref(RHO)
    mbfl_declare_varref(THETA)

    mbfl_default_class_define _(complex) _(mbfl_default_object) 'complex' real imag
    complex_rectangular_constructor _(Z) 1.1 1.2

    complex_real_var  _(REAL)  _(Z)
    complex_imag_var  _(IMAG)  _(Z)
    complex_rho_var   _(RHO)   _(Z)
    complex_theta_var _(THETA) _(Z)

    printf -v _(RHO)   '%.4f' "$RHO"
    printf -v _(THETA) '%.4f' "$THETA"

    dotest-equal	1.1	"$REAL"  'the real part' &&
	dotest-equal	1.2	"$IMAG"  'the imag part' &&
	dotest-equal	1.6279	"$RHO"   'the rho part'  &&
	dotest-equal	0.8288  "$THETA" 'the theta part'
}

function object-example-complex-1.2 () {
    mbfl_default_class_declare(complex)
    mbfl_default_object_declare(Z)
    mbfl_default_object_declare(W)
    mbfl_declare_varref(REAL)
    mbfl_declare_varref(IMAG)

    mbfl_default_class_define _(complex) _(mbfl_default_object) 'complex' real imag
    complex_polar_constructor _(Z) 1.6279 0.8288
    complex_real_var _(REAL) _(Z)
    complex_imag_var _(IMAG) _(Z)

    printf -v _(REAL)   '%.2f' "$REAL"
    printf -v _(IMAG)   '%.2f' "$IMAG"

    dotest-equal	1.10	"$REAL" 'the real part' &&
	dotest-equal	1.20	"$IMAG" 'the imag part'
}

function complex_rectangular_constructor () {
    mbfl_mandatory_nameref_parameter(Z, 1, reference to default object)
    mbfl_mandatory_parameter(REAL,      2, the real part)
    mbfl_mandatory_parameter(IMAG,      3, the imag part)

    complex_define _(Z) "$REAL" "$IMAG"
}
function complex_polar_constructor () {
    mbfl_mandatory_nameref_parameter(Z, 1, reference to default object)
    mbfl_mandatory_parameter(RHO,       2, the radius)
    mbfl_mandatory_parameter(THETA,     3, the angle)
    mbfl_declare_varref(REAL)
    mbfl_declare_varref(IMAG)

    mbfl_math_expr_var _(REAL) "$RHO * cos($THETA)"
    mbfl_math_expr_var _(IMAG) "$RHO * sin($THETA)"
    complex_define _(Z) "$REAL" "$IMAG"
}
function complex_rho_var () {
    mbfl_mandatory_nameref_parameter(RHO, 1, rho result variable)
    mbfl_mandatory_nameref_parameter(Z,   2, reference to default object)
    mbfl_declare_varref(REAL)
    mbfl_declare_varref(IMAG)

    complex_real_var _(REAL) _(Z)
    complex_imag_var _(IMAG) _(Z)
    mbfl_math_expr_var RHO "sqrt ($REAL ^ 2 + $IMAG ^ 2)"
}
function complex_theta_var () {
    mbfl_mandatory_nameref_parameter(THETA, 1, theta result variable)
    mbfl_mandatory_nameref_parameter(Z,     2, reference to default object)
    mbfl_declare_varref(REAL)
    mbfl_declare_varref(IMAG)

    complex_real_var _(REAL) _(Z)
    complex_imag_var _(IMAG) _(Z)
    mbfl_math_expr_var THETA "atan2 ($IMAG, $REAL)"
}


#### usage of initialisation function
#
# At the  time of  this writing  this feature  is undocumented.   It is  not a  great idea.   I will
# probably remove it.  (Marco Maggi; Apr 10, 2023)
#

function object_initialiser_1_1_init () {
    mbfl_mandatory_nameref_parameter(self, 1, reference to object of class object_initialiser_1_1_class)

    object_initialiser_1_1_alpha_set _(self) 11
    object_initialiser_1_1_beta_set  _(self) 22
    object_initialiser_1_1_gamma_set _(self) 33
}
function object-initialiser-1.1 () {
    mbfl_default_class_declare(object_initialiser_1_1_class)
    mbfl_default_object_declare(object_initialiser_1_1_object)
    declare ALPHA BETA GAMMA

    mbfl_default_class_define _(object_initialiser_1_1_class) _(mbfl_default_object) 'object_initialiser_1_1' alpha beta gamma
    object_initialiser_1_1_define _(object_initialiser_1_1_object) a b c

    object_initialiser_1_1_alpha_var ALPHA _(object_initialiser_1_1_object)
    object_initialiser_1_1_beta_var  BETA  _(object_initialiser_1_1_object)
    object_initialiser_1_1_gamma_var GAMMA _(object_initialiser_1_1_object)

    dotest-equal	11	"$ALPHA"	'value of alpha field'	&&
	dotest-equal	22	"$BETA"		'value of beta field'	&&
	dotest-equal	33	"$GAMMA"	'value of gamma field'
}


#### method functions
#
# At the time of this writing this feature is undocumented.  (Marco Maggi; Apr 10, 2023)
#

function object-methods-1.1 () {
    mbfl_default_class_declare(object_method_class_1_1)
    mbfl_default_object_declare(object_method_object_1_1)
    mbfl_declare_varref(ALPHA)
    mbfl_declare_varref(BETA)

    mbfl_default_class_define _(object_method_class_1_1) _(mbfl_default_object) 'object_method_class_1_1' alpha beta
    object_method_class_1_1_define _(object_method_object_1_1) 123 456

    _(object_method_object_1_1, alpha) _(ALPHA)
    _(object_method_object_1_1, beta)  _(BETA)

    dotest-equal 123 "$ALPHA" &&
	dotest-equal 456 "$BETA"
}

function object_method_class_1_1_method_alpha () {
    mbfl_mandatory_nameref_parameter(SELF, 1, reference to object of class object_method_class_1_1)
    mbfl_mandatory_nameref_parameter(RV,   2, reference to result variable)

    object_method_class_1_1_alpha_var _(RV) _(SELF)
}
function object_method_class_1_1_method_beta () {
    mbfl_mandatory_nameref_parameter(SELF, 1, reference to object of class object_method_class_1_1)
    mbfl_mandatory_nameref_parameter(RV,   2, reference to result variable)

    object_method_class_1_1_beta_var _(RV) _(SELF)
}


#### let's go

dotest object-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
