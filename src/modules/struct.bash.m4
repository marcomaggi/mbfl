# struct.bash.m4 --
#
# Part of: Marco's BASH functions library
# Contents: data structures module
# Date: Mar 12, 2023
#
# Abstract
#
#	Simple data structures implementation on top of index arrays.
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

m4_define([[[_]]],[[[mbfl_datavar([[[$1]]])]]])

m4_define([[[MBFL_STRUCT_FIRST_FIELD_OFFSET]]],			[[[1]]])
m4_define([[[MBFL_TYPE_DESCR_FIELD_OFFSET_FIRST_FIELD]]],	[[[4]]])

# To    use    these    we    need    to   add    them    to    MBFL_STRUCT_FIRST_FIELD_OFFSET    or
# MBFL_TYPE_DESCR_FIELD_OFFSET_FIRST_FIELD.
m4_define([[[MBFL_TYPE_DESCR_FIELD_OFFSET_PARENT]]],		[[[0]]])
m4_define([[[MBFL_TYPE_DESCR_FIELD_OFFSET_NAME]]],		[[[1]]])
m4_define([[[MBFL_TYPE_DESCR_FIELD_OFFSET_FIELDS_NUMBER]]],	[[[2]]])

m4_define([[[MBFL_STRUCT_FUNCNAME_PATTERN_CONSTRUCTOR]]],	[[['%s_init']]])
m4_define([[[MBFL_STRUCT_FUNCNAME_PATTERN_PREDICATE]]],		[[['%s?']]])
m4_define([[[MBFL_STRUCT_FUNCNAME_PATTERN_ACCESSOR]]],		[[['%s_%s_ref']]])
m4_define([[[MBFL_STRUCT_FUNCNAME_PATTERN_MUTATOR]]],		[[['%s_%s_set']]])


#### data-structure type-descriptor descriptor
#
# The data structure "mbfl_struct_top"  is the type of all the data structure  types; it is also the
# type of itself.
#

if true ; #mbfl_string_neq_yes("$mbfl_INTERACTIVE")
then
    mbfl_struct_declare(mbfl_struct_top)

    # Slot  0 of  "mbfl_struct_top"  holds the  data  variable of  "mbfl_struct_top".   The type  of
    # "mbfl_struct_top" is "mbfl_struct_top" itself.  This is not a field.
    mbfl_slot_set(mbfl_struct_top, 0, _(mbfl_struct_top))

    # Slot 1  is field  0: it is  the data variable  of the  parent type of  "mbfl_struct_top".  The
    # parent type of "mbfl_struct_top" is void.
    {
	mbfl_slot_set(mbfl_struct_top,
		      m4_eval(MBFL_STRUCT_FIRST_FIELD_OFFSET           + MBFL_TYPE_DESCR_FIELD_OFFSET_PARENT), '')
	mbfl_slot_set(mbfl_struct_top,
		      m4_eval(MBFL_TYPE_DESCR_FIELD_OFFSET_FIRST_FIELD + MBFL_TYPE_DESCR_FIELD_OFFSET_PARENT), 'parent')
    }

    # Slot 2 is field 1: it is the name of the data structure type.
    {
	mbfl_slot_set(mbfl_struct_top,
		      m4_eval(MBFL_STRUCT_FIRST_FIELD_OFFSET           + MBFL_TYPE_DESCR_FIELD_OFFSET_NAME), 'mbfl_struct_top')
	mbfl_slot_set(mbfl_struct_top,
		      m4_eval(MBFL_TYPE_DESCR_FIELD_OFFSET_FIRST_FIELD + MBFL_TYPE_DESCR_FIELD_OFFSET_NAME), 'name')
    }

    # Slot 3 is field 2: it is the number of fields in "mbfl_struct_top".
    {
	mbfl_slot_set(mbfl_struct_top,
		      m4_eval(MBFL_STRUCT_FIRST_FIELD_OFFSET           + MBFL_TYPE_DESCR_FIELD_OFFSET_FIELDS_NUMBER), 3)
	mbfl_slot_set(mbfl_struct_top,
		      m4_eval(MBFL_TYPE_DESCR_FIELD_OFFSET_FIRST_FIELD + MBFL_TYPE_DESCR_FIELD_OFFSET_FIELDS_NUMBER), 'fields_number')
    }
fi


#### data-structure type-descriptor ultimate parent
#
# The  data structure  "mbfl_struct_top_descriptor" is  ultimate  parent of  all the  data-structure
# type-descriptors.  It is itself a data-structure instance of type "mbfl_struct_top".
#

if true ; #mbfl_string_neq_yes("$mbfl_INTERACTIVE")
then
    mbfl_struct_declare(mbfl_struct_top_descriptor)

    # Slot 0 of "mbfl_struct_top_descriptor" holds the  data variable of "mbfl_struct_top".  This is
    # not a field.
    mbfl_slot_set(mbfl_struct_top_descriptor, 0, _(mbfl_struct_top))

    # Slot 1 is field 0: it is the data variable of the parent type of "mbfl_struct_top_descriptor".
    # The parent type of "mbfl_struct_top_descriptor" is void.
    mbfl_slot_set(mbfl_struct_top_descriptor,
		  m4_eval(MBFL_STRUCT_FIRST_FIELD_OFFSET + MBFL_TYPE_DESCR_FIELD_OFFSET_PARENT),
		  '')

    # Slot 2 is field 1: it is the name of the data-structure type.
    mbfl_slot_set(mbfl_struct_top_descriptor,
		  m4_eval(MBFL_STRUCT_FIRST_FIELD_OFFSET + MBFL_TYPE_DESCR_FIELD_OFFSET_NAME),
		  'mbfl_struct_top_descriptor')

    # Slot 3 is field 2: it is the number of fields in "mbfl_struct_top_descriptor".
    mbfl_slot_set(mbfl_struct_top_descriptor,
		  m4_eval(MBFL_STRUCT_FIRST_FIELD_OFFSET + MBFL_TYPE_DESCR_FIELD_OFFSET_FIELDS_NUMBER),
		  0)
fi


#### data-structure type-descriptor handling functions

# Return  true  if the  parameter  is  a  string representing  the  name  of  the data  variable  of
# "mbfl_struct_top".
#
function mbfl_struct_top? () {
    mbfl_mandatory_parameter(mbfl_STRU, 1, data variable)
    mbfl_string_equal _(mbfl_struct_top) "$mbfl_STRU"
}

# Return  true  if the  parameter  is  a  string representing  the  name  of  the data  variable  of
# "mbfl_struct_top_descriptor".
#
function mbfl_struct_top_descriptor? () {
    mbfl_mandatory_parameter(mbfl_STRU, 1, data variable)
    mbfl_string_equal _(mbfl_struct_top_descriptor) "$mbfl_STRU"
}

# Return true  if the parameter  is the data  variable of a data  structure and this  data structure
# represents a structure type descriptor.
#
function mbfl_struct_descriptor? () {
    mbfl_mandatory_nameref_parameter(mbfl_STRU, 1, reference to data structure type variable)
    declare TYPE
    mbfl_struct_type_var TYPE _(mbfl_STRU)
    mbfl_string_equal _(mbfl_struct_top) "$TYPE"
}

# Given the  data variable  of a data-structure  type-descriptor: store in  the result  variable the
# value of the field "parent".
#
function mbfl_struct_descriptor_parent_var () {
    mbfl_mandatory_nameref_parameter(mbfl_VALUE, 1, the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_TYPE,  2, variable referencing a data structure type descriptor)
    mbfl_VALUE=mbfl_slot_ref(mbfl_TYPE, m4_eval(MBFL_STRUCT_FIRST_FIELD_OFFSET + MBFL_TYPE_DESCR_FIELD_OFFSET_PARENT))
}

# Given the  data variable  of a data-structure  type-descriptor: store in  the result  variable the
# value of the field "name".
#
function mbfl_struct_descriptor_name_var () {
    mbfl_mandatory_nameref_parameter(mbfl_VALUE, 1, the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_TYPE,  2, variable referencing a data structure type descriptor)
    mbfl_VALUE=mbfl_slot_ref(mbfl_TYPE, m4_eval(MBFL_STRUCT_FIRST_FIELD_OFFSET + MBFL_TYPE_DESCR_FIELD_OFFSET_NAME))
}

# Given the  data variable  of a data-structure  type-descriptor: store in  the result  variable the
# value of the field "fields_number".
#
function mbfl_struct_descriptor_fields_number_var () {
    mbfl_mandatory_nameref_parameter(mbfl_VALUE, 1, the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_TYPE,  2, variable referencing a data structure type descriptor)
    mbfl_VALUE=mbfl_slot_ref(mbfl_TYPE, m4_eval(MBFL_STRUCT_FIRST_FIELD_OFFSET + MBFL_TYPE_DESCR_FIELD_OFFSET_FIELDS_NUMBER))
}


#### struct instance handling

function mbfl_struct_define () {
    mbfl_mandatory_nameref_parameter(mbfl_SELF, 1, reference to a data-structure instance)
    mbfl_mandatory_nameref_parameter(mbfl_TYPE, 2, reference to a data-structure type-descriptor)
    shift 2
    declare -a mbfl_FIELD_INIT_VALUES=("$@")

    mbfl_slot_set(mbfl_SELF, 0, _(mbfl_TYPE))

    {
	declare -i mbfl_FIELDS_NUMBER
	mbfl_struct_descriptor_fields_number_var mbfl_FIELDS_NUMBER _(mbfl_TYPE)
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

# Return true if the  given data-structure instance if of the specified type.   This means the given
# type is in the linked list of types from the instance.
#
function mbfl_struct_is_a () {
    mbfl_mandatory_nameref_parameter(mbfl_SELF,		1, variable referencing a data-structure instance)
    mbfl_mandatory_nameref_parameter(mbfl_GIVEN_TYPE,	2, variable referencing a data-structure type-descriptor)

    if test -v _(mbfl_SELF) -a -v mbfl_slot_spec(mbfl_SELF,0)
    then mbfl_p_struct_is_a mbfl_slot_ref(mbfl_SELF,0) _(mbfl_GIVEN_TYPE)
    else return_because_failure
    fi
}
function mbfl_p_struct_is_a () {
    mbfl_mandatory_nameref_parameter(mbfl_TYPE,       1)
    mbfl_mandatory_nameref_parameter(mbfl_GIVEN_TYPE, 2)

    if mbfl_string_equal _(mbfl_TYPE) _(mbfl_GIVEN_TYPE)
    then return_because_success
    else
	mbfl_declare_varref(mbfl_PARENT)
	mbfl_struct_descriptor_parent_var _(mbfl_PARENT) _(mbfl_TYPE)
	if mbfl_string_is_empty "$mbfl_PARENT"
	then return_because_failure
	else mbfl_p_struct_is_a _(mbfl_PARENT) _(mbfl_GIVEN_TYPE)
	fi
    fi
}

# We  can  apply  this funtion  to  every  struct:  data  structure instance,  data  structure  type
# descriptor.
#
function mbfl_struct_type_var () {
    mbfl_mandatory_nameref_parameter(mbfl_TYPE_RV,	1, the result variable)
    mbfl_mandatory_nameref_parameter(mbfl_SELF,		2, variable referencing a data structure)
    mbfl_TYPE_RV=mbfl_slot_ref(mbfl_SELF, 0)
}


#### data-structure type-descriptor definition
#
# A data-structure type-descriptor describes the fields of a data-structure instance.
#
# A data-structure type-descriptor with a parent  type-descriptor inherits the fields of its parent;
# a data-structure type-descriptor adds fields to the ones defined by its parent.
#

function mbfl_struct_define_type () {
    mbfl_mandatory_nameref_parameter(mbfl_TYPE,		1, reference variable to the type descriptor)
    mbfl_mandatory_nameref_parameter(mbfl_PARENT,	2, reference variable to the parent type descriptor)
    mbfl_mandatory_parameter(mbfl_NAME,			3, the name of the new structure type)
    shift 3
    declare -ar mbfl_NEW_FIELD_NAMES=("$@")
    declare -ir mbfl_NEW_FIELDS_NUMBER=mbfl_slots_number(mbfl_NEW_FIELD_NAMES)
    declare -i  mbfl_TOTAL_FIELDS_NUMBER
    declare -i  mbfl_I

    # Initialise the fields of the new data-structure type-descriptor.
    {
	declare -i mbfl_PARENT_FIELDS_NUMBER
	mbfl_struct_descriptor_fields_number_var mbfl_PARENT_FIELDS_NUMBER _(mbfl_PARENT)
	let mbfl_TOTAL_FIELDS_NUMBER=mbfl_PARENT_FIELDS_NUMBER+mbfl_NEW_FIELDS_NUMBER
	#                               type_descriptor    parent         name         fields_number
	mbfl_struct_define _(mbfl_TYPE) _(mbfl_struct_top) _(mbfl_PARENT) "$mbfl_NAME" $mbfl_TOTAL_FIELDS_NUMBER
	# Copy the fields from the parent
	for ((mbfl_I=0; mbfl_I < mbfl_PARENT_FIELDS_NUMBER; ++mbfl_I))
	do mbfl_slot_set(mbfl_TYPE,                  MBFL_TYPE_DESCR_FIELD_OFFSET_FIRST_FIELD + mbfl_I,
			 mbfl_slot_qref(mbfl_PARENT, MBFL_TYPE_DESCR_FIELD_OFFSET_FIRST_FIELD + mbfl_I))
	done
	# Store the new fields.
	for ((mbfl_I=mbfl_PARENT_FIELDS_NUMBER; mbfl_I < mbfl_TOTAL_FIELDS_NUMBER; ++mbfl_I))
	do mbfl_slot_set(mbfl_TYPE, MBFL_TYPE_DESCR_FIELD_OFFSET_FIRST_FIELD + mbfl_I,
			 mbfl_slot_qref(mbfl_NEW_FIELD_NAMES, mbfl_I))
	done
    }

    declare -r mbfl_TYPE_DATAVAR=_(mbfl_TYPE)

    # We need to iterate over the fields; we could use a single loop statement, but a loop statement
    # for every purpose makes the code more readable.

    # Build the data-structure instance-constructor function.
    {
	declare mbfl_CONSTRUCTOR_NAME mbfl_CONSTRUCTOR_BODY
	declare mbfl_PARAMETER_COUNT

	printf -v mbfl_CONSTRUCTOR_NAME MBFL_STRUCT_FUNCNAME_PATTERN_CONSTRUCTOR "$mbfl_NAME"

	mbfl_CONSTRUCTOR_BODY='{ '
	mbfl_CONSTRUCTOR_BODY+="local -n mbfl_SELF=\${1:"
	mbfl_CONSTRUCTOR_BODY+="?\"missing reference to struct '${mbfl_NAME}' variable parameter to '\${FUNCNAME}'\"};"
	mbfl_CONSTRUCTOR_BODY+="mbfl_SELF[0]=${mbfl_TYPE_DATAVAR};"
	for ((mbfl_I=0, mbfl_PARAMETER_COUNT=2; mbfl_I < mbfl_TOTAL_FIELDS_NUMBER; ++mbfl_I, ++mbfl_PARAMETER_COUNT))
	do
	    declare mbfl_FIELD_NAME=mbfl_slot_ref(mbfl_TYPE, MBFL_TYPE_DESCR_FIELD_OFFSET_FIRST_FIELD + $mbfl_I)
	    declare mbfl_OFFSET=$((MBFL_STRUCT_FIRST_FIELD_OFFSET + $mbfl_I))
	    mbfl_CONSTRUCTOR_BODY+="mbfl_SELF[$mbfl_OFFSET]=\${$mbfl_PARAMETER_COUNT:?"
	    mbfl_CONSTRUCTOR_BODY+="\"missing field value parameter '$mbfl_FIELD_NAME' to '\$FUNCNAME'\"};"
	done
	mbfl_CONSTRUCTOR_BODY+='}'
	mbfl_p_struct_make_function "$mbfl_CONSTRUCTOR_NAME" "$mbfl_CONSTRUCTOR_BODY"
    }

    # Build the data-structure type-predicate function: return true if a struct instance is of type "".
    {
	declare mbfl_PREDICATE_NAME mbfl_PREDICATE_BODY

	printf -v mbfl_PREDICATE_NAME  MBFL_STRUCT_FUNCNAME_PATTERN_PREDICATE   "$mbfl_NAME"
	mbfl_PREDICATE_BODY="{ declare mbfl_SELF_DATAVAR=\${1:?\"missing reference to data-structure parameter to '\$FUNCNAME'\"};"
	mbfl_PREDICATE_BODY+="mbfl_struct_is_a \"\$mbfl_SELF_DATAVAR\" '${mbfl_TYPE_DATAVAR}' ; }"
	mbfl_p_struct_make_function "$mbfl_PREDICATE_NAME" "$mbfl_PREDICATE_BODY"
    }

    # Build the data-structure field-mutator functions.
    {
	for ((mbfl_I=0, mbfl_PARAMETER_COUNT=2; mbfl_I < mbfl_TOTAL_FIELDS_NUMBER; ++mbfl_I, ++mbfl_PARAMETER_COUNT))
	do
	    declare mbfl_MUTATOR_NAME mbfl_MUTATOR_BODY
	    declare mbfl_FIELD_NAME=mbfl_slot_ref(mbfl_TYPE, MBFL_TYPE_DESCR_FIELD_OFFSET_FIRST_FIELD + $mbfl_I)
	    declare mbfl_OFFSET=$((MBFL_STRUCT_FIRST_FIELD_OFFSET + $mbfl_I))

	    printf -v mbfl_MUTATOR_NAME MBFL_STRUCT_FUNCNAME_PATTERN_MUTATOR "$mbfl_NAME" "$mbfl_FIELD_NAME"
	    mbfl_MUTATOR_BODY='{ '
	    mbfl_MUTATOR_BODY+="declare -n mbfl_SELF=\${1:?\"missing reference to struct '$mbfl_NAME' parameter to '\$FUNCNAME'\"};"
	    mbfl_MUTATOR_BODY+="mbfl_SELF[$mbfl_OFFSET]=\${2:?\"missing field value parameter to '\$FUNCNAME'\"};"
	    mbfl_MUTATOR_BODY+='}'
	    mbfl_p_struct_make_function "$mbfl_MUTATOR_NAME" "$mbfl_MUTATOR_BODY"
	done
    }

    # Build the data-structure field-accessor functions.
    {
	for ((mbfl_I=0, mbfl_PARAMETER_COUNT=2; mbfl_I < mbfl_TOTAL_FIELDS_NUMBER; ++mbfl_I, ++mbfl_PARAMETER_COUNT))
	do
	    declare mbfl_ACCESSOR_NAME mbfl_ACCESSOR_BODY
	    declare mbfl_FIELD_NAME=mbfl_slot_ref(mbfl_TYPE, MBFL_TYPE_DESCR_FIELD_OFFSET_FIRST_FIELD + $mbfl_I)
	    declare mbfl_OFFSET=$((MBFL_STRUCT_FIRST_FIELD_OFFSET + $mbfl_I))

	    printf -v mbfl_ACCESSOR_NAME MBFL_STRUCT_FUNCNAME_PATTERN_ACCESSOR "$mbfl_NAME" "$mbfl_FIELD_NAME"
	    mbfl_ACCESSOR_BODY='{ '
	    mbfl_ACCESSOR_BODY+="declare -n mbfl_SELF=\${1:?\"missing reference to struct '$mbfl_NAME' parameter to '\$FUNCNAME'\"};"
	    mbfl_ACCESSOR_BODY+="declare -n mbfl_RV=\${2:?\"missing result variable parameter to '\$FUNCNAME'\"};"
	    mbfl_ACCESSOR_BODY+="mbfl_RV=\${mbfl_SELF[$mbfl_OFFSET]};"
	    mbfl_ACCESSOR_BODY+='}'
	    mbfl_p_struct_make_function "$mbfl_ACCESSOR_NAME" "$mbfl_ACCESSOR_BODY"
	done
    }
}


#### helper functions

function mbfl_p_struct_make_function () {
    mbfl_mandatory_parameter(mbfl_FUNCNAME, 1, function name)
    mbfl_mandatory_parameter(mbfl_BODY,     2, function body)
    #echo function "$mbfl_FUNCNAME" '()' "$mbfl_BODY"; echo
    eval function "$mbfl_FUNCNAME" '()' "$mbfl_BODY"
}

### end of file
# Local Variables:
# mode: sh
# End:
