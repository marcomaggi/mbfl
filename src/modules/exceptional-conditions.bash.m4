# exceptional-conditions.bash.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: exceptional-condition objects module
# Date: May  2, 2023
#
# Abstract
#
#       This module defines default objects describing exceptional-conditions.
#
#       A lot of ideas were recycled from  the "Revised^6 Report on the Algorithmic Language Scheme"
#       (R6RS): <https://www.r6rs.org/>.
#
# Copyright (c) 2023 Marco Maggi
# <mrc.mgg@gmail.com>
#
# This is free software; you can redistribute it and/or  modify it under the terms of the GNU Lesser
# General Public  License as published by  the Free Software  Foundation; either version 3.0  of the
# License, or (at your option) any later version.
#
# This library is distributed in the hope that  it will be useful, but WITHOUT ANY WARRANTY; without
# even the  implied warranty of MERCHANTABILITY  or FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the  GNU Lesser General Public License along with this library;
# if not,  write to  the Free  Software Foundation,  Inc., 59  Temple Place,  Suite 330,  Boston, MA
# 02111-1307 USA.
#


#### macros

MBFL_DEFINE_UNDERSCORE_MACRO_FOR_SLOTS


#### global variables

# Here we want  to make global both  the data variable "_(mbfl_exceptional_condition_t)" and  the proxy variable
# "mbfl_exceptional_condition_t".  So we keep these declarations outside the module initialisation function.
#
mbfl_default_class_declare(mbfl_exceptional_condition_t)
mbfl_default_class_declare(mbfl_error_condition_t)
mbfl_default_class_declare(mbfl_warning_condition_t)
mbfl_default_class_declare(mbfl_logic_error_condition_t)
mbfl_default_class_declare(mbfl_runtime_error_condition_t)
mbfl_default_class_declare(mbfl_uncaught_exceptional_condition_t)
mbfl_default_class_declare(mbfl_wrong_parameters_number_condition_t)
mbfl_default_class_declare(mbfl_invalid_function_parameter_condition_t)
mbfl_default_class_declare(mbfl_invalid_object_attrib_value_condition_t)
mbfl_default_class_declare(mbfl_invalid_ctor_parm_value_condition_t)
mbfl_default_class_declare(mbfl_outside_location_condition_t)

function mbfl_initialise_module_exceptional_conditions () {
    mbfl_default_class_define _(mbfl_exceptional_condition_t) _(mbfl_default_object) 'mbfl_exceptional_condition' \
			      'who' 'message' 'continuable'

    mbfl_default_class_define _(mbfl_warning_condition_t)       _(mbfl_exceptional_condition_t)  'mbfl_warning_condition'
    mbfl_default_class_define _(mbfl_error_condition_t)         _(mbfl_exceptional_condition_t)  'mbfl_error_condition'
    mbfl_default_class_define _(mbfl_logic_error_condition_t)   _(mbfl_error_condition_t)        'mbfl_logic_error_condition'
    mbfl_default_class_define _(mbfl_runtime_error_condition_t) _(mbfl_error_condition_t)        'mbfl_runtime_error_condition'

    mbfl_default_class_define _(mbfl_uncaught_exceptional_condition_t) _(mbfl_logic_error_condition_t) \
			      'mbfl_uncaught_exceptional_condition' \
			      'object'

    mbfl_default_class_define _(mbfl_wrong_parameters_number_condition_t) _(mbfl_logic_error_condition_t) \
			      'mbfl_wrong_parameters_number_condition' \
			      'expected_min_number' 'expected_max_number' 'given_number'

    mbfl_default_class_define _(mbfl_invalid_function_parameter_condition_t) _(mbfl_logic_error_condition_t) \
			      'mbfl_invalid_function_parameter_condition' \
			      'error_description' \
			      'parameter_number' 'parameter_name' 'parameter_value'

    mbfl_default_class_define _(mbfl_invalid_ctor_parm_value_condition_t) _(mbfl_logic_error_condition_t) \
			      'mbfl_invalid_ctor_parm_value_condition' \
			      'class' 'parm_name' 'invalid_value'

    mbfl_default_class_define _(mbfl_invalid_object_attrib_value_condition_t) _(mbfl_logic_error_condition_t) \
			      'mbfl_invalid_object_attrib_value_condition' \
			      'object' 'attrib_name' 'invalid_value'

    mbfl_default_class_define _(mbfl_outside_location_condition_t) _(mbfl_logic_error_condition_t) 'mbfl_outside_location_condition'

    # Unset the constructors of abstract classes.
    mbfl_function_unset 'mbfl_exceptional_condition_define'
    mbfl_function_unset 'mbfl_error_condition_define'

    # Redefine "mbfl_exceptional_condition_continuable_set()" to introduce type-checking.
    #
    mbfl_function_rename 'mbfl_exceptional_condition_continuable_set' 'mbfl_p_exceptional_condition_continuable_set'
    function mbfl_exceptional_condition_continuable_set () {
	mbfl_check_mandatory_parameters_number(2,2)
	mbfl_mandatory_nameref_parameter(mbfl_OBJ,	1, reference to condition object)
	mbfl_mandatory_parameter(mbfl_VAL,		2, possible boolean value)
	mbfl_declare_varref(mbfl_NORMAL)

	if mbfl_string_normalise_boolean_var _(mbfl_NORMAL) "$mbfl_VAL"
	then mbfl_p_exceptional_condition_continuable_set _(mbfl_OBJ) "$mbfl_NORMAL"
	else
	    mbfl_default_object_declare(mbfl_CND)

	    mbfl_invalid_object_attrib_value_condition_make _(mbfl_CND) $FUNC _(mbfl_OBJ) 'continuable' "$mbfl_VAL"
	    mbfl_exception_raise_then_return_failure(_(mbfl_CND))
	fi
    }
}


#### predefined core condition object classes

function mbfl_warning_condition_make () {
    mbfl_check_mandatory_parameters_number(3,3)
    mbfl_mandatory_nameref_parameter(mbfl_CND,	1, exceptional-condition object)
    mbfl_mandatory_parameter(mbfl_WHO,		2, entity reporting the exceptional-condition)
    mbfl_mandatory_parameter(mbfl_MESSAGE,	3, exceptional-condition description message)

    mbfl_warning_condition_define _(mbfl_CND) "$mbfl_WHO" "$mbfl_MESSAGE" 'true'
}
function mbfl_runtime_error_condition_make () {
    mbfl_check_mandatory_parameters_number(3,3)
    mbfl_mandatory_nameref_parameter(mbfl_CND,	1, exceptional-condition object)
    mbfl_mandatory_parameter(mbfl_WHO,		2, entity reporting the exceptional-condition)
    mbfl_mandatory_parameter(mbfl_MESSAGE,	3, exceptional-condition description message)

    mbfl_runtime_error_condition_define _(mbfl_CND) "$mbfl_WHO" "$mbfl_MESSAGE" 'true'
}
function mbfl_logic_error_condition_make () {
    mbfl_check_mandatory_parameters_number(3,3)
    mbfl_mandatory_nameref_parameter(mbfl_CND,	1, exceptional-condition object)
    mbfl_mandatory_parameter(mbfl_WHO,		2, entity reporting the exceptional-condition)
    mbfl_mandatory_parameter(mbfl_MESSAGE,	3, exceptional-condition description message)

    mbfl_logic_error_condition_define _(mbfl_CND) "$mbfl_WHO" "$mbfl_MESSAGE" 'false'
}
function mbfl_uncaught_exceptional_condition_make () {
    mbfl_check_mandatory_parameters_number(3,3)
    mbfl_mandatory_nameref_parameter(mbfl_CND,	1, exceptional-condition object)
    mbfl_mandatory_parameter(mbfl_WHO,		2, entity reporting the exceptional-condition)
    mbfl_mandatory_nameref_parameter(mbfl_OBJ,	3, uncaught exceptional-condition object)

    #echo $FUNCNAME  _(mbfl_CND) "$mbfl_WHO" 'uncaught exception' 'false' _(mbfl_OBJ) >&2
    mbfl_uncaught_exceptional_condition_define _(mbfl_CND) "$mbfl_WHO" 'uncaught exception' 'false' _(mbfl_OBJ)
}
function mbfl_outside_location_condition_make () {
    mbfl_check_mandatory_parameters_number(3,3)
    mbfl_mandatory_nameref_parameter(mbfl_CND,	1, exceptional-condition object)
    mbfl_mandatory_parameter(mbfl_WHO,		2, entity reporting the exceptional-condition)
    mbfl_mandatory_parameter(mbfl_MESSAGE,	3, exceptional-condition description message)

    mbfl_outside_location_condition_define _(mbfl_CND) "$mbfl_WHO" "$mbfl_MESSAGE" 'false'
}


#### predefined exceptional-condition object classes: functions related

function mbfl_wrong_parameters_number_condition_make () {
    mbfl_check_mandatory_parameters_number(5,5)
    mbfl_mandatory_nameref_parameter(mbfl_CND,			1, exceptional-condition object)
    mbfl_mandatory_parameter(mbfl_FUNCNAME,			2, entity reporting the exceptional-condition)
    mbfl_mandatory_parameter(mbfl_GIVEN_NUMBER,			3, given parameters number)
    mbfl_mandatory_integer_parameter(mbfl_MIN_EXPECTED_NUMBER,	4, expected minimum parameters number)
    mbfl_optional_integer_parameter(mbfl_MAX_EXPECTED_NUMBER,	5, 9999)
    declare mbfl_MSG

    if (( 9999 == $mbfl_MAX_EXPECTED_NUMBER ))
    then printf -v mbfl_MSG 'in call to "%s" expected at least %d parameters, given %d parameters' \
		"$mbfl_FUNCNAME" "$mbfl_MIN_EXPECTED_NUMBER" "$mbfl_GIVEN_NUMBER"
    elif (( $mbfl_MIN_EXPECTED_NUMBER == $mbfl_MAX_EXPECTED_NUMBER ))
    then printf -v mbfl_MSG 'in call to "%s" expected exactly %d parameters, given %d parameters' \
		"$mbfl_FUNCNAME" "$mbfl_MIN_EXPECTED_NUMBER" "$mbfl_GIVEN_NUMBER"
    else printf -v mbfl_MSG 'in call to "%s" expected between %d and %d parameters, given %d parameters' \
		"$mbfl_FUNCNAME" "$mbfl_MIN_EXPECTED_NUMBER" "$mbfl_MAX_EXPECTED_NUMBER" "$mbfl_GIVEN_NUMBER"
    fi

    #                                                         who              message     continuable
    mbfl_wrong_parameters_number_condition_define _(mbfl_CND) "$mbfl_FUNCNAME" "$mbfl_MSG" 'false' \
						  "$mbfl_MIN_EXPECTED_NUMBER" "$mbfl_MAX_EXPECTED_NUMBER" "$mbfl_GIVEN_NUMBER"
}
function mbfl_invalid_function_parameter_condition_make () {
    mbfl_check_mandatory_parameters_number(5,6)
    mbfl_mandatory_nameref_parameter(mbfl_CND,		1, exceptional-condition object)
    mbfl_mandatory_parameter(mbfl_FUNCNAME,		2, entity reporting the exceptional-condition)
    mbfl_mandatory_parameter(mbfl_ERROR_DESCRIPTION,	3, error description)
    mbfl_mandatory_parameter(mbfl_PARAMETER_NUMBER,	4, parameter name)
    mbfl_mandatory_parameter(mbfl_PARAMETER_NAME,	5, invalid parameter value)
    mbfl_optional_parameter(mbfl_PARAMETER_VALUE,	6)
    declare mbfl_MSG

    printf -v mbfl_MSG 'in call to "%s" invalid value for parameter %d "%s": "%s", %s' \
	   "$mbfl_FUNCNAME" "$mbfl_PARAMETER_NUMBER" "$mbfl_PARAMETER_NAME" "$mbfl_PARAMETER_VALUE" "$mbfl_ERROR_DESCRIPTION"

    #                                                            who              message     continuable
    mbfl_invalid_function_parameter_condition_define _(mbfl_CND) "$mbfl_FUNCNAME" "$mbfl_MSG" 'false' \
						     "$mbfl_ERROR_DESCRIPTION" \
						     "$mbfl_PARAMETER_NUMBER" "$mbfl_PARAMETER_NAME" "$mbfl_PARAMETER_VALUE"
}


#### predefined exceptional-condition object classes: classes and objects related

function mbfl_invalid_ctor_parm_value_condition_make () {
    mbfl_check_mandatory_parameters_number(5)
    mbfl_mandatory_nameref_parameter(mbfl_CND,		1, exceptional-condition object)
    mbfl_mandatory_parameter(mbfl_WHO,			2, entity reporting the exceptional-condition)
    mbfl_mandatory_nameref_parameter(mbfl_CLASS,	3, default class)
    mbfl_mandatory_parameter(mbfl_PARAMETER_NAME,	4, parameter name)
    mbfl_mandatory_parameter(mbfl_PARAMETER_VALUE,	5, invalid parameter value)
    mbfl_declare_varref(mbfl_CLASS_NAME)
    declare mbfl_MSG

    #echo $FUNCNAME _(mbfl_CND) "$mbfl_WHO" _(mbfl_CLASS) "$mbfl_PARAMETER_NAME" "$mbfl_PARAMETER_VALUE" >&2

    mbfl_default_class_name_var _(mbfl_CLASS_NAME) _(mbfl_CLASS)
    printf -v mbfl_MSG 'invalid value for parameter "%s" of class "%s" constructor: "%s"' \
	   "$mbfl_PARAMETER_NAME" "$mbfl_CLASS_NAME" "$mbfl_PARAMETER_VALUE"
    mbfl_invalid_ctor_parm_value_condition_define _(mbfl_CND) "$mbfl_WHO" "$mbfl_MSG" 'false' \
						  _(mbfl_CLASS) "$mbfl_PARAMETER_NAME" "$mbfl_PARAMETER_VALUE"
}
function mbfl_invalid_object_attrib_value_condition_make () {
    mbfl_check_mandatory_parameters_number(5)
    mbfl_mandatory_nameref_parameter(mbfl_CND,		1, exceptional-condition object)
    mbfl_mandatory_parameter(mbfl_WHO,			2, entity reporting the exceptional-condition)
    mbfl_mandatory_nameref_parameter(mbfl_OBJ,		3, default object)
    mbfl_mandatory_parameter(mbfl_ATTRIB_NAME,		4, attribute name)
    mbfl_mandatory_parameter(mbfl_PARAMETER_VALUE,	5, invalid attribute value)
    mbfl_declare_varref(mbfl_CLASS_NAME)
    declare mbfl_MSG

    mbfl_default_object_class_name_var _(mbfl_CLASS_NAME) _(mbfl_OBJ)
    printf -v mbfl_MSG 'invalid value for attribute "%s" of class "%s" object: "%s"' \
	   "$mbfl_ATTRIB_NAME" "$mbfl_CLASS_NAME" "$mbfl_PARAMETER_VALUE"
    mbfl_invalid_object_attrib_value_condition_define _(mbfl_CND) "$mbfl_WHO" "$mbfl_MSG" 'false' \
						      _(mbfl_OBJ) "$mbfl_ATTRIB_NAME" "$mbfl_PARAMETER_VALUE"
}


#### predefined exceptional-condition object methods

function mbfl_exceptional_condition_is_continuable () {
    mbfl_check_mandatory_parameters_number(1)
    mbfl_mandatory_nameref_parameter(mbfl_CND, 1, reference to error descriptor object)
    mbfl_declare_varref(mbfl_CONTINUABLE)

    mbfl_exceptional_condition_continuable_var _(mbfl_CONTINUABLE) _(mbfl_CND)
    #echo $FUNCNAME continuable "$mbfl_CONTINUABLE" >&2
    "$mbfl_CONTINUABLE"
}
function mbfl_exceptional_condition_print_report () {
    mbfl_check_mandatory_parameters_number(1)
    mbfl_mandatory_nameref_parameter(mbfl_CND, 1, reference to error descriptor object)
    mbfl_declare_varref(mbfl_WHO)
    mbfl_declare_varref(mbfl_MESSAGE)

    mbfl_exceptional_condition_who_var     _(mbfl_WHO)     _(mbfl_CND)
    mbfl_exceptional_condition_message_var _(mbfl_MESSAGE) _(mbfl_CND)

    if mbfl_error_condition_is_a _(mbfl_CND)
    then mbfl_message_error_printf '%s: %s' "$mbfl_WHO" "$mbfl_MESSAGE"
    elif mbfl_warning_condition_is_a _(mbfl_CND)
    then mbfl_message_warning_printf '%s: %s' "$mbfl_WHO" "$mbfl_MESSAGE"
    else printf '%s: %s\n' "$mbfl_WHO" "$mbfl_MESSAGE"
    fi
}
function mbfl_exceptional_condition_print () {
    mbfl_check_mandatory_parameters_number(1)
    mbfl_mandatory_nameref_parameter(mbfl_CND, 1, reference to error descriptor object)
    mbfl_declare_varref(mbfl_WHO)
    mbfl_declare_varref(mbfl_MESSAGE)

    mbfl_exceptional_condition_who_var     _(mbfl_WHO)     _(mbfl_CND)
    mbfl_exceptional_condition_message_var _(mbfl_MESSAGE) _(mbfl_CND)

    if mbfl_uncaught_exceptional_condition_is_a _(mbfl_CND)
    then
	mbfl_message_error_printf '%s: %s' "$mbfl_WHO" "$mbfl_MESSAGE"

	mbfl_declare_varref(mbfl_ORIGINAL_CND_VARNAME)
	mbfl_declare_varref(mbfl_ORIGINAL_CLASS_NAME)
	mbfl_declare_varref(mbfl_ORIGINAL_WHO)
	mbfl_declare_varref(mbfl_ORIGINAL_MESSAGE)

	mbfl_uncaught_exceptional_condition_object_var _(mbfl_ORIGINAL_CND_VARNAME) _(mbfl_CND)
	mbfl_declare_nameref(mbfl_ORIGINAL_CND, $mbfl_ORIGINAL_CND_VARNAME)

	mbfl_default_object_class_name_var      _(mbfl_ORIGINAL_CLASS_NAME)	_(mbfl_ORIGINAL_CND)
	mbfl_exceptional_condition_who_var      _(mbfl_ORIGINAL_WHO)		_(mbfl_ORIGINAL_CND)
	mbfl_exceptional_condition_message_var  _(mbfl_ORIGINAL_MESSAGE)	_(mbfl_ORIGINAL_CND)

	printf '  exceptional-condition class:\t%s\n  who:                        \t%s\n  message:                    \t%s\n' \
	       "$mbfl_ORIGINAL_CLASS_NAME" "$mbfl_ORIGINAL_WHO" "$mbfl_ORIGINAL_MESSAGE" >&2
    elif mbfl_error_condition_is_a _(mbfl_CND)
    then mbfl_message_error_printf '%s: %s' "$mbfl_WHO" "$mbfl_MESSAGE"
    elif mbfl_warning_condition_is_a _(mbfl_CND)
    then mbfl_message_warning_printf '%s: %s' "$mbfl_WHO" "$mbfl_MESSAGE"
    else printf '%s: %s\n' "$mbfl_WHO" "$mbfl_MESSAGE"
    fi
}

### end of file
# Local Variables:
# mode: sh
# End:
