# exceptional-conditions.test.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for exceptional-condition objects
# Date: May  2, 2023
#
# Abstract
#
#	This file must be executed with:
#
#		$ make all test TESTMATCH=conditions-
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

declare -r script_PROGNAME='exceptional-conditions.test'

mbfl_embed_library(__LIBMBFL_LINKER__)
mbfl_linker_source_library_by_stem(core)
mbfl_linker_source_library_by_stem(tests)


#### macros

MBFL_DEFINE_UNDERSCORE_MACRO_FOR_SLOTS


#### helpers

mbfl_default_class_declare(colour)

mbfl_default_class_define _(colour) _(mbfl_default_object) 'colour' red green blue

mbfl_function_rename 'colour_red_set'   'colour_p_red_set'
mbfl_function_rename 'colour_green_set' 'colour_p_green_set'
mbfl_function_rename 'colour_blue_set'  'colour_p_blue_set'

function colour_make () {
    mbfl_mandatory_nameref_parameter(OBJ,	1, colour object)
    mbfl_mandatory_parameter(RED,		2, red)
    mbfl_mandatory_parameter(GREEN,		3, green)
    mbfl_mandatory_parameter(BLUE,		3, blue)

    if ! mbfl_string_is_digit "$RED"
    then
	mbfl_default_object_declare(CND)

	mbfl_invalid_ctor_parm_value_condition_make _(CND) $FUNCNAME _(colour) 'RED' "$RED"
	mbfl_exception_raise_then_return_failure(_(CND))
    fi

    if ! mbfl_string_is_digit "$GREEN"
    then
	mbfl_default_object_declare(CND)

	dotest-debug  _(CND) invalid green $FUNCNAME _(colour) 'green' "$GREEN"
	mbfl_invalid_ctor_parm_value_condition_make _(CND) $FUNCNAME _(colour) 'GREEN' "$GREEN"
	mbfl_exception_raise_then_return_failure(_(CND))
    fi

    if ! mbfl_string_is_digit "$BLUE"
    then
	mbfl_default_object_declare(CND)

	mbfl_invalid_ctor_parm_value_condition_make _(CND) $FUNCNAME _(colour) 'BLUE' "$BLUE"
	mbfl_exception_raise_then_return_failure(_(CND))
    fi

    colour_define _(OBJ) "$RED" "$GREEN" "$BLUE"
}
function colour_red_set () {
    mbfl_mandatory_nameref_parameter(OBJ,	1, colour object)
    mbfl_mandatory_parameter(RED,		2, red)

    if mbfl_string_is_digit "$RED"
    then colour_p_red_set _(OBJ) "$RED"
    else
	mbfl_default_object_declare(CND)

	mbfl_invalid_object_attrib_value_condition_make _(CND) $FUNCNAME _(OBJ) 'red' "$RED"
	mbfl_exception_raise_then_return_failure(_(CND))
    fi
}
function colour_green_set () {
    mbfl_mandatory_nameref_parameter(OBJ,	1, colour object)
    mbfl_mandatory_parameter(GREEN,		2, green)

    if mbfl_string_is_digit "$GREEN"
    then colour_p_green_set _(OBJ) "$GREEN"
    else
	mbfl_default_object_declare(CND)

	mbfl_invalid_object_attrib_value_condition_make _(CND) $FUNCNAME _(OBJ) 'green' "$GREEN"
	mbfl_exception_raise_then_return_failure(_(CND))
    fi
}
function colour_blue_set () {
    mbfl_mandatory_nameref_parameter(OBJ,	1, colour object)
    mbfl_mandatory_parameter(BLUE,		2, blue)

    if mbfl_string_is_digit "$BLUE"
    then colour_p_blue_set _(OBJ) "$BLUE"
    else
	mbfl_default_object_declare(CND)

	mbfl_invalid_object_attrib_value_condition_make _(CND) $FUNCNAME _(OBJ) 'blue' "$BLUE"
	mbfl_exception_raise_then_return_failure(_(CND))
    fi
}


#### base class tests

mbfl_default_class_declare_global(my_something_happened_t)

mbfl_default_class_define _(my_something_happened_t) _(mbfl_exceptional_condition_t) 'my_something_happened'

