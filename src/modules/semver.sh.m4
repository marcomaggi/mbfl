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


#### parser configuration

mbfl_declare_symbolic_array(mbfl_semver_CONFIG)

function mbfl_semver_reset_config () {
    mbfl_semver_CONFIG[PARSE_LEADING_V]='optional'
    mbfl_semver_CONFIG[ACCEPT_UNDERSCORE_IN_BUILD_METADATA]='false'
}

mbfl_semver_reset_config


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

    case mbfl_slot_ref(mbfl_semver_CONFIG, PARSE_LEADING_V)
    in
	'mandatory')
	    if test "mbfl_string_idx(mbfl_INPUT_STRING, $mbfl_START_INDEX)" = 'v'
	    then let ++mbfl_START_INDEX
	    else
		mbfl_RV[PARSING_ERROR_MESSAGE]='missing leading "v" character'
		return 1
	    fi
	    ;;
	'missing')
	    if test "mbfl_string_idx(mbfl_INPUT_STRING, $mbfl_START_INDEX)" = 'v'
	    then
		mbfl_RV[PARSING_ERROR_MESSAGE]='unexpected leading "v" character'
		return 1
	    fi
	    ;;
	*)
	    if test "mbfl_string_idx(mbfl_INPUT_STRING, $mbfl_START_INDEX)" = 'v'
	    then let ++mbfl_START_INDEX
	    fi
	    ;;
    esac

    if ! mbfl_p_semver_parse_version_numbers
    then
	mbfl_RV[PARSING_ERROR_MESSAGE]=$mbfl_PARSING_ERROR_MESSAGE
	return 1
    fi

    if test "mbfl_string_idx(mbfl_INPUT_STRING, $mbfl_START_INDEX)" = '-'
    then
	# There is a prerelease version component.
	if ! mbfl_p_semver_parse_prerelease_version
	then
	    mbfl_RV[PARSING_ERROR_MESSAGE]=$mbfl_PARSING_ERROR_MESSAGE
	    return 1
	fi
    fi

    if test "mbfl_string_idx(mbfl_INPUT_STRING, $mbfl_START_INDEX)" = '+'
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
    mbfl_RV[START_INDEX]=$mbfl_THE_START_INDEX
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


#### parser functions: parse version numbers

function mbfl_p_semver_parse_version_numbers () {
    # If a version number is  a single digit: it can be 0.  If there  are multiple digits: the first
    # digit cannot be 0.
    local -r REX='^(0|([1-9][0-9]*))\.(0|([1-9][0-9]*))\.(0|([1-9][0-9]*))($|[\-\+]|[^0-9A-Za-z])'
    #              1  2               3  4               5  6
    #              |-----------------------------------------------------||----------------------|
    #                                    major.minor.patch                   end or one char after

    if [[ "${mbfl_INPUT_STRING:$mbfl_START_INDEX}" =~ $REX ]]
    then
	# For debugging purposes.
	# echo ${FUNCNAME}: successful match "mbfl_slot_ref(BASH_REMATCH, @)" >&2
	# echo ${FUNCNAME}: MAJOR_NUMBER="mbfl_slot_ref(BASH_REMATCH, 1)" >&2
	# echo ${FUNCNAME}: MINOR_NUMBER="mbfl_slot_ref(BASH_REMATCH, 4)" >&2
	# echo ${FUNCNAME}: PATCH_LEVEL="mbfl_slot_ref(BASH_REMATCH, 7)" >&2

	mbfl_MAJOR_NUMBER=mbfl_slot_ref(BASH_REMATCH, 1)
	mbfl_MINOR_NUMBER=mbfl_slot_ref(BASH_REMATCH, 3)
	mbfl_PATCH_LEVEL=mbfl_slot_ref(BASH_REMATCH, 5)
	let mbfl_START_INDEX+=2+${#mbfl_MAJOR_NUMBER}+${#mbfl_MINOR_NUMBER}+${#mbfl_PATCH_LEVEL}
	return 0
    else
	# For debugging purposes.
	#echo ${FUNCNAME}: no match >&2
	mbfl_PARSING_ERROR_MESSAGE='invalid version numbers specification'
	return 1
    fi
}


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
	#echo ${FUNCNAME}: successful match "mbfl_slot_ref(BASH_REMATCH, @)" >&2
	#echo ${FUNCNAME}: PRERELEASE_VERSION="mbfl_slot_ref(BASH_REMATCH, 1)" >&2

	mbfl_PRERELEASE_VERSION=mbfl_slot_ref(BASH_REMATCH, 1)
	let mbfl_START_INDEX+=1+${#BASH_REMATCH[1]}
	return 0
    else
	# For debugging purposes.
	#echo ${FUNCNAME}: no match >&2
	mbfl_PARSING_ERROR_MESSAGE='invalid prerelease version'
	return 1
    fi
}


#### parser functions: parse build metadata

# The build  metadata must  start with a  plus.  Then  a non-empty identifier  must follow.   Then a
# number of optional identifiers separated by dots.
#
function mbfl_p_semver_parse_build_metadata () {
    local IDRANGE='0-9A-Za-z'
    if mbfl_slot_ref(mbfl_semver_CONFIG, ACCEPT_UNDERSCORE_IN_BUILD_METADATA)
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
	#echo ${FUNCNAME}: successful match "mbfl_slot_ref(BASH_REMATCH, @)" >&2
	#echo ${FUNCNAME}: BUILD_METADATA="mbfl_slot_ref(BASH_REMATCH, 1)" >&2

	mbfl_BUILD_METADATA=mbfl_slot_ref(BASH_REMATCH, 1)
	let mbfl_START_INDEX+=1+${#BASH_REMATCH[1]}
	return 0
    else
	# For debugging purposes.
	#echo ${FUNCNAME}: no match >&2
	mbfl_PARSING_ERROR_MESSAGE='invalid build metadata'
	return 1
    fi
}


#### split prerelease version specifications

function mbfl_semver_split_prerelease_version () {
    mbfl_mandatory_nameref_parameter(mbfl_RV, 1, result array variable)
    mbfl_mandatory_parameter(mbfl_INPUT_SPEC, 2, input prerelease version specification)

    local -r IDREX='(0|[1-9][0-9]*|[0-9A-Za-z\-][0-9A-Za-z\-]+)'
    local -r DOTIDREX='\.(0|[1-9][0-9]*|[0-9A-Za-z\-][0-9A-Za-z\-]+)'
    local -i i=0 j=0

    # Parse the first, mandatory identifier.
    if [[ "$mbfl_INPUT_SPEC" =~ $IDREX ]]
    then
	mbfl_RV[0]=mbfl_slot_ref(BASH_REMATCH, 1)
	j=${#BASH_REMATCH[1]}
    else return 1
    fi

    for ((i=1; 0 < (${#mbfl_INPUT_SPEC} - j); ++i))
    do
	if [[ "${mbfl_INPUT_SPEC:$j}" =~ $DOTIDREX ]]
	then
	    mbfl_RV[$i]=mbfl_slot_ref(BASH_REMATCH, 1)
	    j+=1+${#BASH_REMATCH[1]}
	else return 1
	fi
    done

    return 0
}


#### semantic version specifications comparison

# The value stored in the NAMEREF variable RV is the classic ternary comparison result:
#
# -1 if ONE < TWO
#  0 if ONE = TWO
# +1 if ONE > TWO
#
function mbfl_semver_compare_var () {
    mbfl_mandatory_nameref_parameter(RV, 1, result variable)
    mbfl_mandatory_parameter(ONE,        2, first semantic version specification)
    mbfl_mandatory_parameter(TWO,        3, second semantic version specification)
    mbfl_local_varref(ONE_INDEX, 0, -i)
    mbfl_local_varref(TWO_INDEX, 0, -i)
    mbfl_local_varref(ONE_COMPONENTS,, -A)
    mbfl_local_varref(TWO_COMPONENTS,, -A)

    #echo ${FUNCNAME}: ONE=\""$ONE"\" ONE_INDEX=$ONE_INDEX ONE_COMPONENTS=mbfl_datavar(ONE_COMPONENTS) >&2
    if ! mbfl_semver_parse mbfl_datavar(ONE_COMPONENTS) "$ONE" mbfl_datavar(ONE_INDEX)
    then return 1
    fi

    #echo ${FUNCNAME}: TWO=\""$TWO"\" TWO_INDEX=$TWO_INDEX TWO_COMPONENTS=mbfl_datavar(TWO_COMPONENTS) >&2
    if ! mbfl_semver_parse mbfl_datavar(TWO_COMPONENTS) "$TWO" mbfl_datavar(TWO_INDEX)
    then return 1
    fi

    mbfl_semver_compare_components_var mbfl_datavar(RV) mbfl_datavar(ONE_COMPONENTS) mbfl_datavar(TWO_COMPONENTS)
}

function mbfl_semver_compare_components_var () {
    mbfl_mandatory_nameref_parameter(RV,             1, result variable)
    mbfl_mandatory_nameref_parameter(ONE_COMPONENTS, 2, first semantic version specification components)
    mbfl_mandatory_nameref_parameter(TWO_COMPONENTS, 3, second semantic version specification components)

    if   test "mbfl_slot_ref(ONE_COMPONENTS, MAJOR_NUMBER)" -lt "mbfl_slot_ref(TWO_COMPONENTS, MAJOR_NUMBER)"
    then RV=-1
    elif test "mbfl_slot_ref(ONE_COMPONENTS, MAJOR_NUMBER)" -gt "mbfl_slot_ref(TWO_COMPONENTS, MAJOR_NUMBER)"
    then RV=+1
    else
    	if   test "mbfl_slot_ref(ONE_COMPONENTS, MINOR_NUMBER)" -lt "mbfl_slot_ref(TWO_COMPONENTS, MINOR_NUMBER)"
    	then RV=-1
    	elif test "mbfl_slot_ref(ONE_COMPONENTS, MINOR_NUMBER)" -gt "mbfl_slot_ref(TWO_COMPONENTS, MINOR_NUMBER)"
    	then RV=+1
    	else
    	    if   test "mbfl_slot_ref(ONE_COMPONENTS, PATCH_LEVEL)" -lt "mbfl_slot_ref(TWO_COMPONENTS, PATCH_LEVEL)"
    	    then RV=-1
    	    elif test "mbfl_slot_ref(ONE_COMPONENTS, PATCH_LEVEL)" -gt "mbfl_slot_ref(TWO_COMPONENTS, PATCH_LEVEL)"
    	    then RV=+1
    	    else
    		# Major  number, minor  number  and patch  level  are equal.   We  must compare  the
    		# prerelease version specifications.
    		#
    		# If one is missing a prerelease version: that one is greater.
    		if   (( 0 == ${#ONE_COMPONENTS[PRERELEASE_VERSION]} && 0 == ${#TWO_COMPONENTS[PRERELEASE_VERSION]} ))
    		then RV=0
    		elif (( 0 == ${#ONE_COMPONENTS[PRERELEASE_VERSION]} && 0 < ${#TWO_COMPONENTS[PRERELEASE_VERSION]} ))
    		then RV=-1
    		elif (( 0 == ${#TWO_COMPONENTS[PRERELEASE_VERSION]} && 0 < ${#ONE_COMPONENTS[PRERELEASE_VERSION]} ))
    		then RV=+1
    		else
    		    # Both have  a non-empty prerelease  version.  Let's compare them  identifier by
    		    # identifier.
    		    mbfl_semver_compare_prerelease_version		\
    			mbfl_datavar(RV)				\
    			"mbfl_slot_ref(ONE_COMPONENTS, PRERELEASE_VERSION)"		\
    			"mbfl_slot_ref(TWO_COMPONENTS, PRERELEASE_VERSION)"
    		    return $?
    		fi
    	    fi
    	fi
    fi
    return 0
}

function mbfl_semver_compare_prerelease_version () {
    mbfl_mandatory_nameref_parameter(RV,            1, result variable)
    mbfl_optional_parameter(ONE_PRERELEASE_VERSION, 2, first prerelease version specification)
    mbfl_optional_parameter(TWO_PRERELEASE_VERSION, 3, second prerelease version specification)
    mbfl_local_varref(ONE_IDENTIFIERS,, -a)
    mbfl_local_varref(TWO_IDENTIFIERS,, -a)

    if ! mbfl_semver_split_prerelease_version mbfl_datavar(ONE_IDENTIFIERS) "$ONE_PRERELEASE_VERSION"
    then return 1
    fi

    if ! mbfl_semver_split_prerelease_version mbfl_datavar(TWO_IDENTIFIERS) "$TWO_PRERELEASE_VERSION"
    then return 1
    fi

    local -i i ONE_IS_NUMERIC TWO_IS_NUMERIC MIN

    RV=0

    if (( mbfl_slots_number(ONE_IDENTIFIERS) < mbfl_slots_number(TWO_IDENTIFIERS) ))
    then MIN=mbfl_slots_number(ONE_IDENTIFIERS)
    else MIN=mbfl_slots_number(TWO_IDENTIFIERS)
    fi

    #echo ${FUNCNAME}: MIN=$MIN >&2
    for ((i=0; i < MIN; ++i))
    do
	mbfl_string_is_digit "mbfl_slot_ref(ONE_IDENTIFIERS, $i)"
	ONE_IS_NUMERIC=$?

	mbfl_string_is_digit "mbfl_slot_ref(TWO_IDENTIFIERS, $i)"
	TWO_IS_NUMERIC=$?

	if (( 0 == ONE_IS_NUMERIC && 0 == TWO_IS_NUMERIC ))
	then
	    # They are both numeric, so let's compare them as numbers.
	    if   test "mbfl_slot_ref(ONE_IDENTIFIERS, $i)" -lt "mbfl_slot_ref(TWO_IDENTIFIERS, $i)"
	    then RV=-1 ; break
	    elif test "mbfl_slot_ref(ONE_IDENTIFIERS, $i)" -gt "mbfl_slot_ref(TWO_IDENTIFIERS, $i)"
	    then RV=+1 ; break
	    fi
	elif (( 0 == ONE_IS_NUMERIC ))
	then RV=+1 ; break ;# ONE is numeric, TWO is not: ONE is lesser according to the standard.
	elif (( 0 == TWO_IS_NUMERIC ))
	then RV=-1 ; break ;# TWO is numeric, ONE is not: TWO is lesser according to the standard.
	else
	    #echo ${FUNCNAME}: ONE_IDENTIFIERS[$i]="mbfl_slot_ref(ONE_IDENTIFIERS, $i)" TWO_IDENTIFIERS[$i]="mbfl_slot_ref(TWO_IDENTIFIERS, $i)" >&2
	    # They are both non-numeric, so let's compare them as strings.
	    if   test "mbfl_slot_ref(ONE_IDENTIFIERS, $i)" '<' "mbfl_slot_ref(TWO_IDENTIFIERS, $i)"
	    then RV=-1 ; break
	    elif test "mbfl_slot_ref(ONE_IDENTIFIERS, $i)" '>' "mbfl_slot_ref(TWO_IDENTIFIERS, $i)"
	    then RV=+1 ; break
	    fi
	fi
    done

    #echo ${FUNCNAME}: after iterating RV=$RV >&2
    if (( 0 == RV ))
    then
	# All the identifiers compared  so far are equal.  If a  specification has more identifiers:
	# it is greater.
	if   (( mbfl_slots_number(ONE_IDENTIFIERS) < mbfl_slots_number(TWO_IDENTIFIERS) ))
	then RV=-1
	elif (( mbfl_slots_number(ONE_IDENTIFIERS) > mbfl_slots_number(TWO_IDENTIFIERS) ))
	then RV=+1
	fi
    fi

    return 0
}

### end of file
# Local Variables:
# mode: sh
# End:
