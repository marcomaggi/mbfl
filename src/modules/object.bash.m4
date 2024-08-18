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
# Copyright (c) 2023, 2024 Marco Maggi
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

MBFL_DEFINE_QQ_MACRO()
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
m4_define([[[MBFL_STDOBJ__FUNCNAME_PATTERN__PREDICATE]]],	[[['%s_p']]])
m4_define([[[MBFL_STDOBJ__FUNCNAME_PATTERN__ACCESSOR]]],	[[['%s_%s_var']]])
m4_define([[[MBFL_STDOBJ__FUNCNAME_PATTERN__MUTATOR]]],		[[['%s_%s_set']]])


#### global variables

mbfl_default_class_declare(mbfl_default_object)
mbfl_default_class_declare(mbfl_default_class)
mbfl_default_class_declare(mbfl_default_abstract_class)


#### default object class
#
# The object "mbfl_default_object" is the default class of objects created by "mbfl_object_define".
#

mbfl_slot_set(mbfl_default_object, MBFL_STDOBJ__CLASS_INDEX,			_(mbfl_default_abstract_class))
mbfl_slot_set(mbfl_default_object, MBFL_STDCLS__FIELD_INDEX__PARENT,		'')
mbfl_slot_set(mbfl_default_object, MBFL_STDCLS__FIELD_INDEX__NAME,		'mbfl_default_object')
mbfl_slot_set(mbfl_default_object, MBFL_STDCLS__FIELD_INDEX__FIELDS_NUMBER,	0)

# This class adds no fields to its instances: we store nothing after the number of fields.


#### default metaclass
#
# The object "mbfl_default_class"  is the default class of classes  defined by "mbfl_default_class_define";
# it is also the class of itself.
#

mbfl_slot_set(mbfl_default_class, MBFL_STDOBJ__CLASS_INDEX,			_(mbfl_default_class))
mbfl_slot_set(mbfl_default_class, MBFL_STDCLS__FIELD_INDEX__PARENT,		_(mbfl_default_object))
mbfl_slot_set(mbfl_default_class, MBFL_STDCLS__FIELD_INDEX__NAME,		'mbfl_default_class')
mbfl_slot_set(mbfl_default_class, MBFL_STDCLS__FIELD_INDEX__FIELDS_NUMBER,	3)

# This class  adds fields to  its instances, so  we store their  specifications after the  number of
# fields.
mbfl_slot_set(mbfl_default_class, MBFL_STDCLS__FIELD_SPEC_INDEX__PARENT,        'parent')
mbfl_slot_set(mbfl_default_class, MBFL_STDCLS__FIELD_SPEC_INDEX__NAME,          'name')
mbfl_slot_set(mbfl_default_class, MBFL_STDCLS__FIELD_SPEC_INDEX__FIELDS_NUMBER, 'fields_number')


#### default abstract class
#
# The   object  "mbfl_default_abstract_class"   is  the   default  class   of  classes   defined  by
# "mbfl_default_abstract_class_define".
#

mbfl_slot_set(mbfl_default_abstract_class, MBFL_STDOBJ__CLASS_INDEX,			_(mbfl_default_class))
mbfl_slot_set(mbfl_default_abstract_class, MBFL_STDCLS__FIELD_INDEX__PARENT,		_(mbfl_default_class))
mbfl_slot_set(mbfl_default_abstract_class, MBFL_STDCLS__FIELD_INDEX__NAME,		'mbfl_default_abstract_class')
mbfl_slot_set(mbfl_default_abstract_class, MBFL_STDCLS__FIELD_INDEX__FIELDS_NUMBER,	3)

# This class  adds fields to  its instances, so  we store their  specifications after the  number of
# fields.
mbfl_slot_set(mbfl_default_abstract_class, MBFL_STDCLS__FIELD_SPEC_INDEX__PARENT,        'parent')
mbfl_slot_set(mbfl_default_abstract_class, MBFL_STDCLS__FIELD_SPEC_INDEX__NAME,          'name')
mbfl_slot_set(mbfl_default_abstract_class, MBFL_STDCLS__FIELD_SPEC_INDEX__FIELDS_NUMBER, 'fields_number')


#### predicates, accessors and operations for instances of "mbfl_default_class"

# Imperfect predicate:  attempt to  determine if the  given parameter is  a string  representing the
# datavar of a default instance.
#
function mbfl_default_object_maybe_p () {
    mbfl_mandatory_nameref_parameter(mbfl_SELF, 1, reference to datavar)
    test -v _(mbfl_SELF) -a -v _(mbfl_SELF,MBFL_STDOBJ__CLASS_INDEX) && \
	mbfl_default_classes_are_superclass_and_subclass _(mbfl_default_object) _(mbfl_SELF,MBFL_STDOBJ__CLASS_INDEX)
}

# Assuming SELF is  a standard object: return  true if the class of  SELF is CLASS or  a subclass of
# CLASS; otherwise return false.
#
function mbfl_default_object_is_a () {
    mbfl_mandatory_nameref_parameter(mbfl_SELF,  1, reference to instance of mbfl_default_object)
    mbfl_mandatory_nameref_parameter(mbfl_CLASS, 2, reference to instance of mbfl_default_class)

    #echo  _(mbfl_CLASS) _(mbfl_SELF,MBFL_STDOBJ__CLASS_INDEX) >&2
    mbfl_default_classes_are_same_or_superclass_and_subclass _(mbfl_CLASS) _(mbfl_SELF,MBFL_STDOBJ__CLASS_INDEX)
}
function mbfl_default_class_p () {
    mbfl_mandatory_nameref_parameter(mbfl_SELF, 1, reference to instance of mbfl_default_object)
    mbfl_default_object_is_a _(mbfl_SELF) _(mbfl_default_class)
}
function mbfl_default_metaclass_p () {
    mbfl_mandatory_nameref_parameter(mbfl_SELF, 1, reference to instance of mbfl_default_object)
    mbfl_default_class_p _(mbfl_SELF) && \
	mbfl_default_classes_are_same_or_superclass_and_subclass _(mbfl_default_class) _(mbfl_SELF)
}
function mbfl_default_abstract_class_p () {
    mbfl_mandatory_nameref_parameter(mbfl_SELF, 1, reference to instance of mbfl_default_object)
    mbfl_default_class_p _(mbfl_SELF) && \
	mbfl_default_classes_are_same_or_superclass_and_subclass _(mbfl_default_abstract_class) _(mbfl_SELF,MBFL_STDOBJ__CLASS_INDEX)
}

### ------------------------------------------------------------------------

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

### ------------------------------------------------------------------------

function mbfl_default_abstract_class_parent_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,    1, the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_CLASS, 2, variable referencing a default abstract class)
    mbfl_RV=mbfl_slot_ref(mbfl_CLASS, MBFL_STDCLS__FIELD_INDEX__PARENT)
}

function mbfl_default_abstract_class_name_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,    1, the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_CLASS, 2, variable referencing a default abstract class)
    mbfl_RV=mbfl_slot_ref(mbfl_CLASS, MBFL_STDCLS__FIELD_INDEX__NAME)
}

function mbfl_default_abstract_class_fields_number_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,    1, the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_CLASS, 2, variable referencing a default abstract class)
    mbfl_RV=mbfl_slot_ref(mbfl_CLASS, MBFL_STDCLS__FIELD_INDEX__FIELDS_NUMBER)
}

### ------------------------------------------------------------------------

function mbfl_default_classes_are_superclass_and_subclass () {
    mbfl_mandatory_nameref_parameter(mbfl_MAYBE_SUPERCLASS, 1, variable referencing a default class)
    mbfl_mandatory_nameref_parameter(mbfl_MAYBE_SUBCLASS,   2, variable referencing a default class)
    mbfl_declare_varref(mbfl_SUBCLASS_PARENT)

    mbfl_default_class_parent_var _(mbfl_SUBCLASS_PARENT) _(mbfl_MAYBE_SUBCLASS)
    # If the parent is empty: _(mbfl_MAYBE_SUBCLASS) is "mbfl_default_object".
    if mbfl_string_is_empty QQ(mbfl_SUBCLASS_PARENT)
    then return_failure
    else mbfl_default_classes_are_same_or_superclass_and_subclass _(mbfl_MAYBE_SUPERCLASS) QQ(mbfl_SUBCLASS_PARENT)
    fi
}
function mbfl_default_classes_are_same_or_superclass_and_subclass () {
    mbfl_mandatory_nameref_parameter(mbfl_CLASS_A, 1, variable referencing a default class)
    mbfl_mandatory_nameref_parameter(mbfl_CLASS_B, 2, variable referencing a default class)

    mbfl_string_eq(_(mbfl_CLASS_A), _(mbfl_CLASS_B)) || \
	mbfl_default_classes_are_superclass_and_subclass _(mbfl_CLASS_A) _(mbfl_CLASS_B)
}


#### data-structure instance handling

function mbfl_p_default_object_field_by_field_constructor () {
    mbfl_check_mandatory_parameters_number(3)
    mbfl_mandatory_nameref_parameter(mbfl_SELF,			1, reference to a default object)
    mbfl_mandatory_nameref_parameter(mbfl_CLASS,		2, reference to a default class)
    mbfl_mandatory_nameref_parameter(mbfl_FIELD_INIT_VALUES,	3, reference to an index array containing init field values)
    declare -i mbfl_TOTAL_FIELDS_NUMBER

    # Parameters validation.
    {
	if ! mbfl_default_class_p _(mbfl_CLASS)
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

function mbfl_default_object_class_var () {
    mbfl_check_mandatory_parameters_number(2)
    mbfl_mandatory_nameref_parameter(mbfl_CLASS_RV,	1, the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_SELF,		2, variable referencing an object of type mbfl_default_object)
    mbfl_CLASS_RV=_(mbfl_SELF, MBFL_STDOBJ__CLASS_INDEX)
}
function mbfl_default_object_class_name_var () {
    mbfl_check_mandatory_parameters_number(2)
    mbfl_mandatory_nameref_parameter(NAME, 1, result variable)
    mbfl_mandatory_nameref_parameter(OBJ,  2, default object)
    mbfl_declare_varref(CLASS)

    mbfl_default_object_class_var _(CLASS) _(OBJ)
    mbfl_default_class_name_var   _(NAME)  "$CLASS"
}

function mbfl_default_object_call_method () {
    mbfl_check_mandatory_parameters_number(2)
    mbfl_mandatory_nameref_parameter(mbfl_SELF, 1, reference to object of class mbfl_default_object)
    mbfl_mandatory_parameter(mbfl_METHOD,       2, method name)
    shift 2
    mbfl_declare_varref(mbfl_CLASS)
    mbfl_declare_varref(mbfl_NAME)
    declare mbfl_METHOD_FUNC

    mbfl_default_object_class_var _(mbfl_CLASS) _(mbfl_SELF)
    mbfl_default_class_name_var   _(mbfl_NAME)  "$mbfl_CLASS"

    if mbfl_function_exists [[["${mbfl_METHOD_FUNC:=${mbfl_NAME}_${mbfl_METHOD}}"]]]
    then "$mbfl_METHOD_FUNC" _(mbfl_SELF) "$@"
    else mbfl_default_object_unknown_method "$mbfl_METHOD_FUNC" _(mbfl_SELF) "$@"
    fi
}
function mbfl_default_object_unknown_method () {
    echo $FUNCNAME unknown method call: "$@" >&2
}

### ------------------------------------------------------------------------

# For a default object: rename an existing attribute mutator function to a hidden name; define a new
# attribute  mutator function  with the  original name;  the new  mutator calls  the old  mutator to
# perform the mutation.
#
# The new  mutator uses a predicate  to validate the new  attribute value: if the  predicate returns
# false an  exceptional-condition object  of type  "mbfl_invalid_object_attrib_value_condition_t" is
# raised.
#
function mbfl_default_object_make_predicate_mutator_from_mutator () {
    mbfl_check_mandatory_parameters_number(3)
    mbfl_mandatory_parameter(mbfl_ORIGINAL_MUTATOR_NAME,	1, untyped mutator name)
    mbfl_mandatory_parameter(mbfl_ATTRIB_NAME,			2, attribute value)
    mbfl_mandatory_parameter(mbfl_PREDICATE,			3, predicate name)
    declare mbfl_UNPRED_MUTATOR_NAME

    printf -v mbfl_UNPRED_MUTATOR_NAME 'mbfl_default_object_unpred_mutator_%s' "$mbfl_ORIGINAL_MUTATOR_NAME"

    declare mbfl_PRED_MUTATOR_NAME=$mbfl_ORIGINAL_MUTATOR_NAME
    declare mbfl_PRED_MUTATOR_BODY="{ "
    mbfl_PRED_MUTATOR_BODY+="mbfl_check_mandatory_parameters_number(2);"
    mbfl_PRED_MUTATOR_BODY+="declare -r mbfl_OBJ_DATAVAR=\${1:?\"missing default-object parameter to '\$FUNCNAME'\"};"
    mbfl_PRED_MUTATOR_BODY+="declare -r mbfl_ATTRIB_VALUE=\${2:?\"missing new attribute value parameter to '\$FUNCNAME'\"};"
    mbfl_PRED_MUTATOR_BODY+="mbfl_default_object__predicate_mutator_implementation \"\$mbfl_OBJ_DATAVAR\""
    mbfl_PRED_MUTATOR_BODY+=" '${mbfl_PRED_MUTATOR_NAME}' '${mbfl_UNPRED_MUTATOR_NAME}' '${mbfl_PREDICATE}'"
    mbfl_PRED_MUTATOR_BODY+=" '${mbfl_ATTRIB_NAME}' \"\$mbfl_ATTRIB_VALUE\";"
    mbfl_PRED_MUTATOR_BODY+='}'

    if ! mbfl_function_rename "$mbfl_ORIGINAL_MUTATOR_NAME" "$mbfl_UNPRED_MUTATOR_NAME"
    then return_because_failure
    fi
    eval function "$mbfl_ORIGINAL_MUTATOR_NAME" '()' "$mbfl_PRED_MUTATOR_BODY"
    #echo function "$mbfl_ORIGINAL_MUTATOR_NAME" '()' "$mbfl_PRED_MUTATOR_BODY" >&2
}
function mbfl_default_object__predicate_mutator_implementation () {
    mbfl_mandatory_nameref_parameter(mbfl_OBJ,		1, default-object reference)
    mbfl_mandatory_parameter(mbfl_PRED_MUTATOR_NAME,	2, typed mutator name)
    mbfl_mandatory_parameter(mbfl_UNPRED_MUTATOR_NAME,	3, untyped mutator name)
    mbfl_mandatory_parameter(mbfl_PREDICATE,		4, predicate name)
    mbfl_mandatory_parameter(mbfl_ATTRIB_NAME,		5, new attribute name)
    mbfl_mandatory_parameter(mbfl_ATTRIB_VALUE,		6, new attribute value)

    if "$mbfl_PREDICATE" "$mbfl_ATTRIB_VALUE"
    then "$mbfl_UNPRED_MUTATOR_NAME" _(mbfl_OBJ) "$mbfl_ATTRIB_VALUE"
    else
	mbfl_default_object_declare(mbfl_CND)

	mbfl_invalid_object_attrib_value_condition_make _(mbfl_CND) "$mbfl_PRED_MUTATOR_NAME" _(mbfl_OBJ) \
							"$mbfl_ATTRIB_NAME" "$mbfl_ATTRIB_VALUE"
	mbfl_exception_raise _(mbfl_CND)
    fi
}


#### API of "mbfl_default_class"

function mbfl_default_class_define () {
    mbfl_p_default_class_define false _(mbfl_default_class) "$@"
}
function mbfl_default_abstract_class_define () {
    mbfl_p_default_class_define true _(mbfl_default_abstract_class) "$@"
}
function mbfl_p_default_class_define () {
    mbfl_check_mandatory_parameters_number(5)
    mbfl_mandatory_nameref_parameter(mbfl_NEW_CLASS_IS_ABSTRACT,	1, expression evaluating to true if the new class is abstract)
    mbfl_mandatory_nameref_parameter(mbfl_META_CLASS,			2, reference to the metaclass of the new class)
    mbfl_mandatory_nameref_parameter(mbfl_NEW_CLASS,			3, reference to the new default class)
    mbfl_mandatory_nameref_parameter(mbfl_PARENT_CLASS,			4, reference to the parent default class)
    mbfl_mandatory_parameter(mbfl_NEW_CLASS_NAME,			5, the name of the new default class)
    shift 5
    mbfl_declare_index_array_varref(mbfl_NEW_FIELD_NAMES, ("$@"))

    # Validate parameters.
    {
	if ! mbfl_default_class_p _(mbfl_PARENT_CLASS)
	then
	    mbfl_message_error_printf 'in call to "%s" expected default class as parent class: "%s"' $FUNCNAME "$mbfl_PARENT_CLASS"
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
	mbfl_p_default_object_field_by_field_constructor _(mbfl_NEW_CLASS) _(mbfl_META_CLASS) _(mbfl_NEW_CLASS_FIELD_VALUES)
    }

    if ! mbfl_default_class_define__store_field_specifications _(mbfl_NEW_CLASS) _(mbfl_NEW_FIELD_NAMES)
    then return_because_failure
    fi

    if ! mbfl_default_class_define__check_field_name_uniqueness _(mbfl_NEW_CLASS)
    then return_because_failure
    fi

    if $mbfl_NEW_CLASS_IS_ABSTRACT
    then
	if ! mbfl_default_class_define__build_instance_constructor _(mbfl_NEW_CLASS)
	then return_because_failure
	fi
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
function mbfl_default_class_define__build_instance_constructor () {
    mbfl_mandatory_nameref_parameter(mbfl_NEW_CLASS, 1, reference to object of type mbfl_default_class)
    declare -r mbfl_NEW_CLASS_DATAVAR=_(mbfl_NEW_CLASS)
    declare -r mbfl_NEW_CLASS_NAME=_(mbfl_NEW_CLASS, MBFL_STDCLS__FIELD_INDEX__NAME)
    declare mbfl_CONSTRUCTOR_NAME mbfl_CONSTRUCTOR_BODY

    printf -v mbfl_CONSTRUCTOR_NAME MBFL_STDOBJ__FUNCNAME_PATTERN__CONSTRUCTOR "$mbfl_NEW_CLASS_NAME"

    mbfl_CONSTRUCTOR_BODY='{ '
    mbfl_CONSTRUCTOR_BODY+="declare -r mbfl_SELF_DATAVAR=\${1:?\"missing reference to instance of 'color' to '${mbfl_CONSTRUCTOR_NAME}'\"};"
    mbfl_CONSTRUCTOR_BODY+="shift;"
    mbfl_CONSTRUCTOR_BODY+="declare -ar mbfl_u_variable_FIELD_INIT_VALUES=(\"\$@\");"
    mbfl_CONSTRUCTOR_BODY+="mbfl_p_default_object_field_by_field_constructor "
    mbfl_CONSTRUCTOR_BODY+="\$mbfl_SELF_DATAVAR '${mbfl_NEW_CLASS_DATAVAR}' 'mbfl_u_variable_FIELD_INIT_VALUES';"
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
function mbfl_default_class_define__build_instance_predicate () {
    mbfl_mandatory_nameref_parameter(mbfl_NEW_CLASS, 1, reference to object of type mbfl_default_class)
    declare -r mbfl_NEW_CLASS_DATAVAR=_(mbfl_NEW_CLASS)
    declare -r mbfl_NEW_CLASS_NAME=_(mbfl_NEW_CLASS, MBFL_STDCLS__FIELD_INDEX__NAME)
    declare mbfl_PREDICATE_NAME mbfl_PREDICATE_BODY

    printf -v mbfl_PREDICATE_NAME MBFL_STDOBJ__FUNCNAME_PATTERN__PREDICATE "$mbfl_NEW_CLASS_NAME"

    mbfl_PREDICATE_BODY='{ '
    mbfl_PREDICATE_BODY+="declare mbfl_SELF_DATAVAR=\${1:?\"missing reference to data-structure parameter to '${mbfl_PREDICATE_NAME}'\"};"
    mbfl_PREDICATE_BODY+="mbfl_default_object_is_a \"\$mbfl_SELF_DATAVAR\" '${mbfl_NEW_CLASS_DATAVAR}' ;"
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
    mbfl_ACCESSOR_BODY+="mbfl_check_mandatory_parameters_number(2);"
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
    mbfl_mandatory_nameref_parameter(mbfl_VALUE,		1, the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_SELF,			2, variable referencing the default object)
    mbfl_mandatory_nameref_parameter(mbfl_REQUIRED_CLASS,	3, variable referencing the default class)
    mbfl_mandatory_parameter(mbfl_FIELD_INDEX,			4, the field offset in the class instance)
    mbfl_mandatory_parameter(mbfl_CALLER_FUNCNAME,		5, the name of the calling function)

    if mbfl_default_object_is_a _(mbfl_SELF) _(mbfl_REQUIRED_CLASS)
    then mbfl_VALUE=mbfl_slot_ref(mbfl_SELF, $mbfl_FIELD_INDEX)
    else
	mbfl_default_object_declare(CND)
	mbfl_declare_varref(mbfl_REQUIRED_CLASS_NAME)
	declare mbfl_ERRDESCR

	mbfl_default_class_name_var _(mbfl_REQUIRED_CLASS_NAME) _(mbfl_REQUIRED_CLASS)
	printf -v mbfl_ERRDESCR 'expected instance parameter of type: "%s"' "$mbfl_REQUIRED_CLASS_NAME"

	mbfl_invalid_function_parameter_condition_make _(CND) $mbfl_CALLER_FUNCNAME "$mbfl_ERRDESCR" 2 'SELF' "$mbfl_SELF"
	mbfl_exception_raise_then_return_failure(_(CND))
    fi
}

# This is the implementation of the slot mutator functions.
#
function mbfl_p_default_object_slot_mutator () {
    mbfl_mandatory_nameref_parameter(mbfl_SELF,		1, variable referencing the default object)
    mbfl_mandatory_parameter(mbfl_NEW_VALUE,		2, the new field value)
    mbfl_mandatory_nameref_parameter(mbfl_REQUIRED_CLASS,3, variable referencing the default class)
    mbfl_mandatory_parameter(mbfl_FIELD_INDEX,		4, the field offset in the class instance)
    mbfl_mandatory_parameter(mbfl_CALLER_FUNCNAME,	5, the name of the calling function)

    if mbfl_default_object_is_a _(mbfl_SELF) _(mbfl_REQUIRED_CLASS)
    then mbfl_slot_set(mbfl_SELF, $mbfl_FIELD_INDEX, "$mbfl_NEW_VALUE")
    else
	mbfl_default_object_declare(mbfl_CND)
	mbfl_declare_varref(mbfl_CLASS_NAME)
	declare mbfl_ERRDESCR

	mbfl_default_class_name_var _(mbfl_CLASS_NAME) _(mbfl_REQUIRED_CLASS)
	printf -v mbfl_ERRDESCR 'expected instance parameter of type: "%s"' "$mbfl_CLASS_NAME"

	mbfl_invalid_function_parameter_condition_make _(mbfl_CND) $mbfl_CALLER_FUNCNAME "$mbfl_ERRDESCR" 1 'SELF' "$mbfl_SELF"
	mbfl_exception_raise_then_return_failure(_(mbfl_CND))
    fi
}


#### predicates

function mbfl_the_default_object_p () {
    mbfl_optional_parameter(mbfl_SELF_DATAVAR, 1)
    mbfl_string_not_empty(mbfl_SELF_DATAVAR) && mbfl_string_eq(_(mbfl_default_object), "$mbfl_SELF_DATAVAR")
}

function mbfl_the_default_class_p () {
    mbfl_optional_parameter(mbfl_SELF_DATAVAR, 1)
    mbfl_string_not_empty(mbfl_SELF_DATAVAR) && mbfl_string_eq(_(mbfl_default_class), "$mbfl_SELF_DATAVAR")
}

function mbfl_the_default_abstract_class_p () {
    mbfl_optional_parameter(mbfl_SELF_DATAVAR, 1)
    mbfl_string_not_empty(mbfl_SELF_DATAVAR) && mbfl_string_eq(_(mbfl_default_abstract_class), "$mbfl_SELF_DATAVAR")
}


#### helper functions

function mbfl_p_object_make_function () {
    mbfl_mandatory_parameter(mbfl_FUNCNAME, 1, function name)
    mbfl_mandatory_parameter(mbfl_BODY,     2, function body)
    #echo function "$mbfl_FUNCNAME" '()' "$mbfl_BODY"; echo
    eval function "$mbfl_FUNCNAME" '()' "$mbfl_BODY"
}


#### predefined constants

mbfl_default_class_declare(mbfl_predefined_constant)
mbfl_default_class_define _(mbfl_predefined_constant) _(mbfl_default_object) 'mbfl_predefined_constant'

mbfl_default_object_declare(mbfl_unspecified)
mbfl_default_object_declare(mbfl_undefined)

mbfl_predefined_constant_define _(mbfl_unspecified)
mbfl_predefined_constant_define _(mbfl_undefined)

function mbfl_the_unspecified_p () {
    mbfl_optional_parameter(mbfl_SELF_DATAVAR, 1)
    mbfl_string_not_empty(mbfl_SELF_DATAVAR) && mbfl_string_eq(_(mbfl_unspecified),QQ(mbfl_SELF_DATAVAR))
}
function mbfl_the_undefined_p () {
    mbfl_optional_parameter(mbfl_SELF_DATAVAR, 1)
    mbfl_string_not_empty(mbfl_SELF_DATAVAR) && mbfl_string_eq(_(mbfl_undefined),QQ(mbfl_SELF_DATAVAR))
}

### end of file
# Local Variables:
# mode: sh
# End:
