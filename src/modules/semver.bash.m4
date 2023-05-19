# semver.bash.m4 --
#
# Part of: Marco's BASH functions library
# Contents: semantic version string parser
# Date: Oct 15, 2020
#
# Abstract
#
#       This module  implements a  parser for  a string representing  a semantic  version.  Semantic
#       versioning is defined at:
#
#		<https://semver.org/>
#
# Copyright (c) 2020, 2023 Marco Maggi
# <mrc.mgg@gmail.com>
#
# This is free software; you can redistribute it and/or  modify it under the terms of the GNU Lesser
# General Public  License as published by  the Free Software  Foundation; either version 3.0  of the
# License, or (at your option) any later version.
#
# This library is distributed in the hope that  it will be useful, but WITHOUT ANY WARRANTY; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the  GNU Lesser General Public License along with this library;
# if not,  write to  the Free  Software Foundation,  Inc., 59  Temple Place,  Suite 330,  Boston, MA
# 02111-1307 USA.
#


#### macros

MBFL_DEFINE_UNDERSCORE_MACRO


#### validation predicates

function mbfl_string_is_semver_major_number () {
    mbfl_mandatory_parameter(STR, 1, string)
    declare -r REX='^(0|([1-9][0-9]*))$'
    [[ "$STR" =~ $REX ]]
}
function mbfl_string_is_semver_minor_number () {
    mbfl_mandatory_parameter(STR, 1, string)
    mbfl_string_is_semver_major_number "$STR"
}
function mbfl_string_is_semver_patch_level () {
    mbfl_mandatory_parameter(STR, 1, string)
    mbfl_string_is_semver_major_number "$STR"
}
function mbfl_string_is_semver_prerelease_version () {
    mbfl_mandatory_parameter(STR, 1, string)
    declare -r IDREX='([0-9A-Za-z\-]|([1-9A-Za-z\-][0-9A-Za-z\-]+))'
    declare REX='^'
    # The first identifier.  There must be at least one.
    REX+=$IDREX
    # The optional trailing identifiers, separated by a dot.
    REX+='(\.'
    REX+=$IDREX
    REX+=')*$'

    [[ "$STR" =~ $REX ]]
}
function mbfl_string_is_semver_build_metadata () {
    mbfl_mandatory_parameter(STR, 1, string)
    [[ "$STR" =~ ${MBFL_SEMVER_REX_BUILD_METADATA[1]} ]]
}
function mbfl_string_is_semver_build_metadata_with_underscore () {
    mbfl_mandatory_parameter(STR, 1, string)
    [[ "$STR" =~ ${MBFL_SEMVER_REX_BUILD_METADATA[3]} ]]
}

### ------------------------------------------------------------------------

function mbfl_string_is_a_semver_parser_parse_leading_v_option () {
    mbfl_mandatory_parameter(mbfl_OPTION_VALUE, 1, semver_parser_parse_leading_v option value)

    case "$mbfl_OPTION_VALUE" in
	'mandatory'|'optional'|'missing')
	    return_success
	    ;;
	*)
	    return_failure
	    ;;
    esac
}
function mbfl_string_is_a_semver_parser_accept_underscore_in_build_metadata_option () {
    mbfl_mandatory_parameter(mbfl_OPTION_VALUE, 1, semver_parser_parse_leading_v option value)

    case "$mbfl_OPTION_VALUE" in
	'true'|'false')
	    return_success
	    ;;
	*)
	    return_failure
	    ;;
    esac
}


#### class definitions

if mbfl_string_neq_yes("$mbfl_INTERACTIVE")
then
    # These regular expressions must not contain the leading "+" character.
    declare -ra MBFL_SEMVER_REX_BUILD_METADATA=([0]='^(([0-9A-Za-z\-]+)(\.([0-9A-Za-z\-]+))*)'
						[1]='^(([0-9A-Za-z\-]+)(\.([0-9A-Za-z\-]+))*)$'
						[2]=[[['^(([0-9A-Za-z_\-]+)(\.([0-9A-Za-z_\-]+))*)']]]
						[3]=[[['^(([0-9A-Za-z_\-]+)(\.([0-9A-Za-z_\-]+))*)$']]])

    mbfl_default_class_declare(mbfl_semver_parser_input_t)
    mbfl_default_class_declare(mbfl_semver_parser_t)
    mbfl_default_class_declare(mbfl_semver_spec_t)

    mbfl_default_class_declare(mbfl_semver_parser_error_condition_t)

    mbfl_default_class_define _(mbfl_semver_parser_input_t) _(mbfl_default_object)	\
			      'mbfl_semver_parser_input'				\
			      string start_index end_index

    mbfl_default_class_define _(mbfl_semver_parser_t) _(mbfl_default_object)		\
			      'mbfl_semver_parser'					\
			      parse_leading_v accept_underscore_in_build_metadata	\
			      error_message

    mbfl_default_class_define _(mbfl_semver_spec_t) _(mbfl_default_object)		\
			      'mbfl_semver_spec'					\
			      major_number minor_number patch_level			\
			      prerelease_version build_metadata

    # mbfl_default_class_define _(mbfl_semver_comparator_t) _(mbfl_default_object)	\
	# 			      'mbfl_semver_comparator'					\
	# 			      major_number minor_number patch_level			\
	# 			      prerelease_version

    # mbfl_default_class_define _(mbfl_semver_parser_t) _(mbfl_default_object)		\
	# 			      'mbfl_semver_parser'					\
	# 			      error_message

    mbfl_function_rename 'mbfl_semver_parser_input_end_index_set'   'mbfl_p_semver_parser_input_end_index_set'
fi

function mbfl_initialise_module_semver () {
    mbfl_default_class_define _(mbfl_semver_parser_error_condition_t) _(mbfl_runtime_error_condition_t) \
     			      'mbfl_semver_parser_error_condition'

    # Unset the mutators of immutable attributes.
    mbfl_function_unset 'mbfl_semver_parser_input_string_set'
    mbfl_function_unset 'mbfl_semver_parser_input_start_index_set'

    # Mutators for "mbfl_semver_spec_t".
    mbfl_default_object_make_predicate_mutator_from_mutator \
	'mbfl_semver_spec_major_number_set' 'major_number' 'mbfl_string_is_semver_major_number'
    mbfl_default_object_make_predicate_mutator_from_mutator \
	'mbfl_semver_spec_minor_number_set' 'minor_number' 'mbfl_string_is_semver_minor_number'
    mbfl_default_object_make_predicate_mutator_from_mutator \
	'mbfl_semver_spec_patch_level_set' 'patch_level' 'mbfl_string_is_semver_patch_level'
    mbfl_default_object_make_predicate_mutator_from_mutator \
	'mbfl_semver_spec_prerelease_version_set' 'prerelease_version' 'mbfl_string_is_semver_prerelease_version'
    mbfl_default_object_make_predicate_mutator_from_mutator \
	'mbfl_semver_spec_build_metadata_set' 'build_metadata' 'mbfl_string_is_semver_build_metadata'

    # Mutators for "mbfl_semver_parser".
    mbfl_default_object_make_predicate_mutator_from_mutator				\
	'mbfl_semver_parser_parse_leading_v_set'					\
	'parse_leading_v'								\
	'mbfl_string_is_a_semver_parser_parse_leading_v_option'
    mbfl_default_object_make_predicate_mutator_from_mutator				\
	'mbfl_semver_parser_accept_underscore_in_build_metadata_set'			\
	'accept_underscore_in_build_metadata'						\
	'mbfl_string_is_a_semver_parser_accept_underscore_in_build_metadata_option'
}


#### exceptional-condition classes

function mbfl_semver_parser_error_condition_make () {
    mbfl_mandatory_nameref_parameter(mbfl_CND,	1, exceptional-conditio object)
    mbfl_mandatory_parameter(mbfl_WHO,		2, entity that raised the exception)
    mbfl_mandatory_parameter(mbfl_MESSAGE,	3, error message)

    mbfl_semver_parser_error_condition_define _(mbfl_CND) "$mbfl_WHO" "$mbfl_MESSAGE" 'false'
}


#### semver-parser input-string class

function mbfl_semver_parser_input_make () {
    mbfl_mandatory_nameref_parameter(mbfl_PARSER_INPUT,	1, reference to object of class mbfl_semver_parser_input_t)
    mbfl_mandatory_parameter(mbfl_INPUT_STRING,		2, semantic-version parser input string)
    mbfl_mandatory_integer_parameter(mbfl_START_INDEX,	3, semantic-version parser input string start index)

    if ! mbfl_string_is_digit "$mbfl_START_INDEX"
    then
	mbfl_message_error_printf 'expected positive integer as input string start index, got: "%s"' "$mbfl_START_INDEX"
	return_because_failure
    fi

    if (( mbfl_START_INDEX < 0 || mbfl_string_len(mbfl_INPUT_STRING) < mbfl_START_INDEX ))
    then
	mbfl_message_error_printf 'start index "%s" must be positive and less than the length of the input string "%s"' \
				  $mbfl_START_INDEX mbfl_string_len(mbfl_INPUT_STRING)
	return_because_failure
    fi

    declare -i mbfl_END_INDEX=mbfl_START_INDEX
    mbfl_semver_parser_input_define _(mbfl_PARSER_INPUT) "$mbfl_INPUT_STRING" $mbfl_START_INDEX $mbfl_END_INDEX
}

# Field mutator that checks its parameters.
#
function mbfl_semver_parser_input_end_index_set () {
    mbfl_mandatory_nameref_parameter(mbfl_PARSER_INPUT,	1, reference to object of class mbfl_semver_parser_input_t)
    mbfl_mandatory_parameter(mbfl_END_INDEX,		2, semantic-version parser input string end index)
    mbfl_declare_varref(mbfl_INPUT_STRING)

    if ! mbfl_string_is_digit "$mbfl_END_INDEX"
    then
	mbfl_default_object_declare(CND)

	mbfl_invalid_object_attrib_value_condition_make _(mbfl_CND) $FUNCNAME _(mbfl_OBJ) \
							'end_index' "$mbfl_END_INDES"
	mbfl_exception_raise _(mbfl_CND)
	return_because_failure
    fi

    mbfl_semver_parser_input_string_var _(mbfl_INPUT_STRING) _(mbfl_PARSER_INPUT)

    if (( mbfl_END_INDEX < 0 || mbfl_string_len(mbfl_INPUT_STRING) < mbfl_END_INDEX ))
    then
	mbfl_message_error_printf 'end index "%d" must be positive and less than the length of the input string "%d"' \
				  $mbfl_END_INDEX mbfl_string_len(mbfl_INPUT_STRING)
	return_because_failure
    fi

    mbfl_p_semver_parser_input_end_index_set _(mbfl_PARSER_INPUT) $mbfl_END_INDEX
}


#### semver-parser class

function mbfl_semver_parser_make_default () {
    mbfl_mandatory_nameref_parameter(mbfl_SEMVER_PARSER, 1, reference to object of class mbfl_semver_parser_t)

    mbfl_semver_parser_define _(mbfl_SEMVER_PARSER) 'optional' 'false' ''
}


#### semver specification class

function mbfl_semver_spec_make_from_string () {
    mbfl_mandatory_nameref_parameter(mbfl_SEMVER_SPEC,	1, reference to object of class mbfl_semver_spec_t)
    mbfl_mandatory_parameter(mbfl_INPUT_STRING,		2, input string)

    mbfl_default_object_declare(mbfl_PARSER_INPUT)
    mbfl_default_object_declare(mbfl_SEMVER_PARSER)

    mbfl_semver_parser_input_make _(mbfl_PARSER_INPUT) "$mbfl_INPUT_STRING" 0
    mbfl_semver_parser_make_default _(mbfl_SEMVER_PARSER)
    mbfl_semver_parse _(mbfl_SEMVER_SPEC) _(mbfl_SEMVER_PARSER) _(mbfl_PARSER_INPUT)
}

function mbfl_semver_spec_make_from_components () {
    mbfl_mandatory_nameref_parameter(mbfl_SEMVER_SPEC,	1, reference to object of class mbfl_semver_spec_t)
    mbfl_mandatory_parameter(mbfl_MAJOR_NUMBER,		2, major number)
    mbfl_mandatory_parameter(mbfl_MINOR_NUMBER,		3, minor number)
    mbfl_mandatory_parameter(mbfl_PATCH_LEVEL,		4, patch level)
    mbfl_optional_parameter(mbfl_PRERELEASE_VERSION,	5)
    mbfl_optional_parameter(mbfl_BUILD_METADATA,	6)

    if ! mbfl_string_is_semver_major_number "$mbfl_MAJOR_NUMBER"
    then
	mbfl_message_error_printf 'expected semantic-version specification major number, got "%s"' "$mbfl_MAJOR_NUMBER"
	return_because_failure
    fi
    if ! mbfl_string_is_semver_minor_number "$mbfl_MINOR_NUMBER"
    then
	mbfl_message_error_printf 'expected semantic-version specification minor number, got "%s"' "$mbfl_MINOR_NUMBER"
	return_because_failure
    fi
    if ! mbfl_string_is_semver_patch_level "$mbfl_PATCH_LEVEL"
    then
	mbfl_message_error_printf 'expected semantic-version specification patch level, got "%s"' "$mbfl_PATCH_LEVEL"
	return_because_failure
    fi
    if { mbfl_string_not_empty(mbfl_PRERELEASE_VERSION) && ! mbfl_string_is_semver_prerelease_version "$mbfl_PRERELEASE_VERSION" ; }
    then
	mbfl_message_error_printf 'expected semantic-version specification prerelease version, got "%s"' "$mbfl_PRERELEASE_VERSION"
	return_because_failure
    fi
    if { mbfl_string_not_empty(mbfl_BUILD_METADATA) && ! mbfl_string_is_semver_build_metadata "$mbfl_BUILD_METADATA" ; }
    then
	mbfl_message_error_printf 'expected semantic-version specification build metadata, got "%s"' "$mbfl_BUILD_METADATA"
	return_because_failure
    fi

    mbfl_semver_spec_define _(mbfl_SEMVER_SPEC) \
			    "$mbfl_MAJOR_NUMBER" "$mbfl_MINOR_NUMBER" "$mbfl_PATCH_LEVEL" \
			    "$mbfl_PRERELEASE_VERSION" "$mbfl_BUILD_METADATA"
}

function mbfl_semver_spec_string_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,		1, result variable)
    mbfl_mandatory_nameref_parameter(mbfl_SEMVER_SPEC,	2, reference to object of class mbfl_semver_spec_t)
    mbfl_declare_varref(mbfl_MAJOR_NUMBER)
    mbfl_declare_varref(mbfl_MINOR_NUMBER)
    mbfl_declare_varref(mbfl_PATCH_LEVEL)
    mbfl_declare_varref(mbfl_PRERELEASE_VERSION)
    mbfl_declare_varref(mbfl_BUILD_METADATA)

    if ! mbfl_semver_spec_is_a _(mbfl_SEMVER_SPEC)
    then
	mbfl_message_error_printf 'expected datavar of object of class "mbfl_semver_spec_t", got: "%s"' _(mbfl_SEMVER_SPEC)
	return_because_failure
    fi

    mbfl_semver_spec_major_number_var		_(mbfl_MAJOR_NUMBER)		_(SEMVER_SPEC)
    mbfl_semver_spec_minor_number_var		_(mbfl_MINOR_NUMBER)		_(SEMVER_SPEC)
    mbfl_semver_spec_patch_level_var		_(mbfl_PATCH_LEVEL)		_(SEMVER_SPEC)
    mbfl_semver_spec_prerelease_version_var	_(mbfl_PRERELEASE_VERSION)	_(SEMVER_SPEC)
    mbfl_semver_spec_build_metadata_var		_(mbfl_BUILD_METADATA)		_(SEMVER_SPEC)

    printf -v mbfl_RV '%d.%d.%d' $mbfl_MAJOR_NUMBER $mbfl_MINOR_NUMBER $mbfl_PATCH_LEVEL
    if mbfl_string_not_empty(mbfl_PRERELEASE_VERSION)
    then mbfl_RV+="-${mbfl_PRERELEASE_VERSION}"
    fi
    if mbfl_string_not_empty(mbfl_BUILD_METADATA)
    then mbfl_RV+="+${mbfl_BUILD_METADATA}"
    fi
}


#### parser functions: main parser

function mbfl_semver_parse () {
    mbfl_mandatory_nameref_parameter(mbfl_SEMVER_SPEC,		1, reference to object of class mbfl_semver_spec_t)
    mbfl_mandatory_nameref_parameter(mbfl_SEMVER_PARSER,	2, reference to object of class mbfl_semver_parser_t)
    mbfl_mandatory_nameref_parameter(mbfl_PARSER_INPUT,		3, reference to object of class mbfl_semver_parser_input_t)
    mbfl_declare_varref(mbfl_INPUT_STRING)

    # Validate parameters.
    {
	if ! mbfl_semver_parser_is_a _(mbfl_SEMVER_PARSER)
	then
	    mbfl_message_error_printf 'expected datavar of object of class "mbfl_semver_parser_t", got: "%s"' _(mbfl_SEMVER_PARSER)
	    return_because_failure
	fi
	if ! mbfl_semver_parser_input_is_a _(mbfl_PARSER_INPUT)
	then
	    mbfl_message_error_printf 'expected datavar of object of class "mbfl_semver_parser_input_t", got: "%s"' _(mbfl_PARSER_INPUT)
	    return_because_failure
	fi
    }

    # The parser functions will mutate these variables.
    mbfl_declare_integer_varref(mbfl_MAJOR_NUMBER)
    mbfl_declare_integer_varref(mbfl_MINOR_NUMBER)
    mbfl_declare_integer_varref(mbfl_PATCH_LEVEL)
    mbfl_declare_varref(mbfl_PRERELEASE_VERSION)
    mbfl_declare_varref(mbfl_BUILD_METADATA)
    mbfl_declare_integer_varref(mbfl_NEXT_INDEX)
    declare mbfl_PARSING_ERROR_MESSAGE

    mbfl_semver_parser_input_string_var       _(mbfl_INPUT_STRING)	_(mbfl_PARSER_INPUT)
    mbfl_semver_parser_input_start_index_var  _(mbfl_NEXT_INDEX)	_(mbfl_PARSER_INPUT)

    if ! mbfl_p_semver_parse_leading_v
    then
	mbfl_default_object_declare(mbfl_CND)

	mbfl_semver_parser_error_condition_make _(mbfl_CND) $FUNCNAME "$mbfl_PARSING_ERROR_MESSAGE"
	if ! mbfl_exception_raise _(mbfl_CND)
	then return_because_failure
	fi
    fi

    if ! mbfl_p_semver_parse_version_numbers
    then
	mbfl_default_object_declare(mbfl_CND)

	mbfl_semver_parser_error_condition_make _(mbfl_CND) $FUNCNAME "$mbfl_PARSING_ERROR_MESSAGE"
	if ! mbfl_exception_raise _(mbfl_CND)
	then return_because_failure
	fi
    fi

    if mbfl_string_eq('-', mbfl_string_qidx(mbfl_INPUT_STRING, $mbfl_NEXT_INDEX))
    then
	# There is a prerelease version component.
	if ! mbfl_p_semver_parse_prerelease_version
	then
	    mbfl_default_object_declare(mbfl_CND)

	    mbfl_semver_parser_error_condition_make _(mbfl_CND) $FUNCNAME "$mbfl_PARSING_ERROR_MESSAGE"
	    if ! mbfl_exception_raise _(mbfl_CND)
	    then return_because_failure
	    fi
	fi
    fi

    if mbfl_string_eq('+', mbfl_string_qidx(mbfl_INPUT_STRING, $mbfl_NEXT_INDEX))
    then
	let ++mbfl_NEXT_INDEX

	# There is a build metadata component.
	mbfl_declare_varref(AUIBM)

	mbfl_semver_parser_accept_underscore_in_build_metadata_var _(AUIBM) _(mbfl_SEMVER_PARSER)
	if ! mbfl_p_semver_parse_build_metadata
	then
	    mbfl_default_object_declare(mbfl_CND)

	    mbfl_semver_parser_error_condition_make _(mbfl_CND) $FUNCNAME "$mbfl_PARSING_ERROR_MESSAGE"
	    if ! mbfl_exception_raise _(mbfl_CND)
	    then return_because_failure
	    fi
	fi
    fi

    mbfl_semver_spec_define _(mbfl_SEMVER_SPEC) \
			    "$mbfl_MAJOR_NUMBER" "$mbfl_MINOR_NUMBER" "$mbfl_PATCH_LEVEL" \
			    "$mbfl_PRERELEASE_VERSION" "$mbfl_BUILD_METADATA"
    # Let's return the same return status of this call!
    mbfl_semver_parser_input_end_index_set _(mbfl_PARSER_INPUT) "$mbfl_NEXT_INDEX"
}


