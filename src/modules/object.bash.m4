# object.bash.m4 --
#
# Part of: Marco's BASH functions library
# Contents: object-oriented programming
# Date: Mar 12, 2023
#
# Abstract
#
#	Object-oriented programming.  Objects on top of Bash arrays.
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


#### local macros

MBFL_DEFINE_UNDERSCORE_MACRO_FOR_SLOTS()

# An  object whose  class is  a  child of  "mbfl_default_object" is  a  Bash index  array with  the
# following layout:
#
#  ---------------
# | type datavar | <-- MBFL_STDOBJ__CLASS_INDEX
# |--------------|
# | first field  | <-- MBFL_STDOBJ__FIRST_FIELD_INDEX
# |--------------|
# | second field | <-- MBFL_STDOBJ__FIRST_FIELD_INDEX + 1
# |--------------|
# |     ...      |
#  --------------
#
m4_define([[[MBFL_STDOBJ__CLASS_INDEX]]],		[[[0]]])
m4_define([[[MBFL_STDOBJ__FIRST_FIELD_INDEX]]],		[[[1]]])

# A class  whose class is  "mbfl_default_class" is  a Bash index  array with the  following layout,
# where the field specifications are just strings representing the field name:
#
#  ---------------------
# | type datavar       | <-- MBFL_STDOBJ__CLASS_INDEX
# |--------------------|
# | parent             | <-- MBFL_STDCLS__FIELD_INDEX__PARENT
# |--------------------|
# | name               | <-- MBFL_STDCLS__FIELD_INDEX__NAME
# |--------------------|
# | fields_number      | <-- MBFL_STDCLS__FIELD_INDEX__FIELDS_NUMBER
# |--------------------|
# | field 0 spec       | <-- MBFL_STDCLS__FIRST_FIELD_SPEC_INDEX + 0
# |--------------------|
# | field 1 spec       | <-- MBFL_STDCLS__FIRST_FIELD_SPEC_INDEX + 1
# |--------------------|
#          ...
# |--------------------|
# | field (n-1) spec   | <-- MBFL_STDCLS__FIRST_FIELD_SPEC_INDEX + fields_number - 1
#  --------------------
#

m4_define([[[MBFL_STDCLS__FIELD_OFFSET__PARENT]]],		[[[0]]])
m4_define([[[MBFL_STDCLS__FIELD_OFFSET__NAME]]],		[[[1]]])
m4_define([[[MBFL_STDCLS__FIELD_OFFSET__FIELDS_NUMBER]]],	[[[2]]])
m4_define([[[MBFL_STDCLS__FIELD_OFFSET__FIRST_FIELD_SPEC]]],	[[[3]]])

m4_define([[[MBFL_STDCLS__FIELD_INDEX__PARENT]]],
	  m4_eval(MBFL_STDOBJ__FIRST_FIELD_INDEX + MBFL_STDCLS__FIELD_OFFSET__PARENT))
m4_define([[[MBFL_STDCLS__FIELD_INDEX__NAME]]],
	  m4_eval(MBFL_STDOBJ__FIRST_FIELD_INDEX + MBFL_STDCLS__FIELD_OFFSET__NAME))
m4_define([[[MBFL_STDCLS__FIELD_INDEX__FIELDS_NUMBER]]],
	  m4_eval(MBFL_STDOBJ__FIRST_FIELD_INDEX + MBFL_STDCLS__FIELD_OFFSET__FIELDS_NUMBER))
m4_define([[[MBFL_STDCLS__FIELD_INDEX__FIRST_FIELD_SPEC]]],
	  m4_eval(MBFL_STDOBJ__FIRST_FIELD_INDEX + MBFL_STDCLS__FIELD_OFFSET__FIRST_FIELD_SPEC))

m4_define([[[MBFL_STDCLS__FIELD_SPEC_INDEX__PARENT]]],
	  m4_eval(MBFL_STDCLS__FIELD_INDEX__FIRST_FIELD_SPEC + MBFL_STDCLS__FIELD_OFFSET__PARENT))
m4_define([[[MBFL_STDCLS__FIELD_SPEC_INDEX__NAME]]],
	  m4_eval(MBFL_STDCLS__FIELD_INDEX__FIRST_FIELD_SPEC + MBFL_STDCLS__FIELD_OFFSET__NAME))
m4_define([[[MBFL_STDCLS__FIELD_SPEC_INDEX__FIELDS_NUMBER]]],
	  m4_eval(MBFL_STDCLS__FIELD_INDEX__FIRST_FIELD_SPEC + MBFL_STDCLS__FIELD_OFFSET__FIELDS_NUMBER))

# These are printf string patterns to format the names os class functions.
#
m4_define([[[MBFL_STDOBJ__FUNCNAME_PATTERN__CONSTRUCTOR]]],	[[['%s_define']]])
m4_define([[[MBFL_STDOBJ__FUNCNAME_PATTERN__PREDICATE]]],	[[['%s_is_a']]])
m4_define([[[MBFL_STDOBJ__FUNCNAME_PATTERN__ACCESSOR]]],	[[['%s_%s_var']]])
m4_define([[[MBFL_STDOBJ__FUNCNAME_PATTERN__MUTATOR]]],		[[['%s_%s_set']]])
m4_define([[[MBFL_STDOBJ__FUNCNAME_PATTERN__INITIALISER]]],	[[['%s_init']]])


#### global variables

if mbfl_string_neq_yes("$mbfl_INTERACTIVE")
then
    mbfl_default_class_declare(mbfl_default_object)
    mbfl_default_class_declare(mbfl_default_class)
fi


#### default object class
#
# The object "mbfl_default_object" is the default class of objects created by "mbfl_object_define".
#

if mbfl_string_neq_yes("$mbfl_INTERACTIVE")
then
    mbfl_slot_set(mbfl_default_object, MBFL_STDOBJ__CLASS_INDEX,		_(mbfl_default_class))
    mbfl_slot_set(mbfl_default_object, MBFL_STDCLS__FIELD_INDEX__PARENT,       '')
    mbfl_slot_set(mbfl_default_object, MBFL_STDCLS__FIELD_INDEX__NAME,         'mbfl_default_object')
    mbfl_slot_set(mbfl_default_object, MBFL_STDCLS__FIELD_INDEX__FIELDS_NUMBER, 0)

    # This class adds no fields to its instances: we store nothing after the number of fields.
fi


#### default metaclass
#
# The object "mbfl_default_class"  is the default class of classes  defined by "mbfl_default_class_define";
# it is also the class of itself.
#

if mbfl_string_neq_yes("$mbfl_INTERACTIVE")
then
    mbfl_slot_set(mbfl_default_class, MBFL_STDOBJ__CLASS_INDEX,			_(mbfl_default_class))
    mbfl_slot_set(mbfl_default_class, MBFL_STDCLS__FIELD_INDEX__PARENT,		_(mbfl_default_object))
    mbfl_slot_set(mbfl_default_class, MBFL_STDCLS__FIELD_INDEX__NAME,		'mbfl_default_class')
    mbfl_slot_set(mbfl_default_class, MBFL_STDCLS__FIELD_INDEX__FIELDS_NUMBER,	3)

    # This class adds fields to its instances, so  we store their specifications after the number of
    # fields.
    mbfl_slot_set(mbfl_default_class, MBFL_STDCLS__FIELD_SPEC_INDEX__PARENT,        'parent')
    mbfl_slot_set(mbfl_default_class, MBFL_STDCLS__FIELD_SPEC_INDEX__NAME,          'name')
    mbfl_slot_set(mbfl_default_class, MBFL_STDCLS__FIELD_SPEC_INDEX__FIELDS_NUMBER, 'fields_number')
fi


#### accessor functions for objects of type "mbfl_default_class"

function mbfl_default_class_is_a () {
    mbfl_mandatory_nameref_parameter(mbfl_SELF, 1, reference to instance of mbfl_default_object)
    if test -v _(mbfl_SELF) -a -v mbfl_slot_spec(mbfl_SELF,MBFL_STDOBJ__CLASS_INDEX)
    then mbfl_string_eq(_(mbfl_default_class), _(mbfl_SELF,MBFL_STDOBJ__CLASS_INDEX)) ||
	    mbfl_default_classes_are_parent_and_child _(mbfl_default_class) _(mbfl_SELF,MBFL_STDOBJ__CLASS_INDEX)
    else false
    fi
}

function mbfl_default_metaclass_is_a () {
    mbfl_mandatory_nameref_parameter(mbfl_SELF, 1, reference to instance of mbfl_default_object)
    if mbfl_default_class_is_a _(mbfl_SELF)
    then mbfl_string_eq(_(mbfl_default_class), _(mbfl_SELF)) ||
	    mbfl_default_classes_are_parent_and_child _(mbfl_default_class) _(mbfl_SELF)
    else false
    fi
}

function mbfl_default_class_parent_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,    1, the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_CLASS, 2, variable referencing a default class)
    mbfl_RV=mbfl_slot_ref(mbfl_CLASS, MBFL_STDCLS__FIELD_INDEX__PARENT)
}

function mbfl_default_class_name_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,    1, the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_CLASS, 2, variable referencing a default class)
    mbfl_RV=mbfl_slot_ref(mbfl_CLASS, MBFL_STDCLS__FIELD_INDEX__NAME)
}

function mbfl_default_class_fields_number_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,    1, the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_CLASS, 2, variable referencing a default class)
    mbfl_RV=mbfl_slot_ref(mbfl_CLASS, MBFL_STDCLS__FIELD_INDEX__FIELDS_NUMBER)
}

function mbfl_default_classes_are_parent_and_child () {
    mbfl_mandatory_nameref_parameter(mbfl_MAYBE_PARENT, 1, variable referencing a default class)
    mbfl_mandatory_nameref_parameter(mbfl_MAYBE_CHILD,  2, variable referencing a default class)

    if mbfl_string_eq(_(mbfl_MAYBE_PARENT), _(mbfl_MAYBE_CHILD))
    then return_success
    else
	declare mbfl_CHILD_PARENT
	mbfl_default_class_parent_var mbfl_CHILD_PARENT _(mbfl_MAYBE_CHILD)
	if mbfl_string_is_empty "$mbfl_CHILD_PARENT"
	then return_failure
	else mbfl_default_classes_are_parent_and_child _(mbfl_MAYBE_PARENT) "$mbfl_CHILD_PARENT"
	fi
    fi
}


#### data-structure instance handling

function mbfl_default_object_define () {
    mbfl_mandatory_nameref_parameter(mbfl_SELF,			1, reference to a default object)
    mbfl_mandatory_nameref_parameter(mbfl_CLASS,		2, reference to a default class)
    mbfl_mandatory_nameref_parameter(mbfl_FIELD_INIT_VALUES,	3, reference to an index array containing init field values)
    declare -i mbfl_TOTAL_FIELDS_NUMBER

    # Parameters validation.
    {
	if ! mbfl_default_class_is_a _(mbfl_CLASS)
	then
	    mbfl_message_error_printf 'in call to "%s": expected default class as class parameter, got: ""' \
				      $FUNCNAME _(mbfl_CLASS)
	    return_because_failure
	fi

	mbfl_default_class_fields_number_var mbfl_TOTAL_FIELDS_NUMBER _(mbfl_CLASS)
	if ((mbfl_slots_number(mbfl_FIELD_INIT_VALUES) != mbfl_TOTAL_FIELDS_NUMBER))
	then
	    mbfl_message_error_printf 'in call to "%s": wrong number of field initial values: expected %d, got %d' \
				      $FUNCNAME $mbfl_TOTAL_FIELDS_NUMBER mbfl_slots_number(mbfl_FIELD_INIT_VALUES)
	    return_because_failure
	fi

    }
    # Slots initialisation.
    {
	declare -i mbfl_I mbfl_FIELD_INDEX
	mbfl_slot_set(mbfl_SELF, MBFL_STDOBJ__CLASS_INDEX, _(mbfl_CLASS))

	#mbfl_array_dump _(mbfl_FIELD_INIT_VALUES) mbfl_FIELD_INIT_VALUES
	for ((mbfl_I=0; mbfl_I<mbfl_TOTAL_FIELDS_NUMBER; ++mbfl_I))
	do
	    let mbfl_FIELD_INDEX=MBFL_STDOBJ__FIRST_FIELD_INDEX+mbfl_I
	    mbfl_slot_set(mbfl_SELF, $mbfl_FIELD_INDEX, _(mbfl_FIELD_INIT_VALUES, $mbfl_I))
	done
    }
    return_because_success
}

function mbfl_default_object_define_and_init () {
    mbfl_mandatory_nameref_parameter(mbfl_SELF,			1, reference to a default object)
    mbfl_mandatory_nameref_parameter(mbfl_CLASS,		2, reference to a default class)
    mbfl_mandatory_nameref_parameter(mbfl_FIELD_INIT_VALUES,	3, reference to an index array containing init field values)
    mbfl_mandatory_parameter(mbfl_INITIALISER_NAME,		4, name of class initialisation function)

    if mbfl_default_object_define _(mbfl_SELF) _(mbfl_CLASS) _(mbfl_FIELD_INIT_VALUES);
    then
	if mbfl_function_exists "$mbfl_INITIALISER_NAME"
	then "$mbfl_INITIALISER_NAME" _(mbfl_SELF)
	fi
    else return $?
    fi
}

# Return true  if the  given parameter is  the datavar  of an  object whose class  is a  subclass of
# "mbfl_default_object".  We do our best.
#
function mbfl_default_object_is_a () {
    mbfl_mandatory_nameref_parameter(mbfl_SELF, 1, variable referencing a data-structure instance)

    if test -v _(mbfl_SELF) -a -v mbfl_slot_spec(mbfl_SELF,MBFL_STDOBJ__CLASS_INDEX)
    then mbfl_default_classes_are_parent_and_child _(mbfl_default_object) _(mbfl_SELF,MBFL_STDOBJ__CLASS_INDEX)
    else false
    fi
}

function mbfl_default_object_is_of_class () {
    mbfl_mandatory_nameref_parameter(mbfl_OBJECT, 1, variable referencing an object of class mbfl_default_object)
    mbfl_mandatory_nameref_parameter(mbfl_CLASS,  2, variable referencing a class of class mbfl_default_object)

    if test -v _(mbfl_OBJECT) -a -v mbfl_slot_spec(mbfl_OBJECT,MBFL_STDOBJ__CLASS_INDEX)
    then mbfl_string_eq(_(mbfl_CLASS), _(mbfl_OBJECT,MBFL_STDOBJ__CLASS_INDEX)) ||
	    mbfl_default_classes_are_parent_and_child _(mbfl_CLASS) _(mbfl_OBJECT,MBFL_STDOBJ__CLASS_INDEX)
    else false
    fi
}

function mbfl_default_object_class_var () {
    mbfl_mandatory_nameref_parameter(mbfl_CLASS_RV,	1, the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_SELF,		2, variable referencing an object of type mbfl_default_object)
    mbfl_CLASS_RV=_(mbfl_SELF, MBFL_STDOBJ__CLASS_INDEX)
}

function mbfl_default_object_call_method () {
    mbfl_mandatory_nameref_parameter(SELF, 1, reference to color object)
    mbfl_mandatory_parameter(METHOD,       2, method name)
    shift 2
    mbfl_declare_varref(CLASS)
    mbfl_declare_varref(NAME)
    declare METHOD_FUNC

    mbfl_default_object_class_var _(CLASS) _(SELF)
    mbfl_default_class_name_var   _(NAME)  "$CLASS"

    if mbfl_function_exists "${METHOD_FUNC:=${NAME}_method_${METHOD}}"
    then "$METHOD_FUNC" _(SELF) "$@"
    else mbfl_default_object_unknown_method "$METHOD_FUNC" _(SELF) "$@"
    fi
}
function mbfl_default_object_unknown_method () {
    echo $FUNCNAME unknown method call: "$@" >&2
}


#### API of "mbfl_default_class"

function mbfl_default_class_define () {
    mbfl_mandatory_nameref_parameter(mbfl_NEW_CLASS,	1, reference to the new default class)
    mbfl_mandatory_nameref_parameter(mbfl_PARENT_CLASS,	2, reference to the parent default class)
    mbfl_mandatory_parameter(mbfl_NEW_CLASS_NAME,	3, the name of the new default class)
    shift 3
    mbfl_declare_index_array_varref(mbfl_NEW_FIELD_NAMES, ("$@"))

    # Validate parameters.
    {
	if ! mbfl_default_class_is_a _(mbfl_PARENT_CLASS)
	then
	    mbfl_message_error_printf 'in call to "%s" expected default class parent class: "%s"' $FUNCNAME "$mbfl_PARENT_CLASS"
	    return_because_failure
	fi

	if ! mbfl_string_is_identifier "$mbfl_NEW_CLASS_NAME"
	then
	    mbfl_message_error_printf 'in call to "%s" expected identifier as class name: "%s"' $FUNCNAME "$mbfl_NEW_CLASS_NAME"
	    return_because_failure
	fi
    }

    # Initialise the new class object as a subclass of "mbfl_default_object".
    {
	declare -ir mbfl_PARENT_CLASS_FIELDS_NUMBER=_(mbfl_PARENT_CLASS,MBFL_STDCLS__FIELD_INDEX__FIELDS_NUMBER)
	declare -ir mbfl_NEW_FIELDS_NUMBER=mbfl_slots_number(mbfl_NEW_FIELD_NAMES)
	declare -i  mbfl_TOTAL_FIELDS_NUMBER=mbfl_PARENT_CLASS_FIELDS_NUMBER+mbfl_NEW_FIELDS_NUMBER

	mbfl_declare_index_array_varref(mbfl_NEW_CLASS_FIELD_VALUES, (_(mbfl_PARENT_CLASS) "$mbfl_NEW_CLASS_NAME" $mbfl_TOTAL_FIELDS_NUMBER))
	mbfl_default_object_define _(mbfl_NEW_CLASS) _(mbfl_default_class) _(mbfl_NEW_CLASS_FIELD_VALUES)
    }

    if ! mbfl_default_class_define__store_field_specifications _(mbfl_NEW_CLASS) _(mbfl_NEW_FIELD_NAMES)
    then return_because_failure
    fi

    if ! mbfl_default_class_define__check_field_name_uniqueness _(mbfl_NEW_CLASS)
    then return_because_failure
    fi

    if ! mbfl_default_class_define__build_instance_constructor _(mbfl_NEW_CLASS)
    then return_because_failure
    fi

    if ! mbfl_default_class_define__build_instance_predicate _(mbfl_NEW_CLASS)
    then return_because_failure
    fi

    if ! mbfl_default_class_define__build_accessors_and_mutators _(mbfl_NEW_CLASS)
    then return_because_failure
    fi
}

# STore the field  specifications of the new class  object; for class objects that  are instances of
# "mbfl_default_class" a field specification is just the string representing its name.
#
# The layout of a class object of type "mbfl_default_class" is as follows:
#
#  -----------------------
# | _(mbfl_default_class) |
# |-----------------------|
# | parent datavar        |
# |-----------------------|
# | this class name       |
# |-----------------------|
# | total fields number   |
# |-----------------------|
# | parent field 0 name   |
# |-----------------------|
# | parent field 1 name   |
# |-----------------------|
# | new field 0 name      |
# |-----------------------|
# | new field 1 name      |
#  -----------------------
#
function mbfl_default_class_define__store_field_specifications () {
    mbfl_mandatory_nameref_parameter(mbfl_NEW_CLASS,       1, reference to object of type mbfl_default_class)
    mbfl_mandatory_nameref_parameter(mbfl_NEW_FIELD_NAMES, 2, reference to index array holding the field names)
    mbfl_declare_nameref(mbfl_PARENT_CLASS,_(mbfl_NEW_CLASS, MBFL_STDCLS__FIELD_INDEX__PARENT))
    declare -ir mbfl_PARENT_CLASS_FIELDS_NUMBER=_(mbfl_PARENT_CLASS,MBFL_STDCLS__FIELD_INDEX__FIELDS_NUMBER)
    declare -ir mbfl_NEW_FIELDS_NUMBER=mbfl_slots_number(mbfl_NEW_FIELD_NAMES)
    declare -i  mbfl_I mbfl_FIELD_INDEX

    # Copy the field names from the parent class to the new class.
    for ((mbfl_I=0; mbfl_I<mbfl_PARENT_CLASS_FIELDS_NUMBER; ++mbfl_I))
    do
	# There must be no blanks in a "let" expression.
	let mbfl_FIELD_INDEX=MBFL_STDCLS__FIELD_INDEX__FIRST_FIELD_SPEC+mbfl_I
	mbfl_slot_set(mbfl_NEW_CLASS, $mbfl_FIELD_INDEX, _(mbfl_PARENT_CLASS, $mbfl_FIELD_INDEX))
    done
    # AFter those, copy the field names of the new class.
    for ((mbfl_I=0; mbfl_I<mbfl_NEW_FIELDS_NUMBER; ++mbfl_I))
    do
	# There must be no blanks in a "let" expression.
	let mbfl_FIELD_INDEX=mbfl_PARENT_CLASS_FIELDS_NUMBER+MBFL_STDCLS__FIELD_INDEX__FIRST_FIELD_SPEC+mbfl_I
	mbfl_slot_set(mbfl_NEW_CLASS, $mbfl_FIELD_INDEX, _(mbfl_NEW_FIELD_NAMES, $mbfl_I))
    done
}

# Here we expect a fully initialised default class object:
#
#  -----------------------
# | _(mbfl_default_class) |
# |-----------------------|
# | parent datavar        |
# |-----------------------|
# | this class name       |
# |-----------------------|
# | total fields number   |
# |-----------------------|
# | field 0 name          |
# |-----------------------|
# | field 1 name          |
# |-----------------------|
# | field 2 name          |
#  -----------------------
#
# and we check the field names for duplicates.
#
function mbfl_default_class_define__check_field_name_uniqueness () {
    mbfl_mandatory_nameref_parameter(mbfl_NEW_CLASS, 1, reference to object of type mbfl_default_class)
    declare -ir mbfl_TOTAL_FIELDS_NUMBER=_(mbfl_NEW_CLASS, MBFL_STDCLS__FIELD_INDEX__FIELDS_NUMBER)
    declare -i  mbfl_I mbfl_J
    declare     mbfl_FIELD_NAME

    for ((mbfl_I=0; mbfl_I<mbfl_TOTAL_FIELDS_NUMBER; ++mbfl_I))
    do
	mbfl_FIELD_NAME=_(mbfl_NEW_CLASS, $((MBFL_STDCLS__FIELD_INDEX__FIRST_FIELD_SPEC + $mbfl_I)))
	for ((mbfl_J=1+mbfl_I; mbfl_J<mbfl_TOTAL_FIELDS_NUMBER; ++mbfl_J))
	do
	    # There must be no blanks in a "let" expression.
	    let mbfl_FIELD_INDEX=MBFL_STDCLS__FIELD_INDEX__FIRST_FIELD_SPEC+mbfl_J
	    if mbfl_string_eq($mbfl_FIELD_NAME, _(mbfl_NEW_CLASS, $mbfl_FIELD_INDEX))
	    then
		declare -r mbfl_NEW_CLASS_NAME=_(mbfl_NEW_CLASS, MBFL_STDCLS__FIELD_INDEX__NAME)
		mbfl_message_error_printf 'duplicate field name in the definition of type "%s": "%s"' \
					  "$mbfl_NEW_CLASS_NAME" "$mbfl_FIELD_NAME"
		return_because_failure
	    fi
	done
    done
    return_success
}

# Build the default class instance constructor function.  For the class definition:
#
#   mbfl_default_class_declare(color)
#   mbfl_default_class_define _(color) _(mbfl_default_object) 'color' red green blue
#
# the constructor should look like:
#
#   function color_define () {
#      declare -n  mbfl_SELF=${1:?"missing reference to instance of 'color' to 'color_define'"}
#      shift
#      declare -ar mbfl_FIELD_INIT_VALUES=("$@")
#
#      mbfl_default_object_define_and_init _(mbfl_SELF) ${mbfl_NEW_CLASS_DATAVAR} mbfl_FIELD_INIT_VALUES 'color_init'
#   }
#
function mbfl_default_class_define__build_instance_constructor () {
    mbfl_mandatory_nameref_parameter(mbfl_NEW_CLASS, 1, reference to object of type mbfl_default_class)
    declare -r mbfl_NEW_CLASS_DATAVAR=_(mbfl_NEW_CLASS)
    declare -r mbfl_NEW_CLASS_NAME=_(mbfl_NEW_CLASS, MBFL_STDCLS__FIELD_INDEX__NAME)
    declare mbfl_CONSTRUCTOR_NAME mbfl_CONSTRUCTOR_BODY mbfl_INITIALISER_NAME

    printf -v mbfl_CONSTRUCTOR_NAME MBFL_STDOBJ__FUNCNAME_PATTERN__CONSTRUCTOR "$mbfl_NEW_CLASS_NAME"
    printf -v mbfl_INITIALISER_NAME MBFL_STDOBJ__FUNCNAME_PATTERN__INITIALISER "$mbfl_NEW_CLASS_NAME"

    mbfl_CONSTRUCTOR_BODY='{ '
    mbfl_CONSTRUCTOR_BODY+="declare -r mbfl_SELF_DATAVAR=\${1:?\"missing reference to instance of 'color' to '${mbfl_CONSTRUCTOR_NAME}'\"};"
    mbfl_CONSTRUCTOR_BODY+="shift;"
    mbfl_CONSTRUCTOR_BODY+="declare -ar mbfl_u_variable_FIELD_INIT_VALUES=(\"\$@\");"
    mbfl_CONSTRUCTOR_BODY+="mbfl_default_object_define_and_init "
    mbfl_CONSTRUCTOR_BODY+="\$mbfl_SELF_DATAVAR '${mbfl_NEW_CLASS_DATAVAR}' 'mbfl_u_variable_FIELD_INIT_VALUES' '${mbfl_INITIALISER_NAME}';"
    mbfl_CONSTRUCTOR_BODY+='}'

    #echo $FUNCNAME mbfl_CONSTRUCTOR_BODY="$mbfl_CONSTRUCTOR_BODY" >&2
    mbfl_p_object_make_function "$mbfl_CONSTRUCTOR_NAME" "$mbfl_CONSTRUCTOR_BODY"
}

# Build the class predicate function: return true if a struct instance is of type "$mbfl_NEW_CLASS".
# For the class definition:
#
#   mbfl_default_class_declare(color)
#   mbfl_default_class_define _(color) _(mbfl_default_object) 'color' red green blue
#
# the predicate function should look like:
#
#   function color_is_a () {
#       declare -r mbfl_SELF_DATAVAR=${1:?"missing reference to instance of 'color' to 'color_is_a'"};
#       mbfl_default_object_is_of_class "$mbfl_SELF_DATAVAR" '${mbfl_NEW_CLASS_DATAVAR}'
#   }
#
function mbfl_default_class_define__build_instance_predicate () {
    mbfl_mandatory_nameref_parameter(mbfl_NEW_CLASS, 1, reference to object of type mbfl_default_class)
    declare -r mbfl_NEW_CLASS_DATAVAR=_(mbfl_NEW_CLASS)
    declare -r mbfl_NEW_CLASS_NAME=_(mbfl_NEW_CLASS, MBFL_STDCLS__FIELD_INDEX__NAME)
    declare mbfl_PREDICATE_NAME mbfl_PREDICATE_BODY

    printf -v mbfl_PREDICATE_NAME MBFL_STDOBJ__FUNCNAME_PATTERN__PREDICATE "$mbfl_NEW_CLASS_NAME"

    mbfl_PREDICATE_BODY='{ '
    mbfl_PREDICATE_BODY+="declare mbfl_SELF_DATAVAR=\${1:?\"missing reference to data-structure parameter to '${mbfl_PREDICATE_NAME}'\"};"
    mbfl_PREDICATE_BODY+="mbfl_default_object_is_of_class \"\$mbfl_SELF_DATAVAR\" '${mbfl_NEW_CLASS_DATAVAR}' ;"
    mbfl_PREDICATE_BODY+='}'

    mbfl_p_object_make_function "$mbfl_PREDICATE_NAME" "$mbfl_PREDICATE_BODY"
}

# Build instance's fields accessor and mutator functions.
#
function mbfl_default_class_define__build_accessors_and_mutators () {
    mbfl_mandatory_nameref_parameter(mbfl_NEW_CLASS, 1, reference to object of type mbfl_default_class)
    mbfl_declare_nameref(mbfl_PARENT_CLASS,_(mbfl_NEW_CLASS,    MBFL_STDCLS__FIELD_INDEX__PARENT))
    declare -ri mbfl_PARENT_FIELDS_NUMBER=_( mbfl_PARENT_CLASS, MBFL_STDCLS__FIELD_INDEX__FIELDS_NUMBER)
    declare -ri mbfl_TOTAL_FIELDS_NUMBER=_(  mbfl_NEW_CLASS,    MBFL_STDCLS__FIELD_INDEX__FIELDS_NUMBER)
    declare -i  mbfl_I

    for ((mbfl_I=0; mbfl_I<mbfl_PARENT_FIELDS_NUMBER; ++mbfl_I))
    do
	if ! mbfl_default_class_define__build_parent_field_mutator  _(mbfl_NEW_CLASS) $mbfl_I
	then return_failure
	fi
	if ! mbfl_default_class_define__build_parent_field_accessor _(mbfl_NEW_CLASS) $mbfl_I
	then return_failure
	fi
    done
    for ((mbfl_I=mbfl_PARENT_FIELDS_NUMBER; mbfl_I<mbfl_TOTAL_FIELDS_NUMBER; ++mbfl_I))
    do
	if ! mbfl_default_class_define__build_new_field_mutator  _(mbfl_NEW_CLASS) $mbfl_I
	then return_failure
	fi
	if ! mbfl_default_class_define__build_new_field_accessor _(mbfl_NEW_CLASS) $mbfl_I
	then return_failure
	fi
    done
}

# Build a field's mutator function for the field of the parent class.  For the class definition:
#
#   mbfl_default_class_declare(pig)
#   mbfl_default_class_declare(peppa)
#
#   mbfl_default_class_define _(pig)   _(mbfl_default_object) 'pig' color
#   mbfl_default_class_define _(peppa) _(pig) 'peppa' nickname
#
# the mutator function of field "color" should look like:
#
#    function peppa_color_set () {
#        declare mbfl_SELF_DATAVAR=${1:?"missing reference to object 'peppa' parameter to 'peppa_color_set'"};
#        declare mbfl_NEW_VALUE=${2:?"missing new field value parameter to 'peppa_color_set'"}
#        pig_color_set "$mbfl_SELF_DATAVAR" "$mbfl_NEW_VALUE"
#    }
#
function mbfl_default_class_define__build_parent_field_mutator () {
    mbfl_mandatory_nameref_parameter(mbfl_NEW_CLASS,	1, reference to object of type mbfl_default_class)
    mbfl_mandatory_parameter(mbfl_NEW_FIELD_INDEX,	2, the index of the new field)
    mbfl_declare_nameref(mbfl_PARENT_CLASS, _(mbfl_NEW_CLASS, MBFL_STDCLS__FIELD_INDEX__PARENT))
    declare -r mbfl_NEW_CLASS_DATAVAR=_(mbfl_NEW_CLASS)
    declare -r mbfl_NEW_CLASS_NAME=_(mbfl_NEW_CLASS, MBFL_STDCLS__FIELD_INDEX__NAME)
    declare -r mbfl_PARENT_CLASS_NAME=_(mbfl_PARENT_CLASS, MBFL_STDCLS__FIELD_INDEX__NAME)
    declare -r mbfl_FIELD_NAME=_(mbfl_NEW_CLASS, MBFL_STDCLS__FIELD_INDEX__FIRST_FIELD_SPEC + $mbfl_NEW_FIELD_INDEX)
    declare mbfl_MUTATOR_NAME mbfl_MUTATOR_BODY mbfl_PARENT_MUTATOR_NAME

    printf -v mbfl_MUTATOR_NAME		MBFL_STDOBJ__FUNCNAME_PATTERN__MUTATOR "$mbfl_NEW_CLASS_NAME"    "$mbfl_FIELD_NAME"
    printf -v mbfl_PARENT_MUTATOR_NAME	MBFL_STDOBJ__FUNCNAME_PATTERN__MUTATOR "$mbfl_PARENT_CLASS_NAME" "$mbfl_FIELD_NAME"

    mbfl_MUTATOR_BODY='{ '
    mbfl_MUTATOR_BODY+="declare mbfl_SELF_DATAVAR=\${1:?"
    mbfl_MUTATOR_BODY+="\"missing reference to object '${mbfl_NEW_CLASS_NAME}' parameter to '${mbfl_MUTATOR_NAME}'\"};"
    mbfl_MUTATOR_BODY+="declare mbfl_NEW_VALUE=\${2:?\"missing new field value parameter to '${mbfl_MUTATOR_NAME}'\"};"
    mbfl_MUTATOR_BODY+="${mbfl_PARENT_MUTATOR_NAME} \"\$mbfl_SELF_DATAVAR\" \"\$mbfl_NEW_VALUE\";"
    mbfl_MUTATOR_BODY+='}'

    #echo $FUNCNAME mbfl_MUTATOR_BODY="$mbfl_MUTATOR_BODY" >&2
    mbfl_p_object_make_function "$mbfl_MUTATOR_NAME" "$mbfl_MUTATOR_BODY"
}

# Build a field's mutator function for the field of a new class.  For the class definition:
#
#   mbfl_default_class_declare(pig)
#   mbfl_default_class_declare(peppa)
#
#   mbfl_default_class_define _(pig)   _(mbfl_default_object) 'pig' color
#   mbfl_default_class_define _(peppa) _(pig) 'peppa' nickname
#
# the mutator function of field "nickname" should look like:
#
#    function peppa_nickname_set () {
#        declare mbfl_SELF_DATAVAR=${1:?"missing reference to object 'peppa' parameter to 'peppa_nickname_set'"};
#        declare mbfl_NEW_VALUE=${2:?"missing new field value parameter to 'peppa_nichname_set'"}
#        mbfl_p_default_object_slot_mutator "$mbfl_SELF_DATAVAR" "$mbfl_NEW_VALUE" ${mbfl_NEW_CLASS_DATAVAR} 2 peppa_nickname_set
#    }
#
function mbfl_default_class_define__build_new_field_mutator () {
    mbfl_mandatory_nameref_parameter(mbfl_NEW_CLASS,	1, reference to object of type mbfl_default_class)
    mbfl_mandatory_parameter(mbfl_NEW_FIELD_INDEX,	2, the index of the new field)
    declare -r mbfl_NEW_CLASS_DATAVAR=_(mbfl_NEW_CLASS)
    declare -r mbfl_NEW_CLASS_NAME=_(mbfl_NEW_CLASS, MBFL_STDCLS__FIELD_INDEX__NAME)

    declare mbfl_MUTATOR_NAME mbfl_MUTATOR_BODY
    declare -r  mbfl_FIELD_NAME=_(mbfl_NEW_CLASS, MBFL_STDCLS__FIELD_INDEX__FIRST_FIELD_SPEC + $mbfl_NEW_FIELD_INDEX)
    declare -ri mbfl_OFFSET=MBFL_STDOBJ__FIRST_FIELD_INDEX+mbfl_NEW_FIELD_INDEX

    printf -v mbfl_MUTATOR_NAME MBFL_STDOBJ__FUNCNAME_PATTERN__MUTATOR "$mbfl_NEW_CLASS_NAME" "$mbfl_FIELD_NAME"

    mbfl_MUTATOR_BODY='{ '
    mbfl_MUTATOR_BODY+="declare mbfl_SELF_DATAVAR=\${1:?"
    mbfl_MUTATOR_BODY+="\"missing reference to object '${mbfl_NEW_CLASS_NAME}' parameter to '${mbfl_MUTATOR_NAME}'\"};"
    mbfl_MUTATOR_BODY+="declare mbfl_NEW_VALUE=\${2:?\"missing new field value parameter to '${mbfl_MUTATOR_NAME}'\"};"
    mbfl_MUTATOR_BODY+="mbfl_p_default_object_slot_mutator \"\$mbfl_SELF_DATAVAR\" \"\$mbfl_NEW_VALUE\""
    mbfl_MUTATOR_BODY+=" ${mbfl_NEW_CLASS_DATAVAR} ${mbfl_OFFSET} ${mbfl_MUTATOR_NAME};"
    mbfl_MUTATOR_BODY+='}'

    #echo $FUNCNAME mbfl_MUTATOR_BODY="$mbfl_MUTATOR_BODY" >&2
    mbfl_p_object_make_function "$mbfl_MUTATOR_NAME" "$mbfl_MUTATOR_BODY"
}

# Build a field's accessor function for a field of the parent class.  For the class definition:
#
#   mbfl_default_class_declare(pig)
#   mbfl_default_class_declare(peppa)
#
#   mbfl_default_class_define _(pig)   _(mbfl_default_object) 'pig' color
#   mbfl_default_class_define _(peppa) _(pig) 'peppa' nickname
#
# the accessor function of field "color" should look like:
#
#    function peppa_color_var () {
#        declare mbfl_RV_DATAVAR=${1:?"missing new field value parameter to 'peppa_color_var'"}
#        declare mbfl_SELF_DATAVAR=${2:?"missing reference to object 'peppa' parameter to 'peppa_color_var'"};
#        pig_color_var "$mbfl_RV_DATAVAR" "$mbfl_SELF_DATAVAR"
#    }
#
function mbfl_default_class_define__build_parent_field_accessor () {
    mbfl_mandatory_nameref_parameter(mbfl_NEW_CLASS,	1, reference to object of type mbfl_default_class)
    mbfl_mandatory_parameter(mbfl_NEW_FIELD_INDEX,	2, the index of the new field)
    mbfl_declare_nameref(mbfl_PARENT_CLASS, _(mbfl_NEW_CLASS, MBFL_STDCLS__FIELD_INDEX__PARENT))
    declare -r mbfl_NEW_CLASS_DATAVAR=_(mbfl_NEW_CLASS)
    declare -r mbfl_NEW_CLASS_NAME=_(mbfl_NEW_CLASS, MBFL_STDCLS__FIELD_INDEX__NAME)
    declare -r mbfl_PARENT_CLASS_NAME=_(mbfl_PARENT_CLASS, MBFL_STDCLS__FIELD_INDEX__NAME)
    declare -r mbfl_FIELD_NAME=_(mbfl_NEW_CLASS, MBFL_STDCLS__FIELD_INDEX__FIRST_FIELD_SPEC + $mbfl_NEW_FIELD_INDEX)
    declare mbfl_ACCESSOR_NAME mbfl_ACCESSOR_BODY mbfl_PARENT_ACCESSOR_NAME

    printf -v mbfl_ACCESSOR_NAME	MBFL_STDOBJ__FUNCNAME_PATTERN__ACCESSOR "$mbfl_NEW_CLASS_NAME"    "$mbfl_FIELD_NAME"
    printf -v mbfl_PARENT_ACCESSOR_NAME	MBFL_STDOBJ__FUNCNAME_PATTERN__ACCESSOR "$mbfl_PARENT_CLASS_NAME" "$mbfl_FIELD_NAME"

    mbfl_ACCESSOR_BODY='{ '
    mbfl_ACCESSOR_BODY+="declare mbfl_RV_DATAVAR=\${1:?\"missing result variable datavar parameter to '${mbfl_ACCESSOR_NAME}'\"};"
    mbfl_ACCESSOR_BODY+="declare mbfl_SELF_DATAVAR=\${2:?"
    mbfl_ACCESSOR_BODY+="\"missing reference to object '${mbfl_NEW_CLASS_NAME}' parameter to '${mbfl_ACCESSOR_NAME}'\"};"
    mbfl_ACCESSOR_BODY+="${mbfl_PARENT_ACCESSOR_NAME} \"\$mbfl_RV_DATAVAR\" \"\$mbfl_SELF_DATAVAR\";"
    mbfl_ACCESSOR_BODY+='}'

    #echo $FUNCNAME mbfl_ACCESSOR_BODY="$mbfl_ACCESSOR_BODY" >&2
    mbfl_p_object_make_function "$mbfl_ACCESSOR_NAME" "$mbfl_ACCESSOR_BODY"
}

# Build a field's accessor function for the field of a new class.  For the class definition:
#
#   mbfl_default_class_declare(pig)
#   mbfl_default_class_declare(peppa)
#
#   mbfl_default_class_define _(pig)   _(mbfl_default_object) 'pig' color
#   mbfl_default_class_define _(peppa) _(pig) 'peppa' nickname
#
# the accessor function of field "nickname" should look like:
#
#    function peppa_nickname_var () {
#        declare mbfl_RV_DATAVAR=${1:?"missing new field value parameter to 'peppa_nichname_var'"}
#        declare mbfl_SELF_DATAVAR=${2:?"missing reference to object 'peppa' parameter to 'peppa_nickname_var'"};
#        mbfl_p_default_object_slot_accessor "$mbfl_RV_DATAVAR" "$mbfl_SELF_DATAVAR" ${mbfl_NEW_CLASS_DATAVAR} 2 peppa_nickname_var
#    }
#
function mbfl_default_class_define__build_new_field_accessor () {
    mbfl_mandatory_nameref_parameter(mbfl_NEW_CLASS,	1, reference to object of type mbfl_default_class)
    mbfl_mandatory_parameter(mbfl_NEW_FIELD_INDEX,	2, the index of the new field)
    declare -r mbfl_NEW_CLASS_DATAVAR=_(mbfl_NEW_CLASS)
    declare -r mbfl_NEW_CLASS_NAME=_(mbfl_NEW_CLASS, MBFL_STDCLS__FIELD_INDEX__NAME)

    declare mbfl_ACCESSOR_NAME mbfl_ACCESSOR_BODY
    declare -r  mbfl_FIELD_NAME=_(mbfl_NEW_CLASS, MBFL_STDCLS__FIELD_INDEX__FIRST_FIELD_SPEC + $mbfl_NEW_FIELD_INDEX)
    declare -ri mbfl_OFFSET=MBFL_STDOBJ__FIRST_FIELD_INDEX+mbfl_NEW_FIELD_INDEX

    printf -v mbfl_ACCESSOR_NAME MBFL_STDOBJ__FUNCNAME_PATTERN__ACCESSOR "$mbfl_NEW_CLASS_NAME" "$mbfl_FIELD_NAME"

    mbfl_ACCESSOR_BODY='{ '
    mbfl_ACCESSOR_BODY+="declare mbfl_RV_DATAVAR=\${1:?\"missing result variable datavar parameter to '${mbfl_ACCESSOR_NAME}'\"};"
    mbfl_ACCESSOR_BODY+="declare mbfl_SELF_DATAVAR=\${2:?"
    mbfl_ACCESSOR_BODY+="\"missing reference to object '${mbfl_NEW_CLASS_NAME}' parameter to '${mbfl_ACCESSOR_NAME}'\"};"
    mbfl_ACCESSOR_BODY+="mbfl_p_default_object_slot_accessor \"\$mbfl_RV_DATAVAR\" \"\$mbfl_SELF_DATAVAR\""
    mbfl_ACCESSOR_BODY+=" ${mbfl_NEW_CLASS_DATAVAR} ${mbfl_OFFSET} ${mbfl_ACCESSOR_NAME};"
    mbfl_ACCESSOR_BODY+='}'

    #echo $FUNCNAME mbfl_ACCESSOR_BODY="$mbfl_ACCESSOR_BODY" >&2
    mbfl_p_object_make_function "$mbfl_ACCESSOR_NAME" "$mbfl_ACCESSOR_BODY"
}

# This is the implementation of the slot accessor functions.
#
function mbfl_p_default_object_slot_accessor () {
    mbfl_mandatory_nameref_parameter(mbfl_VALUE,	1, the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_SELF,		2, variable referencing the default object)
    mbfl_mandatory_nameref_parameter(mbfl_REQUIRED_TYPE,3, variable referencing the default class)
    mbfl_mandatory_parameter(mbfl_FIELD_INDEX,		4, the field offset in the class instance)
    mbfl_mandatory_parameter(mbfl_CALLER_FUNCNAME,	5, the name of the calling function)

    if mbfl_default_object_is_of_class _(mbfl_SELF) _(mbfl_REQUIRED_TYPE)
    then mbfl_VALUE=mbfl_slot_ref(mbfl_SELF, $mbfl_FIELD_INDEX)
    else mbfl_p_default_class_mismatch_error_self_given_type _(mbfl_SELF) _(mbfl_REQUIRED_TYPE) "$mbfl_CALLER_FUNCNAME"
    fi
}

# This is the implementation of the slot mutator functions.
#
function mbfl_p_default_object_slot_mutator () {
    mbfl_mandatory_nameref_parameter(mbfl_SELF,		1, variable referencing the default object)
    mbfl_mandatory_parameter(mbfl_NEW_VALUE,		2, the new field value)
    mbfl_mandatory_nameref_parameter(mbfl_REQUIRED_TYPE,3, variable referencing the default class)
    mbfl_mandatory_parameter(mbfl_FIELD_INDEX,		4, the field offset in the class instance)
    mbfl_mandatory_parameter(mbfl_CALLER_FUNCNAME,	5, the name of the calling function)

    if mbfl_default_object_is_of_class _(mbfl_SELF) _(mbfl_REQUIRED_TYPE)
    then mbfl_slot_set(mbfl_SELF, $mbfl_FIELD_INDEX, "$mbfl_NEW_VALUE")
    else mbfl_p_default_class_mismatch_error_self_given_type _(mbfl_SELF) _(mbfl_REQUIRED_TYPE) "$mbfl_CALLER_FUNCNAME"
    fi
}

function mbfl_p_default_class_mismatch_error_self_given_type () {
    mbfl_mandatory_nameref_parameter(mbfl_SELF,		1, variable referencing a default object)
    mbfl_mandatory_nameref_parameter(mbfl_REQUIRED_TYPE,2, variable referencing a default class)
    mbfl_mandatory_parameter(mbfl_CALLER_FUNCNAME,	3, the name of the calling function)
    declare mbfl_SELF_TYPE mbfl_SELF_NAME mbfl_GIVEN_NAME

    mbfl_default_object_class_var mbfl_SELF_TYPE  _(mbfl_SELF)
    mbfl_default_class_name_var mbfl_SELF_NAME  $mbfl_SELF_TYPE
    mbfl_default_class_name_var mbfl_GIVEN_NAME _(mbfl_REQUIRED_TYPE)
    mbfl_message_error_printf 'in call to "%s": instance parameter "%s" of wrong type, expected "%s" got: "%s"' \
			      "$mbfl_CALLER_FUNCNAME" _(mbfl_SELF) "$mbfl_GIVEN_NAME" "$mbfl_SELF_NAME"
    return_because_failure
}


#### predicates

function mbfl_default_object_is_the_default_object () {
    mbfl_mandatory_parameter(mbfl_SELF_DATAVAR, 1, reference to data-structure instance)
    mbfl_string_eq(_(mbfl_default_object), "$mbfl_SELF_DATAVAR")
}

function mbfl_default_object_is_the_default_class () {
    mbfl_mandatory_parameter(mbfl_SELF_DATAVAR, 1, reference to data-structure instance)
    mbfl_string_eq(_(mbfl_default_class), "$mbfl_SELF_DATAVAR")
}


#### helper functions

function mbfl_p_object_make_function () {
    mbfl_mandatory_parameter(mbfl_FUNCNAME, 1, function name)
    mbfl_mandatory_parameter(mbfl_BODY,     2, function body)
    #echo function "$mbfl_FUNCNAME" '()' "$mbfl_BODY"; echo
    eval function "$mbfl_FUNCNAME" '()' "$mbfl_BODY"
}


#### predefined constants

if mbfl_string_neq_yes("$mbfl_INTERACTIVE")
then
    mbfl_default_object_declare(mbfl_predefined_constant)
    mbfl_default_class_define _(mbfl_predefined_constant) _(mbfl_default_object) 'mbfl_predefined_constant'

    mbfl_default_object_declare(mbfl_unspecified)
    mbfl_default_object_declare(mbfl_undefined)

    #declare -f -p mbfl_predefined_constant_define >&2
    mbfl_predefined_constant_define _(mbfl_unspecified)
    mbfl_predefined_constant_define _(mbfl_undefined)
fi

function mbfl_is_the_unspecified () {
    mbfl_mandatory_parameter(mbfl_SELF_DATAVAR, 1, reference to data-structure instance)
    mbfl_string_eq(_(mbfl_unspecified),"$mbfl_SELF_DATAVAR")
}
function mbfl_is_the_undefined () {
    mbfl_mandatory_parameter(mbfl_SELF_DATAVAR, 1, reference to data-structure instance)
    mbfl_string_eq(_(mbfl_undefined),"$mbfl_SELF_DATAVAR")
}

### end of file
# Local Variables:
# mode: sh
# End:
