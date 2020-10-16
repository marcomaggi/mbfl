# semver.test --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for the semver functions
# Date: Oct 15, 2020
#
# Abstract
#
#
# Copyright (c) 2020 Marco Maggi <mrc.mgg@gmail.com>
#
# This is free software you can redistribute it and/or  modify it under the terms of the GNU General
# Public License as published by the Free Software Foundation; either version 3, or (at your option)
# any later version.
#
# This file  is distributed in the  hope that it will  be useful, but WITHOUT  ANY WARRANTY; without
# even the  implied warranty of MERCHANTABILITY  or FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU
# General Public License for more details.
#
# You should have  received a copy of the GNU  General Public License along with this  file; see the
# file COPYING.  If not,  write to the Free Software Foundation, Inc., 59  Temple Place - Suite 330,
# Boston, MA 02111-1307, USA.
#

#PAGE
#### setup

source setup.sh

#page
#### helper functions

declare -A p_semver_CONFIG
p_semver_CONFIG[PARSE_LEADING_V]=false

function p-semver-parse-correct-specification () {
    mbfl_optional_parameter(MAJOR_NUMBER,	1)
    mbfl_optional_parameter(MINOR_NUMBER,	2)
    mbfl_optional_parameter(PATCH_LEVEL,	3)
    mbfl_optional_parameter(PRERELEASE_VERSION,	4)
    mbfl_optional_parameter(BUILD_METADATA,	5)
    mbfl_optional_parameter(TAIL,		6)

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
    mbfl_local_varref(START_INDEX, 0, -i)
    mbfl_local_varref(RV,,-A)

    mbfl_semver_parse mbfl_datavar(RV) "$INPUT_STRING" mbfl_datavar(START_INDEX)

    if dotest-equal 0 $? 'return status'
    then
	# For debugging purposes.
	if false
	then
	    echo ${FUNCNAME}: RV="${RV[@]}" >&2
	    echo ${FUNCNAME}: MAJOR_NUMBER="${RV[MAJOR_NUMBER]}" >&2
	    echo ${FUNCNAME}: MINOR_NUMBER="${RV[MINOR_NUMBER]}" >&2
	    echo ${FUNCNAME}: PATCH_LEVEL="${RV[PATCH_LEVEL]}" >&2
	    echo ${FUNCNAME}: PRERELEASE_VERSION="${RV[PRERELEASE_VERSION]}" >&2
	    echo ${FUNCNAME}: BUILD_METADATA="${RV[BUILD_METADATA]}" >&2
	    echo ${FUNCNAME}: PARSING_ERROR_MESSAGE="${RV[PARSING_ERROR_MESSAGE]}" >&2
	fi

	if false
	then
	    # For debugging purposes.
	    dotest-equal '' ${RV[PARSING_ERROR_MESSAGE]} 'parsing error message'
	else
	    dotest-equal	''			"${RV[PARSING_ERROR_MESSAGE]}"	'parsing error message'	      && \
		dotest-equal	"$MAJOR_NUMBER"		"${RV[MAJOR_NUMBER]}"		'major number'		      && \
		dotest-equal	"$MINOR_NUMBER"		"${RV[MINOR_NUMBER]}"		'minor number'		      && \
		dotest-equal	"$PATCH_LEVEL"		"${RV[PATCH_LEVEL]}"		'patch level'		      && \
		dotest-equal	"$PRERELEASE_VERSION"	"${RV[PRERELEASE_VERSION]}"	'prerelease version'	      && \
		dotest-equal	"$BUILD_METADATA"	"${RV[BUILD_METADATA]}"		'build metadata'	      && \
		dotest-equal	${#SPEC}		"${RV[END_INDEX]}"		'end index'		      && \
		dotest-equal	${#SPEC}		"$START_INDEX"			'start index'
	fi
    else return 1
    fi
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

#page
#### Correct semantic version specification.  No prerelease version.  No build metadata.

function semver-parse-1.1.01 () { p-semver-parse-correct-version-numbers  '1'  '2'  '3'	      ;}
function semver-parse-1.1.02 () { p-semver-parse-correct-version-numbers  '0'  '0'  '0'	      ;}
function semver-parse-1.1.03 () { p-semver-parse-correct-version-numbers '10' '20' '30'	      ;}

# Tests for characters after the version numbers specification.
function semver-parse-1.1.10 () { p-semver-parse-correct-version-numbers '1' '2' '3' '/'      ;}
function semver-parse-1.1.11 () { p-semver-parse-correct-version-numbers '1' '2' '3' '_'      ;}

#page
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

#page
#### Correct semantic version specification.  No prerelease version.  Build metadata.

function semver-parse-1.3.01 () { p-semver-parse-correct-build-metadata 'x86-64'	      ;}

# Tests for the characters after the build metadata specification.
function semver-parse-1.3.10 () { p-semver-parse-correct-build-metadata 'x86-64' '[alpha'     ;}
function semver-parse-1.3.11 () { p-semver-parse-correct-build-metadata 'x86-64' '_alpha'     ;}

#page
#### Correct semantic version specification.  With prerelease version.  With build metadata.

function semver-parse-1.4.01 () {
    p-semver-parse-correct-specification '1' '2' '3' 'alpha.1' 'x86-64'
}

function semver-parse-1.4.02 () {
    mbfl_location_enter
    {
	mbfl_semver_CONFIG[PARSE_LEADING_V]=true
	mbfl_location_handler 'mbfl_semver_reset_config'

	p_semver_CONFIG[PARSE_LEADING_V]=true
	p-semver-parse-correct-specification '1' '2' '3' 'alpha.1' 'x86-64'
    }
    mbfl_location_leave
}

function semver-parse-1.4.03 () {
    mbfl_location_enter
    {
	mbfl_location_handler 'mbfl_semver_reset_config'

	mbfl_semver_CONFIG[ACCEPT_UNDERSCORE_IN_BUILD_METADATA]=true
	p-semver-parse-correct-specification '1' '2' '3' 'alpha.1' 'x86_64'
    }
    mbfl_location_leave
}

# Enable underscore, but then do not use it.
#
function semver-parse-1.4.04 () {
    mbfl_location_enter
    {
	mbfl_location_handler 'mbfl_semver_reset_config'

	mbfl_semver_CONFIG[ACCEPT_UNDERSCORE_IN_BUILD_METADATA]=true
	p-semver-parse-correct-specification '1' '2' '3' 'alpha.1' 'x86-64'
    }
    mbfl_location_leave
}

#page
#### miscellaneous errors

# Expected a leading 'v' character.
#
function semver-parse-error-1.0 () {
    local -r INPUT_STRING='1.2.3'
    mbfl_local_varref(START_INDEX, 0, -i)
    mbfl_local_varref(RV,,-A)

    mbfl_semver_reset_config
    mbfl_semver_CONFIG[PARSE_LEADING_V]=true
    mbfl_semver_parse mbfl_datavar(RV) "$INPUT_STRING" mbfl_datavar(START_INDEX)

    dotest-equal 1 $? 'return status' && \
	dotest-equal 'missing leading "v" character' "${RV[PARSING_ERROR_MESSAGE]}"
}

### ------------------------------------------------------------------------

# Leading zero in major number.
#
function semver-parse-error-version-numbers-1.0 () {
    local -r INPUT_STRING='01.2.3'
    mbfl_local_varref(START_INDEX, 0, -i)
    mbfl_local_varref(RV,,-A)

    mbfl_semver_reset_config
    mbfl_semver_parse mbfl_datavar(RV) "$INPUT_STRING" mbfl_datavar(START_INDEX)

    dotest-equal 1 $? 'return status' && \
	dotest-equal 'invalid version numbers specification' "${RV[PARSING_ERROR_MESSAGE]}"
}

# Leading zero in minor number.
#
function semver-parse-error-version-numbers-1.2 () {
    local -r INPUT_STRING='1.02.3'
    mbfl_local_varref(START_INDEX, 0, -i)
    mbfl_local_varref(RV,,-A)

    mbfl_semver_reset_config
    mbfl_semver_parse mbfl_datavar(RV) "$INPUT_STRING" mbfl_datavar(START_INDEX)

    dotest-equal 1 $? 'return status' && \
	dotest-equal 'invalid version numbers specification' "${RV[PARSING_ERROR_MESSAGE]}"
}

# Leading zero in patch level.
#
function semver-parse-error-version-numbers-1.3 () {
    local -r INPUT_STRING='1.2.03'
    mbfl_local_varref(START_INDEX, 0, -i)
    mbfl_local_varref(RV,,-A)

    mbfl_semver_reset_config
    mbfl_semver_parse mbfl_datavar(RV) "$INPUT_STRING" mbfl_datavar(START_INDEX)

    dotest-equal 1 $? 'return status' && \
	dotest-equal 'invalid version numbers specification' "${RV[PARSING_ERROR_MESSAGE]}"
}

### ------------------------------------------------------------------------

# Invalid character in major number.
#
function semver-parse-error-version-numbers-2.0 () {
    local -r INPUT_STRING='1x9.2.3'
    mbfl_local_varref(START_INDEX, 0, -i)
    mbfl_local_varref(RV,,-A)

    mbfl_semver_reset_config
    mbfl_semver_parse mbfl_datavar(RV) "$INPUT_STRING" mbfl_datavar(START_INDEX)

    dotest-equal 1 $? 'return status' && \
	dotest-equal 'invalid version numbers specification' "${RV[PARSING_ERROR_MESSAGE]}"
}

# Invalid character in minor number.
#
function semver-parse-error-version-numbers-2.1 () {
    local -r INPUT_STRING='1.2x9.3'
    mbfl_local_varref(START_INDEX, 0, -i)
    mbfl_local_varref(RV,,-A)

    mbfl_semver_reset_config
    mbfl_semver_parse mbfl_datavar(RV) "$INPUT_STRING" mbfl_datavar(START_INDEX)

    dotest-equal 1 $? 'return status' && \
	dotest-equal 'invalid version numbers specification' "${RV[PARSING_ERROR_MESSAGE]}"
}

# Invalid character in patch level.
#
function semver-parse-error-version-numbers-2.2 () {
    local -r INPUT_STRING='1.2.3x9'
    mbfl_local_varref(START_INDEX, 0, -i)
    mbfl_local_varref(RV,,-A)

    mbfl_semver_reset_config
    mbfl_semver_parse mbfl_datavar(RV) "$INPUT_STRING" mbfl_datavar(START_INDEX)

    dotest-equal 1 $? 'return status' && \
	dotest-equal 'invalid version numbers specification' "${RV[PARSING_ERROR_MESSAGE]}"
}

#page
#### errors in prerelease version

# Empty prerelease version after hypen character.
#
function semver-parse-error-prerelease-version-1.1 () {
    local -r INPUT_STRING='1.2.3-'
    mbfl_local_varref(START_INDEX, 0, -i)
    mbfl_local_varref(RV,,-A)

    mbfl_semver_reset_config
    mbfl_semver_CONFIG[ACCEPT_UNDERSCORE_IN_BUILD_METADATA]=false
    mbfl_semver_parse mbfl_datavar(RV) "$INPUT_STRING" mbfl_datavar(START_INDEX)

    dotest-equal 1 $? 'return status' && dotest-equal 'invalid prerelease version' "${RV[PARSING_ERROR_MESSAGE]}"
}

#page
#### errors in build metadata

# Invalid character in build metadata causes parsing to stop.
#
function semver-parse-error-build-metadata-1.0 () {
    #                      123456789012
    local -r INPUT_STRING='1.2.3+x86_64'
    mbfl_local_varref(START_INDEX, 0, -i)
    mbfl_local_varref(RV,,-A)

    mbfl_semver_reset_config
    mbfl_semver_CONFIG[ACCEPT_UNDERSCORE_IN_BUILD_METADATA]=false
    mbfl_semver_parse mbfl_datavar(RV) "$INPUT_STRING" mbfl_datavar(START_INDEX)

    if dotest-equal 0 $? 'return status'
    then
	# For debugging purposes.
	if false
	then
	    echo ${FUNCNAME}: RV="${RV[@]}" >&2
	    echo ${FUNCNAME}: MAJOR_NUMBER="${RV[MAJOR_NUMBER]}" >&2
	    echo ${FUNCNAME}: MINOR_NUMBER="${RV[MINOR_NUMBER]}" >&2
	    echo ${FUNCNAME}: PATCH_LEVEL="${RV[PATCH_LEVEL]}" >&2
	    echo ${FUNCNAME}: PRERELEASE_VERSION="${RV[PRERELEASE_VERSION]}" >&2
	    echo ${FUNCNAME}: BUILD_METADATA="${RV[BUILD_METADATA]}" >&2
	    echo ${FUNCNAME}: PARSING_ERROR_MESSAGE="${RV[PARSING_ERROR_MESSAGE]}" >&2
	fi

	if false
	then
	    # For debugging purposes.
	    dotest-equal '' ${RV[PARSING_ERROR_MESSAGE]} 'parsing error message'
	else
	    dotest-equal	''			"${RV[PARSING_ERROR_MESSAGE]}"	'parsing error message'	      && \
		dotest-equal	1			"${RV[MAJOR_NUMBER]}"		'major number'		      && \
		dotest-equal	2			"${RV[MINOR_NUMBER]}"		'minor number'		      && \
		dotest-equal	3			"${RV[PATCH_LEVEL]}"		'patch level'		      && \
		dotest-equal	''			"${RV[PRERELEASE_VERSION]}"	'prerelease version'	      && \
		dotest-equal	'x86'			"${RV[BUILD_METADATA]}"		'build metadata'	      && \
		dotest-equal	9			"${RV[END_INDEX]}"		'end index'		      && \
		dotest-equal	9			"$START_INDEX"			'start index'
	fi
    else return 1
    fi
}

# Empty build metadata after plus character.
#
function semver-parse-error-build-metadata-1.1 () {
    local -r INPUT_STRING='1.2.3+'
    mbfl_local_varref(START_INDEX, 0, -i)
    mbfl_local_varref(RV,,-A)

    mbfl_semver_reset_config
    mbfl_semver_CONFIG[ACCEPT_UNDERSCORE_IN_BUILD_METADATA]=false
    mbfl_semver_parse mbfl_datavar(RV) "$INPUT_STRING" mbfl_datavar(START_INDEX)

    dotest-equal 1 $? 'return status' && dotest-equal 'invalid build metadata' "${RV[PARSING_ERROR_MESSAGE]}"
}

#page
#### end of tests

dotest semver-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