#### parser functions: parse leading v

function mbfl_p_semver_parse_leading_v () {
    mbfl_declare_varref(mbfl_PARSE_LEADING_V)

    mbfl_semver_parser_parse_leading_v_var _(mbfl_PARSE_LEADING_V) _(mbfl_SEMVER_PARSER)
    case "$mbfl_PARSE_LEADING_V"
    in
	'mandatory')
	    if mbfl_string_eq('v', mbfl_string_qidx(mbfl_INPUT_STRING, $mbfl_NEXT_INDEX))
	    then let ++mbfl_NEXT_INDEX
	    else
		mbfl_PARSING_ERROR_MESSAGE='mandatory leading "v" character not present in semantic-version specification'
		return_because_failure
	    fi
	    ;;
	'missing')
	    if mbfl_string_eq('v', mbfl_string_qidx(mbfl_INPUT_STRING, $mbfl_NEXT_INDEX))
	    then
		mbfl_PARSING_ERROR_MESSAGE='unexpected leading "v" character is present in semantic-version specification'
		return_because_failure
	    fi
	    ;;
	*)
	    # optional
	    if mbfl_string_eq('v', mbfl_string_qidx(mbfl_INPUT_STRING, $mbfl_NEXT_INDEX))
	    then let ++mbfl_NEXT_INDEX
	    fi
	    ;;
    esac
}


#### parser functions: parse version numbers

function mbfl_p_semver_parse_version_numbers () {
    # If a version number is  a single digit: it can be 0.  If there  are multiple digits: the first
    # digit cannot be 0.
    declare -r REX='^(0|([1-9][0-9]*))\.(0|([1-9][0-9]*))\.(0|([1-9][0-9]*))($|[\-\+]|[^0-9A-Za-z])'
    #                1  2               3  4               5  6
    #                |-----------------------------------------------------||---------------------|
    #                                    major.minor.patch                   end or one char after

    if [[ "${mbfl_INPUT_STRING:$mbfl_NEXT_INDEX}" =~ $REX ]]
    then
	# For debugging purposes.
	# echo ${FUNCNAME}: successful match "mbfl_slot_ref(BASH_REMATCH, @)" >&2
	# echo ${FUNCNAME}: MAJOR_NUMBER="mbfl_slot_ref(BASH_REMATCH, 1)" >&2
	# echo ${FUNCNAME}: MINOR_NUMBER="mbfl_slot_ref(BASH_REMATCH, 4)" >&2
	# echo ${FUNCNAME}: PATCH_LEVEL="mbfl_slot_ref(BASH_REMATCH, 7)" >&2

	mbfl_MAJOR_NUMBER=mbfl_slot_ref(BASH_REMATCH, 1)
	mbfl_MINOR_NUMBER=mbfl_slot_ref(BASH_REMATCH, 3)
	mbfl_PATCH_LEVEL=mbfl_slot_ref(BASH_REMATCH, 5)
	let mbfl_NEXT_INDEX+=2+${#mbfl_MAJOR_NUMBER}+${#mbfl_MINOR_NUMBER}+${#mbfl_PATCH_LEVEL}
	return_because_success
    else
	# For debugging purposes.
	#echo ${FUNCNAME}: no match >&2
	mbfl_PARSING_ERROR_MESSAGE='invalid version numbers specification'
	return_because_failure
    fi
}


#### parser functions: parse prerelease version

# The prerelease version must start with a hyphen.  Then a non-empty identifier must follow.  Then a
# number of optional identifiers separated by dots.  A numeric identifier with a single digit can be
# zero.  A numeric identifier with multiple digits must not start with a zero.
#
# So a prerelease version identifier can be:
#
# [0-9A-Za-z\-]			a single-digit numeric identifier whose digit is zero
# [A-Za-z1-9\-][0-9A-Za-z\-]+	a multi-char identifier, underscore not allowed, dashes allowed
#
# notice that the singla-char identifier includes this as subcase:
#
# 0				a single-digit numeric identifier whose digit is zero
#
# notice that the multi-char identifier regexp includes the following as a subcase:
#
# [1-9][0-9]*			a numeric identifier whose first digit is not zero
#
# After the prerelease version specification, we can have:
#
# $				the end of the input string
# \+				a build metadata specification
# [^0-9A-Za-z\.\-]		a character that is invalid for an identifier
#
function mbfl_p_semver_parse_prerelease_version () {
    declare -r IDREX='([0-9A-Za-z\-]|([1-9A-Za-z\-][0-9A-Za-z\-]+))'
    # The leading hyphen.
    declare REX='^\-('
    # The first identifier.  There must be at least one.
    REX+=$IDREX
    # The optional trailing identifiers, separated by a dot.
    REX+='(\.'
    REX+=$IDREX
    REX+=')*'
    # Whatever comes  after the prerelease version.   Let's make sure  that the quoted hypen  is the
    # last character in the range!
    REX+=')($|\+|[^0-9A-Za-z\.\-])'

    # For debugging purposes.
    #echo ${FUNCNAME}: INPUT_STRING="${mbfl_INPUT_STRING:$mbfl_NEXT_INDEX}" START_INDEX=$mbfl_NEXT_INDEX >&2

    if [[ "${mbfl_INPUT_STRING:$mbfl_NEXT_INDEX}" =~ $REX ]]
    then
	# For debugging purposes.
	#echo ${FUNCNAME}: successful match "mbfl_slot_ref(BASH_REMATCH, @)" >&2
	#echo ${FUNCNAME}: PRERELEASE_VERSION="mbfl_slot_ref(BASH_REMATCH, 1)" >&2

	mbfl_PRERELEASE_VERSION=mbfl_slot_ref(BASH_REMATCH, 1)
	let mbfl_NEXT_INDEX+=1+${#BASH_REMATCH[1]}
	return_because_success
    else
	# For debugging purposes.
	#echo ${FUNCNAME}: no match >&2
	mbfl_PARSING_ERROR_MESSAGE='invalid prerelease version'
	return_because_failure
    fi
}


#### parser functions: parse build metadata

# The build  metadata must  start with a  plus.  Then  a non-empty identifier  must follow.   Then a
# number of optional identifiers separated by dots.
#
function mbfl_p_semver_parse_build_metadata () {
    if "$AUIBM"
    then declare -r REX=${MBFL_SEMVER_REX_BUILD_METADATA[2]}
    else declare -r REX=${MBFL_SEMVER_REX_BUILD_METADATA[0]}
    fi

    if [[ "${mbfl_INPUT_STRING:$mbfl_NEXT_INDEX}" =~ $REX ]]
    then
	# For debugging purposes.
	#echo ${FUNCNAME}: successful match "mbfl_slot_ref(BASH_REMATCH, @)" >&2
	#echo ${FUNCNAME}: BUILD_METADATA="mbfl_slot_ref(BASH_REMATCH, 1)" >&2

	mbfl_BUILD_METADATA=mbfl_slot_ref(BASH_REMATCH, 1)
	let mbfl_NEXT_INDEX+=mbfl_string_len(mbfl_BUILD_METADATA)
	return_because_success
    else
	# For debugging purposes.
	#echo ${FUNCNAME}: no match >&2
	mbfl_PARSING_ERROR_MESSAGE='invalid build metadata'
	return_because_failure
    fi
}


#### split prerelease version specifications

function mbfl_semver_split_prerelease_version () {
    mbfl_mandatory_nameref_parameter(mbfl_RV, 1, result array variable)
    mbfl_mandatory_parameter(mbfl_INPUT_SPEC, 2, input prerelease version specification)

    declare -r IDREX='(0|([1-9][0-9]*)|([A-Za-z\-][0-9A-Za-z\-]*))'
    declare -r DOTIDREX='\.(0|[1-9][0-9]*|[0-9A-Za-z\-][0-9A-Za-z\-]+)'
    declare -i i=0 j=0

    # Parse the first, mandatory identifier.
    if [[ "$mbfl_INPUT_SPEC" =~ $IDREX ]]
    then
	mbfl_RV[0]=mbfl_slot_ref(BASH_REMATCH, 1)
	j=${#BASH_REMATCH[1]}
    else return_because_failure
    fi

    for ((i=1; 0 < (${#mbfl_INPUT_SPEC} - j); ++i))
    do
	if [[ "${mbfl_INPUT_SPEC:$j}" =~ $DOTIDREX ]]
	then
	    mbfl_RV[$i]=mbfl_slot_ref(BASH_REMATCH, 1)
	    j+=1+${#BASH_REMATCH[1]}
	else return_because_failure
	fi
    done

    return_because_success
}


#### semantic version specifications comparison

# The value stored in the NAMEREF variable RV is the classic ternary comparison result:
#
# -1 if ONE < TWO
#  0 if ONE = TWO
# +1 if ONE > TWO
#
function mbfl_semver_compare_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,	1, result variable)
    mbfl_mandatory_parameter(mbfl_STRING1,	2, first semantic version specification as string)
    mbfl_mandatory_parameter(mbfl_STRING2,	3, second semantic version specification as string)
    mbfl_default_object_declare(mbfl_SEMVER_SPEC1)
    mbfl_default_object_declare(mbfl_SEMVER_SPEC2)

    if ! mbfl_semver_spec_make_from_string _(mbfl_SEMVER_SPEC1) "$mbfl_STRING1"
    then return_failure
    fi
    if ! mbfl_semver_spec_make_from_string _(mbfl_SEMVER_SPEC2) "$mbfl_STRING2"
    then return_failure
    fi

    mbfl_semver_compare_components_var _(mbfl_RV) _(mbfl_SEMVER_SPEC1) _(mbfl_SEMVER_SPEC2)
}

function mbfl_semver_compare_components_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,		1, result variable)
    mbfl_mandatory_nameref_parameter(mbfl_SEMVER_SPEC1,	2, reference to object of class mbfl_semver_spec_t)
    mbfl_mandatory_nameref_parameter(mbfl_SEMVER_SPEC2,	3, reference to object of class mbfl_semver_spec_t)
    declare -i mbfl_MAJOR_NUMBER1 mbfl_MAJOR_NUMBER2
    declare -i mbfl_MINOR_NUMBER1 mbfl_MINOR_NUMBER2
    declare -i mbfl_PATCH_LEVEL1  mbfl_PATCH_LEVEL2
    declare mbfl_PRERELEASE_VERSION1 mbfl_PRERELEASE_VERSION2
    declare mbfl_BUILD_METADATA1 mbfl_BUILD_METADATA2

    mbfl_semver_spec_major_number_var mbfl_MAJOR_NUMBER1 _(mbfl_SEMVER_SPEC1)
    mbfl_semver_spec_major_number_var mbfl_MAJOR_NUMBER2 _(mbfl_SEMVER_SPEC2)

    if   (( mbfl_MAJOR_NUMBER1 < mbfl_MAJOR_NUMBER2 ))
    then mbfl_RV=-1
    elif (( mbfl_MAJOR_NUMBER1 > mbfl_MAJOR_NUMBER2 ))
    then mbfl_RV=+1
    else
	# (( mbfl_MAJOR_NUMBER1 = mbfl_MAJOR_NUMBER2 ))
	mbfl_semver_spec_minor_number_var mbfl_MINOR_NUMBER1 _(mbfl_SEMVER_SPEC1)
	mbfl_semver_spec_minor_number_var mbfl_MINOR_NUMBER2 _(mbfl_SEMVER_SPEC2)

    	if   (( mbfl_MINOR_NUMBER1 < mbfl_MINOR_NUMBER2 ))
    	then mbfl_RV=-1
    	elif (( mbfl_MINOR_NUMBER1 > mbfl_MINOR_NUMBER2 ))
    	then mbfl_RV=+1
    	else
	    # (( mbfl_MINOR_NUMBER1 = mbfl_MINOR_NUMBER2 ))
	    mbfl_semver_spec_patch_level_var mbfl_PATCH_LEVEL1 _(mbfl_SEMVER_SPEC1)
	    mbfl_semver_spec_patch_level_var mbfl_PATCH_LEVEL2 _(mbfl_SEMVER_SPEC2)

    	    if   (( mbfl_PATCH_LEVEL1 < mbfl_PATCH_LEVEL2 ))
    	    then mbfl_RV=-1
    	    elif (( mbfl_PATCH_LEVEL1 > mbfl_PATCH_LEVEL2 ))
    	    then mbfl_RV=+1
    	    else
		# (( mbfl_PATCH_LEVEL1 = mbfl_PATCH_LEVEL2 ))
		mbfl_semver_spec_prerelease_version_var mbfl_PRERELEASE_VERSION1 _(mbfl_SEMVER_SPEC1)
		mbfl_semver_spec_prerelease_version_var mbfl_PRERELEASE_VERSION2 _(mbfl_SEMVER_SPEC2)

    		# If one is missing a prerelease version: that one is greater.
    		if   (( 0 == mbfl_string_len(mbfl_PRERELEASE_VERSION1) && 0 == mbfl_string_len(mbfl_PRERELEASE_VERSION2) ))
    		then mbfl_RV=0
    		elif (( 0 == mbfl_string_len(mbfl_PRERELEASE_VERSION1) && 0 <  mbfl_string_len(mbfl_PRERELEASE_VERSION2) ))
    		then mbfl_RV=-1
    		elif (( 0 <  mbfl_string_len(mbfl_PRERELEASE_VERSION1) && 0 == mbfl_string_len(mbfl_PRERELEASE_VERSION2) ))
    		then mbfl_RV=+1
    		else
    		    # Both have  a non-empty prerelease  version.  Let's compare them  identifier by
    		    # identifier.
    		    mbfl_semver_compare_prerelease_version _(mbfl_RV) "$mbfl_PRERELEASE_VERSION1" "$mbfl_PRERELEASE_VERSION2"
    		    return $?
    		fi
    	    fi
    	fi
    fi
    return_because_success
}

function mbfl_semver_compare_prerelease_version () {
    mbfl_mandatory_nameref_parameter(mbfl_RV,            1, result variable)
    mbfl_optional_parameter(mbfl_ONE_PRERELEASE_VERSION, 2, first prerelease version specification)
    mbfl_optional_parameter(mbfl_TWO_PRERELEASE_VERSION, 3, second prerelease version specification)
    mbfl_declare_index_array_varref(mbfl_ONE_IDENTIFIERS)
    mbfl_declare_index_array_varref(mbfl_TWO_IDENTIFIERS)

    if ! mbfl_semver_split_prerelease_version _(mbfl_ONE_IDENTIFIERS) "$mbfl_ONE_PRERELEASE_VERSION"
    then return_because_failure
    fi

    if ! mbfl_semver_split_prerelease_version _(mbfl_TWO_IDENTIFIERS) "$mbfl_TWO_PRERELEASE_VERSION"
    then return_because_failure
    fi

    # mbfl_array_dump mbfl_ONE_IDENTIFIERS mbfl_ONE_IDENTIFIERS
    # mbfl_array_dump mbfl_ONE_IDENTIFIERS mbfl_TWO_IDENTIFIERS

    declare -i mbfl_I mbfl_ONE_IS_NUMERIC mbfl_TWO_IS_NUMERIC mbfl_MIN

    mbfl_RV=0

    if (( mbfl_slots_number(mbfl_ONE_IDENTIFIERS) < mbfl_slots_number(mbfl_TWO_IDENTIFIERS) ))
    then mbfl_MIN=mbfl_slots_number(mbfl_ONE_IDENTIFIERS)
    else mbfl_MIN=mbfl_slots_number(mbfl_TWO_IDENTIFIERS)
    fi

    #echo ${FUNCNAME}: mbfl_MIN=$mbfl_MIN >&2
    for ((mbfl_I=0; mbfl_I < mbfl_MIN; ++mbfl_I))
    do
	mbfl_string_is_digit mbfl_slot_qref(mbfl_ONE_IDENTIFIERS, $mbfl_I)
	mbfl_ONE_IS_NUMERIC=$?

	mbfl_string_is_digit mbfl_slot_qref(mbfl_TWO_IDENTIFIERS, $mbfl_I)
	mbfl_TWO_IS_NUMERIC=$?

	if (( 0 == mbfl_ONE_IS_NUMERIC && 0 == mbfl_TWO_IS_NUMERIC ))
	then
	    # They are both numeric, so let's compare them as numbers.
	    if   test mbfl_slot_qref(mbfl_ONE_IDENTIFIERS, $mbfl_I) -lt mbfl_slot_qref(mbfl_TWO_IDENTIFIERS, $mbfl_I)
	    then mbfl_RV=-1 ; break
	    elif test mbfl_slot_qref(mbfl_ONE_IDENTIFIERS, $mbfl_I) -gt mbfl_slot_qref(mbfl_TWO_IDENTIFIERS, $mbfl_I)
	    then mbfl_RV=+1 ; break
	    fi
	elif (( 0 == mbfl_ONE_IS_NUMERIC ))
	then mbfl_RV=+1 ; break ;# ONE is numeric, TWO is not: ONE is lesser according to the standard.
	elif (( 0 == mbfl_TWO_IS_NUMERIC ))
	then mbfl_RV=-1 ; break ;# TWO is numeric, ONE is not: TWO is lesser according to the standard.
	else
	    #echo ${FUNCNAME}: mbfl_ONE_IDENTIFIERS[$mbfl_I]=mbfl_slot_qref(mbfl_ONE_IDENTIFIERS, $mbfl_I) mbfl_TWO_IDENTIFIERS[$mbfl_I]=mbfl_slot_qref(mbfl_TWO_IDENTIFIERS, $mbfl_I) >&2
	    # They are both non-numeric, so let's compare them as strings.
	    if   test mbfl_slot_qref(mbfl_ONE_IDENTIFIERS, $mbfl_I) '<' mbfl_slot_qref(mbfl_TWO_IDENTIFIERS, $mbfl_I)
	    then mbfl_RV=-1 ; break
	    elif test mbfl_slot_qref(mbfl_ONE_IDENTIFIERS, $mbfl_I) '>' mbfl_slot_qref(mbfl_TWO_IDENTIFIERS, $mbfl_I)
	    then mbfl_RV=+1 ; break
	    fi
	fi
    done

    #echo ${FUNCNAME}: after iterating mbfl_RV=$mbfl_RV >&2
    if (( 0 == mbfl_RV ))
    then
	# All the identifiers compared  so far are equal.  If a  specification has more identifiers:
	# it is greater.
	if   (( mbfl_slots_number(mbfl_ONE_IDENTIFIERS) < mbfl_slots_number(mbfl_TWO_IDENTIFIERS) ))
	then mbfl_RV=-1
	elif (( mbfl_slots_number(mbfl_ONE_IDENTIFIERS) > mbfl_slots_number(mbfl_TWO_IDENTIFIERS) ))
	then mbfl_RV=+1
	fi
    fi

    return_because_success
}

### end of file
# Local Variables:
# mode: sh
# End:
