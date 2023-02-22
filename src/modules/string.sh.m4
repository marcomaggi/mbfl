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
#       The functions make heavy usage of  special variable substitutions (like ${name:num:num}) so,
#       maybe, other Bourne shells will not work at all.
#
# Copyright (c) 2003-2005, 2009, 2013, 2014, 2018, 2020, 2023 Marco Maggi
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


#### global variables, known character ranges

if mbfl_string_neq_yes("$mbfl_INTERACTIVE")
then

# These should be  all the symbols in the ASCII  table in the range [0, 127],  with the exception of
# blanks.  Notice the value is the concatenation of the strings:
#
#    '.,:;{[()]}_=<>~+-*/%&$!?"^|#@'
#    "'"
#    '`'
#
declare -r MBFL_ASCII_RANGE_ASCII_SYMBOLS='.,:;{[()]}_=<>~+-*/%&$!?"^|#@'"'"'`'

declare -r MBFL_ASCII_RANGE_DIGITS='0123456789'

declare -r MBFL_ASCII_RANGE_LOWER_CASE_ALPHABET='abcdefghijklmnopqrstuvwxyz'
declare -r MBFL_ASCII_RANGE_LOWER_CASE_VOWELS='aeiouy'
declare -r MBFL_ASCII_RANGE_LOWER_CASE_CONSONANTS='bcdfghjklmnpqrstvwxz'
declare -r MBFL_ASCII_RANGE_LOWER_CASE_ALNUM='abcdefghijklmnopqrstuvwxyz0123456789'
declare -r MBFL_ASCII_RANGE_LOWER_CASE_BASE16='abcdef0123456789'

declare -r MBFL_ASCII_RANGE_UPPER_CASE_ALPHABET='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
declare -r MBFL_ASCII_RANGE_UPPER_CASE_VOWELS='AEIOUY'
declare -r MBFL_ASCII_RANGE_UPPER_CASE_CONSONANTS='BCDFGHJKLMNPQRSTVWXZ'
declare -r MBFL_ASCII_RANGE_UPPER_CASE_ALNUM='ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
declare -r MBFL_ASCII_RANGE_UPPER_CASE_BASE16='ABCDEF0123456789'

declare -r MBFL_ASCII_RANGE_MIXED_CASE_ALPHABET="${MBFL_ASCII_RANGE_LOWER_CASE_ALPHABET}${MBFL_ASCII_RANGE_UPPER_CASE_ALPHABET}"
declare -r MBFL_ASCII_RANGE_MIXED_CASE_VOWELS="${MBFL_ASCII_RANGE_LOWER_CASE_VOWELS}${MBFL_ASCII_RANGE_UPPER_CASE_VOWELS}"
declare -r MBFL_ASCII_RANGE_MIXED_CASE_CONSONANTS="${MBFL_ASCII_RANGE_LOWER_CASE_CONSONANTS}${MBFL_ASCII_RANGE_UPPER_CASE_CONSONANTS}"
declare -r MBFL_ASCII_RANGE_MIXED_CASE_ALNUM="${MBFL_ASCII_RANGE_LOWER_CASE_ALPHABET}${MBFL_ASCII_RANGE_UPPER_CASE_ALPHABET}${MBFL_ASCII_RANGE_DIGITS}"
declare -r MBFL_ASCII_RANGE_MIXED_CASE_BASE16='abcdefABCDEF0123456789'

# According to RFC 4648, without padding character, as described in:
#
#  <https://datatracker.ietf.org/doc/html/rfc4648>
#
declare -r MBFL_ASCII_RANGE_BASE32="${MBFL_ASCII_RANGE_UPPER_CASE_ALPHABET}234567"

# According to RFC 4648, without padding character, as described in:
#
#  <https://datatracker.ietf.org/doc/html/rfc4648>
#
declare -r MBFL_ASCII_RANGE_BASE64="${MBFL_ASCII_RANGE_LOWER_CASE_ALPHABET}${MBFL_ASCII_RANGE_UPPER_CASE_ALPHABET}${MBFL_ASCII_RANGE_DIGITS}+/"

# We need to quote the symbols to avoit a further round of evaluation!!!
#
declare -r MBFL_ASCII_RANGE_ASCII_NOBLANK="${MBFL_ASCII_RANGE_LOWER_CASE_ALPHABET}${MBFL_ASCII_RANGE_UPPER_CASE_ALPHABET}${MBFL_ASCII_RANGE_DIGITS}${MBFL_ASCII_RANGE_ASCII_SYMBOLS}"

fi


#### quoted characters

function mbfl_string_is_quoted_char () {
    mbfl_mandatory_parameter(STRING, 1, string)
    mbfl_mandatory_integer_parameter(POS, 2, position)
    local -i COUNT
    let --POS
    for ((COUNT=0; POS >= 0; --POS))
    do
	if test "mbfl_string_idx(STRING, ${POS})" = \\
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
    if test "mbfl_string_idx(STRING, ${POS})" != "$CHAR"
    then mbfl_string_is_quoted_char "$STRING" "$POS"
    fi
}

function mbfl_string_quote_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_optional_parameter(mbfl_STRING, 2)
    local -i mbfl_I
    local mbfl_ch
    mbfl_RESULT_VARREF=
    for ((mbfl_I=0; mbfl_I < mbfl_string_len(mbfl_STRING); ++mbfl_I))
    do
        mbfl_ch=mbfl_string_idx(mbfl_STRING, $mbfl_I)
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


#### inspecting a string

function mbfl_string_length () {
    # We  want this  function to  accept empty  strings, so  we use  the
    # "optional" macro here.
    mbfl_optional_parameter(STRING, 1)
    echo mbfl_string_len(STRING)
}
function mbfl_string_length_equal_to () {
    mbfl_mandatory_integer_parameter(LENGTH, 1, length of string)
    # We  want this  function to  accept empty  strings, so  we use  the
    # "optional" macro here.
    mbfl_optional_parameter(STRING, 2)
    test mbfl_string_len(STRING) -eq $LENGTH
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
    for ((mbfl_I=mbfl_BEGIN; mbfl_I < mbfl_string_len(mbfl_STRING); ++mbfl_I))
    do
	if test "mbfl_string_idx(mbfl_STRING, $mbfl_I)" = "$mbfl_CHAR"
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
    mbfl_local_varref(RESULT_VARNAME)
    # Be  careful  to  return  the  same exit  status  of  the  call  to
    # "mbfl_string_first_var".
    if mbfl_string_first_var mbfl_datavar(RESULT_VARNAME) "$STRING" "$CHAR" "$BEGIN"
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
    for ((mbfl_I=${mbfl_BEGIN:-((mbfl_string_len(mbfl_STRING)-1))}; mbfl_I >= 0; --mbfl_I))
    do
	if test "mbfl_string_idx(mbfl_STRING, $mbfl_I)" = "$mbfl_CHAR"
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
    mbfl_local_varref(RESULT_VARNAME)
    # Be  careful  to  return  the  same exit  status  of  the  call  to
    # "mbfl_string_last_var".
    if mbfl_string_last_var mbfl_datavar(RESULT_VARNAME) "$STRING" "$CHAR" "$BEGIN"
    then printf '%s\n' "$RESULT_VARNAME"
    else return $?
    fi
}

function mbfl_string_index_var () {
    mbfl_mandatory_nameref_parameter(mbfl_RESULT_VARREF, 1, result variable name)
    mbfl_mandatory_parameter(mbfl_STRING, 2, string)
    mbfl_mandatory_parameter(mbfl_INDEX, 3, index)
    mbfl_RESULT_VARREF=mbfl_string_idx(mbfl_STRING, ${mbfl_INDEX})
}
function mbfl_string_index () {
    mbfl_mandatory_parameter(STRING, 1, string)
    mbfl_mandatory_parameter(INDEX, 2, index)
    printf "mbfl_string_idx(STRING, $INDEX)\n"
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
    mbfl_local_varref(RESULT_VARNAME)
    if mbfl_string_range_var mbfl_datavar(RESULT_VARNAME) "$STRING" "$BEGIN" "$END"
    then printf '%s\n' "$RESULT_VARNAME"
    else return $?
    fi
}

function mbfl_string_is_true () {
    mbfl_mandatory_parameter(STRING, 1, the string argument)
    test 'true' = "$STRING"
}
function mbfl_string_is_false () {
    mbfl_mandatory_parameter(STRING, 1, the string argument)
    test 'false' = "$STRING"
}


#### splitting

function mbfl_string_chars () {
    mbfl_mandatory_parameter(STRING, 1, string)
    local -i i j
    local ch
    for ((i=0, j=0; i < mbfl_string_len(STRING); ++i, ++j))
    do
        ch=mbfl_string_idx(STRING, $i)
        if test "$ch" != $'\\'
        then SPLITFIELD[$j]=$ch
        else
            let ++i
            if test $i != mbfl_string_len(STRING)
            then SPLITFIELD[$j]=${ch}mbfl_string_idx(STRING, $i)
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
    for ((i=0; i < mbfl_string_len(STRING); ++i))
    do
        if (( (i + mbfl_string_len(SEPARATOR)) > mbfl_string_len(STRING)))
	then break
	elif mbfl_string_equal_substring "$STRING" $i "$SEPARATOR"
	then
	    # Here $i is the index of the first char in the separator.
	    SPLITFIELD[$k]=${STRING:$first:$((i - first))}
	    let ++k
	    let i+=mbfl_string_len(SEPARATOR)-1
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
    for ((i=0; i < mbfl_string_len(STRING); ++i))
    do
	CH=mbfl_string_idx(STRING, $i)
	if test ' ' = "$CH" -o $'\t' = "$CH"
	then
	    # Store the field.
	    SPLITFIELD[${#SPLITFIELD[@]}]=$ACCUM
	    ACCUM=
	    # Consume all the adjacent blanks, if any.
	    for ((i=$i; i < mbfl_string_len(STRING); ++i))
	    do
		CH=mbfl_string_idx(STRING, $((i+1)))
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
    if (( (POSITION + mbfl_string_len(PATTERN)) > mbfl_string_len(STRING) ))
    then return 1
    fi
    for ((i=0; i < "mbfl_string_len(PATTERN)"; ++i))
    do
	if test "mbfl_string_idx(PATTERN, $i)" != "mbfl_string_idx(STRING, $(($POSITION+$i)))"
	then return 1
	fi
    done
    return 0
}


#### character predicates

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


#### character predicates from character ranges and similar

m4_define([[[MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE]]],[[[
function $1 () {
    mbfl_mandatory_parameter(CHAR, 1, char)
    mbfl_local_varref(RV)
    mbfl_string_first_var mbfl_datavar(RV) "$[[[]]]$2[[[]]]" "$CHAR"
}
]]])

MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_ascii_symbol_char,	      MBFL_ASCII_RANGE_ASCII_SYMBOLS)

MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_lower_case_vowel_char,	      MBFL_ASCII_RANGE_LOWER_CASE_VOWELS)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_lower_case_consonant_char,    MBFL_ASCII_RANGE_LOWER_CASE_CONSONANTS)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_lower_case_alphabet_char,     MBFL_ASCII_RANGE_LOWER_CASE_ALPHABET)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_lower_case_alnum_char,	      MBFL_ASCII_RANGE_LOWER_CASE_ALNUM)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_lower_case_base16_char,	      MBFL_ASCII_RANGE_LOWER_CASE_BASE16)

MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_upper_case_vowel_char,	      MBFL_ASCII_RANGE_UPPER_CASE_VOWELS)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_upper_case_consonant_char,    MBFL_ASCII_RANGE_UPPER_CASE_CONSONANTS)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_upper_case_alphabet_char,     MBFL_ASCII_RANGE_UPPER_CASE_ALPHABET)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_upper_case_alnum_char,	      MBFL_ASCII_RANGE_UPPER_CASE_ALNUM)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_upper_case_base16_char,	      MBFL_ASCII_RANGE_UPPER_CASE_BASE16)

MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_mixed_case_vowel_char,	      MBFL_ASCII_RANGE_MIXED_CASE_VOWELS)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_mixed_case_consonant_char,    MBFL_ASCII_RANGE_MIXED_CASE_CONSONANTS)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_mixed_case_alphabet_char,     MBFL_ASCII_RANGE_MIXED_CASE_ALPHABET)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_mixed_case_alnum_char,	      MBFL_ASCII_RANGE_MIXED_CASE_ALNUM)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_mixed_case_base16_char,	      MBFL_ASCII_RANGE_MIXED_CASE_BASE16)

MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_base32_char,		      MBFL_ASCII_RANGE_BASE32)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_base64_char,		      MBFL_ASCII_RANGE_BASE64)
MBFL_DEFINE_FUNCTION_STRING_PREDICATE_FROM_RANGE(mbfl_string_is_ascii_noblank_char,	      MBFL_ASCII_RANGE_ASCII_NOBLANK)


#### string predicates

function mbfl_p_string_is () {
    mbfl_mandatory_parameter(CHAR_PRED_FUNC, 1, char predicate func)
    # Accept $2  even if  it is  empty; for  this reason  we do  not use
    # MBFL_MANDATORY_PARAMETER.
    local STRING=$2
    local -i i
    if ((0 < mbfl_string_len(STRING)))
    then
	for ((i=0; i < mbfl_string_len(STRING); ++i))
	do
	    if ! $CHAR_PRED_FUNC "mbfl_string_idx(STRING, $i)"
	    then return 1
	    fi
	done
	return 0
    else return 1
    fi
}
function mbfl_string_is_alpha			() { mbfl_p_string_is mbfl_string_is_alpha_char   "$@"; }
function mbfl_string_is_digit			() { mbfl_p_string_is mbfl_string_is_digit_char   "$@"; }
function mbfl_string_is_alnum			() { mbfl_p_string_is mbfl_string_is_alnum_char   "$@"; }
function mbfl_string_is_noblank			() { mbfl_p_string_is mbfl_string_is_noblank_char "$@"; }

function mbfl_string_is_ascii_symbol		() { mbfl_p_string_is mbfl_string_is_ascii_symbol_char "$@"; }
function mbfl_string_is_lower_case_vowel	() { mbfl_p_string_is mbfl_string_is_lower_case_vowel_char "$@"; }
function mbfl_string_is_lower_case_consonant	() { mbfl_p_string_is mbfl_string_is_lower_case_consonant_char "$@"; }
function mbfl_string_is_lower_case_alphabet	() { mbfl_p_string_is mbfl_string_is_lower_case_alphabet_char "$@"; }
function mbfl_string_is_lower_case_alnum	() { mbfl_p_string_is mbfl_string_is_lower_case_alnum_char "$@"; }
function mbfl_string_is_lower_case_base16	() { mbfl_p_string_is mbfl_string_is_lower_case_base16_char "$@"; }

function mbfl_string_is_upper_case_vowel	() { mbfl_p_string_is mbfl_string_is_upper_case_vowel_char "$@"; }
function mbfl_string_is_upper_case_consonant	() { mbfl_p_string_is mbfl_string_is_upper_case_consonant_char "$@"; }
function mbfl_string_is_upper_case_alphabet	() { mbfl_p_string_is mbfl_string_is_upper_case_alphabet_char "$@"; }
function mbfl_string_is_upper_case_alnum	() { mbfl_p_string_is mbfl_string_is_upper_case_alnum_char "$@"; }
function mbfl_string_is_upper_case_base16	() { mbfl_p_string_is mbfl_string_is_upper_case_base16_char "$@"; }

function mbfl_string_is_mixed_case_vowel	() { mbfl_p_string_is mbfl_string_is_mixed_case_vowel_char "$@"; }
function mbfl_string_is_mixed_case_consonant	() { mbfl_p_string_is mbfl_string_is_mixed_case_consonant_char "$@"; }
function mbfl_string_is_mixed_case_alphabet	() { mbfl_p_string_is mbfl_string_is_mixed_case_alphabet_char "$@"; }
function mbfl_string_is_mixed_case_alnum	() { mbfl_p_string_is mbfl_string_is_mixed_case_alnum_char "$@"; }
function mbfl_string_is_mixed_case_base16	() { mbfl_p_string_is mbfl_string_is_mixed_case_base16_char "$@"; }

function mbfl_string_is_base32			() { mbfl_p_string_is mbfl_string_is_base32_char "$@"; }
function mbfl_string_is_base64			() { mbfl_p_string_is mbfl_string_is_base64_char "$@"; }
function mbfl_string_is_ascii_noblank		() { mbfl_p_string_is mbfl_string_is_ascii_noblank_char "$@"; }

function mbfl_string_is_name () {
    # Accept $1  even if  it is  empty; for  this reason  we do  not use
    # MBFL_MANDATORY_PARAMETER.
    local STRING=$1
    mbfl_string_is_not_empty "$STRING" && \
	mbfl_p_string_is mbfl_string_is_name_char "$STRING" && \
	{ ! mbfl_string_is_digit "mbfl_string_idx(STRING, 0)"; }
}
function mbfl_string_is_identifier () {
    # Accept $1  even if  it is  empty; for  this reason  we do  not use
    # MBFL_MANDATORY_PARAMETER.
    mbfl_optional_parameter(STRING, 1)
    mbfl_string_is_not_empty "$STRING"					\
	&&   mbfl_p_string_is mbfl_string_is_identifier_char "$STRING"	\
	&& ! mbfl_string_is_digit "mbfl_string_idx(STRING, 0)"		\
	&& mbfl_string_not_equal "mbfl_string_idx(STRING, 0)" '-'
}
function mbfl_string_is_extended_identifier () {
    # Accept $1 even if it is empty; for this reason we do not use MBFL_MANDATORY_PARAMETER.
    local STRING=$1
    mbfl_string_is_not_empty "$STRING" \
	&&   mbfl_p_string_is mbfl_string_is_extended_identifier_char "$STRING"		\
	&& ! mbfl_string_is_digit "mbfl_string_idx(STRING, 0)"				\
	&& mbfl_string_not_equal "mbfl_string_idx(STRING, 0)" '-'
}
function mbfl_string_is_username () {
    mbfl_optional_parameter(STRING,1)
    local -r REX='^(([a-zA-Z0-9_\.\-]+)|(\+[0-9]+))$'

    if mbfl_string_equal $'\n' "mbfl_string_last_char(STRING)"
    then return_failure
    elif [[ "$STRING" =~ $REX ]]
    then return_success
    else return_failure
    fi
}
function mbfl_string_is_groupname () {
    mbfl_optional_parameter(STRING,1)
    mbfl_string_is_username "$STRING"
}
function mbfl_string_is_network_port () {
    # We want to accept an empty parameter and return unsuccessfully when given.
    mbfl_optional_parameter(STRING, 1)

    if mbfl_string_is_not_empty "$STRING" && mbfl_string_is_digit "$STRING" && ((0 <= STRING && STRING <= 1024))
    then return 0
    else return 1
    fi
}
function mbfl_string_is_network_hostname () {
    # We want to accept an empty parameter and return unsuccessfully when given.
    mbfl_optional_parameter(STRING, 1)
    # This regular expression comes from:
    #
    #   https://stackoverflow.com/questions/106179/regular-expression-to-match-dns-hostname-or-ip-address
    #
    # answer by Sakari A. Maaranen, last visited Nov 23, 2018.
    local -r REX="^([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])(\.([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9]))*$"

    if ((mbfl_string_len(STRING) <= 255)) && [[ $STRING =~ $REX ]]
    then return 0
    fi
    return 1
}

function mbfl_string_is_network_ip_address () {
    # We want to accept an empty parameter and return unsuccessfully when given.
    mbfl_optional_parameter(STRING, 1)
    # This regular expression comes from:
    #
    #   https://stackoverflow.com/questions/106179/regular-expression-to-match-dns-hostname-or-ip-address
    #
    # answer by Jorge Ferreira, last visited Nov 23, 2018.
    #
    local -r REX="^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"

    if ((mbfl_string_len(STRING) <= 255)) && [[ $STRING =~ $REX ]]
    then return 0
    fi
    return 1
}

function mbfl_string_is_email_address () {
    # We want to accept an empty parameter and return unsuccessfully when given.
    mbfl_optional_parameter(ADDRESS, 1)
    local -r REX='^[a-zA-Z0-9_.\-]+(@[a-zA-Z0-9_.\-]+)?$'

    if [[ $ADDRESS =~ $REX ]]
    then return 0
    else return 1
    fi
}


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
    while test "mbfl_string_idx(mbfl_STRING, $mbfl_POSNAME)" = "$mbfl_CHAR"
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

	mbfl_string_index_var mbfl_datavar(CH) "$LINE" $((mbfl_string_len(LINE) - 1))
	if mbfl_string_equal "$CH" $'\r'
	then RESULT_NAMEREF=${LINE:0:((mbfl_string_len(LINE) - 1))}
	else RESULT_NAMEREF=$LINE
	fi
    fi
}

### end of file
# Local Variables:
# mode: sh
# End:
