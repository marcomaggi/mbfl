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
mbfl_default_class_declare(mbfl_invalid_object_attrib_value_condition_t)
mbfl_default_class_declare(mbfl_invalid_ctor_parm_value_condition_t)

function mbfl_initialise_module_exceptional_conditions () {
    mbfl_default_class_define _(mbfl_exceptional_condition_t) _(mbfl_default_object) 'mbfl_exceptional_condition' \
			      'who' 'message' 'continuable'

    mbfl_default_class_define _(mbfl_warning_condition_t)       _(mbfl_exceptional_condition_t)  'mbfl_warning_condition'
    mbfl_default_class_define _(mbfl_error_condition_t)         _(mbfl_exceptional_condition_t)  'mbfl_error_condition'
    mbfl_default_class_define _(mbfl_logic_error_condition_t)   _(mbfl_error_condition_t)        'mbfl_logic_error_condition'
    mbfl_default_class_define _(mbfl_runtime_error_condition_t) _(mbfl_error_condition_t)        'mbfl_runtime_error_condition'

    mbfl_default_class_define _(mbfl_invalid_ctor_parm_value_condition_t) _(mbfl_logic_error_condition_t) \
			      'mbfl_invalid_ctor_parm_value_condition' \
			      'class' 'parm_name' 'invalid_value'

    mbfl_default_class_define _(mbfl_invalid_object_attrib_value_condition_t) _(mbfl_logic_error_condition_t) \
			      'mbfl_invalid_object_attrib_value_condition' \
			      'object' 'attrib_name' 'invalid_value'

    # Unset the constructors of abstract classes.
    mbfl_function_unset 'mbfl_exceptional_condition_define'
    mbfl_function_unset 'mbfl_error_condition_define'

    # Redefine "mbfl_exceptional_condition_continuable_set()" to introduce type-checking.
    #
    mbfl_function_rename 'mbfl_exceptional_condition_continuable_set' 'mbfl_p_exceptional_condition_continuable_set'
    function mbfl_exceptional_condition_continuable_set () {
	mbfl_mandatory_nameref_parameter(mbfl_OBJ,	1, reference to condition object)
	mbfl_mandatory_parameter(mbfl_VAL,		2, possible boolean value)
	mbfl_declare_varref(mbfl_NORMAL)

	if mbfl_string_normalise_boolean_var _(mbfl_NORMAL) "$mbfl_VAL"
	then mbfl_p_exceptional_condition_continuable_set _(mbfl_OBJ) "$mbfl_NORMAL"
	else
	    mbfl_default_object_declare(mbfl_CND)

	    mbfl_invalid_object_attrib_value_condition_make _(mbfl_CND) $FUNC _(mbfl_OBJ) 'continuable' "$mbfl_VAL"
	    mbfl_exception_raise _(mbfl_CND)
	fi
    }
}


#### predefined core condition object classes

function mbfl_warning_condition_make () {
    mbfl_mandatory_nameref_parameter(mbfl_CND,	1, exceptional-condition object)
    mbfl_mandatory_parameter(mbfl_WHO,		2, entity reporting the exceptional-condition)
    mbfl_mandatory_parameter(mbfl_MESSAGE,	3, exceptional-condition description message)

    mbfl_warning_condition_define _(mbfl_CND) "$mbfl_WHO" "$mbfl_MESSAGE" 'true'
}
function mbfl_runtime_error_condition_make () {
    mbfl_mandatory_nameref_parameter(mbfl_CND,	1, exceptional-condition object)
    mbfl_mandatory_parameter(mbfl_WHO,		2, entity reporting the exceptional-condition)
    mbfl_mandatory_parameter(mbfl_MESSAGE,	3, exceptional-condition description message)

    mbfl_runtime_error_condition_define _(mbfl_CND) "$mbfl_WHO" "$mbfl_MESSAGE" 'true'
}
function mbfl_logic_error_condition_make () {
    mbfl_mandatory_nameref_parameter(mbfl_CND,	1, exceptional-condition object)
    mbfl_mandatory_parameter(mbfl_WHO,		2, entity reporting the exceptional-condition)
    mbfl_mandatory_parameter(mbfl_MESSAGE,	3, exceptional-condition description message)

    mbfl_logic_error_condition_define _(mbfl_CND) "$mbfl_WHO" "$mbfl_MESSAGE" 'false'
}


#### predefined condition object classes: classes and objects related

function mbfl_invalid_ctor_parm_value_condition_make () {
    mbfl_mandatory_nameref_parameter(mbfl_CND,		1, exceptional-condition object)
    mbfl_mandatory_parameter(mbfl_WHO,			2, entity reporting the exceptional-condition)
    mbfl_mandatory_nameref_parameter(mbfl_CLASS,	3, default class)
    mbfl_mandatory_parameter(mbfl_PARM_NAME,		4, parameter name)
    mbfl_mandatory_parameter(mbfl_INVALID_VALUE,	5, invalid parameter value)
    mbfl_declare_varref(mbfl_CLASS_NAME)
    declare mbfl_MSG

    #echo $FUNCNAME _(mbfl_CND) "$mbfl_WHO" _(mbfl_CLASS) "$mbfl_PARM_NAME" "$mbfl_INVALID_VALUE" >&2

    mbfl_default_class_name_var _(mbfl_CLASS_NAME) _(mbfl_CLASS)
    printf -v mbfl_MSG 'invalid value for parameter "%s" of class "%s" constructor: "%s"' \
	   "$mbfl_PARM_NAME" "$mbfl_CLASS_NAME" "$mbfl_INVALID_VALUE"
    mbfl_invalid_ctor_parm_value_condition_define _(mbfl_CND) "$mbfl_WHO" "$mbfl_MSG" 'false' \
						  _(mbfl_CLASS) "$mbfl_PARM_NAME" "$mbfl_INVALID_VALUE"
}
function mbfl_invalid_object_attrib_value_condition_make () {
    mbfl_mandatory_nameref_parameter(mbfl_CND,		1, exceptional-condition object)
    mbfl_mandatory_parameter(mbfl_WHO,			2, entity reporting the exceptional-condition)
    mbfl_mandatory_nameref_parameter(mbfl_OBJ,		3, default object)
    mbfl_mandatory_parameter(mbfl_ATTRIB_NAME,		4, attribute name)
    mbfl_mandatory_parameter(mbfl_INVALID_VALUE,	5, invalid attribute value)
    mbfl_declare_varref(mbfl_CLASS_NAME)
    declare mbfl_MSG

    mbfl_default_object_class_name_var _(mbfl_CLASS_NAME) _(mbfl_OBJ)
    printf -v mbfl_MSG 'invalid boolean value for attribute "%s" of class "%s" object: "%s"' \
	   "$mbfl_ATTRIB_NAME" "$mbfl_CLASS_NAME" "$mbfl_INVALID_VALUE"
    mbfl_invalid_object_attrib_value_condition_define _(mbfl_CND) "$mbfl_WHO" "$mbfl_MSG" 'false' \
						      _(mbfl_OBJ) "$mbfl_ATTRIB_NAME" "$mbfl_INVALID_VALUE"
}


#### predefined condition object methods

function mbfl_exceptional_condition_print () {
    mbfl_mandatory_nameref_parameter(CND, 1, reference to error descriptor object)
    mbfl_declare_varref(WHO)
    mbfl_declare_varref(MESSAGE)

    mbfl_exceptional_condition_who_var     _(WHO)     _(CND)
    mbfl_exceptional_condition_message_var _(MESSAGE) _(CND)

    if mbfl_error_condition_is_a _(CND)
    then mbfl_message_error_printf '%s: %s' "$WHO" "$MESSAGE"
    elif mbfl_warning_condition_is_a _(CND)
    then mbfl_message_warning_printf '%s: %s' "$WHO" "$MESSAGE"
    else printf '%s: %s\n' "$WHO" "$MESSAGE"
    fi
}
function mbfl_exceptional_condition_is_continuable () {
    mbfl_mandatory_nameref_parameter(CND, 1, reference to error descriptor object)
    mbfl_declare_varref(CONTINUABLE)

    mbfl_exceptional_condition_continuable_var _(CONTINUABLE) _(CND)
    #echo $FUNCNAME continuable "$CONTINUABLE" >&2
    "$CONTINUABLE"
}

### end of file
# Local Variables:
# mode: sh
# End:
