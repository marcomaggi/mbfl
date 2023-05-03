# conditions.bash.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: exceptional conditions descriptors module
# Date: May  2, 2023
#
# Abstract
#
#       This module defines standard objects describing exceptional conditions.
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

function mbfl_initialise_module_conditions () {
    mbfl_default_class_declare_global(mbfl_condition_t)
    mbfl_default_class_declare_global(mbfl_error_condition_t)
    mbfl_default_class_declare_global(mbfl_warning_condition_t)
    mbfl_default_class_declare_global(mbfl_logic_error_condition_t)
    mbfl_default_class_declare_global(mbfl_runtime_error_condition_t)
    mbfl_default_class_declare_global(mbfl_invalid_object_field_value_condition_t)

    mbfl_default_class_define _(mbfl_condition_t)               _(mbfl_default_object)    'mbfl_condition' 'message' 'continuable'
    mbfl_default_class_define _(mbfl_warning_condition_t)       _(mbfl_condition_t)       'mbfl_warning_condition'
    mbfl_default_class_define _(mbfl_error_condition_t)         _(mbfl_condition_t)       'mbfl_error_condition'
    mbfl_default_class_define _(mbfl_logic_error_condition_t)   _(mbfl_error_condition_t) 'mbfl_logic_error_condition'
    mbfl_default_class_define _(mbfl_runtime_error_condition_t) _(mbfl_error_condition_t) 'mbfl_runtime_error_condition'

    mbfl_default_class_define _(mbfl_invalid_object_field_value_condition_t) _(mbfl_logic_error_condition_t) \
			      'mbfl_invalid_object_field_value_condition'

    mbfl_function_rename 'mbfl_condition_continuable_set' 'mbfl_p_condition_continuable_set'

    function mbfl_condition_continuable_set () {
	mbfl_mandatory_nameref_parameter(mbfl_OBJ,	1, reference to condition object)
	mbfl_mandatory_nameref_parameter(mbfl_VAL,	2, possible boolean value)
	mbfl_declare_varref(mbfl_NORMAL)

	if mbfl_string_normalise_boolean_var _(mbfl_NORMAL) "$mbfl_VAL"
	then mbfl_p_condition_continuable_set _(mbfl_OBJ) "$mbfl_NORMAL"
	else
	    mbfl_default_object_declare(mbfl_CND)

	    mbfl_invalid_object_field_value_condition_make _(mbfl_CND) _(mbfl_OBJ) 'continuable' "$mbfl_VAL"
	    mbfl_raise _(mbfl_CND)
	fi
    }
}

function mbfl_string_normalise_boolean_var () {
    mbfl_mandatory_nameref_parameter(NORMAL_RV, 1, result variable)
    mbfl_mandatory_nameref_parameter(VAL,       2, possible boolean value)

    case "$VAL" in
	'true'|'false')	NORMAL_RV=$VAL		;;
	'yes'|'1')	NORMAL_RV='true'	;;
	'no'|'0')	NORMAL_RV='false'	;;
	*)
	    return_failure
	    ;;
    esac
    return_success
}


#### predefined core condition object classes

function mbfl_warning_condition_make () {
    mbfl_mandatory_nameref_parameter(CND,	1, condition object)
    mbfl_mandatory_parameter(MESSAGE,		2, condition description message)

    mbfl_warning_condition_define _(CND) "$MESSAGE" 'true'
}
function mbfl_runtime_error_condition_make () {
    mbfl_mandatory_nameref_parameter(CND,	1, condition object)
    mbfl_mandatory_parameter(MESSAGE,		2, condition description message)

    mbfl_runtime_error_condition_define _(CND) "$MESSAGE" 'true'
}
function mbfl_logic_error_condition_make () {
    mbfl_mandatory_nameref_parameter(CND,	1, condition object)
    mbfl_mandatory_parameter(MESSAGE,		2, condition description message)

    mbfl_logic_error_condition_define _(CND) "$MESSAGE" 'false'
}


#### predefined condition object classes: attempt to set an object's field with invalid value

function mbfl_invalid_object_field_value_condition_make () {
    mbfl_mandatory_nameref_parameter(mbfl_OBJ,		1, reference to condition object)
    mbfl_mandatory_parameter(mbfl_FIELD_NAME,		2, field name)
    mbfl_mandatory_parameter(mbfl_INVALID_FIELD_VALUE,	3, invalid field value)
    mbfl_declare_varref(mbfl_CLASS)
    mbfl_declare_varref(mbfl_CLASS_NAME)
    declare MSG

    mbfl_default_object_class_var _(mbfl_CLASS) _(mbfl_OBJ)
    mbfl_default_class_name_var   _(mbfl_CLASS_NAME) "$mbfl_CLASS"
    printf -v MSG 'invalid boolean value for "continuable" field of "%s" object: "%s"' "$mbfl_CLASS_NAME" "$mbfl_INVALID_FIELD_VALUE"
    mbfl_invalid_object_field_value_condition_define _(mbfl_OBJ) "$MSG"
}


#### predefined condition object methods

function mbfl_condition_print () {
    mbfl_mandatory_nameref_parameter(CND, 1, reference to error descriptor object)
    mbfl_declare_varref(MSG)

    mbfl_condition_message_var _(MSG) _(CND)
    if mbfl_error_condition_is_a _(CND)
    then mbfl_message_error "$MSG"
    elif mbfl_warning_condition_is_a _(CND)
    then mbfl_message_warning "$MSG"
    else printf '%s\n' "$MSG"
    fi
}
function mbfl_condition_is_continuable () {
    mbfl_mandatory_nameref_parameter(CND, 1, reference to error descriptor object)
    mbfl_declare_varref(CONTINUABLE)

    mbfl_condition_continuable_var _(CONTINUABLE) _(CND)
    "$CONTINUABLE"
}

### end of file
# Local Variables:
# mode: sh
# End: