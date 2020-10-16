# semver.sh --
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
# Copyright (c) 2020 Marco Maggi
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

#page
#### parser configuration

declare -A mbfl_semver_CONFIG

function mbfl_semver_reset_config () {
    mbfl_semver_CONFIG[PARSE_LEADING_V]=false
    mbfl_semver_CONFIG[ACCEPT_UNDERSCORE_IN_BUILD_METADATA]=false
}

mbfl_semver_reset_config

#page
#### parser functions: main parser

# The argument RV must be the name of a data  array variable to be used as object of a NAMEREF local
# variable.  The array will be filled with the results of parsing the input string.
#
# The argument INPUT_STRING must be a string holding semantic version specification.
#
# The argument START_INDEX must be an integer representing the index of the first character to parse
# in INPUT_STRING.
#
function mbfl_semver_parse () {
    mbfl_mandatory_nameref_parameter(mbfl_RV, 1, result array variable)
    mbfl_mandatory_parameter(mbfl_INPUT_STRING, 2, string)
    mbfl_mandatory_nameref_parameter(mbfl_THE_START_INDEX, 3, index of first character to parse)
    mbfl_local_varref(mbfl_START_INDEX, $mbfl_THE_START_INDEX, -i)

    mbfl_p_semver_init_result_array

    local mbfl_MAJOR_NUMBER
    local mbfl_MINOR_NUMBER
    local mbfl_PATCH_LEVEL
    local mbfl_PRERELEASE_VERSION
    local mbfl_BUILD_METADATA
    local mbfl_PARSING_ERROR_MESSAGE

    # For debugging purposes.
    #echo ${FUNCNAME}: INPUT_STRING="${mbfl_INPUT_STRING:$mbfl_START_INDEX}" START_INDEX=$mbfl_START_INDEX >&2

    if ${mbfl_semver_CONFIG[PARSE_LEADING_V]}
    then
	if test "${INPUT_STRING:$mbfl_START_INDEX:1}" = 'v'
	then let ++mbfl_START_INDEX
	else
	    mbfl_RV[PARSING_ERROR_MESSAGE]='missing leading "v" character'
	    return 1
	fi
    fi

    if ! mbfl_p_semver_parse_version_numbers
    then
	mbfl_RV[PARSING_ERROR_MESSAGE]=$mbfl_PARSING_ERROR_MESSAGE
	return 1
    fi

    if test "${mbfl_INPUT_STRING:$mbfl_START_INDEX:1}" = '-'
    then
	# There is a prerelease version component.
	if ! mbfl_p_semver_parse_prerelease_version
	then
	    mbfl_RV[PARSING_ERROR_MESSAGE]=$mbfl_PARSING_ERROR_MESSAGE
	    return 1
	fi
    fi

    if test "${mbfl_INPUT_STRING:$mbfl_START_INDEX:1}" = '+'
    then
	# There is a build metadata component.
	if ! mbfl_p_semver_parse_build_metadata
	then
	    mbfl_RV[PARSING_ERROR_MESSAGE]=$mbfl_PARSING_ERROR_MESSAGE
	    return 1
	fi
    fi

    mbfl_RV[MAJOR_NUMBER]=$mbfl_MAJOR_NUMBER
    mbfl_RV[MINOR_NUMBER]=$mbfl_MINOR_NUMBER
    mbfl_RV[PATCH_LEVEL]=$mbfl_PATCH_LEVEL
    mbfl_RV[PRERELEASE_VERSION]=$mbfl_PRERELEASE_VERSION
    mbfl_RV[BUILD_METADATA]=$mbfl_BUILD_METADATA
    mbfl_RV[END_INDEX]=$mbfl_START_INDEX
    let mbfl_THE_START_INDEX=mbfl_START_INDEX
    # For debugging purposes.
    #echo ${FUNCNAME}: returning successfully >&2
    return 0
}

function mbfl_p_semver_init_result_array () {
    mbfl_RV[MAJOR_NUMBER]=
    mbfl_RV[MINOR_NUMBER]=
    mbfl_RV[PATCH_LEVEL]=
    mbfl_RV[PRERELEASE_VERSION]=
    mbfl_RV[BUILD_METADATA]=
    mbfl_RV[END_INDEX]=
    mbfl_RV[PARSING_ERROR_MESSAGE]=
}

#page
#### parser functions: parse version numbers

function mbfl_p_semver_parse_version_numbers () {
    # If a version number is  a single digit: it can be 0.  If there  are multiple digits: the first
    # digit cannot be 0.
    local -r REX='^(0|([1-9][0-9]*))\.(0|([1-9][0-9]*))\.(0|([1-9][0-9]*))($|[\-\+]|[^0-9A-Za-z])'
    #              1  2               3  4               5  6
    #              |-------------------------------------------------------||----------------------|
    #                                    major.minor.patch                   end or one char after

    if [[ "${mbfl_INPUT_STRING:$mbfl_START_INDEX}" =~ $REX ]]
    then
	# For debugging purposes.
	# echo ${FUNCNAME}: successful match "${BASH_REMATCH[@]}" >&2
	# echo ${FUNCNAME}: MAJOR_NUMBER="${BASH_REMATCH[1]}" >&2
	# echo ${FUNCNAME}: MINOR_NUMBER="${BASH_REMATCH[4]}" >&2
	# echo ${FUNCNAME}: PATCH_LEVEL="${BASH_REMATCH[7]}" >&2

	mbfl_MAJOR_NUMBER=${BASH_REMATCH[1]}
	mbfl_MINOR_NUMBER=${BASH_REMATCH[3]}
	mbfl_PATCH_LEVEL=${BASH_REMATCH[5]}
	let mbfl_START_INDEX+=2+${#mbfl_MAJOR_NUMBER}+${#mbfl_MINOR_NUMBER}+${#mbfl_PATCH_LEVEL}
	return 0
    else
	# For debugging purposes.
	#echo ${FUNCNAME}: no match >&2
	mbfl_PARSING_ERROR_MESSAGE='invalid version numbers specification'
	return 1
    fi
}

#page
#### parser functions: parse prerelease version

# The prerelease version must start with a hyphen.  Then a non-empty identifier must follow.  Then a
# number of optional identifiers separated by dots.  A numeric identifier with a single digit can be
# zero.  A numeric identifier with multiple digits must not start with a zero.
#
# So a prerelease version idenifier can be:
#
# 0				a single-digit numeric identifier whose digit is zero
# [1-9][0-9]*			a numeric identifier whose first digit is not zero
# [0-9A-Za-z\-][0-9A-Za-z\-]+	a multi-char identifier
#
# After the prerelease version specification, we can have:
#
# $				the end of the input string
# \+				a build metadata specification
# [^0-9A-Za-z\.\-]		a character that is invalid for an identifier
#
function mbfl_p_semver_parse_prerelease_version () {
    local -r IDREX='(0|[1-9][0-9]*|[0-9A-Za-z\-][0-9A-Za-z\-]+)'
    # The leading hyphen.
    local REX='^\-('
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
    #echo ${FUNCNAME}: INPUT_STRING="${mbfl_INPUT_STRING:$mbfl_START_INDEX}" START_INDEX=$mbfl_START_INDEX >&2

    if [[ "${mbfl_INPUT_STRING:$mbfl_START_INDEX}" =~ $REX ]]
    then
	# For debugging purposes.
	#echo ${FUNCNAME}: successful match "${BASH_REMATCH[@]}" >&2
	#echo ${FUNCNAME}: PRERELEASE_VERSION="${BASH_REMATCH[1]}" >&2

	mbfl_PRERELEASE_VERSION=${BASH_REMATCH[1]}
	let mbfl_START_INDEX+=1+${#BASH_REMATCH[1]}
	return 0
    else
	# For debugging purposes.
	#echo ${FUNCNAME}: no match >&2
	mbfl_PARSING_ERROR_MESSAGE='invalid prerelease version'
	return 1
    fi
}

#page
#### parser functions: parse build metadata

# The build  metadata must  start with a  plus.  Then  a non-empty identifier  must follow.   Then a
# number of optional identifiers separated by dots.
#
function mbfl_p_semver_parse_build_metadata () {
    local IDRANGE='0-9A-Za-z'
    if ${mbfl_semver_CONFIG[ACCEPT_UNDERSCORE_IN_BUILD_METADATA]}
    then IDRANGE+='_'
    fi
    # Let's make sure that the quoted hypen is the last character in the range!
    IDRANGE+='\-'

    local IDREX='(['
    IDREX+=$IDRANGE
    IDREX+=']+)'

    local REX='^\+('
    REX+=$IDREX
    REX+='(\.'
    REX+=$IDREX
    REX+=')*'
    REX+=')'

    # For debugging purposes.
    #echo IDRANGE=\""$IDRANGE"\" IDREX=\""$IDREX"\" REX=\""$REX"\" >&2
    #echo ${FUNCNAME}: INPUT_STRING="${mbfl_INPUT_STRING:$mbfl_START_INDEX}" START_INDEX=$mbfl_START_INDEX >&2

    if [[ "${mbfl_INPUT_STRING:$mbfl_START_INDEX}" =~ $REX ]]
    then
	# For debugging purposes.
	#echo ${FUNCNAME}: successful match "${BASH_REMATCH[@]}" >&2
	#echo ${FUNCNAME}: BUILD_METADATA="${BASH_REMATCH[1]}" >&2

	mbfl_BUILD_METADATA=${BASH_REMATCH[1]}
	let mbfl_START_INDEX+=1+${#BASH_REMATCH[1]}
	return 0
    else
	# For debugging purposes.
	#echo ${FUNCNAME}: no match >&2
	mbfl_PARSING_ERROR_MESSAGE='invalid build metadata'
	return 1
    fi
}

### end of file
# Local Variables:
# mode: sh
# End:
