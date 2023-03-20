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

# With one parameter is expands into a use  of "mbfl_datavar()"; with two parameters it expands into
# a use of "mbfl_slot_qref".
#
m4_define([[[_]]],[[[m4_ifelse($#,1,[[[mbfl_datavar([[[$1]]])]]],[[[mbfl_slot_qref([[[$1]]],[[[$2]]])]]])]]])

# An object  whose descriptor is a  child of "mbfl_standard_object" is  a Bash index array  with the
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

# A class whose descriptor is "mbfl_standard_class" is a Bash index array with the following layout,
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

m4_define([[[MBFL_STDCLS__FIELD_INDEX__PARENT]]],	m4_eval(MBFL_STDOBJ__FIRST_FIELD_INDEX + MBFL_STDCLS__FIELD_OFFSET__PARENT))
m4_define([[[MBFL_STDCLS__FIELD_INDEX__NAME]]],		m4_eval(MBFL_STDOBJ__FIRST_FIELD_INDEX + MBFL_STDCLS__FIELD_OFFSET__NAME))
m4_define([[[MBFL_STDCLS__FIELD_INDEX__FIELDS_NUMBER]]],m4_eval(MBFL_STDOBJ__FIRST_FIELD_INDEX + MBFL_STDCLS__FIELD_OFFSET__FIELDS_NUMBER))
m4_define([[[MBFL_STDCLS__FIRST_FIELD_SPEC_INDEX]]],	[[[4]]])

m4_define([[[MBFL_STDCLS__FIELD_SPEC_INDEX__PARENT]]],	[[[4]]])
m4_define([[[MBFL_STDCLS__FIELD_SPEC_INDEX__NAME]]],	[[[5]]])
m4_define([[[MBFL_STDCLS__FIELD_SPEC_INDEX__FIELDS_NUMBER]]],	[[[5]]])

# These are printf string patterns to format the names os class functions.
#
m4_define([[[MBFL_STDOBJ__FUNCNAME_PATTERN__CONSTRUCTOR]]],	[[['%s_define']]])
m4_define([[[MBFL_STDOBJ__FUNCNAME_PATTERN__PREDICATE]]],	[[['%s_is_a']]])
m4_define([[[MBFL_STDOBJ__FUNCNAME_PATTERN__ACCESSOR]]],	[[['%s_%s_var']]])
m4_define([[[MBFL_STDOBJ__FUNCNAME_PATTERN__MUTATOR]]],		[[['%s_%s_set']]])


#### global variables

if mbfl_string_neq_yes("$mbfl_INTERACTIVE")
then
    mbfl_standard_object_declare(mbfl_standard_object)
    mbfl_standard_object_declare(mbfl_standard_class)
fi


#### default data-structure type-descriptor
#
# The object "mbfl_standard_object" is the default class of objects created by "mbfl_object_define".
#

if mbfl_string_neq_yes("$mbfl_INTERACTIVE")
then
    mbfl_slot_set(mbfl_standard_object, MBFL_STDOBJ__CLASS_INDEX,		_(mbfl_standard_class))
    mbfl_slot_set(mbfl_standard_object, MBFL_STDCLS__FIELD_INDEX__PARENT,       '')
    mbfl_slot_set(mbfl_standard_object, MBFL_STDCLS__FIELD_INDEX__NAME,         'mbfl_standard_object')
    mbfl_slot_set(mbfl_standard_object, MBFL_STDCLS__FIELD_INDEX__FIELDS_NUMBER, 0)

    # This data-structure  type-descriptor adds no fields  to its instances: we  store nothing after
    # the number of fields.
fi


#### data-structure type-descriptor default meta-descriptor
#
# The object "mbfl_standard_class"  is the default class of classes  defined by "mbfl_standard_class_define";
# it is also the class of itself.
#

if mbfl_string_neq_yes("$mbfl_INTERACTIVE")
then
    mbfl_slot_set(mbfl_standard_class, MBFL_STDOBJ__CLASS_INDEX,		_(mbfl_standard_class))
    mbfl_slot_set(mbfl_standard_class, MBFL_STDCLS__FIELD_INDEX__PARENT,	_(mbfl_standard_object))
    mbfl_slot_set(mbfl_standard_class, MBFL_STDCLS__FIELD_INDEX__NAME,		'mbfl_standard_class')
    mbfl_slot_set(mbfl_standard_class, MBFL_STDCLS__FIELD_INDEX__FIELDS_NUMBER,	3)

    # This  struct-instance  type-descriptor  adds  fields  to its  instances,  so  we  store  their
    # specifications after the number of fields.
    mbfl_slot_set(mbfl_standard_class, MBFL_STDCLS__FIELD_SPEC_INDEX__PARENT,        'parent')
    mbfl_slot_set(mbfl_standard_class, MBFL_STDCLS__FIELD_SPEC_INDEX__NAME,          'name')
    mbfl_slot_set(mbfl_standard_class, MBFL_STDCLS__FIELD_SPEC_INDEX__FIELDS_NUMBER, 'fields_number')
fi


#### accessor functions for objects of type "mbfl_standard_class"

function mbfl_standard_class_is_a () {
    mbfl_mandatory_nameref_parameter(mbfl_SELF, 1, reference to instance of mbfl_standard_object)
    if test -v _(mbfl_SELF) -a -v mbfl_slot_spec(mbfl_SELF,MBFL_STDOBJ__CLASS_INDEX)
    then mbfl_standard_classes_are_parent_and_child _(mbfl_standard_class) _(mbfl_SELF,MBFL_STDOBJ__CLASS_INDEX)
    else false
    fi
}

function mbfl_standard_metaclass_is_a () {
    mbfl_mandatory_nameref_parameter(mbfl_SELF, 1, reference to instance of mbfl_standard_object)
    if mbfl_standard_class_is_a _(mbfl_SELF)
    then
	mbfl_string_eq(_(mbfl_standard_class), _(mbfl_SELF)) ||
	    mbfl_standard_classes_are_parent_and_child _(mbfl_standard_class) _(mbfl_SELF)
    else false
    fi
}

function mbfl_standard_class_parent_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,   1, the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_CLASS, 2, variable referencing a data-structure type-descriptor)
    mbfl_RV=mbfl_slot_ref(mbfl_CLASS, MBFL_STDCLS__FIELD_INDEX__PARENT)
}

function mbfl_standard_class_name_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,   1, the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_CLASS, 2, variable referencing a data-structure type-descriptor)
    mbfl_RV=mbfl_slot_ref(mbfl_CLASS, MBFL_STDCLS__FIELD_INDEX__NAME)
}

function mbfl_standard_class_fields_number_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,   1, the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_CLASS, 2, variable referencing a data-structure type-descriptor)
    mbfl_RV=mbfl_slot_ref(mbfl_CLASS, MBFL_STDCLS__FIELD_INDEX__FIELDS_NUMBER)
}

function mbfl_standard_classes_are_parent_and_child () {
    mbfl_mandatory_nameref_parameter(mbfl_MAYBE_PARENT, 1, variable referencing a data-structure type-descriptor)
    mbfl_mandatory_nameref_parameter(mbfl_MAYBE_CHILD,  2, variable referencing a data-structure type-descriptor)

    if mbfl_string_eq(_(mbfl_MAYBE_PARENT), _(mbfl_MAYBE_CHILD))
    then return_success
    else
	declare mbfl_CHILD_PARENT
	mbfl_standard_class_parent_var mbfl_CHILD_PARENT _(mbfl_MAYBE_CHILD)
	if mbfl_string_is_empty "$mbfl_CHILD_PARENT"
	then return_failure
	else mbfl_standard_classes_are_parent_and_child _(mbfl_MAYBE_PARENT) "$mbfl_CHILD_PARENT"
	fi
    fi
}


#### data-structure instance handling

function mbfl_p_standard_object_define () {
    mbfl_mandatory_nameref_parameter(mbfl_SELF, 1, reference to a data-structure instance)
    mbfl_mandatory_nameref_parameter(mbfl_TYPE, 2, reference to a data-structure type-descriptor)
    shift 2
    declare -a mbfl_FIELD_INIT_VALUES=("$@")

    # Validate parameters.
    {
	if ! mbfl_standard_object_is_a _(mbfl_TYPE)
	then
	    mbfl_message_error_printf 'in call to "%s" expected type-descriptor as type-descriptor parameter: "%s"' $FUNCNAME "$mbfl_TYPE"
	    return_because_failure
	fi
    }

    mbfl_slot_set(mbfl_SELF, MBFL_STDOBJ__CLASS_INDEX, _(mbfl_TYPE))

    {
	declare -i mbfl_FIELDS_NUMBER
	mbfl_standard_class_fields_number_var mbfl_FIELDS_NUMBER _(mbfl_TYPE)
	if ((mbfl_slots_number(mbfl_FIELD_INIT_VALUES) == $mbfl_FIELDS_NUMBER))
	then
	    declare -i mbfl_I
	    #echo $FUNCNAME mbfl_FIELDS_NUMBER $mbfl_FIELDS_NUMBER >&2
	    for ((mbfl_I=0; mbfl_I < mbfl_FIELDS_NUMBER; ++mbfl_I))
	    do mbfl_slot_set(mbfl_SELF, 1+mbfl_I, mbfl_slot_qref(mbfl_FIELD_INIT_VALUES, mbfl_I))
	    done
	else
	    mbfl_message_error_printf 'wrong number of field initial values in call to "%s", expected %d, got %d' \
				      $FUNCNAME $mbfl_FIELDS_NUMBER mbfl_slots_number(mbfl_FIELD_INIT_VALUES)
	    return_because_failure
	fi
    }
}

# Return true if the given parameter is an instance of "mbfl_standard_object".  We do our best.
#
function mbfl_standard_object_is_a () {
    mbfl_mandatory_nameref_parameter(mbfl_SELF, 1, variable referencing a data-structure instance)

    if test -v _(mbfl_SELF) -a -v mbfl_slot_spec(mbfl_SELF,MBFL_STDOBJ__CLASS_INDEX)
    then mbfl_standard_classes_are_parent_and_child _(mbfl_standard_object) _(mbfl_SELF,MBFL_STDOBJ__CLASS_INDEX)
    else false
    fi
}

function mbfl_standard_object_is_of_class () {
    mbfl_mandatory_nameref_parameter(mbfl_OBJECT, 1, variable referencing an object of class mbfl_standard_object)
    mbfl_mandatory_nameref_parameter(mbfl_CLASS,  2, variable referencing a class of class mbfl_standard_object)

    if test -v _(mbfl_OBJECT) -a -v mbfl_slot_spec(mbfl_OBJECT,MBFL_STDOBJ__CLASS_INDEX)
    then mbfl_standard_classes_are_parent_and_child _(mbfl_CLASS) _(mbfl_OBJECT,MBFL_STDOBJ__CLASS_INDEX)
    else false
    fi
}

# We can apply this funtion to both data-structure instances and data-structure type-descriptors.
#
function mbfl_standard_object_class_var () {
    mbfl_mandatory_nameref_parameter(mbfl_TYPE_RV,	1, the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_SELF,		2, variable referencing a data structure)
    mbfl_TYPE_RV=_(mbfl_SELF, MBFL_STDOBJ__CLASS_INDEX)
}


#### API of "mbfl_standard_class": data-structure type-descriptor definition

function mbfl_standard_class_define () {
    mbfl_mandatory_nameref_parameter(mbfl_TYPE,		1, reference to the new data-structure type-descriptor)
    mbfl_mandatory_nameref_parameter(mbfl_PARENT,	2, reference to the parent data-structure type-descriptor)
    mbfl_mandatory_parameter(mbfl_NAME,			3, the name of the new data-structure type-descriptor)
    shift 3

    # Validate parameters.
    {
	if ! mbfl_standard_class_is_a _(mbfl_PARENT)
	then
	    mbfl_message_error_printf 'in call to "%s" expected type-descriptor as parent parameter: "%s"' $FUNCNAME "$mbfl_PARENT"
	    return_because_failure
	fi

	if ! mbfl_string_is_identifier "$mbfl_NAME"
	then
	    mbfl_message_error_printf 'in call to "%s" expected identifier as type name: "%s"' $FUNCNAME "$mbfl_NAME"
	    return_because_failure
	fi
    }

    declare -ar mbfl_NEW_FIELD_NAMES=("$@")
    declare -ir mbfl_NEW_FIELDS_NUMBER=mbfl_slots_number(mbfl_NEW_FIELD_NAMES)
    declare -i  mbfl_TOTAL_FIELDS_NUMBER
    declare -i  mbfl_I mbfl_J
    declare -r  mbfl_TYPE_DATAVAR=_(mbfl_TYPE)

    # Initialise the fields of the new data-structure type-descriptor.
    {
	declare -i  mbfl_PARENT_FIELDS_NUMBER
	mbfl_standard_class_fields_number_var mbfl_PARENT_FIELDS_NUMBER _(mbfl_PARENT)
	let mbfl_TOTAL_FIELDS_NUMBER=mbfl_PARENT_FIELDS_NUMBER+mbfl_NEW_FIELDS_NUMBER

	mbfl_p_standard_object_define _(mbfl_TYPE) _(mbfl_standard_class) _(mbfl_PARENT) "$mbfl_NAME" $mbfl_TOTAL_FIELDS_NUMBER
	# Copy the fields from the parent
	for ((mbfl_I=0; mbfl_I < mbfl_PARENT_FIELDS_NUMBER; ++mbfl_I))
	do mbfl_slot_set(mbfl_TYPE,                  MBFL_STDCLS__FIRST_FIELD_SPEC_INDEX + mbfl_I,
			 mbfl_slot_qref(mbfl_PARENT, MBFL_STDCLS__FIRST_FIELD_SPEC_INDEX + mbfl_I))
	done
	# Store the new fields.
	for ((mbfl_I=0; mbfl_I < mbfl_NEW_FIELDS_NUMBER; ++mbfl_I))
	do mbfl_slot_set(mbfl_TYPE, mbfl_PARENT_FIELDS_NUMBER +  MBFL_STDCLS__FIRST_FIELD_SPEC_INDEX + mbfl_I,
			 mbfl_slot_qref(mbfl_NEW_FIELD_NAMES, mbfl_I))
	done
    }

    # Check that the field names are unique.
    {
	declare mbfl_FIELD_NAME

	for ((mbfl_I=0; mbfl_I < mbfl_TOTAL_FIELDS_NUMBER; ++mbfl_I))
	do
	    mbfl_FIELD_NAME=_(mbfl_TYPE, MBFL_STDCLS__FIRST_FIELD_SPEC_INDEX + mbfl_I)
	    for ((mbfl_J=1+mbfl_I; mbfl_J < mbfl_TOTAL_FIELDS_NUMBER; ++mbfl_J))
	    do
		if mbfl_string_eq($mbfl_FIELD_NAME, _(mbfl_TYPE, MBFL_STDCLS__FIRST_FIELD_SPEC_INDEX + mbfl_J))
		then
		    mbfl_message_error_printf 'duplicate field name in the definition of type "%s": "%s"' "$mbfl_NAME" "$mbfl_FIELD_NAME"
		    return_because_failure
		fi
	    done
	done
    }

    # We need to iterate over the fields; we could use a single loop statement, but a loop statement
    # for every purpose makes the code more readable.

    # Build the data-structure instance-constructor function.
    {
	declare mbfl_CONSTRUCTOR_NAME mbfl_CONSTRUCTOR_BODY
	declare mbfl_PARAMETER_COUNT

	printf -v mbfl_CONSTRUCTOR_NAME MBFL_STDOBJ__FUNCNAME_PATTERN__CONSTRUCTOR "$mbfl_NAME"

	mbfl_CONSTRUCTOR_BODY='{ '
	mbfl_CONSTRUCTOR_BODY+="local -n mbfl_SELF=\${1:"
	mbfl_CONSTRUCTOR_BODY+="?\"missing reference to struct '${mbfl_NAME}' variable parameter to '\${FUNCNAME}'\"};"
	mbfl_CONSTRUCTOR_BODY+="mbfl_SELF[0]=${mbfl_TYPE_DATAVAR};"
	for ((mbfl_I=0, mbfl_PARAMETER_COUNT=2; mbfl_I < mbfl_TOTAL_FIELDS_NUMBER; ++mbfl_I, ++mbfl_PARAMETER_COUNT))
	do
	    declare mbfl_FIELD_NAME=mbfl_slot_ref(mbfl_TYPE, MBFL_STDCLS__FIRST_FIELD_SPEC_INDEX + $mbfl_I)
	    declare mbfl_OFFSET=$((MBFL_STDOBJ__FIRST_FIELD_INDEX + $mbfl_I))
	    mbfl_CONSTRUCTOR_BODY+="mbfl_SELF[$mbfl_OFFSET]=\${$mbfl_PARAMETER_COUNT:?"
	    mbfl_CONSTRUCTOR_BODY+="\"missing field value parameter '$mbfl_FIELD_NAME' to '\$FUNCNAME'\"};"
	done
	mbfl_CONSTRUCTOR_BODY+='}'
	mbfl_p_struct_make_function "$mbfl_CONSTRUCTOR_NAME" "$mbfl_CONSTRUCTOR_BODY"
    }

    # Build the data-structure type-predicate function: return true if a struct instance is of type "".
    {
	declare mbfl_PREDICATE_NAME mbfl_PREDICATE_BODY

	printf -v mbfl_PREDICATE_NAME  MBFL_STDOBJ__FUNCNAME_PATTERN__PREDICATE   "$mbfl_NAME"
	mbfl_PREDICATE_BODY="{ declare mbfl_SELF_DATAVAR=\${1:?\"missing reference to data-structure parameter to '\$FUNCNAME'\"};"
	mbfl_PREDICATE_BODY+="mbfl_standard_object_is_of_class \"\$mbfl_SELF_DATAVAR\" '${mbfl_TYPE_DATAVAR}' ; }"
	mbfl_p_struct_make_function "$mbfl_PREDICATE_NAME" "$mbfl_PREDICATE_BODY"
    }

    # Build the data-structure field-mutator functions.
    {
	for ((mbfl_I=0, mbfl_PARAMETER_COUNT=2; mbfl_I < mbfl_TOTAL_FIELDS_NUMBER; ++mbfl_I, ++mbfl_PARAMETER_COUNT))
	do
	    declare mbfl_MUTATOR_NAME mbfl_MUTATOR_BODY
	    declare mbfl_FIELD_NAME=mbfl_slot_ref(mbfl_TYPE, MBFL_STDCLS__FIRST_FIELD_SPEC_INDEX + $mbfl_I)
	    declare mbfl_OFFSET=$((MBFL_STDOBJ__FIRST_FIELD_INDEX + $mbfl_I))

	    printf -v mbfl_MUTATOR_NAME MBFL_STDOBJ__FUNCNAME_PATTERN__MUTATOR "$mbfl_NAME" "$mbfl_FIELD_NAME"
	    mbfl_MUTATOR_BODY='{ '
	    mbfl_MUTATOR_BODY+="declare -n mbfl_SELF=\${1:?\"missing reference to struct '${mbfl_NAME}' parameter to '${mbfl_MUTATOR_NAME}'\"};"
	    mbfl_MUTATOR_BODY+="declare mbfl_NEW_VALUE=\${2:?\"missing new field value parameter to '${mbfl_MUTATOR_NAME}'\"};"
	    mbfl_MUTATOR_BODY+="mbfl_standard_object_slot_mutator \$1 \$2 ${mbfl_TYPE_DATAVAR} ${mbfl_OFFSET} ${mbfl_MUTATOR_NAME};"
	    mbfl_MUTATOR_BODY+='}'
	    mbfl_p_struct_make_function "$mbfl_MUTATOR_NAME" "$mbfl_MUTATOR_BODY"
	done
    }

    # Build the data-structure field-accessor functions.
    {
	for ((mbfl_I=0, mbfl_PARAMETER_COUNT=2; mbfl_I < mbfl_TOTAL_FIELDS_NUMBER; ++mbfl_I, ++mbfl_PARAMETER_COUNT))
	do
	    declare mbfl_ACCESSOR_NAME mbfl_ACCESSOR_BODY
	    declare mbfl_FIELD_NAME=mbfl_slot_ref(mbfl_TYPE, MBFL_STDCLS__FIRST_FIELD_SPEC_INDEX + $mbfl_I)
	    declare mbfl_OFFSET=$((MBFL_STDOBJ__FIRST_FIELD_INDEX + $mbfl_I))

	    printf -v mbfl_ACCESSOR_NAME MBFL_STDOBJ__FUNCNAME_PATTERN__ACCESSOR "$mbfl_NAME" "$mbfl_FIELD_NAME"
	    mbfl_ACCESSOR_BODY='{ '
	    mbfl_ACCESSOR_BODY+="declare -n mbfl_RV=\${1:?\"missing result variable parameter to '${mbfl_ACCESSOR_NAME}'\"};"
	    mbfl_ACCESSOR_BODY+="declare -n mbfl_SELF=\${2:?\"missing reference to struct '$mbfl_NAME' parameter to '${mbfl_ACCESSOR_NAME}'\"};"
	    mbfl_ACCESSOR_BODY+="mbfl_standard_object_slot_accessor \$1 \$2 ${mbfl_TYPE_DATAVAR} ${mbfl_OFFSET} ${mbfl_ACCESSOR_NAME};"
	    mbfl_ACCESSOR_BODY+='}'
	    mbfl_p_struct_make_function "$mbfl_ACCESSOR_NAME" "$mbfl_ACCESSOR_BODY"
	done
    }
}

# This is the implementation of the slot accessor functions.
#
function mbfl_standard_object_slot_accessor () {
    mbfl_mandatory_nameref_parameter(mbfl_VALUE,	1, the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_SELF,		2, variable referencing the data-structure instance)
    mbfl_mandatory_nameref_parameter(mbfl_REQUIRED_TYPE,3, variable referencing the data-structure type-descriptor)
    mbfl_mandatory_parameter(mbfl_FIELD_OFFSET,		4, the field offset in the data-structure instance)
    mbfl_mandatory_parameter(mbfl_CALLER_FUNCNAME,	5, the name of the calling function)

    if mbfl_standard_object_is_of_class _(mbfl_SELF) _(mbfl_REQUIRED_TYPE)
    then mbfl_VALUE=mbfl_slot_ref(mbfl_SELF, $mbfl_FIELD_OFFSET)
    else mbfl_p_standard_class_mismatch_error_self_given_type _(mbfl_SELF) _(mbfl_REQUIRED_TYPE) "$mbfl_CALLER_FUNCNAME"
    fi
}

# This is the implementation of the slot mutator functions.
#
function mbfl_standard_object_slot_mutator () {
    mbfl_mandatory_nameref_parameter(mbfl_SELF,		1, variable referencing the data-structure instance)
    mbfl_mandatory_parameter(mbfl_NEW_VALUE,		2, the new field value)
    mbfl_mandatory_nameref_parameter(mbfl_REQUIRED_TYPE,3, variable referencing the data-structure type-descriptor)
    mbfl_mandatory_parameter(mbfl_FIELD_OFFSET,		4, the field offset in the data-structure instance)
    mbfl_mandatory_parameter(mbfl_CALLER_FUNCNAME,	5, the name of the calling function)

    if mbfl_standard_object_is_of_class _(mbfl_SELF) _(mbfl_REQUIRED_TYPE)
    then mbfl_slot_set(mbfl_SELF, $mbfl_FIELD_OFFSET, "$mbfl_NEW_VALUE")
    else mbfl_p_standard_class_mismatch_error_self_given_type _(mbfl_SELF) _(mbfl_REQUIRED_TYPE) "$mbfl_CALLER_FUNCNAME"
    fi
}

function mbfl_p_standard_class_mismatch_error_self_given_type () {
    mbfl_mandatory_nameref_parameter(mbfl_SELF,		1, variable referencing a data-structure instance)
    mbfl_mandatory_nameref_parameter(mbfl_REQUIRED_TYPE,2, variable referencing a data-structure type-descriptor)
    mbfl_mandatory_parameter(mbfl_CALLER_FUNCNAME,	3, the name of the calling function)
    declare mbfl_SELF_TYPE mbfl_SELF_NAME mbfl_GIVEN_NAME

    mbfl_standard_object_class_var mbfl_SELF_TYPE  _(mbfl_SELF)
    mbfl_standard_class_name_var mbfl_SELF_NAME  $mbfl_SELF_TYPE
    mbfl_standard_class_name_var mbfl_GIVEN_NAME _(mbfl_REQUIRED_TYPE)
    mbfl_message_error_printf 'in call to "%s": instance parameter "%s" of wrong type, expected "%s" got: "%s"' \
			      "$mbfl_CALLER_FUNCNAME" _(mbfl_SELF) "$mbfl_GIVEN_NAME" "$mbfl_SELF_NAME"
    return_because_failure
}


#### data-structure type-descriptor handling functions

function mbfl_standard_object_is_the_standard_object () {
    mbfl_mandatory_parameter(mbfl_SELF_DATAVAR, 1, reference to data-structure instance)
    mbfl_string_eq(_(mbfl_standard_object), "$mbfl_SELF_DATAVAR")
}

function mbfl_standard_object_is_the_standard_class () {
    mbfl_mandatory_parameter(mbfl_SELF_DATAVAR, 1, reference to data-structure instance)
    mbfl_string_eq(_(mbfl_standard_class), "$mbfl_SELF_DATAVAR")
}


#### helper functions

function mbfl_p_struct_make_function () {
    mbfl_mandatory_parameter(mbfl_FUNCNAME, 1, function name)
    mbfl_mandatory_parameter(mbfl_BODY,     2, function body)
    #echo function "$mbfl_FUNCNAME" '()' "$mbfl_BODY"; echo
    eval function "$mbfl_FUNCNAME" '()' "$mbfl_BODY"
}


#### predefined constants

if mbfl_string_neq_yes("$mbfl_INTERACTIVE")
then
    mbfl_standard_object_declare(mbfl_predefined_constant)
    mbfl_standard_class_define _(mbfl_predefined_constant) _(mbfl_standard_object) 'mbfl_predefined_constant'

    mbfl_standard_object_declare(mbfl_unspecified)
    mbfl_standard_object_declare(mbfl_undefined)

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
