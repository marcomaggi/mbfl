# semver.test --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for the semver functions
# Date: Oct 15, 2020
#
# Abstract
#
#
# Copyright (c) 2020, 2023, 2024 Marco Maggi <mrc.mgg@gmail.com>
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

mbfl_embed_library(__LIBMBFL_LINKER__)
mbfl_linker_source_library_by_stem(core)
mbfl_linker_source_library_by_stem(tests)


#### macros

# With one parameter is expands into a use  of "mbfl_datavar()"; with two parameters it expands into
# a use of "mbfl_slot_qref".
#
m4_define([[[_]]],[[[m4_ifelse($#,1,[[[mbfl_datavar([[[$1]]])]]],$#,2,[[[mbfl_slot_qref([[[$1]]],[[[$2]]])]]],[[[MBFL_P_WRONG_NUM_ARGS($#,1 or 2)]]])]]])


#### helper functions

# This is used to configure the behaviour of "p-semver-parse-correct-specification()".
declare -A p_semver_CONFIG
p_semver_CONFIG[PARSE_LEADING_V]=false
p_semver_CONFIG[ACCEPT_UNDERSCORE_IN_BUILD_METADATA]=false

function p_semver_reset_config () {
    p_semver_CONFIG[PARSE_LEADING_V]=false
    p_semver_CONFIG[ACCEPT_UNDERSCORE_IN_BUILD_METADATA]=false
}

function p-semver-parse-correct-specification () {
    mbfl_optional_parameter(MAJOR_NUMBER,	1)
    mbfl_optional_parameter(MINOR_NUMBER,	2)
    mbfl_optional_parameter(PATCH_LEVEL,	3)
    mbfl_optional_parameter(PRERELEASE_VERSION,	4)
    mbfl_optional_parameter(BUILD_METADATA,	5)
    mbfl_optional_parameter(TAIL,		6)
    declare -i EXIT_STATUS=0

    local SPEC=
    if ${p_semver_CONFIG[PARSE_LEADING_V]}
    then
	SPEC+='v'
	p_semver_CONFIG[PARSE_LEADING_V]=false
    fi
    SPEC+=${MAJOR_NUMBER}.${MINOR_NUMBER}.${PATCH_LEVEL}
    if test -n "$PRERELEASE_VERSION"
    then SPEC+=-$PRERELEASE_VERSION
    fi
    if test -n "$BUILD_METADATA"
    then SPEC+=+$BUILD_METADATA
    fi

    local -r INPUT_STRING=${SPEC}${TAIL}
    mbfl_default_object_declare(SEMVER_SPEC)
    mbfl_default_object_declare(SEMVER_PARSER)
    mbfl_default_object_declare(PARSER_INPUT)

    mbfl_semver_parser_make_default _(SEMVER_PARSER)
    mbfl_semver_parser_input_make   _(PARSER_INPUT) "$SPEC" 0

    mbfl_location_enter
    {
	mbfl_location_handler p_semver_reset_config

	if mbfl_slot_qref(p_semver_CONFIG, PARSE_LEADING_V)
	then mbfl_semver_parser_parse_leading_v_set _(SEMVER_PARSER) 'mandatory'
	fi
	if mbfl_slot_qref(p_semver_CONFIG, ACCEPT_UNDERSCORE_IN_BUILD_METADATA)
	then mbfl_semver_parser_accept_underscore_in_build_metadata_set _(SEMVER_PARSER) 'true'
	fi

	#echo $FUNCNAME string "$SPEC" >&2
	mbfl_semver_parse _(SEMVER_SPEC) _(SEMVER_PARSER) _(PARSER_INPUT)

	if dotest-equal 0 $? 'return status'
	then
	    mbfl_declare_varref(output_MAJOR_NUMBER)
	    mbfl_declare_varref(output_MINOR_NUMBER)
	    mbfl_declare_varref(output_PATCH_LEVEL)
	    mbfl_declare_varref(output_PRERELEASE_VERSION)
	    mbfl_declare_varref(output_BUILD_METADATA)
	    mbfl_declare_varref(output_STRING_REP)
	    mbfl_declare_varref(output_PARSING_ERROR_MESSAGE)
	    mbfl_declare_varref(output_START_INDEX)
	    mbfl_declare_varref(output_END_INDEX)

	    mbfl_semver_spec_major_number_var		_(output_MAJOR_NUMBER)		_(SEMVER_SPEC)
	    mbfl_semver_spec_minor_number_var		_(output_MINOR_NUMBER)		_(SEMVER_SPEC)
	    mbfl_semver_spec_patch_level_var		_(output_PATCH_LEVEL)		_(SEMVER_SPEC)
	    mbfl_semver_spec_prerelease_version_var	_(output_PRERELEASE_VERSION)	_(SEMVER_SPEC)
	    mbfl_semver_spec_build_metadata_var		_(output_BUILD_METADATA)	_(SEMVER_SPEC)
	    mbfl_semver_spec_string_var			_(output_STRING_REP)		_(SEMVER_SPEC)

	    mbfl_semver_parser_error_message_var	_(output_PARSING_ERROR_MESSAGE)	_(SEMVER_PARSER)

	    mbfl_semver_parser_input_start_index_var	_(output_START_INDEX)		_(PARSER_INPUT)
	    mbfl_semver_parser_input_end_index_var	_(output_END_INDEX)		_(PARSER_INPUT)

	    # For debugging purposes.
	    if false
	    then
		{
		    echo ${FUNCNAME}: STRING_REP="$output_STRING_REP"
		    echo ${FUNCNAME}: MAJOR_NUMBER="$output_MAJOR_NUMBER"
		    echo ${FUNCNAME}: MINOR_NUMBER="$output_MINOR_NUMBER"
		    echo ${FUNCNAME}: PATCH_LEVEL="$output_PATCH_LEVEL"
		    echo ${FUNCNAME}: PRERELEASE_VERSION="$output_PRERELEASE_VERSION"
		    echo ${FUNCNAME}: BUILD_METADATA="$output_BUILD_METADATA"
		    echo ${FUNCNAME}: PARSING_ERROR_MESSAGE="$output_PARSING_ERROR_MESSAGE"
		} >&2
	    fi

	    if false
	    then
		# For debugging purposes.
		dotest-equal '' "$output_PARSING_ERROR_MESSAGE" 'parsing error message'
		EXIT_STATUS=$?
	    else
		dotest-equal		''			"$output_PARSING_ERROR_MESSAGE"		'parsing error message'	      && \
		    dotest-equal	"$MAJOR_NUMBER"		"$output_MAJOR_NUMBER"			'major number'		      && \
		    dotest-equal	"$MINOR_NUMBER"		"$output_MINOR_NUMBER"			'minor number'		      && \
		    dotest-equal	"$PATCH_LEVEL"		"$output_PATCH_LEVEL"			'patch level'		      && \
		    dotest-equal	"$PRERELEASE_VERSION"	"$output_PRERELEASE_VERSION"		'prerelease version'	      && \
		    dotest-equal	"$BUILD_METADATA"	"$output_BUILD_METADATA"		'build metadata'	      && \
		    dotest-equal	0			"$output_START_INDEX"			'start index'		      && \
		    dotest-equal	${#SPEC}		"$output_END_INDEX"			'end index'
		EXIT_STATUS=$?
	    fi
	else EXIT_STATUS=1
	fi
    }
    mbfl_location_leave
    return $EXIT_STATUS
}

function p-semver-parse-correct-version-numbers () {
    mbfl_mandatory_parameter(MAJOR_NUMBER,	1, major version number)
    mbfl_mandatory_parameter(MINOR_NUMBER,	2, minor version number)
    mbfl_mandatory_parameter(PATCH_LEVEL,	3, patch level number)
    local -r PRERELEASE_VERSION=
    local -r BUILD_METADATA=
    mbfl_optional_parameter(TAIL,		4)

    p-semver-parse-correct-specification "$MAJOR_NUMBER" "$MINOR_NUMBER" "$PATCH_LEVEL" "$PRERELEASE_VERSION" "$BUILD_METADATA" "$TAIL"
}

function p-semver-parse-correct-prerelease-version () {
    local -r MAJOR_NUMBER='1'
    local -r MINOR_NUMBER='2'
    local -r PATCH_LEVEL='3'
    mbfl_mandatory_parameter(PRERELEASE_VERSION,	1, prerelease version specification)
    local -r BUILD_METADATA=
    mbfl_optional_parameter(TAIL,			2)

    p-semver-parse-correct-specification "$MAJOR_NUMBER" "$MINOR_NUMBER" "$PATCH_LEVEL" "$PRERELEASE_VERSION" "$BUILD_METADATA" "$TAIL"
}

function p-semver-parse-correct-build-metadata () {
    local -r MAJOR_NUMBER='1'
    local -r MINOR_NUMBER='2'
    local -r PATCH_LEVEL='3'
    local -r PRERELEASE_VERSION=''
    mbfl_mandatory_parameter(BUILD_METADATA,	1, build metadata specification)
    mbfl_optional_parameter(TAIL,		2)

    p-semver-parse-correct-specification "$MAJOR_NUMBER" "$MINOR_NUMBER" "$PATCH_LEVEL" "$PRERELEASE_VERSION" "$BUILD_METADATA" "$TAIL"
}


#### predicates

function semver-string-predicate-major-number-1.1 () {
    mbfl_string_is_semver_major_number '0'
}
function semver-string-predicate-major-number-1.2 () {
    mbfl_string_is_semver_major_number '12'
}
function semver-string-predicate-major-number-2.1 () {
    ! mbfl_string_is_semver_major_number '012'
}
function semver-string-predicate-major-number-2.2 () {
    ! mbfl_string_is_semver_major_number 'ciao'
}
function semver-string-predicate-major-number-2.3 () {
    ! mbfl_string_is_semver_major_number '1.2'
}
function semver-string-predicate-major-number-2.4 () {
    ! mbfl_string_is_semver_major_number '1 2'
}

### ------------------------------------------------------------------------

function semver-string-predicate-minor-number-1.1 () {
    mbfl_string_is_semver_minor_number '0'
}
function semver-string-predicate-minor-number-1.2 () {
    mbfl_string_is_semver_minor_number '12'
}
function semver-string-predicate-minor-number-2.1 () {
    ! mbfl_string_is_semver_minor_number '012'
}
function semver-string-predicate-minor-number-2.2 () {
    ! mbfl_string_is_semver_minor_number 'ciao'
}
function semver-string-predicate-minor-number-2.3 () {
    ! mbfl_string_is_semver_minor_number '1.2'
}
function semver-string-predicate-minor-number-2.4 () {
    ! mbfl_string_is_semver_minor_number '1 2'
}

### ------------------------------------------------------------------------

function semver-string-predicate-patch-level-1.1 () {
    mbfl_string_is_semver_patch_level '0'
}
function semver-string-predicate-patch-level-1.2 () {
    mbfl_string_is_semver_patch_level '12'
}
function semver-string-predicate-patch-level-2.1 () {
    ! mbfl_string_is_semver_patch_level '012'
}
function semver-string-predicate-patch-level-2.2 () {
    ! mbfl_string_is_semver_patch_level 'ciao'
}
function semver-string-predicate-patch-level-2.3 () {
    ! mbfl_string_is_semver_patch_level '1.2'
}
function semver-string-predicate-patch-level-2.4 () {
    ! mbfl_string_is_semver_patch_level '1 2'
}

### ------------------------------------------------------------------------

function semver-string-predicate-prerelease-version-1.1 () {
    mbfl_string_is_semver_prerelease_version '0'
}
function semver-string-predicate-prerelease-version-1.2 () {
    mbfl_string_is_semver_prerelease_version '123'
}
function semver-string-predicate-prerelease-version-1.3 () {
    # Leading zeros are not allowed.
    ! mbfl_string_is_semver_prerelease_version '010'
}

function semver-string-predicate-prerelease-version-2.1 () {
    mbfl_string_is_semver_prerelease_version 'ciao'
}
function semver-string-predicate-prerelease-version-2.2 () {
    mbfl_string_is_semver_prerelease_version 'ciao-mamma'
}
function semver-string-predicate-prerelease-version-2.3 () {
    # Underscores are not allowed.
    ! mbfl_string_is_semver_prerelease_version 'ciao_mamma'
}

function semver-string-predicate-prerelease-version-3.1 () {
    mbfl_string_is_semver_prerelease_version '-'
}
function semver-string-predicate-prerelease-version-3.2 () {
    mbfl_string_is_semver_prerelease_version '-----'
}
function semver-string-predicate-prerelease-version-3.3 () {
    ! mbfl_string_is_semver_prerelease_version [[['_']]]
}
function semver-string-predicate-prerelease-version-3.4 () {
    ! mbfl_string_is_semver_prerelease_version '____'
}

function semver-string-predicate-prerelease-version-4.1 () {
    mbfl_string_is_semver_prerelease_version 'ciao.0.mamma.1'
}
function semver-string-predicate-prerelease-version-4.2 () {
    mbfl_string_is_semver_prerelease_version '0.ciao.1.mamma'
}
function semver-string-predicate-prerelease-version-4.3 () {
    mbfl_string_is_semver_prerelease_version 'ciao.mamma.0.1'
}
function semver-string-predicate-prerelease-version-4.4 () {
    # Weird but valid.
    mbfl_string_is_semver_prerelease_version 'ciao.-----.0.1'
}

function semver-string-predicate-prerelease-version-5.1 () {
    ! mbfl_string_is_semver_prerelease_version 'ciao mamma.0.1'
}
function semver-string-predicate-prerelease-version-5.2 () {
    ! mbfl_string_is_semver_prerelease_version 'ciao,mamma.0.1'
}
function semver-string-predicate-prerelease-version-5.3 () {
    ! mbfl_string_is_semver_prerelease_version 'ciao mamma.0.1'
}
function semver-string-predicate-prerelease-version-5.4 () {
    ! mbfl_string_is_semver_prerelease_version 'ciao_mamma.0.1'
}
function semver-string-predicate-prerelease-version-5.5 () {
    ! mbfl_string_is_semver_prerelease_version 'ciao;mamma.0.1'
}
function semver-string-predicate-prerelease-version-5.6 () {
    ! mbfl_string_is_semver_prerelease_version 'ciao.01'
}

### ------------------------------------------------------------------------

function semver-string-predicate-build-metadata-without-underscore-1.1 () {
    mbfl_string_is_semver_build_metadata '0'
}
function semver-string-predicate-build-metadata-without-underscore-1.2 () {
    mbfl_string_is_semver_build_metadata '123'
}
function semver-string-predicate-build-metadata-without-underscore-1.3 () {
    mbfl_string_is_semver_build_metadata 'ciao'
}
function semver-string-predicate-build-metadata-without-underscore-1.3 () {
    # Leading zeros are allowed
    mbfl_string_is_semver_build_metadata '0123'
}

function semver-string-predicate-build-metadata-without-underscore-2.1 () {
    ! mbfl_string_is_semver_build_metadata '01_23'
}
function semver-string-predicate-build-metadata-without-underscore-2.2 () {
    ! mbfl_string_is_semver_build_metadata '01,23'
}
function semver-string-predicate-build-metadata-without-underscore-2.3 () {
    ! mbfl_string_is_semver_build_metadata '01 23'
}

function semver-string-predicate-build-metadata-without-underscore-3.1 () {
    mbfl_string_is_semver_build_metadata '0.1.2'
}
function semver-string-predicate-build-metadata-without-underscore-3.2 () {
    mbfl_string_is_semver_build_metadata 'ciao.mamma.hey'
}
function semver-string-predicate-build-metadata-without-underscore-3.3 () {
    mbfl_string_is_semver_build_metadata 'ciao.0.mamma.1'
}
function semver-string-predicate-build-metadata-without-underscore-3.4 () {
    mbfl_string_is_semver_build_metadata '0.ciao.1.mamma'
}

### ------------------------------------------------------------------------

function semver-string-predicate-build-metadata-with-underscore-1.1 () {
    mbfl_string_is_semver_build_metadata_with_underscore '0'
}
function semver-string-predicate-build-metadata-with-underscore-1.2 () {
    mbfl_string_is_semver_build_metadata_with_underscore '123'
}
function semver-string-predicate-build-metadata-with-underscore-1.3 () {
    mbfl_string_is_semver_build_metadata_with_underscore 'ciao'
}
function semver-string-predicate-build-metadata-with-underscore-1.3 () {
    # Leading zeros are allowed
    mbfl_string_is_semver_build_metadata_with_underscore '0123'
}
function semver-string-predicate-build-metadata-with-underscore-1.4 () {
    mbfl_string_is_semver_build_metadata_with_underscore '01_23'
}

function semver-string-predicate-build-metadata-with-underscore-2.1 () {
    ! mbfl_string_is_semver_build_metadata_with_underscore '01,23'
}
function semver-string-predicate-build-metadata-with-underscore-2.2 () {
    ! mbfl_string_is_semver_build_metadata_with_underscore '01 23'
}

function semver-string-predicate-build-metadata-with-underscore-3.1 () {
    mbfl_string_is_semver_build_metadata_with_underscore '0.1.2'
}
function semver-string-predicate-build-metadata-with-underscore-3.2 () {
    mbfl_string_is_semver_build_metadata_with_underscore 'ciao.mamma.hey'
}
function semver-string-predicate-build-metadata-with-underscore-3.3 () {
    mbfl_string_is_semver_build_metadata_with_underscore 'ciao.0.mamma.1'
}
function semver-string-predicate-build-metadata-with-underscore-3.4 () {
    mbfl_string_is_semver_build_metadata_with_underscore '0.ciao.1.mamma'
}
function semver-string-predicate-build-metadata-with-underscore-3.5 () {
    mbfl_string_is_semver_build_metadata_with_underscore '0.ciao_mamma'
}
function semver-string-predicate-build-metadata-with-underscore-3.6 () {
    mbfl_string_is_semver_build_metadata_with_underscore '0.ciao-mamma'
}


#### parser input

function semver-class-parser-input-1.1 () {
    mbfl_default_object_declare(PARSER_INPUT)
    declare -r INPUT_STRING="1.2.3-alpha.1"

    mbfl_semver_parser_input_make _(PARSER_INPUT) "$INPUT_STRING" 0
}

### ------------------------------------------------------------------------
### class predicate

function semver-class-parser-input-2.1 () {
    mbfl_default_object_declare(PARSER_INPUT)
    declare -r INPUT_STRING="1.2.3-alpha.1"

    mbfl_semver_parser_input_make _(PARSER_INPUT) "$INPUT_STRING" 0
    mbfl_semver_parser_input_p _(PARSER_INPUT)
}

### ------------------------------------------------------------------------
### input string field

function semver-class-parser-input-3.1 () {
    mbfl_default_object_declare(PARSER_INPUT)
    declare -r INPUT_STRING="1.2.3-alpha.1"
    mbfl_declare_varref(STR)

    mbfl_semver_parser_input_make _(PARSER_INPUT) "$INPUT_STRING" 0
    mbfl_semver_parser_input_string_var _(STR) _(PARSER_INPUT)

    dotest-equal	"$INPUT_STRING"	"$STR"	'input string'
}

### ------------------------------------------------------------------------
### start index field

function semver-class-parser-input-4.1 () {
    mbfl_default_object_declare(PARSER_INPUT)
    declare -r INPUT_STRING="frobnicator-1.2.3-alpha.1"
    mbfl_declare_integer_varref(IDX)

    mbfl_semver_parser_input_make _(PARSER_INPUT) "$INPUT_STRING"  12
    mbfl_semver_parser_input_start_index_var _(IDX) _(PARSER_INPUT)

    dotest-equal 12 "$IDX" 'start index'
}
function semver-class-parser-input-4.2 () {
    mbfl_default_object_declare(PARSER_INPUT)
    declare -r INPUT_STRING="frobnicator-1.2.3-alpha.1"
    mbfl_declare_integer_varref(IDX)

    {
	mbfl_semver_parser_input_make _(PARSER_INPUT) "$INPUT_STRING" 99 2>&1 && echo success
    } | {
	dotest-output '<unknown>: error: start index "99" must be positive and less than the length of the input string "25"'
    }
}

### ------------------------------------------------------------------------
### end index field

function semver-class-parser-input-5.1 () {
    mbfl_default_object_declare(PARSER_INPUT)
    declare -r INPUT_STRING="frobnicator-1.2.3-alpha.1"
    mbfl_declare_integer_varref(IDX)

    mbfl_semver_parser_input_make _(PARSER_INPUT) "$INPUT_STRING"  12
    mbfl_semver_parser_input_end_index_var _(IDX) _(PARSER_INPUT)

    dotest-equal 12 "$IDX" 'end index'
}
function semver-class-parser-input-5.2 () {
    mbfl_default_object_declare(PARSER_INPUT)
    declare -r INPUT_STRING="frobnicator-1.2.3-alpha.1"
    mbfl_declare_integer_varref(IDX)

    mbfl_semver_parser_input_make _(PARSER_INPUT) "$INPUT_STRING"  12
    mbfl_semver_parser_input_end_index_set _(PARSER_INPUT) 20
    mbfl_semver_parser_input_end_index_var _(IDX) _(PARSER_INPUT)

    dotest-equal 20 "$IDX" 'end index'
}


#### semver parser

function semver-class-semver-parser-1.1 () {
    mbfl_default_object_declare(SEMVER_PARSER)
    declare PLV AUIBM

    mbfl_semver_parser_make_default _(SEMVER_PARSER)

    mbfl_semver_parser_parse_leading_v_var                     PLV   _(SEMVER_PARSER)
    mbfl_semver_parser_accept_underscore_in_build_metadata_var AUIBM _(SEMVER_PARSER)

    dotest-equal	'optional'	"$PLV"		&&
	dotest-equal	'false'		"$AUIBM"
}

function semver-class-semver-parser-2.1 () {
    mbfl_default_object_declare(SEMVER_PARSER)
    declare PLV AUIBM

    mbfl_semver_parser_make_default _(SEMVER_PARSER)
    mbfl_semver_parser_p _(SEMVER_PARSER)
}

function semver-class-semver-parser-3.1 () {
    mbfl_default_object_declare(SEMVER_PARSER)
    declare PLV AUIBM

    {
	mbfl_semver_parser_make_default _(SEMVER_PARSER)					      &&
	    mbfl_semver_parser_parse_leading_v_set                     _(SEMVER_PARSER) 'mandatory'   &&
	    mbfl_semver_parser_accept_underscore_in_build_metadata_set _(SEMVER_PARSER) 'true'	      &&
	    mbfl_semver_parser_parse_leading_v_var                     PLV   _(SEMVER_PARSER)	      &&
	    mbfl_semver_parser_accept_underscore_in_build_metadata_var AUIBM _(SEMVER_PARSER)
    } && {
	dotest-equal		'mandatory'	"$PLV"		&&
	    dotest-equal	'true'		"$AUIBM"
    }
}

### ------------------------------------------------------------------------

function handler_semver_class_semver_parser () {
    mbfl_mandatory_parameter(EXPECTED_ATTRIB_NAME,	1, expected attribute name)
    mbfl_mandatory_nameref_parameter(CND,		2, exceptional-condition object)

    #echo $FUNCNAME enter $EXPECTED_ATTRIB_NAME >&2

    if mbfl_invalid_object_attrib_value_condition_p _(CND)
    then
       	mbfl_declare_varref(ATTRIB_NAME)

	mbfl_invalid_object_attrib_value_condition_attrib_name_var _(ATTRIB_NAME) _(CND)
	#echo $FUNCNAME names "$EXPECTED_ATTRIB_NAME" "$ATTRIB_NAME" >&2

	# We   make  this   exceptional-condition  continuable   so  the   mutators  in   the  tests
	# "semver-class-semver-spec-from-components-2.*" will return successfully.
	mbfl_exceptional_condition_continuable_set _(CND) true

	if mbfl_string_eq("$ATTRIB_NAME", "$EXPECTED_ATTRIB_NAME")
	then
	    FLAG='one'
	    #echo $FUNCNAME success $FLAG >&2
	    return_success_after_handling_exception
	else
	    FLAG='two'
	    #echo $FUNCNAME failure >&2
	    return_failure_after_handling_exception
	fi
    else
	FLAG='three'
	return_after_not_handling_exception
    fi
}
function semver-class-semver-parser-4.1 () {
    declare FLAG='false' RETURN_STATUS=0

    mbfl_location_enter
    {
	mbfl_exception_handler 'handler_semver_class_semver_parser parse_leading_v'
	mbfl_default_object_declare(SEMVER_PARSER)

	mbfl_semver_parser_make_default _(SEMVER_PARSER)

	mbfl_semver_parser_parse_leading_v_set _(SEMVER_PARSER) 'ciao'
	RETURN_STATUS=$?
    }
    mbfl_location_leave
    dotest-equal 'one' $FLAG 'flag value' && dotest-equal 0 $RETURN_STATUS 'return status'
}
function semver-class-semver-parser-4.2 () {
    declare FLAG='false' RETURN_STATUS=0

    mbfl_location_enter
    {
	mbfl_exception_handler 'handler_semver_class_semver_parser accept_underscore_in_build_metadata'
	mbfl_default_object_declare(SEMVER_PARSER)

	mbfl_semver_parser_make_default _(SEMVER_PARSER)
	mbfl_semver_parser_accept_underscore_in_build_metadata_set _(SEMVER_PARSER) 'ciao'
	RETURN_STATUS=$?
    }
    mbfl_location_leave
    dotest-equal 'one' $FLAG 'flag value' && dotest-equal 0 $RETURN_STATUS 'return status'
}


#### semver specification from components

function semver-class-semver-spec-from-components-1.1.1 () {
    mbfl_default_object_declare(SEMVER_SPEC)
    declare MAJOR_NUMBER MINOR_NUMBER PATCH_LEVEL PRERELEASE_VERSION BUILD_METADATA STRING_REP

    mbfl_semver_spec_make_from_components _(SEMVER_SPEC) 1 2 3 devel.4 x86-64

    mbfl_semver_spec_major_number_var		MAJOR_NUMBER		_(SEMVER_SPEC)
    mbfl_semver_spec_minor_number_var		MINOR_NUMBER		_(SEMVER_SPEC)
    mbfl_semver_spec_patch_level_var		PATCH_LEVEL		_(SEMVER_SPEC)
    mbfl_semver_spec_prerelease_version_var	PRERELEASE_VERSION	_(SEMVER_SPEC)
    mbfl_semver_spec_build_metadata_var		BUILD_METADATA		_(SEMVER_SPEC)
    mbfl_semver_spec_string_var			STRING_REP		_(SEMVER_SPEC)

    dotest-equal	'1'			"$MAJOR_NUMBER"		&&
	dotest-equal	'2'			"$MINOR_NUMBER"		&&
	dotest-equal	'3'			"$PATCH_LEVEL"		&&
	dotest-equal	'devel.4'		"$PRERELEASE_VERSION"	&&
	dotest-equal	'x86-64'		"$BUILD_METADATA"	&&
	dotest-equal	'1.2.3-devel.4+x86-64'	"$STRING_REP"
}

# No prerelease-version.
#
function semver-class-semver-spec-from-components-1.1.2 () {
    mbfl_default_object_declare(SEMVER_SPEC)
    declare MAJOR_NUMBER MINOR_NUMBER PATCH_LEVEL PRERELEASE_VERSION BUILD_METADATA
    mbfl_declare_varref(STRING_REP)

    mbfl_semver_spec_make_from_components _(SEMVER_SPEC) 1 2 3 '' x86-64

    mbfl_semver_spec_major_number_var		MAJOR_NUMBER		_(SEMVER_SPEC)
    mbfl_semver_spec_minor_number_var		MINOR_NUMBER		_(SEMVER_SPEC)
    mbfl_semver_spec_patch_level_var		PATCH_LEVEL		_(SEMVER_SPEC)
    mbfl_semver_spec_prerelease_version_var	PRERELEASE_VERSION	_(SEMVER_SPEC)
    mbfl_semver_spec_build_metadata_var		BUILD_METADATA		_(SEMVER_SPEC)
    mbfl_semver_spec_string_var			_(STRING_REP)		_(SEMVER_SPEC)

    #echo $FUNCNAME ,"$STRING_REP", mbfl_string_len(STRING_REP) >&2

    dotest-equal	'1'			"$MAJOR_NUMBER"		&&
	dotest-equal	'2'			"$MINOR_NUMBER"		&&
	dotest-equal	'3'			"$PATCH_LEVEL"		&&
	dotest-equal	''			"$PRERELEASE_VERSION"	&&
	dotest-equal	'x86-64'		"$BUILD_METADATA"	&&
	dotest-equal	'1.2.3+x86-64'		"$STRING_REP"		'string representation'
}

# No build-metadata.
#
function semver-class-semver-spec-from-components-1.1.3 () {
    mbfl_default_object_declare(SEMVER_SPEC)
    declare MAJOR_NUMBER MINOR_NUMBER PATCH_LEVEL PRERELEASE_VERSION BUILD_METADATA STRING_REP

    mbfl_semver_spec_make_from_components _(SEMVER_SPEC) 1 2 3 devel.4 ''

    mbfl_semver_spec_major_number_var		MAJOR_NUMBER		_(SEMVER_SPEC)
    mbfl_semver_spec_minor_number_var		MINOR_NUMBER		_(SEMVER_SPEC)
    mbfl_semver_spec_patch_level_var		PATCH_LEVEL		_(SEMVER_SPEC)
    mbfl_semver_spec_prerelease_version_var	PRERELEASE_VERSION	_(SEMVER_SPEC)
    mbfl_semver_spec_build_metadata_var		BUILD_METADATA		_(SEMVER_SPEC)
    mbfl_semver_spec_string_var			STRING_REP		_(SEMVER_SPEC)

    dotest-equal	'1'			"$MAJOR_NUMBER"		&&
	dotest-equal	'2'			"$MINOR_NUMBER"		&&
	dotest-equal	'3'			"$PATCH_LEVEL"		&&
	dotest-equal	'devel.4'		"$PRERELEASE_VERSION"	&&
	dotest-equal	''			"$BUILD_METADATA"	&&
	dotest-equal	'1.2.3-devel.4'		"$STRING_REP"
}

# No prerelease-version and no build-metadata.
#
function semver-class-semver-spec-from-components-1.1.4 () {
    mbfl_default_object_declare(SEMVER_SPEC)
    declare MAJOR_NUMBER MINOR_NUMBER PATCH_LEVEL PRERELEASE_VERSION BUILD_METADATA STRING_REP

    mbfl_semver_spec_make_from_components _(SEMVER_SPEC) 1 2 3 '' ''

    mbfl_semver_spec_major_number_var		MAJOR_NUMBER		_(SEMVER_SPEC)
    mbfl_semver_spec_minor_number_var		MINOR_NUMBER		_(SEMVER_SPEC)
    mbfl_semver_spec_patch_level_var		PATCH_LEVEL		_(SEMVER_SPEC)
    mbfl_semver_spec_prerelease_version_var	PRERELEASE_VERSION	_(SEMVER_SPEC)
    mbfl_semver_spec_build_metadata_var		BUILD_METADATA		_(SEMVER_SPEC)
    mbfl_semver_spec_string_var			STRING_REP		_(SEMVER_SPEC)

    dotest-equal	'1'			"$MAJOR_NUMBER"		&&
	dotest-equal	'2'			"$MINOR_NUMBER"		&&
	dotest-equal	'3'			"$PATCH_LEVEL"		&&
	dotest-equal	''			"$PRERELEASE_VERSION"	&&
	dotest-equal	''			"$BUILD_METADATA"	&&
	dotest-equal	'1.2.3'			"$STRING_REP"
}

function semver-class-semver-spec-from-components-1.2.1 () {
    mbfl_default_object_declare(SEMVER_SPEC)
    mbfl_declare_varref(VALUE)

    mbfl_semver_spec_make_from_components _(SEMVER_SPEC) 1 2 3 devel.4 x86-64
    mbfl_semver_spec_major_number_set _(SEMVER_SPEC) 999
    mbfl_semver_spec_major_number_var _(VALUE) _(SEMVER_SPEC)
    dotest-equal 999 "$VALUE"
}
function semver-class-semver-spec-from-components-1.2.2 () {
    mbfl_default_object_declare(SEMVER_SPEC)
    mbfl_declare_varref(VALUE)

    mbfl_semver_spec_make_from_components _(SEMVER_SPEC) 1 2 3 devel.4 x86-64
    mbfl_semver_spec_minor_number_set _(SEMVER_SPEC) 999
    mbfl_semver_spec_minor_number_var _(VALUE) _(SEMVER_SPEC)
    dotest-equal 999 "$VALUE"
}
function semver-class-semver-spec-from-components-1.2.3 () {
    mbfl_default_object_declare(SEMVER_SPEC)
    mbfl_declare_varref(VALUE)

    mbfl_semver_spec_make_from_components _(SEMVER_SPEC) 1 2 3 devel.4 x86-64
    mbfl_semver_spec_patch_level_set _(SEMVER_SPEC) 999
    mbfl_semver_spec_patch_level_var _(VALUE) _(SEMVER_SPEC)
    dotest-equal 999 "$VALUE"
}
function semver-class-semver-spec-from-components-1.2.4 () {
    mbfl_default_object_declare(SEMVER_SPEC)
    mbfl_declare_varref(VALUE)

    mbfl_semver_spec_make_from_components _(SEMVER_SPEC) 1 2 3 devel.4 x86-64
    mbfl_semver_spec_prerelease_version_set _(SEMVER_SPEC) alpha.9
    mbfl_semver_spec_prerelease_version_var _(VALUE) _(SEMVER_SPEC)
    dotest-equal alpha.9 "$VALUE"
}
function semver-class-semver-spec-from-components-1.2.5 () {
    mbfl_default_object_declare(SEMVER_SPEC)
    mbfl_declare_varref(VALUE)

    mbfl_semver_spec_make_from_components _(SEMVER_SPEC) 1 2 3 devel.4 x86-64
    mbfl_semver_spec_build_metadata_set _(SEMVER_SPEC) x86-32
    mbfl_semver_spec_build_metadata_var _(VALUE) _(SEMVER_SPEC)
    dotest-equal x86-32 "$VALUE"
}

### ------------------------------------------------------------------------

function semver-class-semver-spec-from-components-2.1.1 () {
    mbfl_default_object_declare(SEMVER_SPEC)

    ! mbfl_semver_spec_make_from_components _(SEMVER_SPEC) ciao 2 3 devel.4 x86-64
}
function semver-class-semver-spec-from-components-2.1.2 () {
    mbfl_default_object_declare(SEMVER_SPEC)

    ! mbfl_semver_spec_make_from_components _(SEMVER_SPEC) 1 ciao 3 devel.4 x86-64
}
function semver-class-semver-spec-from-components-2.1.3 () {
    mbfl_default_object_declare(SEMVER_SPEC)

    ! mbfl_semver_spec_make_from_components _(SEMVER_SPEC) 1 2 ciao devel.4 x86-64
}
function semver-class-semver-spec-from-components-2.1.4 () {
    mbfl_default_object_declare(SEMVER_SPEC)

    ! mbfl_semver_spec_make_from_components _(SEMVER_SPEC) 1 2 3 'ciao mamma' x86-64
}
function semver-class-semver-spec-from-components-2.1.5 () {
    mbfl_default_object_declare(SEMVER_SPEC)

    ! mbfl_semver_spec_make_from_components _(SEMVER_SPEC) 1 2 3 devel.4 'ciao mamma'
}

### ------------------------------------------------------------------------

function handler_semver_class_semver_spec_from_components () {
    mbfl_mandatory_parameter(EXPECTED_ATTRIB_NAME,	1, expected attribute name)
    mbfl_mandatory_nameref_parameter(CND,		2, exceptional-condition object)

    #echo $FUNCNAME enter $EXPECTED_ATTRIB_NAME >&2

    if mbfl_invalid_object_attrib_value_condition_p _(CND)
    then
       	mbfl_declare_varref(ATTRIB_NAME)

	mbfl_invalid_object_attrib_value_condition_attrib_name_var _(ATTRIB_NAME) _(CND)
	#echo $FUNCNAME names "$EXPECTED_ATTRIB_NAME" "$ATTRIB_NAME" >&2

	# We   make  this   exceptional-condition  continuable   so  the   mutators  in   the  tests
	# "semver-class-semver-spec-from-components-2.*" will return successfully.
	mbfl_exceptional_condition_continuable_set _(CND) true

	if mbfl_string_eq("$ATTRIB_NAME", "$EXPECTED_ATTRIB_NAME")
	then
	    FLAG='one'
	    #echo $FUNCNAME success $FLAG >&2
	    return_success_after_handling_exception
	else
	    FLAG='two'
	    #echo $FUNCNAME failure >&2
	    return_failure_after_handling_exception
	fi
    else
	FLAG='three'
	return_after_not_handling_exception
    fi
}
function semver-class-semver-spec-from-components-2.2.1 () {
    declare FLAG='false' RETURN_STATUS=0

    mbfl_location_enter
    {
	mbfl_exception_handler 'handler_semver_class_semver_spec_from_components major_number'
	mbfl_default_object_declare(SEMVER_SPEC)

	mbfl_semver_spec_make_from_components _(SEMVER_SPEC) 1 2 3 devel.4 x86-64
	mbfl_semver_spec_major_number_set _(SEMVER_SPEC) 'ciao mamma'
	RETURN_STATUS=$?
    }
    mbfl_location_leave
    dotest-equal 'one' $FLAG 'flag value' && dotest-equal 0 $RETURN_STATUS 'return status'
}
function semver-class-semver-spec-from-components-2.2.2 () {
    declare FLAG='false' RETURN_STATUS=0

    mbfl_location_enter
    {
	mbfl_exception_handler 'handler_semver_class_semver_spec_from_components minor_number'
	mbfl_default_object_declare(SEMVER_SPEC)

	mbfl_semver_spec_make_from_components _(SEMVER_SPEC) 1 2 3 devel.4 x86-64
	! mbfl_semver_spec_minor_number_set _(SEMVER_SPEC) 'ciao mamma'
    }
    mbfl_location_leave
    dotest-equal 'one' $FLAG 'flag value' && dotest-equal 0 $RETURN_STATUS 'return status'
}
function semver-class-semver-spec-from-components-2.2.3 () {
    declare FLAG='false' RETURN_STATUS=0

    mbfl_location_enter
    {
	mbfl_exception_handler 'handler_semver_class_semver_spec_from_components patch_level'
	mbfl_default_object_declare(SEMVER_SPEC)

	mbfl_semver_spec_make_from_components _(SEMVER_SPEC) 1 2 3 devel.4 x86-64
	! mbfl_semver_spec_patch_level_set _(SEMVER_SPEC) 'ciao mamma'
    }
    mbfl_location_leave
    dotest-equal 'one' $FLAG 'flag value' && dotest-equal 0 $RETURN_STATUS 'return status'
}
function semver-class-semver-spec-from-components-2.2.4 () {
    declare FLAG='false' RETURN_STATUS=0

    mbfl_location_enter
    {
	mbfl_exception_handler 'handler_semver_class_semver_spec_from_components prerelease_version'
	mbfl_default_object_declare(SEMVER_SPEC)

	mbfl_semver_spec_make_from_components _(SEMVER_SPEC) 1 2 3 devel.4 x86-64
	! mbfl_semver_spec_prerelease_version_set _(SEMVER_SPEC) 'ciao mamma'
    }
    mbfl_location_leave
    dotest-equal 'one' $FLAG 'flag value' && dotest-equal 0 $RETURN_STATUS 'return status'
}
function semver-class-semver-spec-from-components-2.2.5 () {
    declare FLAG='false' RETURN_STATUS=0

    mbfl_location_enter
    {
	mbfl_exception_handler 'handler_semver_class_semver_spec_from_components build_metadata'
	mbfl_default_object_declare(SEMVER_SPEC)

	mbfl_semver_spec_make_from_components _(SEMVER_SPEC) 1 2 3 devel.4 x86-64
	! mbfl_semver_spec_build_metadata_set _(SEMVER_SPEC) 'ciao mamma'
    }
    mbfl_location_leave
    dotest-equal 'one' $FLAG 'flag value' && dotest-equal 0 $RETURN_STATUS 'return status'
}


#### semver specification from string

function semver-class-semver-spec-from-string-1.1.1 () {
    mbfl_default_object_declare(SEMVER_SPEC)
    declare MAJOR_NUMBER MINOR_NUMBER PATCH_LEVEL PRERELEASE_VERSION BUILD_METADATA STRING_REP

    mbfl_semver_spec_make_from_string _(SEMVER_SPEC) '1.2.3-devel.4+x86-64'

    mbfl_semver_spec_major_number_var		MAJOR_NUMBER		_(SEMVER_SPEC)
    mbfl_semver_spec_minor_number_var		MINOR_NUMBER		_(SEMVER_SPEC)
    mbfl_semver_spec_patch_level_var		PATCH_LEVEL		_(SEMVER_SPEC)
    mbfl_semver_spec_prerelease_version_var	PRERELEASE_VERSION	_(SEMVER_SPEC)
    mbfl_semver_spec_build_metadata_var		BUILD_METADATA		_(SEMVER_SPEC)
    mbfl_semver_spec_string_var			STRING_REP		_(SEMVER_SPEC)

    dotest-equal	'1'			"$MAJOR_NUMBER"		&&
	dotest-equal	'2'			"$MINOR_NUMBER"		&&
	dotest-equal	'3'			"$PATCH_LEVEL"		&&
	dotest-equal	'devel.4'		"$PRERELEASE_VERSION"	&&
	dotest-equal	'x86-64'		"$BUILD_METADATA"	&&
	dotest-equal	'1.2.3-devel.4+x86-64'	"$STRING_REP"
}

# No prerelease-version
#
function semver-class-semver-spec-from-string-1.1.2 () {
    mbfl_default_object_declare(SEMVER_SPEC)
    declare MAJOR_NUMBER MINOR_NUMBER PATCH_LEVEL PRERELEASE_VERSION BUILD_METADATA STRING_REP

    mbfl_semver_spec_make_from_string _(SEMVER_SPEC) '1.2.3+x86-64'

    mbfl_semver_spec_major_number_var		MAJOR_NUMBER		_(SEMVER_SPEC)
    mbfl_semver_spec_minor_number_var		MINOR_NUMBER		_(SEMVER_SPEC)
    mbfl_semver_spec_patch_level_var		PATCH_LEVEL		_(SEMVER_SPEC)
    mbfl_semver_spec_prerelease_version_var	PRERELEASE_VERSION	_(SEMVER_SPEC)
    mbfl_semver_spec_build_metadata_var		BUILD_METADATA		_(SEMVER_SPEC)
    mbfl_semver_spec_string_var			STRING_REP		_(SEMVER_SPEC)

    dotest-equal	'1'			"$MAJOR_NUMBER"		&&
	dotest-equal	'2'			"$MINOR_NUMBER"		&&
	dotest-equal	'3'			"$PATCH_LEVEL"		&&
	dotest-equal	''			"$PRERELEASE_VERSION"	&&
	dotest-equal	'x86-64'		"$BUILD_METADATA"	&&
	dotest-equal	'1.2.3+x86-64'		"$STRING_REP"
}

# No build-metadata.
#
function semver-class-semver-spec-from-string-1.1.3 () {
    mbfl_default_object_declare(SEMVER_SPEC)
    declare MAJOR_NUMBER MINOR_NUMBER PATCH_LEVEL PRERELEASE_VERSION BUILD_METADATA STRING_REP

    mbfl_semver_spec_make_from_string _(SEMVER_SPEC) '1.2.3-devel.4'

    mbfl_semver_spec_major_number_var		MAJOR_NUMBER		_(SEMVER_SPEC)
    mbfl_semver_spec_minor_number_var		MINOR_NUMBER		_(SEMVER_SPEC)
    mbfl_semver_spec_patch_level_var		PATCH_LEVEL		_(SEMVER_SPEC)
    mbfl_semver_spec_prerelease_version_var	PRERELEASE_VERSION	_(SEMVER_SPEC)
    mbfl_semver_spec_build_metadata_var		BUILD_METADATA		_(SEMVER_SPEC)
    mbfl_semver_spec_string_var			STRING_REP		_(SEMVER_SPEC)

    dotest-equal	'1'			"$MAJOR_NUMBER"		&&
	dotest-equal	'2'			"$MINOR_NUMBER"		&&
	dotest-equal	'3'			"$PATCH_LEVEL"		&&
	dotest-equal	'devel.4'		"$PRERELEASE_VERSION"	&&
	dotest-equal	''			"$BUILD_METADATA"	&&
	dotest-equal	'1.2.3-devel.4'		"$STRING_REP"
}

# No prerelease-version and no build-metadata.
#
function semver-class-semver-spec-from-string-1.1.4 () {
    mbfl_default_object_declare(SEMVER_SPEC)
    declare MAJOR_NUMBER MINOR_NUMBER PATCH_LEVEL PRERELEASE_VERSION BUILD_METADATA STRING_REP

    mbfl_semver_spec_make_from_string _(SEMVER_SPEC) '1.2.3'

    mbfl_semver_spec_major_number_var		MAJOR_NUMBER		_(SEMVER_SPEC)
    mbfl_semver_spec_minor_number_var		MINOR_NUMBER		_(SEMVER_SPEC)
    mbfl_semver_spec_patch_level_var		PATCH_LEVEL		_(SEMVER_SPEC)
    mbfl_semver_spec_prerelease_version_var	PRERELEASE_VERSION	_(SEMVER_SPEC)
    mbfl_semver_spec_build_metadata_var		BUILD_METADATA		_(SEMVER_SPEC)
    mbfl_semver_spec_string_var			STRING_REP		_(SEMVER_SPEC)

    dotest-equal	'1'			"$MAJOR_NUMBER"		&&
	dotest-equal	'2'			"$MINOR_NUMBER"		&&
	dotest-equal	'3'			"$PATCH_LEVEL"		&&
	dotest-equal	''			"$PRERELEASE_VERSION"	&&
	dotest-equal	''			"$BUILD_METADATA"	&&
	dotest-equal	'1.2.3'			"$STRING_REP"
}


#### Correct semantic version specification.  No prerelease version.  No build metadata.

function semver-parse-1.1.01 () { p-semver-parse-correct-version-numbers  '1'  '2'  '3'	      ;}
function semver-parse-1.1.02 () { p-semver-parse-correct-version-numbers  '0'  '0'  '0'	      ;}
function semver-parse-1.1.03 () { p-semver-parse-correct-version-numbers '10' '20' '30'	      ;}

# Tests for characters after the version numbers specification.
function semver-parse-1.1.10 () { p-semver-parse-correct-version-numbers '1' '2' '3' '/'      ;}
function semver-parse-1.1.11 () { p-semver-parse-correct-version-numbers '1' '2' '3' '_'      ;}


#### Correct semantic version specification.  Prerelease version.  No build metadata.

# Tests for single identifier specifications.
function semver-parse-1.2.00 () { p-semver-parse-correct-prerelease-version 'alpha'		      ;}
function semver-parse-1.2.01 () { p-semver-parse-correct-prerelease-version 'alpha-beta'	      ;}
function semver-parse-1.2.02 () { p-semver-parse-correct-prerelease-version 'alpha-BETA'	      ;}
function semver-parse-1.2.03 () { p-semver-parse-correct-prerelease-version 'alPHa-bETa-0123'	      ;}
function semver-parse-1.2.04 () { p-semver-parse-correct-prerelease-version 'alPHa123bETa'	      ;}
function semver-parse-1.2.05 () { p-semver-parse-correct-prerelease-version '123'		      ;}
function semver-parse-1.2.06 () { p-semver-parse-correct-prerelease-version '12300'		      ;}
function semver-parse-1.2.07 () { p-semver-parse-correct-prerelease-version '123AB'		      ;}
function semver-parse-1.2.08 () { p-semver-parse-correct-prerelease-version '12-3A-B'		      ;}

# Tests for multi identifier specifications.
function semver-parse-1.2.10 () { p-semver-parse-correct-prerelease-version 'alpha.beta.gamma'	      ;}
function semver-parse-1.2.11 () { p-semver-parse-correct-prerelease-version 'alpha.12'		      ;}
function semver-parse-1.2.12 () { p-semver-parse-correct-prerelease-version '12.alpha'		      ;}
function semver-parse-1.2.13 () { p-semver-parse-correct-prerelease-version 'alpha.12.beta.34'	      ;}
function semver-parse-1.2.14 () { p-semver-parse-correct-prerelease-version 'alpha.0.beta.0'	      ;}

# Tests for characters after the prerelease version specification.
function semver-parse-1.2.20 () { p-semver-parse-correct-prerelease-version 'alpha' '_beta'	      ;}
function semver-parse-1.2.21 () { p-semver-parse-correct-prerelease-version 'alpha' '[beta'	      ;}


#### Correct semantic version specification.  No prerelease version.  Build metadata.

function semver-parse-1.3.01 () { p-semver-parse-correct-build-metadata 'x86-64'	      ;}

# Tests for the characters after the build metadata specification.
function semver-parse-1.3.10 () { p-semver-parse-correct-build-metadata 'x86-64' '[alpha'     ;}
function semver-parse-1.3.11 () { p-semver-parse-correct-build-metadata 'x86-64' '_alpha'     ;}


#### Correct semantic version specification.  With prerelease version.  With build metadata.

function semver-parse-1.4.01 () {
    p-semver-parse-correct-specification '1' '2' '3' 'alpha.1' 'x86-64'
}

function semver-parse-1.4.02 () {
    p_semver_CONFIG[PARSE_LEADING_V]=true
    p-semver-parse-correct-specification '1' '2' '3' 'alpha.1' 'x86-64'
}

function semver-parse-1.4.03 () {
    p_semver_CONFIG[ACCEPT_UNDERSCORE_IN_BUILD_METADATA]=true
    p-semver-parse-correct-specification '1' '2' '3' 'alpha.1' 'x86_64'
}

# Enable underscore, but then do not use it.
#
function semver-parse-1.4.04 () {
    p_semver_CONFIG[ACCEPT_UNDERSCORE_IN_BUILD_METADATA]=true
    p-semver-parse-correct-specification '1' '2' '3' 'alpha.1' 'x86-64'
}


#### miscellaneous errors

# Expected a leading 'v' character.
#
function semver-parse-error-1.0 () {
    declare FLAG='false'
    declare -i EXPECTED_RETURN_STATUS=1
    declare -i GOT_RETURN_STATUS
    declare -r EXPECTED_ERROR_MESSAGE='mandatory leading "v" character not present in semantic-version specification'
    mbfl_declare_varref(GOT_ERROR_MESSAGE)

    mbfl_location_enter
    {
	mbfl_exception_handler 'handler_semver_parse_error'

	declare -r INPUT_STRING='1.2.3'
	declare -i START_INDEX=0

	mbfl_default_object_declare(SEMVER_SPEC)
	mbfl_default_object_declare(SEMVER_PARSER)
	mbfl_default_object_declare(PARSER_INPUT)

	mbfl_semver_parser_make_default _(SEMVER_PARSER)
	mbfl_semver_parser_input_make   _(PARSER_INPUT) "$INPUT_STRING" $START_INDEX

	mbfl_semver_parser_parse_leading_v_set _(SEMVER_PARSER) 'mandatory'

	mbfl_semver_parse _(SEMVER_SPEC) _(SEMVER_PARSER) _(PARSER_INPUT)
	GOT_RETURN_STATUS=$?
    }
    mbfl_location_leave

    dotest-equal	'failure-handling'		"$FLAG"			'exception-handler flag'      &&
	dotest-equal	$EXPECTED_RETURN_STATUS		$GOT_RETURN_STATUS	'return status'		      &&
	dotest-equal	"$EXPECTED_ERROR_MESSAGE"	"$GOT_ERROR_MESSAGE"	'error message'
}

### ------------------------------------------------------------------------

# Leading zero in major number.
#
function semver-parse-error-version-numbers-1.1 () {
    declare FLAG='false'
    declare -i EXPECTED_RETURN_STATUS=1
    declare -i GOT_RETURN_STATUS
    declare -r EXPECTED_ERROR_MESSAGE='invalid version numbers specification'
    mbfl_declare_varref(GOT_ERROR_MESSAGE)

    mbfl_location_enter
    {
	mbfl_exception_handler 'handler_semver_parse_error'

	mbfl_default_object_declare(SEMVER_SPEC)
	mbfl_default_object_declare(SEMVER_PARSER)
	mbfl_default_object_declare(PARSER_INPUT)

	declare -r INPUT_STRING='01.2.3'
	declare -i START_INDEX=0

	mbfl_semver_parser_make_default _(SEMVER_PARSER)
	mbfl_semver_parser_input_make   _(PARSER_INPUT) "$INPUT_STRING" $START_INDEX

	mbfl_semver_parse _(SEMVER_SPEC) _(SEMVER_PARSER) _(PARSER_INPUT)
	GOT_RETURN_STATUS=$?
    }
    mbfl_location_leave

    dotest-equal	'failure-handling'		"$FLAG"			'exception-handler flag'      &&
	dotest-equal	$EXPECTED_RETURN_STATUS		$GOT_RETURN_STATUS	'return status'		      &&
	dotest-equal	"$EXPECTED_ERROR_MESSAGE"	"$GOT_ERROR_MESSAGE"	'error message'
}

# Leading zero in minor number.
#
function semver-parse-error-version-numbers-1.2 () {
    declare FLAG='false'
    declare -i EXPECTED_RETURN_STATUS=1
    declare -i GOT_RETURN_STATUS
    declare -r EXPECTED_ERROR_MESSAGE='invalid version numbers specification'
    mbfl_declare_varref(GOT_ERROR_MESSAGE)

    mbfl_location_enter
    {
	mbfl_exception_handler 'handler_semver_parse_error'

	mbfl_default_object_declare(SEMVER_SPEC)
	mbfl_default_object_declare(SEMVER_PARSER)
	mbfl_default_object_declare(PARSER_INPUT)

	declare -r INPUT_STRING='1.02.3'
	declare -i START_INDEX=0

	mbfl_semver_parser_make_default _(SEMVER_PARSER)
	mbfl_semver_parser_input_make   _(PARSER_INPUT) "$INPUT_STRING" $START_INDEX

	mbfl_semver_parse _(SEMVER_SPEC) _(SEMVER_PARSER) _(PARSER_INPUT)
	GOT_RETURN_STATUS=$?
    }
    mbfl_location_leave

    dotest-equal	'failure-handling'		"$FLAG"			'exception-handler flag'      &&
	dotest-equal	$EXPECTED_RETURN_STATUS		$GOT_RETURN_STATUS	'return status'		      &&
	dotest-equal	"$EXPECTED_ERROR_MESSAGE"	"$GOT_ERROR_MESSAGE"	'error message'
}

# Leading zero in patch level.
#
function semver-parse-error-version-numbers-1.3 () {
    declare FLAG='false'
    declare -i EXPECTED_RETURN_STATUS=1
    declare -i GOT_RETURN_STATUS
    declare -r EXPECTED_ERROR_MESSAGE='invalid version numbers specification'
    mbfl_declare_varref(GOT_ERROR_MESSAGE)

    mbfl_location_enter
    {
	mbfl_exception_handler 'handler_semver_parse_error'

	mbfl_default_object_declare(SEMVER_SPEC)
	mbfl_default_object_declare(SEMVER_PARSER)
	mbfl_default_object_declare(PARSER_INPUT)

	declare -r INPUT_STRING='1.2.03'
	declare -i START_INDEX=0

	mbfl_semver_parser_make_default _(SEMVER_PARSER)
	mbfl_semver_parser_input_make   _(PARSER_INPUT) "$INPUT_STRING" $START_INDEX

	mbfl_semver_parse _(SEMVER_SPEC) _(SEMVER_PARSER) _(PARSER_INPUT)
	GOT_RETURN_STATUS=$?
    }
    mbfl_location_leave

    dotest-equal	'failure-handling'		"$FLAG"			'exception-handler flag'      &&
	dotest-equal	$EXPECTED_RETURN_STATUS		$GOT_RETURN_STATUS	'return status'		      &&
	dotest-equal	"$EXPECTED_ERROR_MESSAGE"	"$GOT_ERROR_MESSAGE"	'error message'
}

### ------------------------------------------------------------------------

# Invalid character in major number.
#
function semver-parse-error-version-numbers-2.0 () {
    declare FLAG='false'
    declare -i EXPECTED_RETURN_STATUS=1
    declare -i GOT_RETURN_STATUS
    declare -r EXPECTED_ERROR_MESSAGE='invalid version numbers specification'
    mbfl_declare_varref(GOT_ERROR_MESSAGE)

    mbfl_location_enter
    {
	mbfl_exception_handler 'handler_semver_parse_error'

	mbfl_default_object_declare(SEMVER_SPEC)
	mbfl_default_object_declare(SEMVER_PARSER)
	mbfl_default_object_declare(PARSER_INPUT)

	declare -r INPUT_STRING='1x9.2.3'
	declare -i START_INDEX=0

	mbfl_semver_parser_make_default _(SEMVER_PARSER)
	mbfl_semver_parser_input_make   _(PARSER_INPUT) "$INPUT_STRING" $START_INDEX

	mbfl_semver_parse _(SEMVER_SPEC) _(SEMVER_PARSER) _(PARSER_INPUT)
	GOT_RETURN_STATUS=$?
    }
    mbfl_location_leave

    dotest-equal	'failure-handling'		"$FLAG"			'exception-handler flag'      &&
	dotest-equal	$EXPECTED_RETURN_STATUS		$GOT_RETURN_STATUS	'return status'		      &&
	dotest-equal	"$EXPECTED_ERROR_MESSAGE"	"$GOT_ERROR_MESSAGE"	'error message'
}

# Invalid character in minor number.
#
function semver-parse-error-version-numbers-2.1 () {
    declare FLAG='false'
    declare -i EXPECTED_RETURN_STATUS=1
    declare -i GOT_RETURN_STATUS
    declare -r EXPECTED_ERROR_MESSAGE='invalid version numbers specification'
    mbfl_declare_varref(GOT_ERROR_MESSAGE)

    mbfl_location_enter
    {
	mbfl_exception_handler 'handler_semver_parse_error'

	mbfl_default_object_declare(SEMVER_SPEC)
	mbfl_default_object_declare(SEMVER_PARSER)
	mbfl_default_object_declare(PARSER_INPUT)

	declare -r INPUT_STRING='1.2x9.3'
	declare -i START_INDEX=0

	mbfl_semver_parser_make_default _(SEMVER_PARSER)
	mbfl_semver_parser_input_make   _(PARSER_INPUT) "$INPUT_STRING" $START_INDEX

	mbfl_semver_parse _(SEMVER_SPEC) _(SEMVER_PARSER) _(PARSER_INPUT)
	GOT_RETURN_STATUS=$?
    }
    mbfl_location_leave

    dotest-equal	'failure-handling'		"$FLAG"			'exception-handler flag'      &&
	dotest-equal	$EXPECTED_RETURN_STATUS		$GOT_RETURN_STATUS	'return status'		      &&
	dotest-equal	"$EXPECTED_ERROR_MESSAGE"	"$GOT_ERROR_MESSAGE"	'error message'
}

# Invalid character in patch level.
#
function semver-parse-error-version-numbers-2.2 () {
    declare FLAG='false'
    declare -i EXPECTED_RETURN_STATUS=1
    declare -i GOT_RETURN_STATUS
    declare -r EXPECTED_ERROR_MESSAGE='invalid version numbers specification'
    mbfl_declare_varref(GOT_ERROR_MESSAGE)

    mbfl_location_enter
    {
	mbfl_exception_handler 'handler_semver_parse_error'

	mbfl_default_object_declare(SEMVER_SPEC)
	mbfl_default_object_declare(SEMVER_PARSER)
	mbfl_default_object_declare(PARSER_INPUT)

	declare -r INPUT_STRING='1.2.3x9'
	declare -i START_INDEX=0

	mbfl_semver_parser_make_default _(SEMVER_PARSER)
	mbfl_semver_parser_input_make   _(PARSER_INPUT) "$INPUT_STRING" $START_INDEX

	mbfl_semver_parse _(SEMVER_SPEC) _(SEMVER_PARSER) _(PARSER_INPUT)
	GOT_RETURN_STATUS=$?
    }
    mbfl_location_leave

    dotest-equal	'failure-handling'		"$FLAG"			'exception-handler flag'      &&
	dotest-equal	$EXPECTED_RETURN_STATUS		$GOT_RETURN_STATUS	'return status'		      &&
	dotest-equal	"$EXPECTED_ERROR_MESSAGE"	"$GOT_ERROR_MESSAGE"	'error message'
}

### ------------------------------------------------------------------------

function handler_semver_parse_error () {
    mbfl_mandatory_nameref_parameter(CND, 1, exceptional-condition object)

    #echo $FUNCNAME enter $EXPECTED_ATTRIB_NAME >&2

    if mbfl_semver_parser_error_condition_p _(CND)
    then
	mbfl_semver_parser_error_condition_message_var _(GOT_ERROR_MESSAGE) _(CND)
	#printf '%s: messages\n\t%s\n\t%s\n' $FUNCNAME "$EXPECTED_ERROR_MESSAGE" "$GOT_ERROR_MESSAGE" >&2

	FLAG='failure-handling'
	#echo $FUNCNAME success $FLAG >&2
	return_failure_after_handling_exception
    else
	FLAG='not-handled'
	return_after_not_handling_exception
    fi
}


#### errors in prerelease version

# Empty prerelease version after hypen character.
#
function semver-parse-error-prerelease-version-1.1 () {
    declare FLAG='false'
    declare -i EXPECTED_RETURN_STATUS=1
    declare -i GOT_RETURN_STATUS
    declare -r EXPECTED_ERROR_MESSAGE='invalid prerelease version'
    mbfl_declare_varref(GOT_ERROR_MESSAGE)

    mbfl_location_enter
    {
	mbfl_exception_handler 'handler_semver_parse_error'

	mbfl_default_object_declare(SEMVER_SPEC)
	mbfl_default_object_declare(SEMVER_PARSER)
	mbfl_default_object_declare(PARSER_INPUT)

	declare -r INPUT_STRING='1.2.3-'
	declare -i START_INDEX=0

	mbfl_semver_parser_make_default _(SEMVER_PARSER)
	mbfl_semver_parser_input_make   _(PARSER_INPUT) "$INPUT_STRING" $START_INDEX

	mbfl_semver_parse _(SEMVER_SPEC) _(SEMVER_PARSER) _(PARSER_INPUT)
	GOT_RETURN_STATUS=$?
    }
    mbfl_location_leave

    dotest-equal	'failure-handling'		"$FLAG"			'exception-handler flag'      &&
	dotest-equal	$EXPECTED_RETURN_STATUS		$GOT_RETURN_STATUS	'return status'		      &&
	dotest-equal	"$EXPECTED_ERROR_MESSAGE"	"$GOT_ERROR_MESSAGE"	'error message'
}


#### errors in build metadata

# Invalid character in build metadata causes parsing to stop.
#
function semver-parse-error-build-metadata-1.0 () {
    declare FLAG='false'
    declare -i EXPECTED_RETURN_STATUS=0
    declare -i GOT_RETURN_STATUS
    declare -r EXPECTED_ERROR_MESSAGE=
    mbfl_declare_varref(GOT_ERROR_MESSAGE)

    declare -i EXPECTED_END_INDEX=9
    mbfl_declare_integer_varref(GOT_END_INDEX,0)

    mbfl_location_enter
    {
	mbfl_exception_handler 'handler_semver_parse_error'

	mbfl_default_object_declare(SEMVER_SPEC)
	mbfl_default_object_declare(SEMVER_PARSER)
	mbfl_default_object_declare(PARSER_INPUT)

	# No exception is raised, but parsing will stop at the underscore.
	#
	#                        012345678901
	declare -r INPUT_STRING='1.2.3+x86_64'
	declare -i START_INDEX=0

	mbfl_semver_parser_make_default _(SEMVER_PARSER)
	mbfl_semver_parser_input_make   _(PARSER_INPUT) "$INPUT_STRING" $START_INDEX

	mbfl_semver_parser_accept_underscore_in_build_metadata_set _(SEMVER_PARSER) 'false'

	mbfl_semver_parse _(SEMVER_SPEC) _(SEMVER_PARSER) _(PARSER_INPUT)
	GOT_RETURN_STATUS=$?

	mbfl_semver_parser_input_end_index_var _(GOT_END_INDEX) _(PARSER_INPUT)
    }
    mbfl_location_leave

    dotest-equal	'false'				"$FLAG"			'exception-handler flag'      &&
	dotest-equal	$EXPECTED_RETURN_STATUS		$GOT_RETURN_STATUS	'return status'		      &&
	dotest-equal	"$EXPECTED_ERROR_MESSAGE"	"$GOT_ERROR_MESSAGE"	'error message'		      &&
	dotest-equal	$EXPECTED_END_INDEX		$GOT_END_INDEX		'end index'
}

# Empty build metadata after plus character.
#
function semver-parse-error-build-metadata-1.1 () {
    declare FLAG='false'
    declare -i EXPECTED_RETURN_STATUS=1
    declare -i GOT_RETURN_STATUS
    declare -r EXPECTED_ERROR_MESSAGE='invalid build metadata'
    mbfl_declare_varref(GOT_ERROR_MESSAGE)

    mbfl_location_enter
    {
	mbfl_exception_handler 'handler_semver_parse_error'

	mbfl_default_object_declare(SEMVER_SPEC)
	mbfl_default_object_declare(SEMVER_PARSER)
	mbfl_default_object_declare(PARSER_INPUT)

	declare -r INPUT_STRING='1.2.3+'
	declare -i START_INDEX=0

	mbfl_semver_parser_make_default _(SEMVER_PARSER)
	mbfl_semver_parser_input_make   _(PARSER_INPUT) "$INPUT_STRING" $START_INDEX

	mbfl_semver_parse _(SEMVER_SPEC) _(SEMVER_PARSER) _(PARSER_INPUT)
	GOT_RETURN_STATUS=$?
    }
    mbfl_location_leave

    dotest-equal	'failure-handling'		"$FLAG"			'exception-handler flag'      &&
	dotest-equal	$EXPECTED_RETURN_STATUS		$GOT_RETURN_STATUS	'return status'		      &&
	dotest-equal	"$EXPECTED_ERROR_MESSAGE"	"$GOT_ERROR_MESSAGE"	'error message'
}


#### splitting prerelease version

function semver-split-prerelease-version-1.0 () {
    mbfl_declare_assoc_array_varref(RV)

    mbfl_semver_split_prerelease_version _(RV) 'alpha'

    dotest-equal	0		$?			'return status'			&& \
	dotest-equal	1		mbfl_slots_number(RV)	'number or identifiers'		&& \
	dotest-equal	'alpha'		mbfl_slot_qref(RV, 0)	'first identifier'
}

function semver-split-prerelease-version-1.1 () {
    mbfl_declare_assoc_array_varref(RV)

    mbfl_semver_split_prerelease_version _(RV) 'alpha.beta.gamma'

    dotest-equal	0		$?			'return status'			&& \
	dotest-equal	3		mbfl_slots_number(RV)	'number or identifiers'		&& \
	dotest-equal	'alpha'		mbfl_slot_qref(RV, 0)	'identifier 1'			&& \
	dotest-equal	'beta'		mbfl_slot_qref(RV, 1)	'identifier 2'			&& \
	dotest-equal	'gamma'		mbfl_slot_qref(RV, 2)	'identifier 3'
}

function semver-split-prerelease-version-1.2 () {
    mbfl_declare_assoc_array_varref(RV)

    mbfl_semver_split_prerelease_version _(RV) 'alpha.12.beta.34.gamma.56'

    dotest-equal	0		$?			'return status'			&& \
	dotest-equal	6		mbfl_slots_number(RV)	'number or identifiers'		&& \
	dotest-equal	'alpha'		mbfl_slot_qref(RV, 0)	'identifier 1'			&& \
	dotest-equal	'12'		mbfl_slot_qref(RV, 1)	'identifier 2'			&& \
	dotest-equal	'beta'		mbfl_slot_qref(RV, 2)	'identifier 3'			&& \
	dotest-equal	'34'		mbfl_slot_qref(RV, 3)	'identifier 4'			&& \
	dotest-equal	'gamma'		mbfl_slot_qref(RV, 4)	'identifier 5'			&& \
	dotest-equal	'56'		mbfl_slot_qref(RV, 5)	'identifier 6'
}


#### semantic version specifications comparison

# Version numbers comparison.
function semver-compare-1.0.01 () { p-semver-compare  0 '1.2.3' '1.2.3' ;}
function semver-compare-1.0.02 () { p-semver-compare -1 '1.2.3' '9.2.3' ;}
function semver-compare-1.0.03 () { p-semver-compare +1 '9.2.3' '1.2.3' ;}
function semver-compare-1.0.04 () { p-semver-compare -1 '1.2.3' '1.9.3' ;}
function semver-compare-1.0.05 () { p-semver-compare +1 '1.9.3' '1.2.3' ;}
function semver-compare-1.0.06 () { p-semver-compare -1 '1.2.3' '1.2.9' ;}
function semver-compare-1.0.07 () { p-semver-compare +1 '1.2.9' '1.2.3' ;}

# Prerelease version comparison: equal multiple identifiers.
function semver-compare-1.1.1 () { p-semver-compare  0 '1.2.3-alpha'		'1.2.3-alpha'	      ;}
function semver-compare-1.1.2 () { p-semver-compare  0 '1.2.3-alpha.beta'	'1.2.3-alpha.beta'    ;}
function semver-compare-1.1.3 () { p-semver-compare  0 '1.2.3-alpha.1.beta.2'	'1.2.3-alpha.1.beta.2';}

# Prerelease version comparison: lexicographic comparison of the first non-numeric identifier.
function semver-compare-1.2.1 () { p-semver-compare -1 '1.2.3-alpha'		'1.2.3-beta'	      ;}
function semver-compare-1.2.2 () { p-semver-compare +1 '1.2.3-beta'		'1.2.3-alpha'	      ;}

# Prerelease version comparison: lexicographic comparison of the second non-numeric identifier.
function semver-compare-1.3.1 () { p-semver-compare -1 '1.2.3-alpha.beta'	'1.2.3-alpha.gamma'   ;}
function semver-compare-1.3.2 () { p-semver-compare +1 '1.2.3-alpha.gamma'	'1.2.3-alpha.beta'    ;}

# Prerelease version comparison: lexicographic comparison of the first numeric identifier.
function semver-compare-1.4.1 () { p-semver-compare -1 '1.2.3-111'		'1.2.3-222'	      ;}
function semver-compare-1.4.2 () { p-semver-compare +1 '1.2.3-222'		'1.2.3-111'	      ;}

# Prerelease version comparison: lexicographic comparison of the second numeric identifier.
function semver-compare-1.5.1 () { p-semver-compare -1 '1.2.3-111.222'		'1.2.3-111.333'	      ;}
function semver-compare-1.5.2 () { p-semver-compare +1 '1.2.3-111.333'		'1.2.3-111.222'	      ;}
function semver-compare-1.5.3 () { p-semver-compare -1 '1.2.3-alpha.222'	'1.2.3-alpha.333'     ;}
function semver-compare-1.5.4 () { p-semver-compare +1 '1.2.3-alpha.333'	'1.2.3-alpha.222'     ;}
function semver-compare-1.5.4 () { p-semver-compare +1 '1.2.3-alpha.1'		'1.2.3-alpha.0'       ;}

# Prerelease version comparison: the SemVer with the most identifiers is greater.
function semver-compare-1.6.1 () { p-semver-compare -1 '1.2.3'			'1.2.3-alpha'	      ;}
function semver-compare-1.6.2 () { p-semver-compare +1 '1.2.3-alpha'		'1.2.3'		      ;}
function semver-compare-1.6.4 () { p-semver-compare -1 '1.2.3-alpha'		'1.2.3-alpha.beta'    ;}
function semver-compare-1.6.3 () { p-semver-compare +1 '1.2.3-alpha.beta'	'1.2.3-alpha'	      ;}
function semver-compare-1.6.5 () { p-semver-compare -1 '1.2.3-alpha.beta'	'1.2.3-alpha.beta.1'  ;}
function semver-compare-1.6.6 () { p-semver-compare +1 '1.2.3-alpha.beta.1'	'1.2.3-alpha.beta'    ;}
function semver-compare-1.6.7 () { p-semver-compare -1 '1.2.3-alpha.beta.gamma'	  '1.2.3-alpha.beta.gamma.1'  ;}
function semver-compare-1.6.8 () { p-semver-compare +1 '1.2.3-alpha.beta.gamma.1' '1.2.3-alpha.beta.gamma'    ;}

function p-semver-compare () {
    mbfl_mandatory_parameter(EXPECTED_RESULT, 1, reference to result variable)
    mbfl_mandatory_parameter(ONE,    2, first semantic version specification)
    mbfl_mandatory_parameter(TWO,    3, second semantic version specification)
    mbfl_declare_varref(GOT_RESULT)

    mbfl_semver_compare_var _(GOT_RESULT) "$ONE" "$TWO"
    dotest-equal 0 $? 'return status' && dotest-equal $EXPECTED_RESULT $GOT_RESULT
}

### ------------------------------------------------------------------------

function semver-compare-example-1.0 () {
    mbfl_declare_varref(RV)
    mbfl_semver_compare_var mbfl_datavar(RV) '1.2.3' '1.2.3'
    dotest-equal 0 $? 'return status' && dotest-equal 0 $RV 'comparison result'
}

function semver-compare-example-1.1 () {
    mbfl_declare_varref(RV)
    mbfl_semver_compare_var mbfl_datavar(RV) '1.2.3' '1.9.3'
    dotest-equal 0 $? 'return status' && dotest-equal -1 $RV 'comparison result'
}

function semver-compare-example-1.2 () {
    mbfl_declare_varref(RV)
    mbfl_semver_compare_var mbfl_datavar(RV) '1.2.3-alpha.1' '1.2.3-alpha.0'
    dotest-equal 0 $? 'return status' && dotest-equal +1 $RV 'comparison result'
}

function semver-compare-example-2.0 () {
    mbfl_default_object_declare(PARSER)

    mbfl_default_object_declare(SPEC1)
    mbfl_default_object_declare(INPUT1)

    mbfl_default_object_declare(SPEC2)
    mbfl_default_object_declare(INPUT2)

    mbfl_semver_parser_make_default _(PARSER)

    mbfl_semver_parser_input_make _(INPUT1) '1.2.3-alpha.3+x86-64' 0
    mbfl_semver_parser_input_make _(INPUT2) '1.2.9-devel.2+x86-64' 0

    mbfl_semver_parse _(SPEC1) _(PARSER) _(INPUT1)
    mbfl_semver_parse _(SPEC2) _(PARSER) _(INPUT2)

    mbfl_declare_varref(RV)

    mbfl_semver_compare_components_var _(RV) _(SPEC1) _(SPEC2)

    dotest-equal 0 $? 'return status' && dotest-equal -1 $RV 'comparison result'
}


#### end of tests

dotest semver-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
