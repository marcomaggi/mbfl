# string.sh --
#
# Part of: Marco's BASH functions library
# Contents: string library
# Date: Fri Apr 18, 2003
#
# Abstract
#
#       This is a collection of string functions for the GNU BASH shell.
#
#       The functions make heavy usage of special variable substitutions
#       (like ${name:num:num})  so, maybe, other Bourne  shells will not
#       work at all.
#
# Copyright (c) 2003-2005, 2009, 2013, 2014, 2018 Marco Maggi
# <marco.maggi-ipsu@poste.it>
#
# This is free software; you  can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the
# Free Software  Foundation; either version  3.0 of the License,  or (at
# your option) any later version.
#
# This library  is distributed in the  hope that it will  be useful, but
# WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
# MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
# Lesser General Public License for more details.
#
# You  should have  received a  copy of  the GNU  Lesser  General Public
# License along  with this library; if  not, write to  the Free Software
# Foundation, Inc.,  59 Temple Place,  Suite 330, Boston,  MA 02111-1307
# USA.
#

#page
#### quoted characters

function mbfl_string_is_quoted_char () {
    mbfl_mandatory_parameter(STRING, 1, string)
    mbfl_mandatory_integer_parameter(POS, 2, position)
    local -i COUNT
    let --POS
    for ((COUNT=0; POS >= 0; --POS))
    do
	if test "${STRING:${POS}:1}" = \\
        then let ++COUNT
        else break
	fi
    done
    let ${COUNT}%2
}
function mbfl_string_is_equal_unquoted_char () {
    mbfl_mandatory_parameter(STRING, 1, string)
    mbfl_mandatory_integer_parameter(POS, 2, position)
    mbfl_mandatory_parameter(CHAR, 3, known char)
    if test "${STRING:${POS}:1}" != "$CHAR"
    then mbfl_string_is_quoted_char "$STRING" "$POS"
    fi
}

function mbfl_string_quote_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_optional_parameter(mbfl_STRING, 2)
    local -i mbfl_I
    local mbfl_ch
    mbfl_RESULT_VARREF=
    for ((mbfl_I=0; mbfl_I < ${#mbfl_STRING}; ++mbfl_I))
    do
        mbfl_ch=${mbfl_STRING:$mbfl_I:1}
        if test "$mbfl_ch" = \\
	then mbfl_ch=\\\\
	fi
        mbfl_RESULT_VARREF+=$mbfl_ch
    done
}
function mbfl_string_quote () {
    mbfl_optional_parameter(STRING, 1)
    local RESULT_VARNAME
    if mbfl_string_quote_var RESULT_VARNAME "$STRING"
    then printf '%s\n' "$RESULT_VARNAME"
    else return 1
    fi
}

#page
#### inspecting a string

function mbfl_string_length () {
    # We  want this  function to  accept empty  strings, so  we use  the
    # "optional" macro here.
    mbfl_optional_parameter(STRING, 1)
    echo ${#STRING}
}
function mbfl_string_length_equal_to () {
    mbfl_mandatory_integer_parameter(LENGTH, 1, length of string)
    # We  want this  function to  accept empty  strings, so  we use  the
    # "optional" macro here.
    mbfl_optional_parameter(STRING, 2)
    test ${#STRING} -eq $LENGTH
}
function mbfl_string_is_empty () {
    # We  want this  function to  accept empty  strings, so  we use  the
    # "optional" macro here.
    mbfl_optional_parameter(STRING, 1)
    test -z "$STRING"
}
function mbfl_string_is_not_empty () {
    # We  want this  function to  accept empty  strings, so  we use  the
    # "optional" macro here.
    mbfl_optional_parameter(STRING, 1)
    test -n "$STRING"
}

function mbfl_string_first_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_parameter(mbfl_STRING, 2, string)
    mbfl_mandatory_parameter(mbfl_CHAR, 3, char)
    mbfl_optional_parameter(mbfl_BEGIN, 4, 0)
    local -i mbfl_I
    for ((mbfl_I=mbfl_BEGIN; mbfl_I < ${#mbfl_STRING}; ++mbfl_I))
    do
	if test "${mbfl_STRING:$mbfl_I:1}" = "$mbfl_CHAR"
	then
            mbfl_RESULT_VARREF=$mbfl_I
	    # Found!  Return with exit status 0.
            return 0
        fi
    done
    # Not found!  Return with exit status 1.
    return 1
}
function mbfl_string_first () {
    mbfl_mandatory_parameter(STRING, 1, string)
    mbfl_mandatory_parameter(CHAR, 2, char)
    mbfl_optional_parameter(BEGIN, 3)
    local RESULT_VARNAME
    # Be  careful  to  return  the  same exit  status  of  the  call  to
    # "mbfl_string_first_var".
    if mbfl_string_first_var RESULT_VARNAME "$STRING" "$CHAR" "$BEGIN"
    then printf '%s\n' "$RESULT_VARNAME"
    else return $?
    fi
}

function mbfl_string_last_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_parameter(mbfl_STRING, 2, string)
    mbfl_mandatory_parameter(mbfl_CHAR, 3, char)
    mbfl_optional_parameter(mbfl_BEGIN, 4)
    local -i mbfl_I
    for ((mbfl_I=${mbfl_BEGIN:-((${#mbfl_STRING}-1))}; mbfl_I >= 0; --mbfl_I))
    do
	if test "${mbfl_STRING:$mbfl_I:1}" = "$mbfl_CHAR"
	then
	    # Found!  Return with exit status 0.
            mbfl_RESULT_VARREF=$mbfl_I
	    return 0
        fi
    done
    # Not found!  Return with exit status 1.
    return 1
}
function mbfl_string_last () {
    mbfl_mandatory_parameter(STRING, 1, string)
    mbfl_mandatory_parameter(CHAR, 2, char)
    mbfl_optional_parameter(BEGIN, 3)
    local RESULT_VARNAME
    # Be  careful  to  return  the  same exit  status  of  the  call  to
    # "mbfl_string_last_var".
    if mbfl_string_last_var RESULT_VARNAME "$STRING" "$CHAR" "$BEGIN"
    then printf '%s\n' "$RESULT_VARNAME"
    else return $?
    fi
}

function mbfl_string_index_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_parameter(mbfl_STRING, 2, string)
    mbfl_mandatory_parameter(mbfl_INDEX, 3, index)
    mbfl_RESULT_VARREF=${mbfl_STRING:${mbfl_INDEX}:1}
}
function mbfl_string_index () {
    mbfl_mandatory_parameter(STRING, 1, string)
    mbfl_mandatory_parameter(INDEX, 2, index)
    printf "${STRING:$INDEX:1}\n"
}

function mbfl_string_range_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_parameter(mbfl_STRING, 2, string)
    mbfl_mandatory_parameter(mbfl_BEGIN, 3, begin)
    mbfl_optional_parameter(mbfl_END, 4)
    if test -z "$mbfl_END" -o "$mbfl_END" = 'end' -o "$mbfl_END" = 'END'
    then mbfl_RESULT_VARREF=${mbfl_STRING:$mbfl_BEGIN}
    else mbfl_RESULT_VARREF=${mbfl_STRING:$mbfl_BEGIN:$mbfl_END}
    fi
}
function mbfl_string_range () {
    mbfl_mandatory_parameter(STRING, 1, string)
    mbfl_mandatory_parameter(BEGIN, 2, begin)
    mbfl_optional_parameter(END, 3)
    local RESULT_VARNAME
    if mbfl_string_range_var RESULT_VARNAME "$STRING" "$BEGIN" "$END"
    then printf '%s\n' "$RESULT_VARNAME"
    else return $?
    fi
}

#page
#### splitting

function mbfl_string_chars () {
    mbfl_mandatory_parameter(STRING, 1, string)
    local -i i j
    local ch
    for ((i=0, j=0; i < ${#STRING}; ++i, ++j))
    do
        ch=${STRING:$i:1}
        if test "$ch" != $'\\'
        then SPLITFIELD[$j]=$ch
        else
            let ++i
            if test $i != ${#STRING}
            then SPLITFIELD[$j]=${ch}${STRING:$i:1}
            else SPLITFIELD[$j]=$ch
            fi
        fi
    done
    SPLITCOUNT=$j
    return 0
}
function mbfl_string_split () {
    mbfl_mandatory_parameter(STRING,    1, string)
    mbfl_mandatory_parameter(SEPARATOR, 2, separator)
    local -i i j k=0 first=0
    SPLITFIELD=()
    SPLITCOUNT=0
    for ((i=0; i < ${#STRING}; ++i))
    do
        if (( (i + ${#SEPARATOR}) > ${#STRING}))
	then break
	elif mbfl_string_equal_substring "$STRING" $i "$SEPARATOR"
	then
	    # Here $i is the index of the first char in the separator.
	    SPLITFIELD[$k]=${STRING:$first:$((i - first))}
	    let ++k
	    let i+=${#SEPARATOR}-1
	    # Place  the "first"  marker to  the beginning  of the  next
	    # substring; "i" will  be incremented by "for",  that is why
	    # we do "+1" here.
	    let first=i+1
        fi
    done
    SPLITFIELD[$k]=${STRING:$first}
    let ++k
    SPLITCOUNT=$k
    return 0
}
function mbfl_string_split_blanks () {
    mbfl_mandatory_parameter(STRING, 1, string)
    local ACCUM CH
    local -i i

    SPLITFIELD=()
    SPLITCOUNT=0
    for ((i=0; i < ${#STRING}; ++i))
    do
	CH=${STRING:$i:1}
	if test ' ' = "$CH" -o $'\t' = "$CH"
	then
	    # Store the field.
	    SPLITFIELD[${#SPLITFIELD[@]}]=$ACCUM
	    ACCUM=
	    # Consume all the adjacent blanks, if any.
	    for ((i=$i; i < ${#STRING}; ++i))
	    do
		CH=${STRING:$((i+1)):1}
		if test ' ' != "$CH" -a $'\t' != "$CH"
		then break
		fi
	    done
	else ACCUM+=$CH
	fi
    done
    if mbfl_string_is_not_empty "$ACCUM"
    then SPLITFIELD[${#SPLITFIELD[@]}]=$ACCUM
    fi
    SPLITCOUNT=${#SPLITFIELD[@]}
    return 0
}

#page
#### comparison

function mbfl_string_equal () {
    mbfl_optional_parameter(STR1, 1)
    mbfl_optional_parameter(STR2, 2)
    test "$STR1" '=' "$STR2"
}
function mbfl_string_not_equal () {
    mbfl_optional_parameter(STR1, 1)
    mbfl_optional_parameter(STR2, 2)
    test "$STR1" '!=' "$STR2"
}

function mbfl_string_is_yes () {
    mbfl_optional_parameter(STR, 1)
    test "$STR" = 'yes'
}
function mbfl_string_is_no () {
    mbfl_optional_parameter(STR, 1)
    test "$STR" = 'no'
}

### ------------------------------------------------------------------------

function mbfl_string_less () {
    mbfl_optional_parameter(STR1, 1)
    mbfl_optional_parameter(STR2, 2)
    test "$STR1" '<' "$STR2"
}

function mbfl_string_greater () {
    mbfl_optional_parameter(STR1, 1)
    mbfl_optional_parameter(STR2, 2)
    test "$STR1" '>' "$STR2"
}

function mbfl_string_less_or_equal () {
    mbfl_optional_parameter(STR1, 1)
    mbfl_optional_parameter(STR2, 2)
    test "$STR1" '<' "$STR2" -o "$STR1" '=' "$STR2"
}

function mbfl_string_greater_or_equal () {
    mbfl_optional_parameter(STR1, 1)
    mbfl_optional_parameter(STR2, 2)
    test "$STR1" '>' "$STR2" -o "$STR1" '=' "$STR2"
}

function mbfl_string_equal_substring () {
    mbfl_mandatory_parameter(STRING,   1, string)
    mbfl_mandatory_parameter(POSITION, 2, position)
    mbfl_mandatory_parameter(PATTERN,  3, pattern)
    local i
    if (( (POSITION + ${#PATTERN}) > ${#STRING} ))
    then return 1
    fi
    for ((i=0; i < "${#PATTERN}"; ++i))
    do
	if test "${PATTERN:$i:1}" != "${STRING:$(($POSITION+$i)):1}"
	then return 1
	fi
    done
    return 0
}

#page
function mbfl_string_is_alpha_char () {
    mbfl_mandatory_parameter(CHAR, 1, char)
    ! test \( "$CHAR" \< A -o Z \< "$CHAR" \) -a \( "$CHAR" \< a -o z \< "$CHAR" \)
}
function mbfl_string_is_digit_char () {
    mbfl_mandatory_parameter(CHAR, 1, char)
    ! test "$CHAR" \< 0 -o 9 \< "$CHAR"
}
function mbfl_string_is_alnum_char () {
    mbfl_mandatory_parameter(CHAR, 1, char)
    mbfl_string_is_alpha_char "$CHAR" || mbfl_string_is_digit_char "$CHAR"
}
function mbfl_string_is_name_char () {
    mbfl_mandatory_parameter(CHAR, 1, char)
    mbfl_string_is_alnum_char "$CHAR" || test "$CHAR" = _
}
function mbfl_string_is_identifier_char () {
    mbfl_mandatory_parameter(CHAR, 1, char)
    mbfl_string_is_alnum_char "$CHAR" || test "$CHAR" = '_' -o "$CHAR" = '-'
}
function mbfl_string_is_extended_identifier_char () {
    mbfl_mandatory_parameter(CHAR, 1, char)
    mbfl_string_is_alnum_char "$CHAR" || test "$CHAR" = '_' -o "$CHAR" = '-' -o "$CHAR" = '.'
}
function mbfl_string_is_noblank_char () {
    mbfl_mandatory_parameter(CHAR, 1, char)
    test \( "$CHAR" != " " \) -a \
	\( "$CHAR" != $'\n' \) -a \( "$CHAR" != $'\r' \) -a \
	\( "$CHAR" != $'\t' \) -a \( "$CHAR" != $'\f' \)
}
for class in alpha digit alnum noblank ; do
    alias "mbfl_string_is_${class}"="mbfl_p_string_is $class"
done
function mbfl_p_string_is () {
    mbfl_mandatory_parameter(CLASS, 1, class)
    # Accept $2  even if  it is  empty; for  this reason  we do  not use
    # MBFL_MANDATORY_PARAMETER.
    local STRING=$2
    local -i i
    if ((0 < ${#STRING}))
    then
	for ((i=0; i < ${#STRING}; ++i))
	do
	    if ! "mbfl_string_is_${CLASS}_char" "${STRING:$i:1}"
	    then return 1
	    fi
	done
	return 0
    else return 1
    fi
}
function mbfl_string_is_name () {
    # Accept $1  even if  it is  empty; for  this reason  we do  not use
    # MBFL_MANDATORY_PARAMETER.
    local STRING=$1
    mbfl_string_is_not_empty "$STRING" && mbfl_p_string_is name "$STRING" && { ! mbfl_string_is_digit "${STRING:0:1}"; }
}
function mbfl_string_is_identifier () {
    # Accept $1  even if  it is  empty; for  this reason  we do  not use
    # MBFL_MANDATORY_PARAMETER.
    local STRING=$1
    mbfl_string_is_not_empty "$STRING" \
	&&   mbfl_p_string_is identifier "$STRING"	\
	&& ! mbfl_string_is_digit "${STRING:0:1}"	\
	&& mbfl_string_not_equal "${STRING:0:1}" '-'
}
function mbfl_string_is_extended_identifier () {
    # Accept $1  even if  it is  empty; for  this reason  we do  not use
    # MBFL_MANDATORY_PARAMETER.
    local STRING=$1
    mbfl_string_is_not_empty "$STRING" \
	&&   mbfl_p_string_is extended_identifier "$STRING"	\
	&& ! mbfl_string_is_digit "${STRING:0:1}"		\
	&& mbfl_string_not_equal "${STRING:0:1}" '-'
}
function mbfl_string_is_username () {
    # Accept $1  even if  it is  empty; for  this reason  we do  not use
    # MBFL_MANDATORY_PARAMETER.
    local STRING=$1
    mbfl_string_is_not_empty "$STRING" && \
	mbfl_string_is_identifier "$STRING"
}
function mbfl_string_is_network_port () {
    # We want  to accept  an empty  parameter and  return unsuccessfully
    # when given.
    mbfl_optional_parameter(STRING, 1)

    if mbfl_string_is_not_empty "$STRING" && mbfl_string_is_digit "$STRING" && ((0 <= STRING && STRING <= 1024))
    then return 0
    else return 1
    fi
}
function mbfl_string_is_network_hostname () {
    # We want  to accept  an empty  parameter and  return unsuccessfully
    # when given.
    mbfl_optional_parameter(STRING, 1)
    # This regular expression comes from:
    #
    #   https://stackoverflow.com/questions/106179/regular-expression-to-match-dns-hostname-or-ip-address
    #
    # answer by Sakari A. Maaranen, last visited Nov 23, 2018.
    local -r REX="^([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])(\.([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9]))*$"

    if ((${#STRING} <= 255)) && [[ $STRING =~ $REX ]]
    then return 0
    fi
    return 1
}

function mbfl_string_is_network_ip_address () {
    # We want  to accept  an empty  parameter and  return unsuccessfully
    # when given.
    mbfl_optional_parameter(STRING, 1)
    # This regular expression comes from:
    #
    #   https://stackoverflow.com/questions/106179/regular-expression-to-match-dns-hostname-or-ip-address
    #
    # answer by Jorge Ferreira, last visited Nov 23, 2018.
    local -r REX="^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"

    if ((${#STRING} <= 255)) && [[ $STRING =~ $REX ]]
    then return 0
    fi
    return 1
}

function mbfl_string_is_email_address () {
    # We want  to accept  an empty  parameter and  return unsuccessfully
    # when given.
    mbfl_optional_parameter(ADDRESS, 1)
    local -r REX='^[a-zA-Z0-9_.\-]+(@[a-zA-Z0-9_.\-]+)?$'

    if [[ $ADDRESS =~ $REX ]]
    then return 0
    else return 1
    fi
}

#page
#### case conversion

function mbfl_string_toupper () {
    echo "${1^^}"
}
function mbfl_string_tolower () {
    echo "${1,,}"
}

function mbfl_string_toupper_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_RESULT_VARREF="${2^^}"
}
function mbfl_string_tolower_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_RESULT_VARREF="${2,,}"
}

#page
#### miscellaneous

function mbfl_string_replace () {
    mbfl_mandatory_parameter(STRING, 1, string)
    mbfl_mandatory_parameter(PATTERN, 2, pattern)
    mbfl_optional_parameter(SUBST, 3)
    printf '%s\n' "${STRING//$PATTERN/$SUBST}"
}
function mbfl_string_replace_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_parameter(mbfl_STRING, 2, string)
    mbfl_mandatory_parameter(mbfl_PATTERN, 3, pattern)
    mbfl_optional_parameter(mbfl_SUBST, 4)
    mbfl_RESULT_VARREF=${mbfl_STRING//${mbfl_PATTERN}/${mbfl_SUBST}}
}

function mbfl_string_skip () {
    mbfl_mandatory_parameter(mbfl_STRING, 1, string)
    mbfl_mandatory_nameref_parameter(mbfl_POSNAME, 2, position)
    mbfl_mandatory_parameter(mbfl_CHAR, 3, char)
    while test "${mbfl_STRING:$mbfl_POSNAME:1}" = "$mbfl_CHAR"
    do let ++mbfl_POSNAME
    done
}

function mbfl_sprintf () {
    mbfl_mandatory_parameter(VARNAME, 1, variable name)
    mbfl_mandatory_parameter(FORMAT,  2, format)
    local OUTPUT=
    shift 2
    printf -v OUTPUT "$FORMAT" "$@"
    eval "$VARNAME"=\'"$OUTPUT"\'
}

function mbfl_string_strip_carriage_return_var () {
    mbfl_mandatory_nameref_parameter(RESULT_NAMEREF, 1, result variable name)
    mbfl_optional_parameter(LINE, 2)

    if mbfl_string_is_not_empty "$LINE"
    then
	mbfl_local_varref(CH)

	mbfl_string_index_var mbfl_datavar(CH) "$LINE" $((${#LINE} - 1))
	if mbfl_string_equal "$CH" $'\r'
	then RESULT_NAMEREF=${LINE:0:((${#LINE} - 1))}
	else RESULT_NAMEREF=$LINE
	fi
    fi
}

### end of file
# Local Variables:
# mode: sh
# End:
