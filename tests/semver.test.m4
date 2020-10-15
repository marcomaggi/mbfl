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
#### Correct semantic version specification.  No prerelease version.  No build metadata.

function semver-parse-1.1 () {
    local -r INPUT_STRING='1.2.3'
    mbfl_local_varref(START_INDEX, 0, -i)
    mbfl_local_varref(RV,,-A)

    mbfl_semver_reset_config
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
		dotest-equal	''			"${RV[BUILD_METADATA]}"		'build metadata'	      && \
		dotest-equal	${#INPUT_STRING}	"${RV[END_INDEX]}"		'end index'		      && \
		dotest-equal	${#INPUT_STRING}	"$START_INDEX"			'start index'
	fi
    else return 1
    fi
}

function semver-parse-1.1 () {
    local -r INPUT_STRING='1.2.3'
    mbfl_local_varref(START_INDEX, 0, -i)
    mbfl_local_varref(RV,,-A)

    mbfl_semver_reset_config
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
		dotest-equal	''			"${RV[BUILD_METADATA]}"		'build metadata'	      && \
		dotest-equal	${#INPUT_STRING}	"${RV[END_INDEX]}"		'end index'		      && \
		dotest-equal	${#INPUT_STRING}	"$START_INDEX"			'start index'
	fi
    else return 1
    fi
}

#page
#### Correct semantic version specification.  Prerelease version.  No build metadata.

function semver-parse-1.2 () {
    local -r INPUT_STRING='1.2.3-alpha.1'
    mbfl_local_varref(START_INDEX, 0, -i)
    mbfl_local_varref(RV,,-A)

    mbfl_semver_reset_config
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
		dotest-equal	'alpha.1'		"${RV[PRERELEASE_VERSION]}"	'prerelease version'	      && \
		dotest-equal	''			"${RV[BUILD_METADATA]}"		'build metadata'	      && \
		dotest-equal	${#INPUT_STRING}	"${RV[END_INDEX]}"		'end index'		      && \
		dotest-equal	${#INPUT_STRING}	"$START_INDEX"			'start index'
	fi
    else return 1
    fi
}

#page
#### Correct semantic version specification.  No prerelease version.  Build metadata.

function semver-parse-1.3 () {
    local -r INPUT_STRING='1.2.3+x86-64'
    mbfl_local_varref(START_INDEX, 0, -i)
    mbfl_local_varref(RV,,-A)

    mbfl_semver_reset_config
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
		dotest-equal	'x86-64'		"${RV[BUILD_METADATA]}"		'build metadata'	      && \
		dotest-equal	${#INPUT_STRING}	"${RV[END_INDEX]}"		'end index'		      && \
		dotest-equal	${#INPUT_STRING}	"$START_INDEX"			'start index'
	fi
    else return 1
    fi
}

#page
#### Correct semantic version specification.  With prerelease version.  Build metadata.

function semver-parse-1.4 () {
    local -r INPUT_STRING='1.2.3-alpha.1+x86-64'
    mbfl_local_varref(START_INDEX, 0, -i)
    mbfl_local_varref(RV,,-A)

    mbfl_semver_reset_config
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
		dotest-equal	'alpha.1'		"${RV[PRERELEASE_VERSION]}"	'prerelease version'	      && \
		dotest-equal	'x86-64'		"${RV[BUILD_METADATA]}"		'build metadata'	      && \
		dotest-equal	${#INPUT_STRING}	"${RV[END_INDEX]}"		'end index'		      && \
		dotest-equal	${#INPUT_STRING}	"$START_INDEX"			'start index'
	fi
    else return 1
    fi
}

#page
#### Correct semantic version specification.  Miscellaneous version number cases.  No prerelease version.  No build metadata.

# Parse a leading 'v' character.
#
function semver-parse-2.1 () {
    local -r INPUT_STRING='v1.2.3'
    mbfl_local_varref(START_INDEX, 0, -i)
    mbfl_local_varref(RV,,-A)

    mbfl_semver_reset_config
    mbfl_semver_CONFIG[PARSE_LEADING_V]=true
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
		dotest-equal	''			"${RV[BUILD_METADATA]}"		'build metadata'	      && \
		dotest-equal	${#INPUT_STRING}	"${RV[END_INDEX]}"		'end index'		      && \
		dotest-equal	${#INPUT_STRING}	"$START_INDEX"			'start index'
	fi
    else return 1
    fi
}

# Multiple digits in version numbers.
#
function semver-parse-2.2 () {
    local -r INPUT_STRING='111.222.333'
    mbfl_local_varref(START_INDEX, 0, -i)
    mbfl_local_varref(RV,,-A)

    mbfl_semver_reset_config
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
		dotest-equal	111			"${RV[MAJOR_NUMBER]}"		'major number'		      && \
		dotest-equal	222			"${RV[MINOR_NUMBER]}"		'minor number'		      && \
		dotest-equal	333			"${RV[PATCH_LEVEL]}"		'patch level'		      && \
		dotest-equal	''			"${RV[PRERELEASE_VERSION]}"	'prerelease version'	      && \
		dotest-equal	''			"${RV[BUILD_METADATA]}"		'build metadata'	      && \
		dotest-equal	${#INPUT_STRING}	"${RV[END_INDEX]}"		'end index'		      && \
		dotest-equal	${#INPUT_STRING}	"$START_INDEX"			'start index'
	fi
    else return 1
    fi
}

# All zero digits in version numbers.
#
function semver-parse-2.3 () {
    local -r INPUT_STRING='0.0.0'
    mbfl_local_varref(START_INDEX, 0, -i)
    mbfl_local_varref(RV,,-A)

    mbfl_semver_reset_config
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
		dotest-equal	0			"${RV[MAJOR_NUMBER]}"		'major number'		      && \
		dotest-equal	0			"${RV[MINOR_NUMBER]}"		'minor number'		      && \
		dotest-equal	0			"${RV[PATCH_LEVEL]}"		'patch level'		      && \
		dotest-equal	''			"${RV[PRERELEASE_VERSION]}"	'prerelease version'	      && \
		dotest-equal	''			"${RV[BUILD_METADATA]}"		'build metadata'	      && \
		dotest-equal	${#INPUT_STRING}	"${RV[END_INDEX]}"		'end index'		      && \
		dotest-equal	${#INPUT_STRING}	"$START_INDEX"			'start index'
	fi
    else return 1
    fi
}

#page
#### Correct semantic version specification.  Miscellaneous prerelease version cases.  No build metadata.


#page
#### Correct semantic version specification.  No prerelease version.  Miscellaneous build metadata cases.

# Accept underscore in build metadata.
#
function semver-parse-4.1 () {
    local -r INPUT_STRING='1.2.3+x86_64'
    mbfl_local_varref(START_INDEX, 0, -i)
    mbfl_local_varref(RV,,-A)

    mbfl_semver_reset_config
    mbfl_semver_CONFIG[ACCEPT_UNDERSCORE_IN_BUILD_METADATA]=true
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
		dotest-equal	'x86_64'		"${RV[BUILD_METADATA]}"		'build metadata'	      && \
		dotest-equal	${#INPUT_STRING}	"${RV[END_INDEX]}"		'end index'		      && \
		dotest-equal	${#INPUT_STRING}	"$START_INDEX"			'start index'
	fi
    else return 1
    fi
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