function my_something_happened_make () {
    mbfl_mandatory_nameref_parameter(CND,	1, condition object)
    mbfl_mandatory_parameter(WHO,		2, entity reporting the exceptional-condition)
    mbfl_mandatory_parameter(MESSAGE,		3, exceptional-condition description message)
    mbfl_mandatory_parameter(CONTINUABLE,	4, condition continuable state)

    my_something_happened_define _(CND) "$WHO" "$MESSAGE" "$CONTINUABLE"
}

function conditions-base-define-1.1 () {
    mbfl_default_object_declare(CND)

    my_something_happened_make _(CND) $FUNCNAME 'this is an error message' 'false'
    mbfl_exceptional_condition_is_a _(CND)
}
function conditions-base-accessors-1.1 () {
    mbfl_default_object_declare(CND)
    mbfl_declare_varref(WHO)
    mbfl_declare_varref(MESSAGE)
    mbfl_declare_varref(CONTINUABLE)

    my_something_happened_make _(CND) $FUNCNAME 'this is an error message' 'false'
    mbfl_exceptional_condition_who_var		_(WHO)		_(CND)
    mbfl_exceptional_condition_message_var	_(MESSAGE)	_(CND)
    mbfl_exceptional_condition_continuable_var	_(CONTINUABLE)	_(CND)

    dotest-equal	$FUNCNAME			"$WHO"		&&
	dotest-equal	'this is an error message'	"$MESSAGE"	&&
	dotest-equal	'false'				"$CONTINUABLE"
}
function conditions-base-mutators-1.1 () {
    mbfl_default_object_declare(CND)
    mbfl_declare_varref(WHO)
    mbfl_declare_varref(MESSAGE)
    mbfl_declare_varref(CONTINUABLE)

    my_something_happened_make _(CND) $FUNCNAME 'this is an error message' 'false'

    mbfl_exceptional_condition_who_set		_(CND) 'another_who'
    mbfl_exceptional_condition_message_set	_(CND) 'this is another error message'
    mbfl_exceptional_condition_continuable_set	_(CND) 'true'

    mbfl_exceptional_condition_who_var		_(WHO)		_(CND)
    mbfl_exceptional_condition_message_var	_(MESSAGE)	_(CND)
    mbfl_exceptional_condition_continuable_var	_(CONTINUABLE)	_(CND)

    dotest-equal	'another_who'			"$WHO"		&&
	dotest-equal	'this is another error message'	"$MESSAGE"	&&
	dotest-equal	'true'				"$CONTINUABLE"
}
function conditions-base-method-print-1.1 () {
    mbfl_default_object_declare(CND)

    my_something_happened_make _(CND) $FUNCNAME 'this is an exception message' 'false'
    mbfl_exceptional_condition_print _(CND) |& dotest-output "$FUNCNAME: this is an exception message"
}


#### warning class tests

function conditions-warning-maker-1.1 () {
    mbfl_default_object_declare(CND)

    mbfl_warning_condition_make _(CND) $FUNCNAME 'this is an warning message'
    mbfl_warning_condition_is_a _(CND)
}
function conditions-warning-accessors-1.1 () {
    mbfl_default_object_declare(CND)
    mbfl_declare_varref(WHO)
    mbfl_declare_varref(MESSAGE)
    mbfl_declare_varref(CONTINUABLE)

    mbfl_warning_condition_make _(CND) $FUNCNAME 'this is an error message'
    mbfl_warning_condition_who_var		_(WHO)		_(CND)
    mbfl_warning_condition_message_var		_(MESSAGE)	_(CND)
    mbfl_warning_condition_continuable_var	_(CONTINUABLE)	_(CND)

    dotest-equal	$FUNCNAME			"$WHO"		&&
	dotest-equal	'this is an error message'	"$MESSAGE"	&&
	dotest-equal	'true'				"$CONTINUABLE"
}
function conditions-warning-mutators-1.1 () {
    mbfl_default_object_declare(CND)
    mbfl_declare_varref(WHO)
    mbfl_declare_varref(MESSAGE)
    mbfl_declare_varref(CONTINUABLE)

    mbfl_warning_condition_make _(CND) $FUNCNAME 'this is an error message'

    mbfl_warning_condition_who_set		_(CND) 'another_who'
    mbfl_warning_condition_message_set		_(CND) 'this is another error message'
    mbfl_warning_condition_continuable_set	_(CND) 'false'

    mbfl_warning_condition_who_var		_(WHO)		_(CND)
    mbfl_warning_condition_message_var		_(MESSAGE)	_(CND)
    mbfl_warning_condition_continuable_var	_(CONTINUABLE)	_(CND)

    dotest-equal	'another_who'			"$WHO"		&&
	dotest-equal	'this is another error message'	"$MESSAGE"	&&
	dotest-equal	'false'				"$CONTINUABLE"
}
function conditions-warning-method-print-1.1 () {
    mbfl_default_object_declare(CND)

    mbfl_warning_condition_make _(CND) $FUNCNAME 'this is an warning message'
    mbfl_exceptional_condition_print _(CND) |& dotest-output "exceptional-conditions.test: warning: $FUNCNAME: this is an warning message"
}


#### error class tests

mbfl_default_class_declare_global(my_some_error_happened_condition_t)

mbfl_default_class_define _(my_some_error_happened_condition_t) _(mbfl_error_condition_t) 'my_some_error_happened_condition'

function my_some_error_happened_condition_make () {
    mbfl_mandatory_nameref_parameter(CND,	1, condition object)
    mbfl_mandatory_parameter(WHO,		2, entity reporting the exceptional-condition)
    mbfl_mandatory_parameter(MESSAGE,		3, exceptional-condition description message)
    mbfl_mandatory_parameter(CONTINUABLE,	4, exceptional-condition continuable state)

    my_some_error_happened_condition_define _(CND) "$WHO" "$MESSAGE" "$CONTINUABLE"
}

function conditions-error-maker-1.1 () {
    mbfl_default_object_declare(CND)

    my_some_error_happened_condition_make _(CND) $FUNCNAME 'this is an error message' 'false'
    mbfl_error_condition_is_a _(CND)
}
function conditions-error-accessors-1.1 () {
    mbfl_default_object_declare(CND)
    mbfl_declare_varref(WHO)
    mbfl_declare_varref(MESSAGE)
    mbfl_declare_varref(CONTINUABLE)

    my_some_error_happened_condition_make _(CND) $FUNCNAME 'this is an error message' 'false'
    mbfl_error_condition_who_var		_(WHO)		_(CND)
    mbfl_error_condition_message_var		_(MESSAGE)	_(CND)
    mbfl_error_condition_continuable_var	_(CONTINUABLE)	_(CND)

    dotest-equal	$FUNCNAME			"$WHO"		&&
	dotest-equal	'this is an error message'	"$MESSAGE"	&&
	dotest-equal	'false'				"$CONTINUABLE"
}
function conditions-error-mutators-1.1 () {
    mbfl_default_object_declare(CND)
    mbfl_declare_varref(WHO)
    mbfl_declare_varref(MESSAGE)
    mbfl_declare_varref(CONTINUABLE)

    my_some_error_happened_condition_make _(CND) $FUNCNAME 'this is an error message' 'false'

    mbfl_error_condition_who_set		_(CND) 'another_who'
    mbfl_error_condition_message_set		_(CND) 'this is another error message'
    mbfl_error_condition_continuable_set	_(CND) 'true'

    mbfl_error_condition_who_var		_(WHO)		_(CND)
    mbfl_error_condition_message_var		_(MESSAGE)	_(CND)
    mbfl_error_condition_continuable_var	_(CONTINUABLE)	_(CND)

    dotest-equal	'another_who'			"$WHO"		&&
	dotest-equal	'this is another error message'	"$MESSAGE"	&&
	dotest-equal	'true'				"$CONTINUABLE"
}
function conditions-error-method-pring-1.1 () {
    mbfl_default_object_declare(CND)

    my_some_error_happened_condition_make _(CND) $FUNCNAME 'this is an error message' 'false'
    mbfl_exceptional_condition_print _(CND) |& dotest-output "exceptional-conditions.test: error: $FUNCNAME: this is an error message"
}


#### runtime-error class tests

function conditions-runtime-error-maker-1.1 () {
    mbfl_default_object_declare(CND)

    mbfl_runtime_error_condition_make _(CND) $FUNCNAME 'this is an error message'
    mbfl_runtime_error_condition_is_a _(CND)
}
function conditions-runtime-error-accessors-1.1 () {
    mbfl_default_object_declare(CND)
    mbfl_declare_varref(WHO)
    mbfl_declare_varref(MESSAGE)
    mbfl_declare_varref(CONTINUABLE)

    mbfl_runtime_error_condition_make _(CND) $FUNCNAME 'this is an error message'
    mbfl_error_condition_who_var		_(WHO)		_(CND)
    mbfl_error_condition_message_var		_(MESSAGE)	_(CND)
    mbfl_error_condition_continuable_var	_(CONTINUABLE)	_(CND)

    dotest-equal	$FUNCNAME			"$WHO"		&&
	dotest-equal	'this is an error message'	"$MESSAGE"	&&
	dotest-equal	'true'				"$CONTINUABLE"
}
function conditions-runtime-error-mutators-1.1 () {
    mbfl_default_object_declare(CND)
    mbfl_declare_varref(WHO)
    mbfl_declare_varref(MESSAGE)
    mbfl_declare_varref(CONTINUABLE)

    mbfl_runtime_error_condition_make _(CND) $FUNCNAME 'this is an error message'

    mbfl_error_condition_who_set		_(CND) 'another_who'
    mbfl_error_condition_message_set		_(CND) 'this is another error message'
    mbfl_error_condition_continuable_set	_(CND) 'false'

    mbfl_error_condition_who_var		_(WHO)		_(CND)
    mbfl_error_condition_message_var		_(MESSAGE)	_(CND)
    mbfl_error_condition_continuable_var	_(CONTINUABLE)	_(CND)

    dotest-equal	'another_who'			"$WHO"		&&
	dotest-equal	'this is another error message'	"$MESSAGE"	&&
	dotest-equal	'false'				"$CONTINUABLE"
}
function conditions-runtime-error-method-print-1.1 () {
    mbfl_default_object_declare(CND)

    mbfl_runtime_error_condition_make _(CND) $FUNCNAME 'this is an error message'
    mbfl_exceptional_condition_print _(CND) |& dotest-output "exceptional-conditions.test: error: $FUNCNAME: this is an error message"
}


#### logic-error class tests

function conditions-logic-error-maker-1.1 () {
    mbfl_default_object_declare(CND)

    mbfl_logic_error_condition_make _(CND) $FUNCNAME 'this is an error message'
    mbfl_logic_error_condition_is_a _(CND)
}
function conditions-logic-error-accessors-1.1 () {
    mbfl_default_object_declare(CND)
    mbfl_declare_varref(WHO)
    mbfl_declare_varref(MESSAGE)
    mbfl_declare_varref(CONTINUABLE)

    mbfl_logic_error_condition_make _(CND) $FUNCNAME 'this is an error message'
    mbfl_error_condition_who_var		_(WHO)		_(CND)
    mbfl_error_condition_message_var		_(MESSAGE)	_(CND)
    mbfl_error_condition_continuable_var	_(CONTINUABLE)	_(CND)

    dotest-equal	$FUNCNAME			"$WHO"		&&
	dotest-equal	'this is an error message'	"$MESSAGE"	&&
	dotest-equal	'false'				"$CONTINUABLE"
}
function conditions-logic-error-mutators-1.1 () {
    mbfl_default_object_declare(CND)
    mbfl_declare_varref(WHO)
    mbfl_declare_varref(MESSAGE)
    mbfl_declare_varref(CONTINUABLE)

    mbfl_logic_error_condition_make _(CND) $FUNCNAME 'this is an error message'

    mbfl_error_condition_who_set		_(CND) 'another_who'
    mbfl_error_condition_message_set		_(CND) 'this is another error message'
    mbfl_error_condition_continuable_set	_(CND) 'true'

    mbfl_error_condition_who_var		_(WHO)		_(CND)
    mbfl_error_condition_message_var		_(MESSAGE)	_(CND)
    mbfl_error_condition_continuable_var	_(CONTINUABLE)	_(CND)

    dotest-equal	'another_who'			"$WHO"		&&
	dotest-equal	'this is another error message'	"$MESSAGE"	&&
	dotest-equal	'true'				"$CONTINUABLE"
}
function conditions-logic-error-method-print-1.1 () {
    mbfl_default_object_declare(CND)

    mbfl_logic_error_condition_make _(CND) $FUNCNAME 'this is an error message'
    mbfl_exceptional_condition_print _(CND) |& dotest-output "exceptional-conditions.test: error: $FUNCNAME: this is an error message"
}


#### invalid constructo's parameter value

function conditions-invalid-ctor-parm-value-maker-1.1 () {
    mbfl_default_object_declare(CND)
    mbfl_default_object_declare(gray)

    colour_define _(gray) 9 9 9

    mbfl_invalid_object_attrib_value_condition_make _(CND) $FUNCNAME _(gray) 'red' 'ciao'
    mbfl_invalid_object_attrib_value_condition_is_a _(CND)
}
function conditions-invalid-ctor-parm-value-maker-2.1 () {
    mbfl_default_object_declare(gray)

    colour_make _(gray) 9 9 9
}

function conditions-invalid-ctor-parm-value-maker-2.2 () {
    mbfl_default_object_declare(gray)
    mbfl_declare_varref(WHO)
    mbfl_declare_varref(MESSAGE)
    mbfl_declare_varref(CONTINUABLE)
    mbfl_declare_varref(CLASS)
    mbfl_declare_varref(PARM_NAME)
    mbfl_declare_varref(INVALID_VALUE)

    #dotest-set-debug

    mbfl_location_enter
    {
	mbfl_exception_handler exception_handler_conditions_invalid_ctor_parm_value_maker_2_2

	colour_make _(gray) 9 'ciao' 9
    }
    mbfl_location_leave

    dotest-equal	'colour_make'	"$WHO"			&&
	dotest-equal	'invalid value for parameter "GREEN" of class "colour" constructor: "ciao"' "$MESSAGE" &&
	dotest-equal	'false'		"$CONTINUABLE"		&&
	dotest-equal	_(colour)	"$CLASS"		&&
	dotest-equal	'GREEN'		"$PARM_NAME"		&&
	dotest-equal	'ciao'		"$INVALID_VALUE"
}
function exception_handler_conditions_invalid_ctor_parm_value_maker_2_2 () {
    mbfl_mandatory_nameref_parameter(CND, 1, exceptional-condition object)

    if mbfl_invalid_ctor_parm_value_condition_is_a _(CND)
    then
	#dotest-debug here

	mbfl_invalid_ctor_parm_value_condition_who_var			_(WHO)			_(CND)
	mbfl_invalid_ctor_parm_value_condition_message_var		_(MESSAGE)	      	_(CND)
	mbfl_invalid_ctor_parm_value_condition_continuable_var		_(CONTINUABLE)	      	_(CND)
	mbfl_invalid_ctor_parm_value_condition_class_var		_(CLASS)		_(CND)
	mbfl_invalid_ctor_parm_value_condition_parm_name_var		_(PARM_NAME)		_(CND)
	mbfl_invalid_ctor_parm_value_condition_invalid_value_var	_(INVALID_VALUE)	_(CND)

	mbfl_invalid_ctor_parm_value_condition_continuable_set _(CND) 'true'
	return_success_after_handling_exception
    else return_after_not_handling_exception
    fi
}


#### invalid value to object's attribute

function conditions-invalid-attrib-value-maker-1.1 () {
    mbfl_default_object_declare(CND)
    mbfl_default_object_declare(gray)

    colour_define _(gray) 9 9 9

    mbfl_invalid_object_attrib_value_condition_make _(CND) $FUNCNAME _(gray) 'red' 'ciao'
    mbfl_invalid_object_attrib_value_condition_is_a _(CND)
}
function conditions-invalid-attrib-value-accessors-1.1 () {
    mbfl_default_object_declare(CND)
    mbfl_default_object_declare(gray)

    colour_define _(gray) 9 9 9

    mbfl_invalid_object_attrib_value_condition_make _(CND) $FUNCNAME _(gray) 'red' 'ciao'

    mbfl_declare_varref(WHO)
    mbfl_declare_varref(MESSAGE)
    mbfl_declare_varref(CONTINUABLE)
    mbfl_declare_varref(OBJECT)
    mbfl_declare_varref(ATTRIB_NAME)
    mbfl_declare_varref(INVALID_VALUE)

    mbfl_invalid_object_attrib_value_condition_who_var			_(WHO)		      _(CND)
    mbfl_invalid_object_attrib_value_condition_message_var		_(MESSAGE)	      _(CND)
    mbfl_invalid_object_attrib_value_condition_continuable_var		_(CONTINUABLE)	      _(CND)
    mbfl_invalid_object_attrib_value_condition_object_var		_(OBJECT)	      _(CND)
    mbfl_invalid_object_attrib_value_condition_attrib_name_var		_(ATTRIB_NAME)	      _(CND)
    mbfl_invalid_object_attrib_value_condition_invalid_value_var	_(INVALID_VALUE)      _(CND)

    dotest-equal	$FUNCNAME	"$WHO"			&&
	dotest-equal	'invalid value for attribute "red" of class "colour" object: "ciao"' "$MESSAGE" &&
	dotest-equal	'false'		"$CONTINUABLE"		&&
	dotest-equal	_(gray)		"$OBJECT"		&&
	dotest-equal	'red'		"$ATTRIB_NAME"		&&
	dotest-equal	'ciao'		"$INVALID_VALUE"
}
function conditions-invalid-attrib-value-method-print-1.1 () {
    mbfl_default_object_declare(CND)
    mbfl_default_object_declare(gray)

    colour_define _(gray) 9 9 9

    mbfl_invalid_object_attrib_value_condition_make _(CND) $FUNCNAME _(gray) 'red' 'ciao'
    mbfl_exceptional_condition_print _(CND) |& \
	dotest-output "exceptional-conditions.test: error: $FUNCNAME: invalid value for attribute \"red\" of class \"colour\" object: \"ciao\""
}


#### uncaught exceptional conditions

function conditions-uncaught-1.1 () {
    mbfl_default_object_declare(CND)

    mbfl_logic_error_condition_make _(CND) $FUNCNAME 'an error'
    (mbfl_exception_raise _(CND))
    dotest-equal _(mbfl_EXIT_CODES_BY_NAME, uncaught_exception) $?
}


#### outside location exceptional-condition

function conditions-outside-location-1.1 () {
    (mbfl_location_handler 'ciao')
    dotest-equal _(mbfl_EXIT_CODES_BY_NAME, uncaught_exception) $?
}


#### invalid parameter to function

function conditions-invalid-function-parameter-1.1 () {
    mbfl_default_object_declare(CND)
    mbfl_declare_varref(WHO)
    mbfl_declare_varref(MESSAGE)
    mbfl_declare_varref(CONTINUABLE)
    mbfl_declare_varref(ERROR_DESCRIPTION)
    mbfl_declare_varref(PARAMETER_NUMBER)
    mbfl_declare_varref(PARAMETER_NAME)
    mbfl_declare_varref(PARAMETER_VALUE)
    declare -r EXPECTED_MESSAGE='in call to "conditions-invalid-function-parameter-1.1" invalid value for parameter 1 "MOOD": "happy", expected good value'

    mbfl_invalid_function_parameter_condition_make _(CND) $FUNCNAME 'expected good value' 1 'MOOD' 'happy'

    mbfl_invalid_function_parameter_condition_who_var			_(WHO)		      _(CND)
    mbfl_invalid_function_parameter_condition_message_var		_(MESSAGE)	      _(CND)
    mbfl_invalid_function_parameter_condition_continuable_var		_(CONTINUABLE)	      _(CND)
    mbfl_invalid_function_parameter_condition_error_description_var	_(ERROR_DESCRIPTION)  _(CND)
    mbfl_invalid_function_parameter_condition_parameter_number_var	_(PARAMETER_NUMBER)   _(CND)
    mbfl_invalid_function_parameter_condition_parameter_name_var	_(PARAMETER_NAME)     _(CND)
    mbfl_invalid_function_parameter_condition_parameter_value_var	_(PARAMETER_VALUE)    _(CND)

    mbfl_invalid_function_parameter_condition_is_a _(CND) &&
	dotest-equal	$FUNCNAME		"$WHO"			'attribute who' &&
	dotest-equal	"$EXPECTED_MESSAGE"	"$MESSAGE"		'attribute message' &&
	dotest-equal	'false'			"$CONTINUABLE"		'attribute continuable' &&
	dotest-equal	"expected good value"	"$ERROR_DESCRIPTION"	'attribute error description' &&
	dotest-equal	'1'			"$PARAMETER_NUMBER"	'attribute parameter number' &&
	dotest-equal	'MOOD'			"$PARAMETER_NAME"	'attribute parameter name' &&
	dotest-equal	'happy'			"$PARAMETER_VALUE"	'attribute parameter value'
}

function conditions-invalid-function-parameter-2.1 () {
    mbfl_default_object_declare(CND)

    #                                                     who       error_description     parm_number parm_name parm_value
    mbfl_invalid_function_parameter_condition_make _(CND) $FUNCNAME 'expected good value' 1           'MOOD'    'happy'
    (mbfl_exception_raise _(CND))
    dotest-equal _(mbfl_EXIT_CODES_BY_NAME, uncaught_exception) $?
}


#### wrong parameters number

function func-wrong-parameters-number-one () {
    mbfl_check_mandatory_parameters_number(3)
    mbfl_mandatory_parameter(ALPHA, 1, the alpha)
    mbfl_mandatory_parameter(BETA,  2, the beta)
    mbfl_mandatory_parameter(GAMMA, 3, the gamma)
    mbfl_optional_parameter(DELTA, 4)
    return_success
}
function conditions-wrong-parameters-number-1.1 () {
    (func-wrong-parameters-number-one a)
    dotest-equal _(mbfl_EXIT_CODES_BY_NAME, uncaught_exception) $?
}
function conditions-wrong-parameters-number-1.2 () {
    (func-wrong-parameters-number-one a b)
    dotest-equal _(mbfl_EXIT_CODES_BY_NAME, uncaught_exception) $?
}
function conditions-wrong-parameters-number-1.3 () {
    func-wrong-parameters-number-one a b c
}
function conditions-wrong-parameters-number-1.4 () {
    func-wrong-parameters-number-one a b c d
}
function conditions-wrong-parameters-number-1.5 () {
    func-wrong-parameters-number-one a b c d e
}

### ------------------------------------------------------------------------

function func-wrong-parameters-number-two () {
    mbfl_check_mandatory_parameters_number(3,5)
    mbfl_mandatory_parameter(ALPHA, 1, the alpha)
    mbfl_mandatory_parameter(BETA,  2, the beta)
    mbfl_mandatory_parameter(GAMMA, 3, the gamma)
    mbfl_optional_parameter(DELTA, 4)
    mbfl_optional_parameter(IOTA, 5)
    return_success
}
function conditions-wrong-parameters-number-2.1 () {
    (func-wrong-parameters-number-two a)
    dotest-equal _(mbfl_EXIT_CODES_BY_NAME, uncaught_exception) $?
}
function conditions-wrong-parameters-number-2.2 () {
    (func-wrong-parameters-number-two a b)
    dotest-equal _(mbfl_EXIT_CODES_BY_NAME, uncaught_exception) $?
}
function conditions-wrong-parameters-number-2.3 () {
    func-wrong-parameters-number-two a b c
}
function conditions-wrong-parameters-number-2.4 () {
    func-wrong-parameters-number-two a b c d
}
function conditions-wrong-parameters-number-2.5 () {
    func-wrong-parameters-number-two a b c d e
}
function conditions-wrong-parameters-number-2.6 () {
    (func-wrong-parameters-number-two a b c d e f)
    dotest-equal _(mbfl_EXIT_CODES_BY_NAME, uncaught_exception) $?
}

### ------------------------------------------------------------------------

function func-wrong-parameters-number-three () {
    mbfl_check_mandatory_parameters_number(3,3)
    mbfl_mandatory_parameter(ALPHA, 1, the alpha)
    mbfl_mandatory_parameter(BETA,  2, the beta)
    mbfl_mandatory_parameter(GAMMA, 3, the gamma)
    return_success
}
function conditions-wrong-parameters-number-3.1 () {
    (func-wrong-parameters-number-three a)
    dotest-equal _(mbfl_EXIT_CODES_BY_NAME, uncaught_exception) $?
}
function conditions-wrong-parameters-number-3.2 () {
    (func-wrong-parameters-number-three a b)
    dotest-equal _(mbfl_EXIT_CODES_BY_NAME, uncaught_exception) $?
}
function conditions-wrong-parameters-number-3.3 () {
    func-wrong-parameters-number-three a b c
}
function conditions-wrong-parameters-number-3.4 () {
    (func-wrong-parameters-number-three a b c d)
    dotest-equal _(mbfl_EXIT_CODES_BY_NAME, uncaught_exception) $?
}
function conditions-wrong-parameters-number-3.5 () {
    (func-wrong-parameters-number-three a b c d e)
    dotest-equal _(mbfl_EXIT_CODES_BY_NAME, uncaught_exception) $?
}


#### let's go

dotest conditions-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
